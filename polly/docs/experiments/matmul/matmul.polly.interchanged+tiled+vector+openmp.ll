; ModuleID = '<stdin>'
source_filename = "matmul.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@A = dso_local local_unnamed_addr global [1536 x [1536 x float]] zeroinitializer, align 16
@B = dso_local local_unnamed_addr global [1536 x [1536 x float]] zeroinitializer, align 16
@stdout = external dso_local local_unnamed_addr global ptr, align 8
@.str = private unnamed_addr constant [5 x i8] c"%lf \00", align 1
@C = dso_local local_unnamed_addr global [1536 x [1536 x float]] zeroinitializer, align 16

; Function Attrs: noinline nounwind uwtable
define dso_local void @init_array() local_unnamed_addr #0 {
polly.split_new_and_old:
  %polly.par.userContext = alloca {}, align 8
  %polly.par.LBPtr.i = alloca i64, align 8
  %polly.par.UBPtr.i = alloca i64, align 8
  call void @GOMP_parallel_loop_runtime_start(ptr nonnull @init_array_polly_subfn, ptr nonnull %polly.par.userContext, i32 0, i64 0, i64 1536, i64 1) #8
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %polly.par.LBPtr.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %polly.par.UBPtr.i)
  %0 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr.i, ptr nonnull %polly.par.UBPtr.i) #8
  %.not1.i = icmp eq i8 %0, 0
  br i1 %.not1.i, label %init_array_polly_subfn.exit, label %polly.par.loadIVBounds.i

polly.par.checkNext.loopexit.i:                   ; preds = %polly.loop_exit3.i
  %1 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr.i, ptr nonnull %polly.par.UBPtr.i) #8
  %.not.i = icmp eq i8 %1, 0
  br i1 %.not.i, label %init_array_polly_subfn.exit, label %polly.par.loadIVBounds.i

polly.par.loadIVBounds.i:                         ; preds = %polly.split_new_and_old, %polly.par.checkNext.loopexit.i
  %polly.par.LB.i = load i64, ptr %polly.par.LBPtr.i, align 8
  %polly.par.UB.i = load i64, ptr %polly.par.UBPtr.i, align 8
  %polly.par.UBAdjusted.i = add i64 %polly.par.UB.i, -1
  br label %polly.loop_header.i

polly.loop_header.i:                              ; preds = %polly.loop_exit3.i, %polly.par.loadIVBounds.i
  %polly.indvar.i = phi i64 [ %polly.par.LB.i, %polly.par.loadIVBounds.i ], [ %polly.indvar_next.i, %polly.loop_exit3.i ]
  %2 = mul i64 %polly.indvar.i, 6144
  %uglygep.i = getelementptr i8, ptr @A, i64 %2
  %uglygep10.i = getelementptr i8, ptr @B, i64 %2
  %3 = trunc i64 %polly.indvar.i to i32
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %3, i64 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %polly.loop_header.i
  %index = phi i64 [ 0, %polly.loop_header.i ], [ %index.next, %vector.body ]
  %vec.ind = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %polly.loop_header.i ], [ %vec.ind.next, %vector.body ]
  %4 = mul <4 x i32> %vec.ind, %broadcast.splat
  %5 = and <4 x i32> %4, <i32 1023, i32 1023, i32 1023, i32 1023>
  %6 = add nuw nsw <4 x i32> %5, <i32 1, i32 1, i32 1, i32 1>
  %7 = sitofp <4 x i32> %6 to <4 x double>
  %8 = fmul <4 x double> %7, <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
  %9 = fptrunc <4 x double> %8 to <4 x float>
  %10 = shl nuw nsw i64 %index, 2
  %11 = getelementptr i8, ptr %uglygep.i, i64 %10
  store <4 x float> %9, ptr %11, align 16, !alias.scope !4, !noalias !7, !llvm.access.group !9
  %12 = getelementptr i8, ptr %uglygep10.i, i64 %10
  store <4 x float> %9, ptr %12, align 16, !alias.scope !7, !noalias !4, !llvm.access.group !9
  %index.next = add nuw i64 %index, 4
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 4, i32 4, i32 4, i32 4>
  %13 = icmp eq i64 %index.next, 1536
  br i1 %13, label %polly.loop_exit3.i, label %vector.body, !llvm.loop !10

