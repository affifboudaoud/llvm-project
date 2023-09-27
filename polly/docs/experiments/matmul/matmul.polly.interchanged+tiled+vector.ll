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
  store <4 x float> %7, ptr %9, align 16, !alias.scope !4, !noalias !7, !llvm.access.group !9
  %10 = getelementptr i8, ptr %uglygep10, i64 %8
  store <4 x float> %7, ptr %10, align 16, !alias.scope !7, !noalias !4, !llvm.access.group !9
  %index.next = add nuw i64 %index, 4
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 4, i32 4, i32 4, i32 4>
  %11 = icmp eq i64 %index.next, 1536
  br i1 %11, label %polly.loop_exit3, label %vector.body, !llvm.loop !12

polly.loop_exit3:                                 ; preds = %vector.body
  %polly.indvar_next = add nuw nsw i64 %polly.indvar, 1
  %exitcond1.not = icmp eq i64 %polly.indvar_next, 1536
  br i1 %exitcond1.not, label %polly.exiting, label %polly.loop_header, !llvm.loop !16
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
  br i1 %exitcond.not, label %13, label %1, !llvm.loop !18

13:                                               ; preds = %12
  %14 = load ptr, ptr @stdout, align 8
  %fputc = tail call i32 @fputc(i32 10, ptr %14)
  %indvars.iv.next6 = add nuw nsw i64 %indvars.iv5, 1
  %exitcond7.not = icmp eq i64 %indvars.iv.next6, 1536
  br i1 %exitcond7.not, label %15, label %.preheader, !llvm.loop !20

15:                                               ; preds = %13
  ret void
}

; Function Attrs: nofree nounwind
declare dso_local noundef i32 @fprintf(ptr nocapture noundef, ptr nocapture noundef readonly, ...) local_unnamed_addr #2

; Function Attrs: nofree noinline nosync nounwind memory(readwrite, argmem: write, inaccessiblemem: none) uwtable
define dso_local i32 @main() local_unnamed_addr #3 {
polly.split_new_and_old:
  tail call void @init_array()
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(9437184) @C, i8 0, i64 9437184, i1 false), !alias.scope !21, !noalias !24
  br label %polly.loop_header8

polly.exiting:                                    ; preds = %polly.loop_exit16
  ret i32 0

polly.loop_header8:                               ; preds = %polly.split_new_and_old, %polly.loop_exit16
  %indvars.iv6 = phi i64 [ 64, %polly.split_new_and_old ], [ %indvars.iv.next7, %polly.loop_exit16 ]
  %polly.indvar11 = phi i64 [ 0, %polly.split_new_and_old ], [ %polly.indvar_next12, %polly.loop_exit16 ]
  br label %polly.loop_header14

polly.loop_exit16:                                ; preds = %polly.loop_exit22
  %polly.indvar_next12 = add nuw nsw i64 %polly.indvar11, 64
  %polly.loop_cond13 = icmp ult i64 %polly.indvar11, 1472
  %indvars.iv.next7 = add nuw nsw i64 %indvars.iv6, 64
  br i1 %polly.loop_cond13, label %polly.loop_header8, label %polly.exiting, !llvm.loop !27

polly.loop_header14:                              ; preds = %polly.loop_header8, %polly.loop_exit22
  %polly.indvar17 = phi i64 [ 0, %polly.loop_header8 ], [ %polly.indvar_next18, %polly.loop_exit22 ]
  %0 = shl nuw nsw i64 %polly.indvar17, 2
  %offset.idx.1 = or i64 %polly.indvar17, 16
  %1 = shl nuw nsw i64 %offset.idx.1, 2
  %offset.idx.2 = or i64 %polly.indvar17, 32
  %2 = shl nuw nsw i64 %offset.idx.2, 2
  %offset.idx.3 = or i64 %polly.indvar17, 48
  %3 = shl nuw nsw i64 %offset.idx.3, 2
  br label %polly.loop_header20

polly.loop_exit22:                                ; preds = %polly.loop_exit28
  %polly.indvar_next18 = add nuw nsw i64 %polly.indvar17, 64
  %polly.loop_cond19 = icmp ult i64 %polly.indvar17, 1472
  br i1 %polly.loop_cond19, label %polly.loop_header14, label %polly.loop_exit16

polly.loop_header20:                              ; preds = %polly.loop_header14, %polly.loop_exit28
  %indvars.iv4 = phi i64 [ 64, %polly.loop_header14 ], [ %indvars.iv.next5, %polly.loop_exit28 ]
  %polly.indvar23 = phi i64 [ 0, %polly.loop_header14 ], [ %polly.indvar_next24, %polly.loop_exit28 ]
  br label %polly.loop_header26

polly.loop_exit28:                                ; preds = %polly.loop_exit34
  %polly.indvar_next24 = add nuw nsw i64 %polly.indvar23, 64
  %polly.loop_cond25 = icmp ult i64 %polly.indvar23, 1472
  %indvars.iv.next5 = add nuw nsw i64 %indvars.iv4, 64
  br i1 %polly.loop_cond25, label %polly.loop_header20, label %polly.loop_exit22

