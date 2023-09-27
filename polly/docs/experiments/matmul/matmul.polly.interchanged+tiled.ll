; ModuleID = '<stdin>'
source_filename = "matmul.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@A = dso_local local_unnamed_addr global [1536 x [1536 x float]] zeroinitializer, align 16
@B = dso_local local_unnamed_addr global [1536 x [1536 x float]] zeroinitializer, align 16
@stdout = external dso_local local_unnamed_addr global ptr, align 8
@.str = private unnamed_addr constant [5 x i8] c"%lf \00", align 1
@C = dso_local local_unnamed_addr global [1536 x [1536 x float]] zeroinitializer, align 16

; Function Attrs: nofree noinline norecurse nosync nounwind memory(write, argmem: none, inaccessiblemem: none) uwtable
define dso_local void @init_array() local_unnamed_addr #0 {
polly.split_new_and_old:
  br label %polly.loop_header

polly.exiting:                                    ; preds = %polly.loop_exit3
  ret void

polly.loop_header:                                ; preds = %polly.split_new_and_old, %polly.loop_exit3
  %polly.indvar = phi i64 [ 0, %polly.split_new_and_old ], [ %polly.indvar_next, %polly.loop_exit3 ]
  %0 = mul nuw nsw i64 %polly.indvar, 6144
  %uglygep = getelementptr i8, ptr @A, i64 %0
  %uglygep10 = getelementptr i8, ptr @B, i64 %0
  %1 = trunc i64 %polly.indvar to i32
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %1, i64 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %polly.loop_header
  %index = phi i64 [ 0, %polly.loop_header ], [ %index.next, %vector.body ]
  %vec.ind = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %polly.loop_header ], [ %vec.ind.next, %vector.body ]
  %2 = mul <4 x i32> %vec.ind, %broadcast.splat
  %3 = and <4 x i32> %2, <i32 1023, i32 1023, i32 1023, i32 1023>
  %4 = add nuw nsw <4 x i32> %3, <i32 1, i32 1, i32 1, i32 1>
  %5 = sitofp <4 x i32> %4 to <4 x double>
  %6 = fmul <4 x double> %5, <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
  %7 = fptrunc <4 x double> %6 to <4 x float>
  %8 = shl nuw nsw i64 %index, 2
  %9 = getelementptr i8, ptr %uglygep, i64 %8
  store <4 x float> %7, ptr %9, align 16, !alias.scope !4, !noalias !7
  %10 = getelementptr i8, ptr %uglygep10, i64 %8
  store <4 x float> %7, ptr %10, align 16, !alias.scope !7, !noalias !4
  %index.next = add nuw i64 %index, 4
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 4, i32 4, i32 4, i32 4>
  %11 = icmp eq i64 %index.next, 1536
  br i1 %11, label %polly.loop_exit3, label %vector.body, !llvm.loop !9

polly.loop_exit3:                                 ; preds = %vector.body
  %polly.indvar_next = add nuw nsw i64 %polly.indvar, 1
  %exitcond1.not = icmp eq i64 %polly.indvar_next, 1536
  br i1 %exitcond1.not, label %polly.exiting, label %polly.loop_header
}

; Function Attrs: nofree noinline nounwind uwtable
define dso_local void @print_array() local_unnamed_addr #1 {
  br label %.preheader

.preheader:                                       ; preds = %13, %0
  %indvars.iv5 = phi i64 [ 0, %0 ], [ %indvars.iv.next6, %13 ]
  br label %1

1:                                                ; preds = %12, %.preheader
  %indvars.iv = phi i64 [ 0, %.preheader ], [ %indvars.iv.next, %12 ]
  %2 = load ptr, ptr @stdout, align 8
  %3 = getelementptr inbounds [1536 x [1536 x float]], ptr @C, i64 0, i64 %indvars.iv5, i64 %indvars.iv
  %4 = load float, ptr %3, align 4
  %5 = fpext float %4 to double
  %6 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef nonnull @.str, double noundef %5) #7
  %7 = trunc i64 %indvars.iv to i32
  %8 = urem i32 %7, 80
  %9 = icmp eq i32 %8, 79
  br i1 %9, label %10, label %12

10:                                               ; preds = %1
  %11 = load ptr, ptr @stdout, align 8
  %fputc2 = tail call i32 @fputc(i32 10, ptr %11)
  br label %12

12:                                               ; preds = %10, %1
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next, 1536
  br i1 %exitcond.not, label %13, label %1, !llvm.loop !12

