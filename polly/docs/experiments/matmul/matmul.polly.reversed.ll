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
  br label %polly.loop_header

polly.exiting:                                    ; preds = %polly.loop_exit3
  ret i32 0

polly.loop_header:                                ; preds = %polly.split_new_and_old, %polly.loop_exit3
  %indvar = phi i64 [ 0, %polly.split_new_and_old ], [ %indvar.next, %polly.loop_exit3 ]
  %polly.indvar = phi i64 [ -1535, %polly.split_new_and_old ], [ %polly.indvar_next, %polly.loop_exit3 ]
  %0 = mul nsw i64 %indvar, -6144
  %1 = add nsw i64 %0, 9431040
  %uglygep = getelementptr i8, ptr @C, i64 %1
  %2 = mul nsw i64 %polly.indvar, 6144
  %uglygep18 = getelementptr i8, ptr @C, i64 %2
  %uglygep20 = getelementptr i8, ptr @A, i64 %2
  %3 = icmp slt i64 %polly.indvar, 1
  %4 = mul nsw i64 %polly.indvar, -6144
  br i1 %3, label %polly.loop_header.split.us, label %polly.loop_header1

polly.loop_header.split.us:                       ; preds = %polly.loop_header
  %5 = icmp sgt i64 %polly.indvar, -1
  br i1 %5, label %polly.loop_header1.us.us, label %polly.loop_header1.us.preheader

polly.loop_header1.us.preheader:                  ; preds = %polly.loop_header.split.us
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(6144) %uglygep, i8 0, i64 6144, i1 false), !alias.scope !15, !noalias !18
  br label %polly.loop_exit3

polly.loop_header1.us.us:                         ; preds = %polly.loop_header.split.us, %polly.merge8.loopexit.us.us
  %polly.indvar4.us.us = phi i64 [ %polly.indvar_next5.us.us, %polly.merge8.loopexit.us.us ], [ 0, %polly.loop_header.split.us ]
  %6 = shl nuw nsw i64 %polly.indvar4.us.us, 2
  %7 = add nsw i64 %6, %4
  %uglygep.us.us = getelementptr i8, ptr @C, i64 %7
  store float 0.000000e+00, ptr %uglygep.us.us, align 4, !alias.scope !15, !noalias !18
  %uglygep19.us.us = getelementptr i8, ptr %uglygep18, i64 %6
  %uglygep23.us.us = getelementptr i8, ptr @B, i64 %6
  %uglygep19.promoted.us.us = load float, ptr %uglygep19.us.us, align 4, !alias.scope !15, !noalias !18
  br label %polly.loop_header11.us.us

