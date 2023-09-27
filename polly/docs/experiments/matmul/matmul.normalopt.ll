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
  br label %vector.ph

vector.ph:                                        ; preds = %0, %middle.block
  %indvars.iv4 = phi i64 [ 0, %0 ], [ %indvars.iv.next5, %middle.block ]
  %broadcast.splatinsert = insertelement <4 x i64> poison, i64 %indvars.iv4, i64 0
  %broadcast.splat = shufflevector <4 x i64> %broadcast.splatinsert, <4 x i64> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.ind = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, %vector.ph ], [ %vec.ind.next, %vector.body ]
  %1 = mul nuw nsw <4 x i64> %vec.ind, %broadcast.splat
  %2 = trunc <4 x i64> %1 to <4 x i32>
  %3 = and <4 x i32> %2, <i32 1023, i32 1023, i32 1023, i32 1023>
  %4 = add nuw nsw <4 x i32> %3, <i32 1, i32 1, i32 1, i32 1>
  %5 = sitofp <4 x i32> %4 to <4 x double>
  %6 = fmul <4 x double> %5, <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
  %7 = fptrunc <4 x double> %6 to <4 x float>
  %8 = getelementptr inbounds [1536 x [1536 x float]], ptr @A, i64 0, i64 %indvars.iv4, i64 %index
  store <4 x float> %7, ptr %8, align 16
  %9 = getelementptr inbounds [1536 x [1536 x float]], ptr @B, i64 0, i64 %indvars.iv4, i64 %index
  store <4 x float> %7, ptr %9, align 16
  %index.next = add nuw i64 %index, 4
  %vec.ind.next = add <4 x i64> %vec.ind, <i64 4, i64 4, i64 4, i64 4>
  %10 = icmp eq i64 %index.next, 1536
  br i1 %10, label %middle.block, label %vector.body, !llvm.loop !4

middle.block:                                     ; preds = %vector.body
  %indvars.iv.next5 = add nuw nsw i64 %indvars.iv4, 1
  %exitcond6.not = icmp eq i64 %indvars.iv.next5, 1536
  br i1 %exitcond6.not, label %11, label %vector.ph, !llvm.loop !8

11:                                               ; preds = %middle.block
  ret void
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
  %6 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef nonnull @.str, double noundef %5) #6
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
  br i1 %exitcond.not, label %13, label %1, !llvm.loop !9

13:                                               ; preds = %12
  %14 = load ptr, ptr @stdout, align 8
  %fputc = tail call i32 @fputc(i32 10, ptr %14)
  %indvars.iv.next6 = add nuw nsw i64 %indvars.iv5, 1
  %exitcond7.not = icmp eq i64 %indvars.iv.next6, 1536
  br i1 %exitcond7.not, label %15, label %.preheader, !llvm.loop !10

15:                                               ; preds = %13
  ret void
}

; Function Attrs: nofree nounwind
declare dso_local noundef i32 @fprintf(ptr nocapture noundef, ptr nocapture noundef readonly, ...) local_unnamed_addr #2

; Function Attrs: nofree noinline nosync nounwind memory(readwrite, argmem: write, inaccessiblemem: none) uwtable
define dso_local i32 @main() local_unnamed_addr #3 {
  tail call void @init_array()
  br label %.preheader

.preheader:                                       ; preds = %21, %0
  %indvars.iv9 = phi i64 [ 0, %0 ], [ %indvars.iv.next10, %21 ]
  br label %1

1:                                                ; preds = %20, %.preheader
  %indvars.iv6 = phi i64 [ 0, %.preheader ], [ %indvars.iv.next7, %20 ]
  %2 = getelementptr inbounds [1536 x [1536 x float]], ptr @C, i64 0, i64 %indvars.iv9, i64 %indvars.iv6
  br label %3

3:                                                ; preds = %3, %1
  %4 = phi float [ 0.000000e+00, %1 ], [ %19, %3 ]
  %indvars.iv = phi i64 [ 0, %1 ], [ %indvars.iv.next.2, %3 ]
  %5 = getelementptr inbounds [1536 x [1536 x float]], ptr @A, i64 0, i64 %indvars.iv9, i64 %indvars.iv
  %6 = load float, ptr %5, align 4
  %7 = getelementptr inbounds [1536 x [1536 x float]], ptr @B, i64 0, i64 %indvars.iv, i64 %indvars.iv6
  %8 = load float, ptr %7, align 4
  %9 = tail call float @llvm.fmuladd.f32(float %6, float %8, float %4)
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %10 = getelementptr inbounds [1536 x [1536 x float]], ptr @A, i64 0, i64 %indvars.iv9, i64 %indvars.iv.next
  %11 = load float, ptr %10, align 4
  %12 = getelementptr inbounds [1536 x [1536 x float]], ptr @B, i64 0, i64 %indvars.iv.next, i64 %indvars.iv6
  %13 = load float, ptr %12, align 4
  %14 = tail call float @llvm.fmuladd.f32(float %11, float %13, float %9)
  %indvars.iv.next.1 = add nuw nsw i64 %indvars.iv, 2
  %15 = getelementptr inbounds [1536 x [1536 x float]], ptr @A, i64 0, i64 %indvars.iv9, i64 %indvars.iv.next.1
  %16 = load float, ptr %15, align 4
  %17 = getelementptr inbounds [1536 x [1536 x float]], ptr @B, i64 0, i64 %indvars.iv.next.1, i64 %indvars.iv6
  %18 = load float, ptr %17, align 4
  %19 = tail call float @llvm.fmuladd.f32(float %16, float %18, float %14)
  %indvars.iv.next.2 = add nuw nsw i64 %indvars.iv, 3
  %exitcond.not.2 = icmp eq i64 %indvars.iv.next.2, 1536
  br i1 %exitcond.not.2, label %20, label %3, !llvm.loop !11

20:                                               ; preds = %3
  store float %19, ptr %2, align 4
  %indvars.iv.next7 = add nuw nsw i64 %indvars.iv6, 1
  %exitcond8.not = icmp eq i64 %indvars.iv.next7, 1536
  br i1 %exitcond8.not, label %21, label %1, !llvm.loop !12

21:                                               ; preds = %20
  %indvars.iv.next10 = add nuw nsw i64 %indvars.iv9, 1
  %exitcond11.not = icmp eq i64 %indvars.iv.next10, 1536
  br i1 %exitcond11.not, label %22, label %.preheader, !llvm.loop !13

22:                                               ; preds = %21
  ret i32 0
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #4

; Function Attrs: nofree nounwind
declare noundef i32 @fputc(i32 noundef, ptr nocapture noundef) local_unnamed_addr #5

attributes #0 = { nofree noinline norecurse nosync nounwind memory(write, argmem: none, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree noinline nosync nounwind memory(readwrite, argmem: write, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nofree nounwind }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{!"clang version 14.0.6"}
!4 = distinct !{!4, !5, !6, !7}
!5 = !{!"llvm.loop.mustprogress"}
!6 = !{!"llvm.loop.isvectorized", i32 1}
!7 = !{!"llvm.loop.unroll.runtime.disable"}
!8 = distinct !{!8, !5}
!9 = distinct !{!9, !5}
!10 = distinct !{!10, !5}
!11 = distinct !{!11, !5}
!12 = distinct !{!12, !5}
!13 = distinct !{!13, !5}