polly.loop_exit3.i:                               ; preds = %vector.body
  %polly.indvar_next.i = add nsw i64 %polly.indvar.i, 1
  %polly.loop_cond.not.not.i = icmp slt i64 %polly.indvar.i, %polly.par.UBAdjusted.i
  br i1 %polly.loop_cond.not.not.i, label %polly.loop_header.i, label %polly.par.checkNext.loopexit.i

init_array_polly_subfn.exit:                      ; preds = %polly.par.checkNext.loopexit.i, %polly.split_new_and_old
  call void @GOMP_loop_end_nowait() #8
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %polly.par.LBPtr.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %polly.par.UBPtr.i)
  call void @GOMP_parallel_end() #8
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
  %6 = tail call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef nonnull @.str, double noundef %5) #8
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
  br i1 %exitcond.not, label %13, label %1, !llvm.loop !14

13:                                               ; preds = %12
  %14 = load ptr, ptr @stdout, align 8
  %fputc = tail call i32 @fputc(i32 10, ptr %14)
  %indvars.iv.next6 = add nuw nsw i64 %indvars.iv5, 1
  %exitcond7.not = icmp eq i64 %indvars.iv.next6, 1536
  br i1 %exitcond7.not, label %15, label %.preheader, !llvm.loop !16

15:                                               ; preds = %13
  ret void
}

; Function Attrs: nofree nounwind
declare dso_local noundef i32 @fprintf(ptr nocapture noundef, ptr nocapture noundef readonly, ...) local_unnamed_addr #2

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() local_unnamed_addr #0 {
polly.split_new_and_old:
  %polly.par.userContext2 = alloca {}, align 8
  %polly.par.LBPtr.i = alloca i64, align 8
  %polly.par.UBPtr.i = alloca i64, align 8
  tail call void @init_array()
  call void @GOMP_parallel_loop_runtime_start(ptr nonnull @main_polly_subfn, ptr nonnull %polly.par.userContext2, i32 0, i64 0, i64 1536, i64 1) #8
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %polly.par.LBPtr.i)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %polly.par.UBPtr.i)
  %0 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr.i, ptr nonnull %polly.par.UBPtr.i) #8
  %.not1.i = icmp eq i8 %0, 0
  br i1 %.not1.i, label %main_polly_subfn.exit, label %polly.par.loadIVBounds.i

polly.par.loadIVBounds.i:                         ; preds = %polly.split_new_and_old, %polly.par.loadIVBounds.i
  %polly.par.LB.i = load i64, ptr %polly.par.LBPtr.i, align 8
  %polly.par.UB.i = load i64, ptr %polly.par.UBPtr.i, align 8
  %polly.par.UBAdjusted.i = add i64 %polly.par.UB.i, -1
  %1 = mul i64 %polly.par.LB.i, 6144
  %uglygep.i = getelementptr i8, ptr @C, i64 %1
  %smax.i = call i64 @llvm.smax.i64(i64 %polly.par.LB.i, i64 %polly.par.UBAdjusted.i)
  %2 = sub i64 1, %polly.par.LB.i
  %3 = add i64 %2, %smax.i
  %4 = mul nuw i64 %3, 6144
  call void @llvm.memset.p0.i64(ptr align 16 %uglygep.i, i8 0, i64 %4, i1 false), !alias.scope !17, !noalias !20
  %5 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr.i, ptr nonnull %polly.par.UBPtr.i) #8
  %.not.i = icmp eq i8 %5, 0
  br i1 %.not.i, label %main_polly_subfn.exit, label %polly.par.loadIVBounds.i

main_polly_subfn.exit:                            ; preds = %polly.par.loadIVBounds.i, %polly.split_new_and_old
  call void @GOMP_loop_end_nowait() #8
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %polly.par.LBPtr.i)
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %polly.par.UBPtr.i)
  call void @GOMP_parallel_end() #8
  call void @GOMP_parallel_loop_runtime_start(ptr nonnull @main_polly_subfn_1, ptr nonnull %polly.par.userContext2, i32 0, i64 0, i64 1536, i64 64) #8
  call void @main_polly_subfn_1(ptr nonnull poison) #8
  call void @GOMP_parallel_end() #8
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @fputc(i32 noundef, ptr nocapture noundef) local_unnamed_addr #3

