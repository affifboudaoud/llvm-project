#ifndef POLLY_REVERSESCHEDULE_H
#define POLLY_REVERSESCHEDULE_H

#include "isl/isl-noexceptions.h"

namespace llvm {
class PassRegistry;
class Pass;
class raw_ostream;
} // namespace llvm

namespace polly {
llvm::Pass *createReverseSchedulePass();
llvm::Pass *createReverseSchedulePrinterLegacyPass(llvm::raw_ostream &OS);
isl::union_map reverseSchedule(isl::union_map Schedule);
} // namespace polly

namespace llvm {
void initializeReverseSchedulePass(llvm::PassRegistry &);
void initializeReverseSchedulePrinterLegacyPassPass(llvm::PassRegistry &);
} // namespace llvm

#endif /* POLLY_REVERSESCHEDULE_H */
