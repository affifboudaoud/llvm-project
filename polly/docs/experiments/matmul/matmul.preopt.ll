; ModuleID = 'matmul.ll'
source_filename = "matmul.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@A = dso_local global [1536 x [1536 x float]] zeroinitializer, align 16
@B = dso_local global [1536 x [1536 x float]] zeroinitializer, align 16
@stdout = external dso_local global ptr, align 8
@.str = private unnamed_addr constant [5 x i8] c"%lf \00", align 1
@C = dso_local global [1536 x [1536 x float]] zeroinitializer, align 16
@.str.1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @init_array() #0 {
  br label %.preheader

.preheader:                                       ; preds = %0, %11
  %indvars.iv4 = phi i64 [ 0, %0 ], [ %indvars.iv.next5, %11 ]
  br label %1

1:                                                ; preds = %.preheader, %1
  %indvars.iv = phi i64 [ 0, %.preheader ], [ %indvars.iv.next, %1 ]
  %2 = mul nuw nsw i64 %indvars.iv, %indvars.iv4
  %3 = trunc i64 %2 to i32
  %4 = and i32 %3, 1023
  %5 = add nuw nsw i32 %4, 1
  %6 = sitofp i32 %5 to double
  %7 = fmul double %6, 5.000000e-01
  %8 = fptrunc double %7 to float
  %9 = getelementptr inbounds [1536 x [1536 x float]], ptr @A, i64 0, i64 %indvars.iv4, i64 %indvars.iv
  store float %8, ptr %9, align 4
  %10 = getelementptr inbounds [1536 x [1536 x float]], ptr @B, i64 0, i64 %indvars.iv4, i64 %indvars.iv
  store float %8, ptr %10, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, 1536
  br i1 %exitcond, label %1, label %11, !llvm.loop !4

11:                                               ; preds = %1
  %indvars.iv.next5 = add nuw nsw i64 %indvars.iv4, 1
  %exitcond6 = icmp ne i64 %indvars.iv.next5, 1536
  br i1 %exitcond6, label %.preheader, label %12, !llvm.loop !6

12:                                               ; preds = %11
  ret void
}

; Function Attrs: noinline nounwind uwtable
define dso_local void @print_array() #0 {
  br label %.preheader

.preheader:                                       ; preds = %0, %13
  %indvars.iv5 = phi i64 [ 0, %0 ], [ %indvars.iv.next6, %13 ]
  br label %1

1:                                                ; preds = %.preheader, %12
  %indvars.iv = phi i64 [ 0, %.preheader ], [ %indvars.iv.next, %12 ]
  %2 = load ptr, ptr @stdout, align 8
  %3 = getelementptr inbounds [1536 x [1536 x float]], ptr @C, i64 0, i64 %indvars.iv5, i64 %indvars.iv
  %4 = load float, ptr %3, align 4
  %5 = fpext float %4 to double
  %6 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef nonnull @.str, double noundef %5) #4
  %7 = trunc i64 %indvars.iv to i32
  %8 = urem i32 %7, 80
  %9 = icmp eq i32 %8, 79
  br i1 %9, label %10, label %12

10:                                               ; preds = %1
  %11 = load ptr, ptr @stdout, align 8
  %fputc2 = tail call i32 @fputc(i32 10, ptr %11)
  br label %12

12:                                               ; preds = %1, %10
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, 1536
  br i1 %exitcond, label %1, label %13, !llvm.loop !7

13:                                               ; preds = %12
  %14 = load ptr, ptr @stdout, align 8
  %fputc = tail call i32 @fputc(i32 10, ptr %14)
  %indvars.iv.next6 = add nuw nsw i64 %indvars.iv5, 1
  %exitcond7 = icmp ne i64 %indvars.iv.next6, 1536
  br i1 %exitcond7, label %.preheader, label %15, !llvm.loop !8

15:                                               ; preds = %13
  ret void
}

declare dso_local i32 @fprintf(ptr noundef, ptr noundef, ...) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 {
  tail call void @init_array()
  br label %.preheader

.preheader:                                       ; preds = %0, %11
  %indvars.iv9 = phi i64 [ 0, %0 ], [ %indvars.iv.next10, %11 ]
  br label %1

1:                                                ; preds = %.preheader, %10
  %indvars.iv6 = phi i64 [ 0, %.preheader ], [ %indvars.iv.next7, %10 ]
  %2 = getelementptr inbounds [1536 x [1536 x float]], ptr @C, i64 0, i64 %indvars.iv9, i64 %indvars.iv6
  store float 0.000000e+00, ptr %2, align 4
  br label %3

3:                                                ; preds = %1, %3
  %indvars.iv = phi i64 [ 0, %1 ], [ %indvars.iv.next, %3 ]
  %4 = load float, ptr %2, align 4
  %5 = getelementptr inbounds [1536 x [1536 x float]], ptr @A, i64 0, i64 %indvars.iv9, i64 %indvars.iv
  %6 = load float, ptr %5, align 4
  %7 = getelementptr inbounds [1536 x [1536 x float]], ptr @B, i64 0, i64 %indvars.iv, i64 %indvars.iv6
  %8 = load float, ptr %7, align 4
  %9 = tail call float @llvm.fmuladd.f32(float %6, float %8, float %4)
  store float %9, ptr %2, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp ne i64 %indvars.iv.next, 1536
  br i1 %exitcond, label %3, label %10, !llvm.loop !9

10:                                               ; preds = %3
  %indvars.iv.next7 = add nuw nsw i64 %indvars.iv6, 1
  %exitcond8 = icmp ne i64 %indvars.iv.next7, 1536
  br i1 %exitcond8, label %1, label %11, !llvm.loop !10

11:                                               ; preds = %10
  %indvars.iv.next10 = add nuw nsw i64 %indvars.iv9, 1
  %exitcond11 = icmp ne i64 %indvars.iv.next10, 1536
  br i1 %exitcond11, label %.preheader, label %12, !llvm.loop !11

12:                                               ; preds = %11
  ret i32 0
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #2

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(ptr nocapture noundef, i64 noundef, i64 noundef, ptr nocapture noundef) #3

; Function Attrs: nofree nounwind
declare noundef i32 @fputc(i32 noundef, ptr nocapture noundef) #3

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { nofree nounwind }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{!"clang version 14.0.6"}
!4 = distinct !{!4, !5}
!5 = !{!"llvm.loop.mustprogress"}
!6 = distinct !{!6, !5}
!7 = distinct !{!7, !5}
!8 = distinct !{!8, !5}
!9 = distinct !{!9, !5}
!10 = distinct !{!10, !5}
!11 = distinct !{!11, !5}