polly.loop_header26:                              ; preds = %polly.loop_header20, %polly.loop_exit34
  %polly.indvar29 = phi i64 [ %polly.indvar11, %polly.loop_header20 ], [ %polly.indvar_next30, %polly.loop_exit34 ]
  %4 = mul nuw nsw i64 %polly.indvar29, 6144
  %uglygep51 = getelementptr i8, ptr @C, i64 %4
  %uglygep53 = getelementptr i8, ptr @A, i64 %4
  %5 = getelementptr i8, ptr %uglygep51, i64 %0
  %6 = getelementptr i8, ptr %uglygep51, i64 %1
  %7 = getelementptr i8, ptr %uglygep51, i64 %2
  %8 = getelementptr i8, ptr %uglygep51, i64 %3
  %.promoted = load <16 x float>, ptr %5, align 16, !alias.scope !21, !noalias !24
  %.promoted18 = load <16 x float>, ptr %6, align 16, !alias.scope !21, !noalias !24
  %.promoted20 = load <16 x float>, ptr %7, align 16, !alias.scope !21, !noalias !24
  %.promoted22 = load <16 x float>, ptr %8, align 16, !alias.scope !21, !noalias !24
  br label %polly.loop_header32

polly.loop_exit34:                                ; preds = %polly.loop_header32
  store <16 x float> %interleaved.vec, ptr %5, align 16, !alias.scope !21, !noalias !24
  store <16 x float> %interleaved.vec.1, ptr %6, align 16, !alias.scope !21, !noalias !24
  store <16 x float> %interleaved.vec.2, ptr %7, align 16, !alias.scope !21, !noalias !24
  store <16 x float> %interleaved.vec.3, ptr %8, align 16, !alias.scope !21, !noalias !24
  %polly.indvar_next30 = add nuw nsw i64 %polly.indvar29, 1
  %exitcond8.not = icmp eq i64 %polly.indvar_next30, %indvars.iv6
  br i1 %exitcond8.not, label %polly.loop_exit28, label %polly.loop_header26

