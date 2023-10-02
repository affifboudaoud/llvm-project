//===------ ReverseSchedule.cpp --------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "polly/ReverseSchedule.h"
#include "polly/ScopInfo.h"
#include "polly/ScopPass.h"
#include "polly/Support/ISLOStream.h"
#include "polly/Support/ISLTools.h"
#include "llvm/Support/Debug.h"
#define DEBUG_TYPE "polly-reverse-schedule"

using namespace polly;
using namespace llvm;

namespace {

/// Print a schedule to @p OS.
///
/// Prints the schedule for each statements on a new line.
void printSchedule(raw_ostream &OS, const isl::union_map &Schedule,
                   int indent) {
  for (isl::map Map : Schedule.get_map_list())
    OS.indent(indent) << Map << "\n";
}

/// Reverse the schedule stored in an polly::Scop.
class ReverseSchedule final : public ScopPass {
private:
  ReverseSchedule(const ReverseSchedule &) = delete;
  const ReverseSchedule &operator=(const ReverseSchedule &) = delete;

  std::shared_ptr<isl_ctx> IslCtx;
  isl::union_map OldSchedule;

public:
  static char ID;
  explicit ReverseSchedule() : ScopPass(ID) {}

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequiredTransitive<ScopInfoRegionPass>();
    AU.setPreservesAll();
  }

  bool runOnScop(Scop &S) override {
    // Keep a reference to isl_ctx to ensure that it is not freed before we free
    // OldSchedule.
    IslCtx = S.getSharedIslCtx();

    LLVM_DEBUG(dbgs() << "Going to reverse old schedule:\n");
    OldSchedule = S.getSchedule();
    LLVM_DEBUG(printSchedule(dbgs(), OldSchedule, 2));

    auto Domains = S.getDomains();
    auto RestrictedOldSchedule = OldSchedule.intersect_domain(Domains);
    LLVM_DEBUG(dbgs() << "Old schedule with domains:\n");
    LLVM_DEBUG(printSchedule(dbgs(), RestrictedOldSchedule, 2));

    auto NewSchedule = reverseSchedule(RestrictedOldSchedule);

    LLVM_DEBUG(dbgs() << "Reversed new schedule:\n");
    LLVM_DEBUG(printSchedule(dbgs(), NewSchedule, 2));

    NewSchedule = NewSchedule.gist_domain(Domains);
    LLVM_DEBUG(dbgs() << "Gisted, reversed new schedule:\n");
    LLVM_DEBUG(printSchedule(dbgs(), NewSchedule, 2));

    S.setSchedule(NewSchedule);
    return false;
  }

  void printScop(raw_ostream &OS, Scop &S) const override {
    OS << "Schedule before reversal {\n";
    printSchedule(OS, OldSchedule, 4);
    OS << "}\n\n";

    OS << "Schedule after reversal {\n";
    printSchedule(OS, S.getSchedule(), 4);
    OS << "}\n";
  }

  void releaseMemory() override {
    OldSchedule = {};
    IslCtx.reset();
  }
};

char ReverseSchedule::ID;

/// Print result from ReverseSchedule.
class ReverseSchedulePrinterLegacyPass final : public ScopPass {
public:
  static char ID;

  ReverseSchedulePrinterLegacyPass()
      : ReverseSchedulePrinterLegacyPass(outs()){};
  explicit ReverseSchedulePrinterLegacyPass(llvm::raw_ostream &OS)
      : ScopPass(ID), OS(OS) {}

  bool runOnScop(Scop &S) override {
    ReverseSchedule &P = getAnalysis<ReverseSchedule>();

    OS << "Printing analysis '" << P.getPassName() << "' for region: '"
       << S.getRegion().getNameStr() << "' in function '"
       << S.getFunction().getName() << "':\n";
    P.printScop(OS, S);

    return false;
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    ScopPass::getAnalysisUsage(AU);
    AU.addRequired<ReverseSchedule>();
    AU.setPreservesAll();
  }

private:
  llvm::raw_ostream &OS;
};