define internal void @init_array_polly_subfn(ptr nocapture readnone %polly.par.userContext) #4 {
polly.par.setup:
  %polly.par.LBPtr = alloca i64, align 8
  %polly.par.UBPtr = alloca i64, align 8
  %0 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr, ptr nonnull %polly.par.UBPtr)
  %.not1 = icmp eq i8 %0, 0
  br i1 %.not1, label %polly.par.exit, label %polly.par.loadIVBounds

polly.par.exit:                                   ; preds = %polly.par.checkNext.loopexit, %polly.par.setup
  call void @GOMP_loop_end_nowait()
  ret void

polly.par.checkNext.loopexit:                     ; preds = %polly.loop_exit3
  %1 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr, ptr nonnull %polly.par.UBPtr)
  %.not = icmp eq i8 %1, 0
  br i1 %.not, label %polly.par.exit, label %polly.par.loadIVBounds

polly.par.loadIVBounds:                           ; preds = %polly.par.setup, %polly.par.checkNext.loopexit
  %polly.par.LB = load i64, ptr %polly.par.LBPtr, align 8
  %polly.par.UB = load i64, ptr %polly.par.UBPtr, align 8
  %polly.par.UBAdjusted = add i64 %polly.par.UB, -1
  br label %polly.loop_header

polly.loop_header:                                ; preds = %polly.par.loadIVBounds, %polly.loop_exit3
  %polly.indvar = phi i64 [ %polly.par.LB, %polly.par.loadIVBounds ], [ %polly.indvar_next, %polly.loop_exit3 ]
  %2 = mul i64 %polly.indvar, 6144
  %uglygep = getelementptr i8, ptr @A, i64 %2
  %uglygep10 = getelementptr i8, ptr @B, i64 %2
  %3 = trunc i64 %polly.indvar to i32
  %broadcast.splatinsert = insertelement <4 x i32> poison, i32 %3, i64 0
  %broadcast.splat = shufflevector <4 x i32> %broadcast.splatinsert, <4 x i32> poison, <4 x i32> zeroinitializer
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %polly.loop_header
  %index = phi i64 [ 0, %polly.loop_header ], [ %index.next, %vector.body ]
  %vec.ind = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, %polly.loop_header ], [ %vec.ind.next, %vector.body ]
  %4 = mul <4 x i32> %vec.ind, %broadcast.splat
  %5 = and <4 x i32> %4, <i32 1023, i32 1023, i32 1023, i32 1023>
  %6 = add nuw nsw <4 x i32> %5, <i32 1, i32 1, i32 1, i32 1>
  %7 = sitofp <4 x i32> %6 to <4 x double>
  %8 = fmul <4 x double> %7, <double 5.000000e-01, double 5.000000e-01, double 5.000000e-01, double 5.000000e-01>
  %9 = fptrunc <4 x double> %8 to <4 x float>
  %10 = shl nuw nsw i64 %index, 2
  %11 = getelementptr i8, ptr %uglygep, i64 %10
  store <4 x float> %9, ptr %11, align 16, !alias.scope !23, !noalias !26, !llvm.access.group !9
  %12 = getelementptr i8, ptr %uglygep10, i64 %10
  store <4 x float> %9, ptr %12, align 16, !alias.scope !26, !noalias !23, !llvm.access.group !9
  %index.next = add nuw i64 %index, 4
  %vec.ind.next = add <4 x i32> %vec.ind, <i32 4, i32 4, i32 4, i32 4>
  %13 = icmp eq i64 %index.next, 1536
  br i1 %13, label %polly.loop_exit3, label %vector.body, !llvm.loop !28

polly.loop_exit3:                                 ; preds = %vector.body
  %polly.indvar_next = add nsw i64 %polly.indvar, 1
  %polly.loop_cond.not.not = icmp slt i64 %polly.indvar, %polly.par.UBAdjusted
  br i1 %polly.loop_cond.not.not, label %polly.loop_header, label %polly.par.checkNext.loopexit
}

declare i8 @GOMP_loop_runtime_next(ptr, ptr) local_unnamed_addr

declare void @GOMP_loop_end_nowait() local_unnamed_addr