polly.loop_header32:                              ; preds = %polly.loop_header26, %polly.loop_header32
  %wide.vec.323 = phi <16 x float> [ %.promoted22, %polly.loop_header26 ], [ %interleaved.vec.3, %polly.loop_header32 ]
  %wide.vec.221 = phi <16 x float> [ %.promoted20, %polly.loop_header26 ], [ %interleaved.vec.2, %polly.loop_header32 ]
  %wide.vec.119 = phi <16 x float> [ %.promoted18, %polly.loop_header26 ], [ %interleaved.vec.1, %polly.loop_header32 ]
  %wide.vec17 = phi <16 x float> [ %.promoted, %polly.loop_header26 ], [ %interleaved.vec, %polly.loop_header32 ]
  %polly.indvar35 = phi i64 [ %polly.indvar23, %polly.loop_header26 ], [ %polly.indvar_next36, %polly.loop_header32 ]
  %9 = shl nuw nsw i64 %polly.indvar35, 2
  %uglygep54 = getelementptr i8, ptr %uglygep53, i64 %9
  %_p_scalar_55 = load float, ptr %uglygep54, align 4, !alias.scope !30, !noalias !31, !llvm.access.group !32
  %broadcast.splatinsert = insertelement <4 x float> poison, float %_p_scalar_55, i64 0
  %broadcast.splat = shufflevector <4 x float> %broadcast.splatinsert, <4 x float> poison, <4 x i32> zeroinitializer
  %10 = mul nuw nsw i64 %polly.indvar35, 6144
  %uglygep56 = getelementptr i8, ptr @B, i64 %10
  %strided.vec = shufflevector <16 x float> %wide.vec17, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec9 = shufflevector <16 x float> %wide.vec17, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec10 = shufflevector <16 x float> %wide.vec17, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec11 = shufflevector <16 x float> %wide.vec17, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %11 = getelementptr i8, ptr %uglygep56, i64 %0
  %wide.vec12 = load <16 x float>, ptr %11, align 16, !alias.scope !34, !noalias !35
  %strided.vec13 = shufflevector <16 x float> %wide.vec12, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec14 = shufflevector <16 x float> %wide.vec12, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec15 = shufflevector <16 x float> %wide.vec12, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec16 = shufflevector <16 x float> %wide.vec12, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %12 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec13, <4 x float> %strided.vec)
  %13 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec14, <4 x float> %strided.vec9)
  %14 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec15, <4 x float> %strided.vec10)
  %15 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec16, <4 x float> %strided.vec11)
  %16 = shufflevector <4 x float> %12, <4 x float> %13, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %17 = shufflevector <4 x float> %14, <4 x float> %15, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x float> %16, <8 x float> %17, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  %strided.vec.1 = shufflevector <16 x float> %wide.vec.119, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec9.1 = shufflevector <16 x float> %wide.vec.119, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec10.1 = shufflevector <16 x float> %wide.vec.119, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec11.1 = shufflevector <16 x float> %wide.vec.119, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %18 = getelementptr i8, ptr %uglygep56, i64 %1
  %wide.vec12.1 = load <16 x float>, ptr %18, align 16, !alias.scope !34, !noalias !35
  %strided.vec13.1 = shufflevector <16 x float> %wide.vec12.1, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec14.1 = shufflevector <16 x float> %wide.vec12.1, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec15.1 = shufflevector <16 x float> %wide.vec12.1, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec16.1 = shufflevector <16 x float> %wide.vec12.1, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %19 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec13.1, <4 x float> %strided.vec.1)
  %20 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec14.1, <4 x float> %strided.vec9.1)
  %21 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec15.1, <4 x float> %strided.vec10.1)
  %22 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec16.1, <4 x float> %strided.vec11.1)
  %23 = shufflevector <4 x float> %19, <4 x float> %20, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %24 = shufflevector <4 x float> %21, <4 x float> %22, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec.1 = shufflevector <8 x float> %23, <8 x float> %24, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  %strided.vec.2 = shufflevector <16 x float> %wide.vec.221, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec9.2 = shufflevector <16 x float> %wide.vec.221, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec10.2 = shufflevector <16 x float> %wide.vec.221, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec11.2 = shufflevector <16 x float> %wide.vec.221, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %25 = getelementptr i8, ptr %uglygep56, i64 %2
  %wide.vec12.2 = load <16 x float>, ptr %25, align 16, !alias.scope !34, !noalias !35
  %strided.vec13.2 = shufflevector <16 x float> %wide.vec12.2, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec14.2 = shufflevector <16 x float> %wide.vec12.2, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec15.2 = shufflevector <16 x float> %wide.vec12.2, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec16.2 = shufflevector <16 x float> %wide.vec12.2, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %26 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec13.2, <4 x float> %strided.vec.2)
  %27 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec14.2, <4 x float> %strided.vec9.2)
  %28 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec15.2, <4 x float> %strided.vec10.2)
  %29 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec16.2, <4 x float> %strided.vec11.2)
  %30 = shufflevector <4 x float> %26, <4 x float> %27, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %31 = shufflevector <4 x float> %28, <4 x float> %29, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec.2 = shufflevector <8 x float> %30, <8 x float> %31, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  %strided.vec.3 = shufflevector <16 x float> %wide.vec.323, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec9.3 = shufflevector <16 x float> %wide.vec.323, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec10.3 = shufflevector <16 x float> %wide.vec.323, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec11.3 = shufflevector <16 x float> %wide.vec.323, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %32 = getelementptr i8, ptr %uglygep56, i64 %3
  %wide.vec12.3 = load <16 x float>, ptr %32, align 16, !alias.scope !34, !noalias !35
  %strided.vec13.3 = shufflevector <16 x float> %wide.vec12.3, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec14.3 = shufflevector <16 x float> %wide.vec12.3, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec15.3 = shufflevector <16 x float> %wide.vec12.3, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec16.3 = shufflevector <16 x float> %wide.vec12.3, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %33 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec13.3, <4 x float> %strided.vec.3)
  %34 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec14.3, <4 x float> %strided.vec9.3)
  %35 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec15.3, <4 x float> %strided.vec10.3)
  %36 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec16.3, <4 x float> %strided.vec11.3)
  %37 = shufflevector <4 x float> %33, <4 x float> %34, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %38 = shufflevector <4 x float> %35, <4 x float> %36, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec.3 = shufflevector <8 x float> %37, <8 x float> %38, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  %polly.indvar_next36 = add nuw nsw i64 %polly.indvar35, 1
  %exitcond.not = icmp eq i64 %polly.indvar_next36, %indvars.iv4
  br i1 %exitcond.not, label %polly.loop_exit34, label %polly.loop_header32
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
!9 = !{!10, !11}
!10 = distinct !{}
!11 = distinct !{}
!12 = distinct !{!12, !13, !14, !15}
!13 = !{!"llvm.loop.parallel_accesses", !11}
!14 = !{!"llvm.loop.isvectorized", i32 1}
!15 = !{!"llvm.loop.unroll.runtime.disable"}
!16 = distinct !{!16, !17}
!17 = !{!"llvm.loop.parallel_accesses", !10}
!18 = distinct !{!18, !19}
!19 = !{!"llvm.loop.mustprogress"}
!20 = distinct !{!20, !19}
!21 = !{!22}
!22 = distinct !{!22, !23, !"polly.alias.scope.MemRef_C"}
!23 = distinct !{!23, !"polly.alias.scope.domain"}
!24 = !{!25, !26}
!25 = distinct !{!25, !23, !"polly.alias.scope.MemRef_A"}
!26 = distinct !{!26, !23, !"polly.alias.scope.MemRef_B"}
!27 = distinct !{!27, !28}
!28 = !{!"llvm.loop.parallel_accesses", !29}
!29 = distinct !{}
!30 = !{!25}
!31 = !{!22, !26}
!32 = !{!29, !33}
!33 = distinct !{}
!34 = !{!26}
!35 = !{!22, !25}