13:                                               ; preds = %12
  %14 = load ptr, ptr @stdout, align 8
  %fputc = tail call i32 @fputc(i32 10, ptr %14)
  %indvars.iv.next6 = add nuw nsw i64 %indvars.iv5, 1
  %exitcond7.not = icmp eq i64 %indvars.iv.next6, 1536
  br i1 %exitcond7.not, label %15, label %.preheader, !llvm.loop !14

15:                                               ; preds = %13
  ret void
}

; Function Attrs: nofree nounwind
declare dso_local noundef i32 @fprintf(ptr nocapture noundef, ptr nocapture noundef readonly, ...) local_unnamed_addr #2

; Function Attrs: nofree noinline nosync nounwind memory(readwrite, argmem: write, inaccessiblemem: none) uwtable
define dso_local i32 @main() local_unnamed_addr #3 {
polly.split_new_and_old:
  tail call void @init_array()
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(9437184) @C, i8 0, i64 9437184, i1 false), !alias.scope !15, !noalias !18
  br label %polly.loop_header8

polly.exiting:                                    ; preds = %polly.loop_exit16
  ret i32 0

polly.loop_header8:                               ; preds = %polly.split_new_and_old, %polly.loop_exit16
  %indvars.iv5 = phi i64 [ 64, %polly.split_new_and_old ], [ %indvars.iv.next6, %polly.loop_exit16 ]
  %polly.indvar11 = phi i64 [ 0, %polly.split_new_and_old ], [ %polly.indvar_next12, %polly.loop_exit16 ]
  br label %polly.loop_header14

polly.loop_exit16:                                ; preds = %polly.loop_exit22
  %polly.indvar_next12 = add nuw nsw i64 %polly.indvar11, 64
  %polly.loop_cond13 = icmp ult i64 %polly.indvar11, 1472
  %indvars.iv.next6 = add nuw nsw i64 %indvars.iv5, 64
  br i1 %polly.loop_cond13, label %polly.loop_header8, label %polly.exiting

polly.loop_header14:                              ; preds = %polly.loop_header8, %polly.loop_exit22
  %polly.indvar17 = phi i64 [ 0, %polly.loop_header8 ], [ %polly.indvar_next18, %polly.loop_exit22 ]
  %0 = shl nuw nsw i64 %polly.indvar17, 2
  %offset.idx.1 = shl i64 %polly.indvar17, 2
  %1 = or i64 %offset.idx.1, 16
  %offset.idx.2 = shl i64 %polly.indvar17, 2
  %2 = or i64 %offset.idx.2, 32
  %offset.idx.3 = shl i64 %polly.indvar17, 2
  %3 = or i64 %offset.idx.3, 48
  %offset.idx.4 = shl i64 %polly.indvar17, 2
  %4 = or i64 %offset.idx.4, 64
  %offset.idx.5 = shl i64 %polly.indvar17, 2
  %5 = or i64 %offset.idx.5, 80
  %offset.idx.6 = shl i64 %polly.indvar17, 2
  %6 = or i64 %offset.idx.6, 96
  %offset.idx.7 = shl i64 %polly.indvar17, 2
  %7 = or i64 %offset.idx.7, 112
  %offset.idx.8 = shl i64 %polly.indvar17, 2
  %8 = or i64 %offset.idx.8, 128
  %offset.idx.9 = shl i64 %polly.indvar17, 2
  %9 = or i64 %offset.idx.9, 144
  %offset.idx.10 = shl i64 %polly.indvar17, 2
  %10 = or i64 %offset.idx.10, 160
  %offset.idx.11 = shl i64 %polly.indvar17, 2
  %11 = or i64 %offset.idx.11, 176
  %offset.idx.12 = shl i64 %polly.indvar17, 2
  %12 = or i64 %offset.idx.12, 192
  %offset.idx.13 = shl i64 %polly.indvar17, 2
  %13 = or i64 %offset.idx.13, 208
  %offset.idx.14 = shl i64 %polly.indvar17, 2
  %14 = or i64 %offset.idx.14, 224
  %offset.idx.15 = shl i64 %polly.indvar17, 2
  %15 = or i64 %offset.idx.15, 240
  br label %polly.loop_header20

polly.loop_exit22:                                ; preds = %polly.loop_exit28
  %polly.indvar_next18 = add nuw nsw i64 %polly.indvar17, 64
  %polly.loop_cond19 = icmp ult i64 %polly.indvar17, 1472
  br i1 %polly.loop_cond19, label %polly.loop_header14, label %polly.loop_exit16