declare void @GOMP_parallel_loop_runtime_start(ptr, ptr, i32, i64, i64, i64) local_unnamed_addr

declare void @GOMP_parallel_end() local_unnamed_addr

define internal void @main_polly_subfn(ptr nocapture readnone %polly.par.userContext) #4 {
polly.par.setup:
  %polly.par.LBPtr = alloca i64, align 8
  %polly.par.UBPtr = alloca i64, align 8
  %0 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr, ptr nonnull %polly.par.UBPtr)
  %.not1 = icmp eq i8 %0, 0
  br i1 %.not1, label %polly.par.exit, label %polly.par.loadIVBounds

polly.par.exit:                                   ; preds = %polly.par.loadIVBounds, %polly.par.setup
  call void @GOMP_loop_end_nowait()
  ret void

polly.par.loadIVBounds:                           ; preds = %polly.par.setup, %polly.par.loadIVBounds
  %polly.par.LB = load i64, ptr %polly.par.LBPtr, align 8
  %polly.par.UB = load i64, ptr %polly.par.UBPtr, align 8
  %polly.par.UBAdjusted = add i64 %polly.par.UB, -1
  %1 = mul i64 %polly.par.LB, 6144
  %uglygep = getelementptr i8, ptr @C, i64 %1
  %smax = call i64 @llvm.smax.i64(i64 %polly.par.LB, i64 %polly.par.UBAdjusted)
  %2 = add i64 %smax, 1
  %3 = sub i64 %2, %polly.par.LB
  %4 = mul nuw i64 %3, 6144
  call void @llvm.memset.p0.i64(ptr align 16 %uglygep, i8 0, i64 %4, i1 false), !alias.scope !29, !noalias !32
  %5 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr, ptr nonnull %polly.par.UBPtr)
  %.not = icmp eq i8 %5, 0
  br i1 %.not, label %polly.par.exit, label %polly.par.loadIVBounds
}

define internal void @main_polly_subfn_1(ptr nocapture readnone %polly.par.userContext) #4 {
polly.par.setup:
  %polly.par.LBPtr = alloca i64, align 8
  %polly.par.UBPtr = alloca i64, align 8
  %0 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr, ptr nonnull %polly.par.UBPtr)
  %.not1 = icmp eq i8 %0, 0
  br i1 %.not1, label %polly.par.exit, label %polly.par.loadIVBounds

polly.par.exit:                                   ; preds = %polly.par.checkNext.loopexit, %polly.par.setup
  call void @GOMP_loop_end_nowait()
  ret void

polly.par.checkNext.loopexit:                     ; preds = %polly.loop_exit3
  %1 = call i8 @GOMP_loop_runtime_next(ptr nonnull %polly.par.LBPtr, ptr nonnull %polly.par.UBPtr)
  %.not = icmp eq i8 %1, 0
  br i1 %.not, label %polly.par.exit, label %polly.par.loadIVBounds

polly.par.loadIVBounds:                           ; preds = %polly.par.setup, %polly.par.checkNext.loopexit
  %polly.par.LB = load i64, ptr %polly.par.LBPtr, align 8
  %polly.par.UB = load i64, ptr %polly.par.UBPtr, align 8
  %polly.par.UBAdjusted = add i64 %polly.par.UB, -1
  br label %polly.loop_header

polly.loop_header:                                ; preds = %polly.par.loadIVBounds, %polly.loop_exit3
  %polly.indvar = phi i64 [ %polly.par.LB, %polly.par.loadIVBounds ], [ %polly.indvar_next, %polly.loop_exit3 ]
  %2 = add nsw i64 %polly.indvar, 63
  br label %polly.loop_header1

polly.loop_exit3:                                 ; preds = %polly.loop_exit9
  %polly.indvar_next = add nsw i64 %polly.indvar, 64
  %polly.loop_cond.not = icmp sgt i64 %polly.indvar_next, %polly.par.UBAdjusted
  br i1 %polly.loop_cond.not, label %polly.par.checkNext.loopexit, label %polly.loop_header