polly.loop_header11.us.us:                        ; preds = %polly.loop_header11.us.us, %polly.loop_header1.us.us
  %_p_scalar_1.us.us = phi float [ %uglygep19.promoted.us.us, %polly.loop_header1.us.us ], [ %p_.us.us.2, %polly.loop_header11.us.us ]
  %polly.indvar14.us.us = phi i64 [ 0, %polly.loop_header1.us.us ], [ %polly.indvar_next15.us.us.2, %polly.loop_header11.us.us ]
  %8 = shl nuw nsw i64 %polly.indvar14.us.us, 2
  %uglygep21.us.us = getelementptr i8, ptr %uglygep20, i64 %8
  %_p_scalar_22.us.us = load float, ptr %uglygep21.us.us, align 4, !alias.scope !21, !noalias !22
  %9 = mul nuw nsw i64 %polly.indvar14.us.us, 6144
  %uglygep24.us.us = getelementptr i8, ptr %uglygep23.us.us, i64 %9
  %_p_scalar_25.us.us = load float, ptr %uglygep24.us.us, align 4, !alias.scope !23, !noalias !24
  %p_.us.us = tail call float @llvm.fmuladd.f32(float %_p_scalar_22.us.us, float %_p_scalar_25.us.us, float %_p_scalar_1.us.us)
  %polly.indvar_next15.us.us = add nuw nsw i64 %polly.indvar14.us.us, 1
  %10 = shl nuw nsw i64 %polly.indvar_next15.us.us, 2
  %uglygep21.us.us.1 = getelementptr i8, ptr %uglygep20, i64 %10
  %_p_scalar_22.us.us.1 = load float, ptr %uglygep21.us.us.1, align 4, !alias.scope !21, !noalias !22
  %11 = mul nuw nsw i64 %polly.indvar_next15.us.us, 6144
  %uglygep24.us.us.1 = getelementptr i8, ptr %uglygep23.us.us, i64 %11
  %_p_scalar_25.us.us.1 = load float, ptr %uglygep24.us.us.1, align 4, !alias.scope !23, !noalias !24
  %p_.us.us.1 = tail call float @llvm.fmuladd.f32(float %_p_scalar_22.us.us.1, float %_p_scalar_25.us.us.1, float %p_.us.us)
  %polly.indvar_next15.us.us.1 = add nuw nsw i64 %polly.indvar14.us.us, 2
  %12 = shl nuw nsw i64 %polly.indvar_next15.us.us.1, 2
  %uglygep21.us.us.2 = getelementptr i8, ptr %uglygep20, i64 %12
  %_p_scalar_22.us.us.2 = load float, ptr %uglygep21.us.us.2, align 4, !alias.scope !21, !noalias !22
  %13 = mul nuw nsw i64 %polly.indvar_next15.us.us.1, 6144
  %uglygep24.us.us.2 = getelementptr i8, ptr %uglygep23.us.us, i64 %13
  %_p_scalar_25.us.us.2 = load float, ptr %uglygep24.us.us.2, align 4, !alias.scope !23, !noalias !24
  %p_.us.us.2 = tail call float @llvm.fmuladd.f32(float %_p_scalar_22.us.us.2, float %_p_scalar_25.us.us.2, float %p_.us.us.1)
  %polly.indvar_next15.us.us.2 = add nuw nsw i64 %polly.indvar14.us.us, 3
  %exitcond5.not.2 = icmp eq i64 %polly.indvar_next15.us.us.2, 1536
  br i1 %exitcond5.not.2, label %polly.merge8.loopexit.us.us, label %polly.loop_header11.us.us

polly.merge8.loopexit.us.us:                      ; preds = %polly.loop_header11.us.us
  store float %p_.us.us.2, ptr %uglygep19.us.us, align 4, !alias.scope !15, !noalias !18
  %polly.indvar_next5.us.us = add nuw nsw i64 %polly.indvar4.us.us, 1
  %exitcond7.not = icmp eq i64 %polly.indvar_next5.us.us, 1536
  br i1 %exitcond7.not, label %polly.loop_exit3, label %polly.loop_header1.us.us

polly.loop_exit3:                                 ; preds = %polly.merge8.loopexit, %polly.merge8.loopexit.us.us, %polly.loop_header1.us.preheader
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %indvar.next = add nuw nsw i64 %indvar, 1
  %exitcond8.not = icmp eq i64 %indvar.next, 3071
  br i1 %exitcond8.not, label %polly.exiting, label %polly.loop_header

polly.loop_header1:                               ; preds = %polly.loop_header, %polly.merge8.loopexit
  %polly.indvar4 = phi i64 [ %polly.indvar_next5, %polly.merge8.loopexit ], [ 0, %polly.loop_header ]
  %14 = shl nuw nsw i64 %polly.indvar4, 2
  %uglygep19 = getelementptr i8, ptr %uglygep18, i64 %14
  %uglygep23 = getelementptr i8, ptr @B, i64 %14
  %uglygep19.promoted = load float, ptr %uglygep19, align 4, !alias.scope !15, !noalias !18
  br label %polly.loop_header11