polly.loop_header20:                              ; preds = %polly.loop_header14, %polly.loop_exit28
  %indvars.iv2 = phi i64 [ 64, %polly.loop_header14 ], [ %indvars.iv.next3, %polly.loop_exit28 ]
  %polly.indvar23 = phi i64 [ 0, %polly.loop_header14 ], [ %polly.indvar_next24, %polly.loop_exit28 ]
  br label %polly.loop_header26

polly.loop_exit28:                                ; preds = %polly.loop_exit34
  %polly.indvar_next24 = add nuw nsw i64 %polly.indvar23, 64
  %polly.loop_cond25 = icmp ult i64 %polly.indvar23, 1472
  %indvars.iv.next3 = add nuw nsw i64 %indvars.iv2, 64
  br i1 %polly.loop_cond25, label %polly.loop_header20, label %polly.loop_exit22

polly.loop_header26:                              ; preds = %polly.loop_header20, %polly.loop_exit34
  %polly.indvar29 = phi i64 [ %polly.indvar11, %polly.loop_header20 ], [ %polly.indvar_next30, %polly.loop_exit34 ]
  %16 = mul nuw nsw i64 %polly.indvar29, 6144
  %uglygep45 = getelementptr i8, ptr @C, i64 %16
  %uglygep47 = getelementptr i8, ptr @A, i64 %16
  %17 = getelementptr i8, ptr %uglygep45, i64 %0
  %18 = getelementptr i8, ptr %uglygep45, i64 %1
  %19 = getelementptr i8, ptr %uglygep45, i64 %2
  %20 = getelementptr i8, ptr %uglygep45, i64 %3
  %21 = getelementptr i8, ptr %uglygep45, i64 %4
  %22 = getelementptr i8, ptr %uglygep45, i64 %5
  %23 = getelementptr i8, ptr %uglygep45, i64 %6
  %24 = getelementptr i8, ptr %uglygep45, i64 %7
  %25 = getelementptr i8, ptr %uglygep45, i64 %8
  %26 = getelementptr i8, ptr %uglygep45, i64 %9
  %27 = getelementptr i8, ptr %uglygep45, i64 %10
  %28 = getelementptr i8, ptr %uglygep45, i64 %11
  %29 = getelementptr i8, ptr %uglygep45, i64 %12
  %30 = getelementptr i8, ptr %uglygep45, i64 %13
  %31 = getelementptr i8, ptr %uglygep45, i64 %14
  %32 = getelementptr i8, ptr %uglygep45, i64 %15
  %.promoted = load <4 x float>, ptr %17, align 16, !alias.scope !15, !noalias !18
  %.promoted10 = load <4 x float>, ptr %18, align 16, !alias.scope !15, !noalias !18
  %.promoted12 = load <4 x float>, ptr %19, align 16, !alias.scope !15, !noalias !18
  %.promoted14 = load <4 x float>, ptr %20, align 16, !alias.scope !15, !noalias !18
  %.promoted16 = load <4 x float>, ptr %21, align 16, !alias.scope !15, !noalias !18
  %.promoted18 = load <4 x float>, ptr %22, align 16, !alias.scope !15, !noalias !18
  %.promoted20 = load <4 x float>, ptr %23, align 16, !alias.scope !15, !noalias !18
  %.promoted22 = load <4 x float>, ptr %24, align 16, !alias.scope !15, !noalias !18
  %.promoted24 = load <4 x float>, ptr %25, align 16, !alias.scope !15, !noalias !18
  %.promoted26 = load <4 x float>, ptr %26, align 16, !alias.scope !15, !noalias !18
  %.promoted28 = load <4 x float>, ptr %27, align 16, !alias.scope !15, !noalias !18
  %.promoted30 = load <4 x float>, ptr %28, align 16, !alias.scope !15, !noalias !18
  %.promoted32 = load <4 x float>, ptr %29, align 16, !alias.scope !15, !noalias !18
  %.promoted34 = load <4 x float>, ptr %30, align 16, !alias.scope !15, !noalias !18
  %.promoted36 = load <4 x float>, ptr %31, align 16, !alias.scope !15, !noalias !18
  %.promoted38 = load <4 x float>, ptr %32, align 16, !alias.scope !15, !noalias !18
  br label %polly.loop_header32