polly.loop_header1:                               ; preds = %polly.loop_header, %polly.loop_exit9
  %polly.indvar4 = phi i64 [ 0, %polly.loop_header ], [ %polly.indvar_next5, %polly.loop_exit9 ]
  %3 = shl nuw nsw i64 %polly.indvar4, 2
  %offset.idx.1 = or i64 %polly.indvar4, 16
  %4 = shl nuw nsw i64 %offset.idx.1, 2
  %offset.idx.2 = or i64 %polly.indvar4, 32
  %5 = shl nuw nsw i64 %offset.idx.2, 2
  %offset.idx.3 = or i64 %polly.indvar4, 48
  %6 = shl nuw nsw i64 %offset.idx.3, 2
  br label %polly.loop_header7

polly.loop_exit9:                                 ; preds = %polly.loop_exit15
  %polly.indvar_next5 = add nuw nsw i64 %polly.indvar4, 64
  %polly.loop_cond6 = icmp ult i64 %polly.indvar4, 1472
  br i1 %polly.loop_cond6, label %polly.loop_header1, label %polly.loop_exit3

polly.loop_header7:                               ; preds = %polly.loop_header1, %polly.loop_exit15
  %indvars.iv4 = phi i64 [ 64, %polly.loop_header1 ], [ %indvars.iv.next5, %polly.loop_exit15 ]
  %polly.indvar10 = phi i64 [ 0, %polly.loop_header1 ], [ %polly.indvar_next11, %polly.loop_exit15 ]
  br label %polly.loop_header13

polly.loop_exit15:                                ; preds = %polly.loop_exit21
  %polly.indvar_next11 = add nuw nsw i64 %polly.indvar10, 64
  %polly.loop_cond12 = icmp ult i64 %polly.indvar10, 1472
  %indvars.iv.next5 = add nuw nsw i64 %indvars.iv4, 64
  br i1 %polly.loop_cond12, label %polly.loop_header7, label %polly.loop_exit9

polly.loop_header13:                              ; preds = %polly.loop_header7, %polly.loop_exit21
  %polly.indvar16 = phi i64 [ %polly.indvar_next17, %polly.loop_exit21 ], [ %polly.indvar, %polly.loop_header7 ]
  %7 = mul i64 %polly.indvar16, 6144
  %uglygep = getelementptr i8, ptr @C, i64 %7
  %uglygep38 = getelementptr i8, ptr @A, i64 %7
  %8 = getelementptr i8, ptr %uglygep, i64 %3
  %9 = getelementptr i8, ptr %uglygep, i64 %4
  %10 = getelementptr i8, ptr %uglygep, i64 %5
  %11 = getelementptr i8, ptr %uglygep, i64 %6
  %.promoted = load <16 x float>, ptr %8, align 16, !alias.scope !29, !noalias !32
  %.promoted15 = load <16 x float>, ptr %9, align 16, !alias.scope !29, !noalias !32
  %.promoted17 = load <16 x float>, ptr %10, align 16, !alias.scope !29, !noalias !32
  %.promoted19 = load <16 x float>, ptr %11, align 16, !alias.scope !29, !noalias !32
  br label %polly.loop_header19

polly.loop_exit21:                                ; preds = %polly.loop_header19
  store <16 x float> %interleaved.vec, ptr %8, align 16, !alias.scope !29, !noalias !32
  store <16 x float> %interleaved.vec.1, ptr %9, align 16, !alias.scope !29, !noalias !32
  store <16 x float> %interleaved.vec.2, ptr %10, align 16, !alias.scope !29, !noalias !32
  store <16 x float> %interleaved.vec.3, ptr %11, align 16, !alias.scope !29, !noalias !32
  %polly.indvar_next17 = add nsw i64 %polly.indvar16, 1
  %polly.loop_cond18.not.not = icmp slt i64 %polly.indvar16, %2
  br i1 %polly.loop_cond18.not.not, label %polly.loop_header13, label %polly.loop_exit15