polly.merge8.loopexit:                            ; preds = %polly.loop_header11
  store float %p_.2, ptr %uglygep19, align 4, !alias.scope !15, !noalias !18
  %polly.indvar_next5 = add nuw nsw i64 %polly.indvar4, 1
  %exitcond4.not = icmp eq i64 %polly.indvar_next5, 1536
  br i1 %exitcond4.not, label %polly.loop_exit3, label %polly.loop_header1

polly.loop_header11:                              ; preds = %polly.loop_header11, %polly.loop_header1
  %_p_scalar_1 = phi float [ %uglygep19.promoted, %polly.loop_header1 ], [ %p_.2, %polly.loop_header11 ]
  %polly.indvar14 = phi i64 [ 0, %polly.loop_header1 ], [ %polly.indvar_next15.2, %polly.loop_header11 ]
  %15 = shl nuw nsw i64 %polly.indvar14, 2
  %uglygep21 = getelementptr i8, ptr %uglygep20, i64 %15
  %_p_scalar_22 = load float, ptr %uglygep21, align 4, !alias.scope !21, !noalias !22
  %16 = mul nuw nsw i64 %polly.indvar14, 6144
  %uglygep24 = getelementptr i8, ptr %uglygep23, i64 %16
  %_p_scalar_25 = load float, ptr %uglygep24, align 4, !alias.scope !23, !noalias !24
  %p_ = tail call float @llvm.fmuladd.f32(float %_p_scalar_22, float %_p_scalar_25, float %_p_scalar_1)
  %polly.indvar_next15 = add nuw nsw i64 %polly.indvar14, 1
  %17 = shl nuw nsw i64 %polly.indvar_next15, 2
  %uglygep21.1 = getelementptr i8, ptr %uglygep20, i64 %17
  %_p_scalar_22.1 = load float, ptr %uglygep21.1, align 4, !alias.scope !21, !noalias !22
  %18 = mul nuw nsw i64 %polly.indvar_next15, 6144
  %uglygep24.1 = getelementptr i8, ptr %uglygep23, i64 %18
  %_p_scalar_25.1 = load float, ptr %uglygep24.1, align 4, !alias.scope !23, !noalias !24
  %p_.1 = tail call float @llvm.fmuladd.f32(float %_p_scalar_22.1, float %_p_scalar_25.1, float %p_)
  %polly.indvar_next15.1 = add nuw nsw i64 %polly.indvar14, 2
  %19 = shl nuw nsw i64 %polly.indvar_next15.1, 2
  %uglygep21.2 = getelementptr i8, ptr %uglygep20, i64 %19
  %_p_scalar_22.2 = load float, ptr %uglygep21.2, align 4, !alias.scope !21, !noalias !22
  %20 = mul nuw nsw i64 %polly.indvar_next15.1, 6144
  %uglygep24.2 = getelementptr i8, ptr %uglygep23, i64 %20
  %_p_scalar_25.2 = load float, ptr %uglygep24.2, align 4, !alias.scope !23, !noalias !24
  %p_.2 = tail call float @llvm.fmuladd.f32(float %_p_scalar_22.2, float %_p_scalar_25.2, float %p_.1)
  %polly.indvar_next15.2 = add nuw nsw i64 %polly.indvar14, 3
  %exitcond.not.2 = icmp eq i64 %polly.indvar_next15.2, 1536
  br i1 %exitcond.not.2, label %polly.merge8.loopexit, label %polly.loop_header11
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #4

; Function Attrs: nofree nounwind
declare noundef i32 @fputc(i32 noundef, ptr nocapture noundef) local_unnamed_addr #5

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #6

attributes #0 = { nofree noinline norecurse nosync nounwind memory(write, argmem: none, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "polly-optimized" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree noinline nosync nounwind memory(readwrite, argmem: write, inaccessiblemem: none) uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "polly-optimized" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nofree nounwind }
attributes #6 = { nocallback nofree nounwind willreturn memory(argmem: write) }
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
