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
  %polly.indvar11 = phi i64 [ %polly.indvar_next12, %polly.loop_exit16 ], [ 0, %polly.split_new_and_old ]
  %0 = mul nuw nsw i64 %polly.indvar11, 6144
  %uglygep27 = getelementptr i8, ptr @C, i64 %0
  %uglygep29 = getelementptr i8, ptr @A, i64 %0
  br label %polly.loop_header14

polly.loop_exit16:                                ; preds = %polly.loop_exit22
  %polly.indvar_next12 = add nuw nsw i64 %polly.indvar11, 1
  %exitcond3.not = icmp eq i64 %polly.indvar_next12, 1536
  br i1 %exitcond3.not, label %polly.exiting, label %polly.loop_header8

polly.loop_header14:                              ; preds = %polly.loop_header8, %polly.loop_exit22
  %polly.indvar17 = phi i64 [ 0, %polly.loop_header8 ], [ %polly.indvar_next18, %polly.loop_exit22 ]
  %1 = mul nuw nsw i64 %polly.indvar17, 6144
  %uglygep32 = getelementptr i8, ptr @B, i64 %1
  %2 = shl nuw nsw i64 %polly.indvar17, 2
  %uglygep30 = getelementptr i8, ptr %uglygep29, i64 %2
  %_p_scalar_31 = load float, ptr %uglygep30, align 4, !alias.scope !21, !noalias !22
  %broadcast.splatinsert = insertelement <4 x float> poison, float %_p_scalar_31, i64 0
  %broadcast.splat = shufflevector <4 x float> %broadcast.splatinsert, <4 x float> poison, <4 x i32> zeroinitializer
  %broadcast.splatinsert7 = insertelement <4 x float> poison, float %_p_scalar_31, i64 0
  %broadcast.splat8 = shufflevector <4 x float> %broadcast.splatinsert7, <4 x float> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %polly.loop_header14
  %index = phi i64 [ 0, %polly.loop_header14 ], [ %index.next.1, %vector.body ]
  %3 = shl nuw nsw i64 %index, 2
  %4 = getelementptr i8, ptr %uglygep27, i64 %3
  %wide.load = load <4 x float>, ptr %4, align 16, !alias.scope !15, !noalias !18
  %5 = getelementptr float, ptr %4, i64 4
  %wide.load4 = load <4 x float>, ptr %5, align 16, !alias.scope !15, !noalias !18
  %6 = getelementptr i8, ptr %uglygep32, i64 %3
  %wide.load5 = load <4 x float>, ptr %6, align 16, !alias.scope !23, !noalias !24
  %7 = getelementptr float, ptr %6, i64 4
  %wide.load6 = load <4 x float>, ptr %7, align 16, !alias.scope !23, !noalias !24
  %8 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load5, <4 x float> %wide.load)
  %9 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat8, <4 x float> %wide.load6, <4 x float> %wide.load4)
  store <4 x float> %8, ptr %4, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %9, ptr %5, align 16, !alias.scope !15, !noalias !18
  %index.next = shl i64 %index, 2
  %10 = or i64 %index.next, 32
  %11 = getelementptr i8, ptr %uglygep27, i64 %10
  %wide.load.1 = load <4 x float>, ptr %11, align 16, !alias.scope !15, !noalias !18
  %12 = getelementptr float, ptr %11, i64 4
  %wide.load4.1 = load <4 x float>, ptr %12, align 16, !alias.scope !15, !noalias !18
  %13 = getelementptr i8, ptr %uglygep32, i64 %10
  %wide.load5.1 = load <4 x float>, ptr %13, align 16, !alias.scope !23, !noalias !24
  %14 = getelementptr float, ptr %13, i64 4
  %wide.load6.1 = load <4 x float>, ptr %14, align 16, !alias.scope !23, !noalias !24
  %15 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %wide.load5.1, <4 x float> %wide.load.1)
  %16 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat8, <4 x float> %wide.load6.1, <4 x float> %wide.load4.1)
  store <4 x float> %15, ptr %11, align 16, !alias.scope !15, !noalias !18
  store <4 x float> %16, ptr %12, align 16, !alias.scope !15, !noalias !18
  %index.next.1 = add nuw nsw i64 %index, 16
  %17 = icmp eq i64 %index.next.1, 1536
  br i1 %17, label %polly.loop_exit22, label %vector.body, !llvm.loop !25

polly.loop_exit22:                                ; preds = %vector.body
  %polly.indvar_next18 = add nuw nsw i64 %polly.indvar17, 1
  %exitcond2.not = icmp eq i64 %polly.indvar_next18, 1536
  br i1 %exitcond2.not, label %polly.loop_exit16, label %polly.loop_header14
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
!25 = distinct !{!25, !10, !11}