polly.loop_header19:                              ; preds = %polly.loop_header13, %polly.loop_header19
  %wide.vec.320 = phi <16 x float> [ %.promoted19, %polly.loop_header13 ], [ %interleaved.vec.3, %polly.loop_header19 ]
  %wide.vec.218 = phi <16 x float> [ %.promoted17, %polly.loop_header13 ], [ %interleaved.vec.2, %polly.loop_header19 ]
  %wide.vec.116 = phi <16 x float> [ %.promoted15, %polly.loop_header13 ], [ %interleaved.vec.1, %polly.loop_header19 ]
  %wide.vec14 = phi <16 x float> [ %.promoted, %polly.loop_header13 ], [ %interleaved.vec, %polly.loop_header19 ]
  %polly.indvar22 = phi i64 [ %polly.indvar10, %polly.loop_header13 ], [ %polly.indvar_next23, %polly.loop_header19 ]
  %12 = shl nuw nsw i64 %polly.indvar22, 2
  %uglygep39 = getelementptr i8, ptr %uglygep38, i64 %12
  %_p_scalar_40 = load float, ptr %uglygep39, align 4, !alias.scope !35, !noalias !36, !llvm.access.group !37
  %broadcast.splatinsert = insertelement <4 x float> poison, float %_p_scalar_40, i64 0
  %broadcast.splat = shufflevector <4 x float> %broadcast.splatinsert, <4 x float> poison, <4 x i32> zeroinitializer
  %13 = mul nuw nsw i64 %polly.indvar22, 6144
  %uglygep41 = getelementptr i8, ptr @B, i64 %13
  %strided.vec = shufflevector <16 x float> %wide.vec14, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec6 = shufflevector <16 x float> %wide.vec14, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec7 = shufflevector <16 x float> %wide.vec14, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec8 = shufflevector <16 x float> %wide.vec14, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %14 = getelementptr i8, ptr %uglygep41, i64 %3
  %wide.vec9 = load <16 x float>, ptr %14, align 16, !alias.scope !38, !noalias !39
  %strided.vec10 = shufflevector <16 x float> %wide.vec9, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec11 = shufflevector <16 x float> %wide.vec9, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec12 = shufflevector <16 x float> %wide.vec9, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec13 = shufflevector <16 x float> %wide.vec9, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %15 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec10, <4 x float> %strided.vec)
  %16 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec11, <4 x float> %strided.vec6)
  %17 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec12, <4 x float> %strided.vec7)
  %18 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec13, <4 x float> %strided.vec8)
  %19 = shufflevector <4 x float> %15, <4 x float> %16, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %20 = shufflevector <4 x float> %17, <4 x float> %18, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x float> %19, <8 x float> %20, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  %strided.vec.1 = shufflevector <16 x float> %wide.vec.116, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec6.1 = shufflevector <16 x float> %wide.vec.116, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec7.1 = shufflevector <16 x float> %wide.vec.116, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec8.1 = shufflevector <16 x float> %wide.vec.116, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %21 = getelementptr i8, ptr %uglygep41, i64 %4
  %wide.vec9.1 = load <16 x float>, ptr %21, align 16, !alias.scope !38, !noalias !39
  %strided.vec10.1 = shufflevector <16 x float> %wide.vec9.1, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec11.1 = shufflevector <16 x float> %wide.vec9.1, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec12.1 = shufflevector <16 x float> %wide.vec9.1, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec13.1 = shufflevector <16 x float> %wide.vec9.1, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %22 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec10.1, <4 x float> %strided.vec.1)
  %23 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec11.1, <4 x float> %strided.vec6.1)
  %24 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec12.1, <4 x float> %strided.vec7.1)
  %25 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec13.1, <4 x float> %strided.vec8.1)
  %26 = shufflevector <4 x float> %22, <4 x float> %23, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %27 = shufflevector <4 x float> %24, <4 x float> %25, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec.1 = shufflevector <8 x float> %26, <8 x float> %27, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  %strided.vec.2 = shufflevector <16 x float> %wide.vec.218, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec6.2 = shufflevector <16 x float> %wide.vec.218, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec7.2 = shufflevector <16 x float> %wide.vec.218, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec8.2 = shufflevector <16 x float> %wide.vec.218, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %28 = getelementptr i8, ptr %uglygep41, i64 %5
  %wide.vec9.2 = load <16 x float>, ptr %28, align 16, !alias.scope !38, !noalias !39
  %strided.vec10.2 = shufflevector <16 x float> %wide.vec9.2, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec11.2 = shufflevector <16 x float> %wide.vec9.2, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec12.2 = shufflevector <16 x float> %wide.vec9.2, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec13.2 = shufflevector <16 x float> %wide.vec9.2, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %29 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec10.2, <4 x float> %strided.vec.2)
  %30 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec11.2, <4 x float> %strided.vec6.2)
  %31 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec12.2, <4 x float> %strided.vec7.2)
  %32 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec13.2, <4 x float> %strided.vec8.2)
  %33 = shufflevector <4 x float> %29, <4 x float> %30, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %34 = shufflevector <4 x float> %31, <4 x float> %32, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec.2 = shufflevector <8 x float> %33, <8 x float> %34, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  %strided.vec.3 = shufflevector <16 x float> %wide.vec.320, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec6.3 = shufflevector <16 x float> %wide.vec.320, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec7.3 = shufflevector <16 x float> %wide.vec.320, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec8.3 = shufflevector <16 x float> %wide.vec.320, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %35 = getelementptr i8, ptr %uglygep41, i64 %6
  %wide.vec9.3 = load <16 x float>, ptr %35, align 16, !alias.scope !38, !noalias !39
  %strided.vec10.3 = shufflevector <16 x float> %wide.vec9.3, <16 x float> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.vec11.3 = shufflevector <16 x float> %wide.vec9.3, <16 x float> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.vec12.3 = shufflevector <16 x float> %wide.vec9.3, <16 x float> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.vec13.3 = shufflevector <16 x float> %wide.vec9.3, <16 x float> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %36 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec10.3, <4 x float> %strided.vec.3)
  %37 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec11.3, <4 x float> %strided.vec6.3)
  %38 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec12.3, <4 x float> %strided.vec7.3)
  %39 = call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %broadcast.splat, <4 x float> %strided.vec13.3, <4 x float> %strided.vec8.3)
  %40 = shufflevector <4 x float> %36, <4 x float> %37, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %41 = shufflevector <4 x float> %38, <4 x float> %39, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec.3 = shufflevector <8 x float> %40, <8 x float> %41, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  %polly.indvar_next23 = add nuw nsw i64 %polly.indvar22, 1
  %exitcond.not = icmp eq i64 %polly.indvar_next23, %indvars.iv4
  br i1 %exitcond.not, label %polly.loop_exit21, label %polly.loop_header19
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #5

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #5

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #6

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.smax.i64(i64, i64) #7

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.fmuladd.v4f32(<4 x float>, <4 x float>, <4 x float>) #7

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "no-trapping-math"="true" "polly-optimized" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nounwind }
attributes #4 = { "polly.skip.fn" }
attributes #5 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #6 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #7 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #8 = { nounwind }

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
!9 = distinct !{}
!10 = distinct !{!10, !11, !12, !13}
!11 = !{!"llvm.loop.parallel_accesses", !9}
!12 = !{!"llvm.loop.isvectorized", i32 1}
!13 = !{!"llvm.loop.unroll.runtime.disable"}
!14 = distinct !{!14, !15}
!15 = !{!"llvm.loop.mustprogress"}
!16 = distinct !{!16, !15}
!17 = !{!18}
!18 = distinct !{!18, !19, !"polly.alias.scope.MemRef_C"}
!19 = distinct !{!19, !"polly.alias.scope.domain"}
!20 = !{!21, !22}
!21 = distinct !{!21, !19, !"polly.alias.scope.MemRef_A"}
!22 = distinct !{!22, !19, !"polly.alias.scope.MemRef_B"}
!23 = !{!24}
!24 = distinct !{!24, !25, !"polly.alias.scope.MemRef_A"}
!25 = distinct !{!25, !"polly.alias.scope.domain"}
!26 = !{!27}
!27 = distinct !{!27, !25, !"polly.alias.scope.MemRef_B"}
!28 = distinct !{!28, !11, !12, !13}
!29 = !{!30}
!30 = distinct !{!30, !31, !"polly.alias.scope.MemRef_C"}
!31 = distinct !{!31, !"polly.alias.scope.domain"}
!32 = !{!33, !34}
!33 = distinct !{!33, !31, !"polly.alias.scope.MemRef_A"}
!34 = distinct !{!34, !31, !"polly.alias.scope.MemRef_B"}
!35 = !{!33}
!36 = !{!30, !34}
!37 = distinct !{}
!38 = !{!34}
!39 = !{!30, !33}