polly.loop_exit34:                                ; preds = %polly.loop_header32
  store <4 x float> %51, ptr %17, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %53, ptr %18, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %55, ptr %19, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %57, ptr %20, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %59, ptr %21, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %61, ptr %22, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %63, ptr %23, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %65, ptr %24, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %67, ptr %25, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %69, ptr %26, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %71, ptr %27, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %73, ptr %28, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %75, ptr %29, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %77, ptr %30, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %79, ptr %31, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %81, ptr %32, align 16, !alias.scope !15, !noalias !18
  %polly.indvar_next30 = add nuw nsw i64 %polly.indvar29, 1
  %exitcond7.not = icmp eq i64 %polly.indvar_next30, %indvars.iv5
  br i1 %exitcond7.not, label %polly.loop_exit28, label %polly.loop_header26

polly.loop_header32:                              ; preds = %polly.loop_header26, %polly.loop_header32
  %33 = phi <4 x float> [ %.promoted38, %polly.loop_header26 ], [ %81, %polly.loop_header32 ]
  %34 = phi <4 x float> [ %.promoted36, %polly.loop_header26 ], [ %79, %polly.loop_header32 ]
  %35 = phi <4 x float> [ %.promoted34, %polly.loop_header26 ], [ %77, %polly.loop_header32 ]
  %36 = phi <4 x float> [ %.promoted32, %polly.loop_header26 ], [ %75, %polly.loop_header32 ]
  %37 = phi <4 x float> [ %.promoted30, %polly.loop_header26 ], [ %73, %polly.loop_header32 ]
  %38 = phi <4 x float> [ %.promoted28, %polly.loop_header26 ], [ %71, %polly.loop_header32 ]
  %39 = phi <4 x float> [ %.promoted26, %polly.loop_header26 ], [ %69, %polly.loop_header32 ]
  %40 = phi <4 x float> [ %.promoted24, %polly.loop_header26 ], [ %67, %polly.loop_header32 ]
  %41 = phi <4 x float> [ %.promoted22, %polly.loop_header26 ], [ %65, %polly.loop_header32 ]
  %42 = phi <4 x float> [ %.promoted20, %polly.loop_header26 ], [ %63, %polly.loop_header32 ]
  %43 = phi <4 x float> [ %.promoted18, %polly.loop_header26 ], [ %61, %polly.loop_header32 ]
  %44 = phi <4 x float> [ %.promoted16, %polly.loop_header26 ], [ %59, %polly.loop_header32 ]
  %45 = phi <4 x float> [ %.promoted14, %polly.loop_header26 ], [ %57, %polly.loop_header32 ]
  %46 = phi <4 x float> [ %.promoted12, %polly.loop_header26 ], [ %55, %polly.loop_header32 ]
  %47 = phi <4 x float> [ %.promoted10, %polly.loop_header26 ], [ %53, %polly.loop_header32 ]
  %wide.load9 = phi <4 x float> [ %.promoted, %polly.loop_header26 ], [ %51, %polly.loop_header32 ]
  %polly.indvar35 = phi i64 [ %polly.indvar23, %polly.loop_header26 ], [ %polly.indvar_next36, %polly.loop_header32 ]
  %48 = shl nuw nsw i64 %polly.indvar35, 2
  %uglygep48 = getelementptr i8, ptr %uglygep47, i64 %48
  %_p_scalar_49 = load float, ptr %uglygep48, align 4, !alias.scope !21, !noalias !22
  %broadcast.splatinsert = insertelement <4 x float> poison, float %_p_scalar_49, i64 0
  %broadcast.splat = shufflevector <4 x float> %broadcast.splatinsert, <4 x float> poison, <4 x i32> zeroinitializer
  %49 = mul nuw nsw i64 %polly.indvar35, 6144
  %uglygep50 = getelementptr i8, ptr @B, i64 %49
  %50 = getelementptr i8, ptr %uglygep50, i64 %0
  %wide.load8 = load <4 x float>, ptr %50, align 16, !alias.scope !23, !noalias !24
  %51 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8, <4 x float> %wide.load9)
  %52 = getelementptr i8, ptr %uglygep50, i64 %1
  %wide.load8.1 = load <4 x float>, ptr %52, align 16, !alias.scope !23, !noalias !24
  %53 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.1, <4 x float> %47)
  %54 = getelementptr i8, ptr %uglygep50, i64 %2
  %wide.load8.2 = load <4 x float>, ptr %54, align 16, !alias.scope !23, !noalias !24
  %55 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.2, <4 x float> %46)
  %56 = getelementptr i8, ptr %uglygep50, i64 %3
  %wide.load8.3 = load <4 x float>, ptr %56, align 16, !alias.scope !23, !noalias !24
  %57 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.3, <4 x float> %45)
  %58 = getelementptr i8, ptr %uglygep50, i64 %4
  %wide.load8.4 = load <4 x float>, ptr %58, align 16, !alias.scope !23, !noalias !24
  %59 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.4, <4 x float> %44)
  %60 = getelementptr i8, ptr %uglygep50, i64 %5
  %wide.load8.5 = load <4 x float>, ptr %60, align 16, !alias.scope !23, !noalias !24
  %61 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.5, <4 x float> %43)
  %62 = getelementptr i8, ptr %uglygep50, i64 %6
  %wide.load8.6 = load <4 x float>, ptr %62, align 16, !alias.scope !23, !noalias !24
  %63 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.6, <4 x float> %42)
  %64 = getelementptr i8, ptr %uglygep50, i64 %7
  %wide.load8.7 = load <4 x float>, ptr %64, align 16, !alias.scope !23, !noalias !24
  %65 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.7, <4 x float> %41)
  %66 = getelementptr i8, ptr %uglygep50, i64 %8
  %wide.load8.8 = load <4 x float>, ptr %66, align 16, !alias.scope !23, !noalias !24
  %67 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.8, <4 x float> %40)
  %68 = getelementptr i8, ptr %uglygep50, i64 %9
  %wide.load8.9 = load <4 x float>, ptr %68, align 16, !alias.scope !23, !noalias !24
  %69 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.9, <4 x float> %39)
  %70 = getelementptr i8, ptr %uglygep50, i64 %10
  %wide.load8.10 = load <4 x float>, ptr %70, align 16, !alias.scope !23, !noalias !24
  %71 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.10, <4 x float> %38)
  %72 = getelementptr i8, ptr %uglygep50, i64 %11
  %wide.load8.11 = load <4 x float>, ptr %72, align 16, !alias.scope !23, !noalias !24
  %73 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.11, <4 x float> %37)
  %74 = getelementptr i8, ptr %uglygep50, i64 %12
  %wide.load8.12 = load <4 x float>, ptr %74, align 16, !alias.scope !23, !noalias !24
  %75 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.12, <4 x float> %36)
  %76 = getelementptr i8, ptr %uglygep50, i64 %13
  %wide.load8.13 = load <4 x float>, ptr %76, align 16, !alias.scope !23, !noalias !24
  %77 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.13, <4 x float> %35)
  %78 = getelementptr i8, ptr %uglygep50, i64 %14
  %wide.load8.14 = load <4 x float>, ptr %78, align 16, !alias.scope !23, !noalias !24
  %79 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.14, <4 x float> %34)
  %80 = getelementptr i8, ptr %uglygep50, i64 %15
  %wide.load8.15 = load <4 x float>, ptr %80, align 16, !alias.scope !23, !noalias !24
  %81 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load8.15, <4 x float> %33)
  %polly.indvar_next36 = add nuw nsw i64 %polly.indvar35, 1
  %exitcond4.not = icmp eq i64 %polly.indvar_next36, %indvars.iv2
  br i1 %exitcond4.not, label %polly.loop_exit34, label %polly.loop_header32
}