char ReverseSchedulePrinterLegacyPass::ID = 0;
} // anonymous namespace

Pass *polly::createReverseSchedulePass() { return new ReverseSchedule(); }

Pass *polly::createReverseSchedulePrinterLegacyPass(llvm::raw_ostream &OS) {
  return new ReverseSchedulePrinterLegacyPass(OS);
}

INITIALIZE_PASS_BEGIN(ReverseSchedule, "polly-reverse-schedule",
                      "Polly - Reverse schedule", false, false)
INITIALIZE_PASS_END(ReverseSchedule, "polly-reverse-schedule",
                    "Polly - Reverse schedule", false, false)

INITIALIZE_PASS_BEGIN(ReverseSchedulePrinterLegacyPass,
                      "polly-print-reverse-schedule",
                      "Polly - Print reversed schedule", false, false)
INITIALIZE_PASS_DEPENDENCY(ReverseSchedule)
INITIALIZE_PASS_END(ReverseSchedulePrinterLegacyPass,
                    "polly-print-reverse-schedule",
                    "Polly - Print reversed schedule", false, false)
namespace {

/// Compute @UPwAff * @p Val.
isl::union_pw_aff multiply(isl::union_pw_aff UPwAff, isl::val Val) {
  if (Val.is_one())
    return UPwAff;

  auto Result = isl::union_pw_aff::empty(UPwAff.get_space());
  isl::stat Stat =
      UPwAff.foreach_pw_aff([=, &Result](isl::pw_aff PwAff) -> isl::stat {
        auto ValAff =
            isl::pw_aff(isl::set::universe(PwAff.get_space().domain()), Val);
        auto Multiplied = PwAff.mul(ValAff);
        Result = Result.union_add(Multiplied);
        return isl::stat::ok();
      });
  if (Stat.is_error())
    return {};
  return Result;
}

/// Return the @p pos' range dimension, converted to an isl_union_pw_aff.
isl::union_pw_aff scheduleExtractDimAff(isl::union_map UMap, unsigned pos) {
  auto SingleUMap = isl::union_map::empty(UMap.ctx());
  for (isl::map Map : UMap.get_map_list()) {
    unsigned MapDims = unsignedFromIslSize(Map.range_tuple_dim());
    assert(MapDims > pos);
    isl::map SingleMap = Map.project_out(isl::dim::out, 0, pos);
    SingleMap = SingleMap.project_out(isl::dim::out, 1, MapDims - pos - 1);
    SingleUMap = SingleUMap.unite(SingleMap);
  };

  auto UAff = isl::union_pw_multi_aff(SingleUMap);
  auto FirstMAff = isl::multi_union_pw_aff(UAff);
  return FirstMAff.at(0);
}

isl::union_map reverseLoop(isl::union_map Schedule) {
  // Reverse the outermost loop in the schedule
  auto FirstAff = scheduleExtractDimAff(Schedule, 0);
  auto value = isl::val(Schedule.ctx(), -1);
  // Multiply the first dynamic dim by -1
  auto reversed = multiply(FirstAff, value);
  // Extract the resulting union map and return it
  auto result = isl::union_map::from(reversed.as_multi_union_pw_aff());
  return result;
}
} // anonymous namespace

isl::union_map polly::reverseSchedule(isl::union_map Schedule) {
  unsigned Dims = getNumScatterDims(Schedule);
  LLVM_DEBUG(dbgs() << "Recursive schedule to process:\n  " << Schedule
                    << "\n");
  // Base case; no dimensions left
  if (Dims == 0) {
    // TODO: Add one dimension?
    return Schedule;
  }

  // Base case; already one-dimensional
  if (Dims == 1)
    return Schedule;
  
  auto NewScheduleLoop = reverseLoop(Schedule);
  if (!NewScheduleLoop.is_null())
    return NewScheduleLoop;

  return Schedule;
}