; Function Attrs: nofree nounwind
declare noundef i32 @fputc(i32 noundef, ptr nocapture noundef) local_unnamed_addr #4

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.fmuladd.v4f32(<4 x float>, <4 x float>, <4 x float>) #6

attributes #0 = { nofree noinline norecurse nosync nounwind memory(write, argmem: none, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "polly-optimized" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree noinline nosync nounwind memory(readwrite, argmem: write, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "polly-optimized" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nofree nounwind }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { nounwind }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{!"clang version 14.0.6"}
!4 = !{!5}
!5 = distinct !{!5, !6, !"polly.alias.scope.MemRef_A"}
!6 = distinct !{!6, !"polly.alias.scope.domain"}
!7 = !{!8}
!8 = distinct !{!8, !6, !"polly.alias.scope.MemRef_B"}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.isvectorized", i32 1}
!11 = !{!"llvm.loop.unroll.runtime.disable"}
!12 = distinct !{!12, !13}
!13 = !{!"llvm.loop.mustprogress"}
!14 = distinct !{!14, !13}
!15 = !{!16}
!16 = distinct !{!16, !17, !"polly.alias.scope.MemRef_C"}
!17 = distinct !{!17, !"polly.alias.scope.domain"}
!18 = !{!19, !20}
!19 = distinct !{!19, !17, !"polly.alias.scope.MemRef_A"}
!20 = distinct !{!20, !17, !"polly.alias.scope.MemRef_B"}
!21 = !{!19}
!22 = !{!16, !20}
!23 = !{!20}
!24 = !{!16, !19}
