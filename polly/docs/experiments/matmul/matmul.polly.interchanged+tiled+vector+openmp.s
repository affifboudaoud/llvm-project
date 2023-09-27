	.text
	.file	"matmul.c"
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0                          # -- Begin function init_array
.LCPI0_0:
	.long	0                               # 0x0
	.long	1                               # 0x1
	.long	2                               # 0x2
	.long	3                               # 0x3
.LCPI0_1:
	.long	1023                            # 0x3ff
	.long	1023                            # 0x3ff
	.long	1023                            # 0x3ff
	.long	1023                            # 0x3ff
.LCPI0_2:
	.quad	0x3fe0000000000000              # double 0.5
	.quad	0x3fe0000000000000              # double 0.5
.LCPI0_3:
	.long	4                               # 0x4
	.long	4                               # 0x4
	.long	4                               # 0x4
	.long	4                               # 0x4
	.text
	.globl	init_array
	.p2align	4, 0x90
	.type	init_array,@function
init_array:                             # @init_array
.Linit_array$local:
	.type	.Linit_array$local,@function
	.cfi_startproc
# %bb.0:                                # %polly.split_new_and_old
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	leaq	init_array_polly_subfn(%rip), %rdi
	leaq	-40(%rbp), %rsi
	movl	$1536, %r8d                     # imm = 0x600
	movl	$1, %r9d
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	callq	GOMP_parallel_loop_runtime_start@PLT
	leaq	-56(%rbp), %rdi
	leaq	-48(%rbp), %rsi
	callq	GOMP_loop_runtime_next@PLT
	testb	%al, %al
	je	.LBB0_7
# %bb.1:
	movdqa	.LCPI0_0(%rip), %xmm5           # xmm5 = [0,1,2,3]
	movdqa	.LCPI0_1(%rip), %xmm6           # xmm6 = [1023,1023,1023,1023]
	pcmpeqd	%xmm7, %xmm7
	movapd	.LCPI0_2(%rip), %xmm8           # xmm8 = [5.0E-1,5.0E-1]
	leaq	.LA$local(%rip), %r15
	leaq	.LB$local(%rip), %r12
	movdqa	.LCPI0_3(%rip), %xmm9           # xmm9 = [4,4,4,4]
	leaq	-56(%rbp), %rbx
	leaq	-48(%rbp), %r14
	.p2align	4, 0x90
.LBB0_3:                                # %polly.par.loadIVBounds.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
                                        #       Child Loop BB0_5 Depth 3
	movq	-56(%rbp), %rcx
	movq	-48(%rbp), %rax
	decq	%rax
	movq	%rcx, %rdx
	shlq	$11, %rdx
	leaq	(%rdx,%rdx,2), %rdx
	.p2align	4, 0x90
.LBB0_4:                                # %polly.loop_header.i
                                        #   Parent Loop BB0_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_5 Depth 3
	movd	%ecx, %xmm0
	pshufd	$0, %xmm0, %xmm0                # xmm0 = xmm0[0,0,0,0]
	xorl	%esi, %esi
	movdqa	%xmm5, %xmm1
	.p2align	4, 0x90
.LBB0_5:                                # %vector.body
                                        #   Parent Loop BB0_3 Depth=1
                                        #     Parent Loop BB0_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movdqa	%xmm1, %xmm2
	pmuludq	%xmm0, %xmm2
	pshufd	$232, %xmm2, %xmm2              # xmm2 = xmm2[0,2,2,3]
	pshufd	$245, %xmm0, %xmm3              # xmm3 = xmm0[1,1,3,3]
	pshufd	$245, %xmm1, %xmm4              # xmm4 = xmm1[1,1,3,3]
	pmuludq	%xmm3, %xmm4
	pshufd	$232, %xmm4, %xmm3              # xmm3 = xmm4[0,2,2,3]
	punpckldq	%xmm3, %xmm2            # xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
	pand	%xmm6, %xmm2
	psubd	%xmm7, %xmm2
	cvtdq2pd	%xmm2, %xmm3
	pshufd	$238, %xmm2, %xmm2              # xmm2 = xmm2[2,3,2,3]
	cvtdq2pd	%xmm2, %xmm2
	mulpd	%xmm8, %xmm2
	mulpd	%xmm8, %xmm3
	cvtpd2ps	%xmm3, %xmm3
	cvtpd2ps	%xmm2, %xmm2
	unpcklpd	%xmm2, %xmm3                    # xmm3 = xmm3[0],xmm2[0]
	leaq	(%rdx,%rsi), %rdi
	movapd	%xmm3, (%r15,%rdi)
	movapd	%xmm3, (%r12,%rdi)
	paddd	%xmm9, %xmm1
	addq	$16, %rsi
	cmpq	$6144, %rsi                     # imm = 0x1800
	jne	.LBB0_5
# %bb.6:                                # %polly.loop_exit3.i
                                        #   in Loop: Header=BB0_4 Depth=2
	leaq	1(%rcx), %rsi
	addq	$6144, %rdx                     # imm = 0x1800
	cmpq	%rax, %rcx
	movq	%rsi, %rcx
	jl	.LBB0_4
# %bb.2:                                # %polly.par.checkNext.loopexit.i
                                        #   in Loop: Header=BB0_3 Depth=1
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	GOMP_loop_runtime_next@PLT
	movdqa	.LCPI0_3(%rip), %xmm9           # xmm9 = [4,4,4,4]
	movapd	.LCPI0_2(%rip), %xmm8           # xmm8 = [5.0E-1,5.0E-1]
	pcmpeqd	%xmm7, %xmm7
	movdqa	.LCPI0_1(%rip), %xmm6           # xmm6 = [1023,1023,1023,1023]
	movdqa	.LCPI0_0(%rip), %xmm5           # xmm5 = [0,1,2,3]
	testb	%al, %al
	jne	.LBB0_3
.LBB0_7:                                # %init_array_polly_subfn.exit
	callq	GOMP_loop_end_nowait@PLT
	callq	GOMP_parallel_end@PLT
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	init_array, .Lfunc_end0-init_array
	.size	.Linit_array$local, .Lfunc_end0-init_array
	.cfi_endproc
                                        # -- End function
	.globl	print_array                     # -- Begin function print_array
	.p2align	4, 0x90
	.type	print_array,@function
print_array:                            # @print_array
.Lprint_array$local:
	.type	.Lprint_array$local,@function
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	leaq	.LC$local(%rip), %r14
	xorl	%eax, %eax
	movl	$3435973837, %r12d              # imm = 0xCCCCCCCD
	leaq	.L.str(%rip), %rbx
	jmp	.LBB1_1
	.p2align	4, 0x90
.LBB1_5:                                #   in Loop: Header=BB1_1 Depth=1
	movq	stdout(%rip), %rsi
	movl	$10, %edi
	callq	fputc@PLT
	movq	-48(%rbp), %rax                 # 8-byte Reload
	incq	%rax
	addq	$6144, %r14                     # imm = 0x1800
	cmpq	$1536, %rax                     # imm = 0x600
	je	.LBB1_6
.LBB1_1:                                # %.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	movq	%rax, -48(%rbp)                 # 8-byte Spill
	xorl	%r13d, %r13d
	jmp	.LBB1_2
	.p2align	4, 0x90
.LBB1_4:                                #   in Loop: Header=BB1_2 Depth=2
	incq	%r13
	cmpq	$1536, %r13                     # imm = 0x600
	je	.LBB1_5
.LBB1_2:                                #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	%r13d, %eax
	imulq	%r12, %rax
	shrq	$38, %rax
	leal	(%rax,%rax,4), %r15d
	shll	$4, %r15d
	addl	$79, %r15d
	movq	stdout(%rip), %rdi
	movss	(%r14,%r13,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	movq	%rbx, %rsi
	movb	$1, %al
	callq	fprintf
	cmpl	%r13d, %r15d
	jne	.LBB1_4
# %bb.3:                                #   in Loop: Header=BB1_2 Depth=2
	movq	stdout(%rip), %rsi
	movl	$10, %edi
	callq	fputc@PLT
	jmp	.LBB1_4
.LBB1_6:
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	print_array, .Lfunc_end1-print_array
	.size	.Lprint_array$local, .Lfunc_end1-print_array
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
.Lmain$local:
	.type	.Lmain$local,@function
	.cfi_startproc
# %bb.0:                                # %polly.split_new_and_old
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	callq	.Linit_array$local
	leaq	main_polly_subfn(%rip), %rdi
	leaq	-32(%rbp), %rsi
	movl	$1536, %r8d                     # imm = 0x600
	movl	$1, %r9d
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	callq	GOMP_parallel_loop_runtime_start@PLT
	leaq	-48(%rbp), %rdi
	leaq	-40(%rbp), %rsi
	callq	GOMP_loop_runtime_next@PLT
	testb	%al, %al
	je	.LBB2_3
# %bb.1:                                # %polly.par.loadIVBounds.i.preheader
	leaq	.LC$local(%rip), %r15
	leaq	-48(%rbp), %rbx
	leaq	-40(%rbp), %r14
	.p2align	4, 0x90
.LBB2_2:                                # %polly.par.loadIVBounds.i
                                        # =>This Inner Loop Header: Depth=1
	movq	-48(%rbp), %rax
	movq	-40(%rbp), %rcx
	decq	%rcx
	leaq	(%rax,%rax,2), %rdi
	shlq	$11, %rdi
	addq	%r15, %rdi
	cmpq	%rcx, %rax
	cmovgq	%rax, %rcx
	subq	%rax, %rcx
	leaq	(%rcx,%rcx,2), %rdx
	shlq	$11, %rdx
	addq	$6144, %rdx                     # imm = 0x1800
	xorl	%esi, %esi
	callq	memset@PLT
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	GOMP_loop_runtime_next@PLT
	testb	%al, %al
	jne	.LBB2_2
.LBB2_3:                                # %main_polly_subfn.exit
	callq	GOMP_loop_end_nowait@PLT
	callq	GOMP_parallel_end@PLT
	leaq	main_polly_subfn_1(%rip), %rdi
	leaq	-32(%rbp), %rsi
	movl	$1536, %r8d                     # imm = 0x600
	movl	$64, %r9d
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	callq	GOMP_parallel_loop_runtime_start@PLT
	callq	main_polly_subfn_1
	callq	GOMP_parallel_end@PLT
	xorl	%eax, %eax
	addq	$24, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
	.size	.Lmain$local, .Lfunc_end2-main
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0                          # -- Begin function init_array_polly_subfn
.LCPI3_0:
	.long	0                               # 0x0
	.long	1                               # 0x1
	.long	2                               # 0x2
	.long	3                               # 0x3
.LCPI3_1:
	.long	1023                            # 0x3ff
	.long	1023                            # 0x3ff
	.long	1023                            # 0x3ff
	.long	1023                            # 0x3ff
.LCPI3_2:
	.quad	0x3fe0000000000000              # double 0.5
	.quad	0x3fe0000000000000              # double 0.5
.LCPI3_3:
	.long	4                               # 0x4
	.long	4                               # 0x4
	.long	4                               # 0x4
	.long	4                               # 0x4
	.text
	.p2align	4, 0x90
	.type	init_array_polly_subfn,@function
init_array_polly_subfn:                 # @init_array_polly_subfn
	.cfi_startproc
# %bb.0:                                # %polly.par.setup
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%r12
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	.cfi_offset %rbx, -40
	.cfi_offset %r12, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	leaq	16(%rsp), %rdi
	leaq	8(%rsp), %rsi
	callq	GOMP_loop_runtime_next@PLT
	testb	%al, %al
	je	.LBB3_2
# %bb.1:
	leaq	.LB$local(%rip), %r15
	leaq	.LA$local(%rip), %r12
	movdqa	.LCPI3_0(%rip), %xmm5           # xmm5 = [0,1,2,3]
	movdqa	.LCPI3_1(%rip), %xmm6           # xmm6 = [1023,1023,1023,1023]
	pcmpeqd	%xmm7, %xmm7
	movapd	.LCPI3_2(%rip), %xmm8           # xmm8 = [5.0E-1,5.0E-1]
	movdqa	.LCPI3_3(%rip), %xmm9           # xmm9 = [4,4,4,4]
	leaq	16(%rsp), %rbx
	leaq	8(%rsp), %r14
	.p2align	4, 0x90
.LBB3_4:                                # %polly.par.loadIVBounds
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_5 Depth 2
                                        #       Child Loop BB3_6 Depth 3
	movq	16(%rsp), %rcx
	movq	8(%rsp), %rax
	decq	%rax
	movq	%rcx, %rdx
	shlq	$11, %rdx
	leaq	(%rdx,%rdx,2), %rdx
	leaq	(%r15,%rdx), %rsi
	addq	%r12, %rdx
	.p2align	4, 0x90
.LBB3_5:                                # %polly.loop_header
                                        #   Parent Loop BB3_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB3_6 Depth 3
	movd	%ecx, %xmm0
	pshufd	$0, %xmm0, %xmm0                # xmm0 = xmm0[0,0,0,0]
	movq	$-6144, %rdi                    # imm = 0xE800
	movdqa	%xmm5, %xmm1
	.p2align	4, 0x90
.LBB3_6:                                # %vector.body
                                        #   Parent Loop BB3_4 Depth=1
                                        #     Parent Loop BB3_5 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movdqa	%xmm1, %xmm2
	pmuludq	%xmm0, %xmm2
	pshufd	$232, %xmm2, %xmm2              # xmm2 = xmm2[0,2,2,3]
	pshufd	$245, %xmm0, %xmm3              # xmm3 = xmm0[1,1,3,3]
	pshufd	$245, %xmm1, %xmm4              # xmm4 = xmm1[1,1,3,3]
	pmuludq	%xmm3, %xmm4
	pshufd	$232, %xmm4, %xmm3              # xmm3 = xmm4[0,2,2,3]
	punpckldq	%xmm3, %xmm2            # xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
	pand	%xmm6, %xmm2
	psubd	%xmm7, %xmm2
	cvtdq2pd	%xmm2, %xmm3
	pshufd	$238, %xmm2, %xmm2              # xmm2 = xmm2[2,3,2,3]
	cvtdq2pd	%xmm2, %xmm2
	mulpd	%xmm8, %xmm2
	mulpd	%xmm8, %xmm3
	cvtpd2ps	%xmm3, %xmm3
	cvtpd2ps	%xmm2, %xmm2
	unpcklpd	%xmm2, %xmm3                    # xmm3 = xmm3[0],xmm2[0]
	movapd	%xmm3, 6144(%rdx,%rdi)
	movapd	%xmm3, 6144(%rsi,%rdi)
	paddd	%xmm9, %xmm1
	addq	$16, %rdi
	jne	.LBB3_6
# %bb.7:                                # %polly.loop_exit3
                                        #   in Loop: Header=BB3_5 Depth=2
	addq	$6144, %rsi                     # imm = 0x1800
	addq	$6144, %rdx                     # imm = 0x1800
	cmpq	%rax, %rcx
	leaq	1(%rcx), %rcx
	jl	.LBB3_5
# %bb.3:                                # %polly.par.checkNext.loopexit
                                        #   in Loop: Header=BB3_4 Depth=1
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	GOMP_loop_runtime_next@PLT
	movdqa	.LCPI3_3(%rip), %xmm9           # xmm9 = [4,4,4,4]
	movapd	.LCPI3_2(%rip), %xmm8           # xmm8 = [5.0E-1,5.0E-1]
	pcmpeqd	%xmm7, %xmm7
	movdqa	.LCPI3_1(%rip), %xmm6           # xmm6 = [1023,1023,1023,1023]
	movdqa	.LCPI3_0(%rip), %xmm5           # xmm5 = [0,1,2,3]
	testb	%al, %al
	jne	.LBB3_4
.LBB3_2:                                # %polly.par.exit
	callq	GOMP_loop_end_nowait@PLT
	addq	$24, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	init_array_polly_subfn, .Lfunc_end3-init_array_polly_subfn
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function main_polly_subfn
	.type	main_polly_subfn,@function
main_polly_subfn:                       # @main_polly_subfn
	.cfi_startproc
# %bb.0:                                # %polly.par.setup
	pushq	%r15
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %r15, -16
	leaq	8(%rsp), %rdi
	movq	%rsp, %rsi
	callq	GOMP_loop_runtime_next@PLT
	testb	%al, %al
	je	.LBB4_3
# %bb.1:
	leaq	.LC$local(%rip), %r15
	leaq	8(%rsp), %rbx
	movq	%rsp, %r14
	.p2align	4, 0x90
.LBB4_2:                                # %polly.par.loadIVBounds
                                        # =>This Inner Loop Header: Depth=1
	movq	8(%rsp), %rax
	movq	(%rsp), %rcx
	decq	%rcx
	leaq	(%rax,%rax,2), %rdi
	shlq	$11, %rdi
	addq	%r15, %rdi
	cmpq	%rcx, %rax
	cmovgq	%rax, %rcx
	subq	%rax, %rcx
	leaq	(%rcx,%rcx,2), %rdx
	shlq	$11, %rdx
	addq	$6144, %rdx                     # imm = 0x1800
	xorl	%esi, %esi
	callq	memset@PLT
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	GOMP_loop_runtime_next@PLT
	testb	%al, %al
	jne	.LBB4_2
.LBB4_3:                                # %polly.par.exit
	callq	GOMP_loop_end_nowait@PLT
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end4:
	.size	main_polly_subfn, .Lfunc_end4-main_polly_subfn
	.cfi_endproc
                                        # -- End function
	.p2align	4, 0x90                         # -- Begin function main_polly_subfn_1
	.type	main_polly_subfn_1,@function
main_polly_subfn_1:                     # @main_polly_subfn_1
	.cfi_startproc
# %bb.0:                                # %polly.par.setup
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$264, %rsp                      # imm = 0x108
	.cfi_def_cfa_offset 320
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	leaq	24(%rsp), %rdi
	leaq	16(%rsp), %rsi
	callq	GOMP_loop_runtime_next@PLT
	testb	%al, %al
	je	.LBB5_2
# %bb.1:
	leaq	.LC$local(%rip), %r13
	.p2align	4, 0x90
.LBB5_4:                                # %polly.par.loadIVBounds
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB5_5 Depth 2
                                        #       Child Loop BB5_6 Depth 3
                                        #         Child Loop BB5_7 Depth 4
                                        #           Child Loop BB5_8 Depth 5
                                        #             Child Loop BB5_9 Depth 6
	movq	24(%rsp), %rcx
	movq	16(%rsp), %rax
	decq	%rax
	movq	%rax, 120(%rsp)                 # 8-byte Spill
	leaq	(%rcx,%rcx,2), %rdx
	shlq	$11, %rdx
	leaq	.LA$local(%rip), %rax
	addq	%rax, %rdx
	movq	%rdx, 8(%rsp)                   # 8-byte Spill
	.p2align	4, 0x90
.LBB5_5:                                # %polly.loop_header
                                        #   Parent Loop BB5_4 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB5_6 Depth 3
                                        #         Child Loop BB5_7 Depth 4
                                        #           Child Loop BB5_8 Depth 5
                                        #             Child Loop BB5_9 Depth 6
	leaq	63(%rcx), %rsi
	leaq	.LB$local+192(%rip), %r12
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB5_6:                                # %polly.loop_header1
                                        #   Parent Loop BB5_4 Depth=1
                                        #     Parent Loop BB5_5 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB5_7 Depth 4
                                        #           Child Loop BB5_8 Depth 5
                                        #             Child Loop BB5_9 Depth 6
	movq	%rax, 128(%rsp)                 # 8-byte Spill
	leaq	(,%rax,4), %r9
	movq	%r9, %r10
	orq	$64, %r10
	movq	%r9, %r11
	orq	$128, %r11
	movq	%r9, %rbp
	orq	$192, %rbp
	movq	8(%rsp), %r15                   # 8-byte Reload
	movq	%r12, 136(%rsp)                 # 8-byte Spill
	xorl	%r14d, %r14d
	.p2align	4, 0x90
.LBB5_7:                                # %polly.loop_header7
                                        #   Parent Loop BB5_4 Depth=1
                                        #     Parent Loop BB5_5 Depth=2
                                        #       Parent Loop BB5_6 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB5_8 Depth 5
                                        #             Child Loop BB5_9 Depth 6
	movq	%r15, %rdx
	movq	%rcx, %rax
	.p2align	4, 0x90
.LBB5_8:                                # %polly.loop_header13
                                        #   Parent Loop BB5_4 Depth=1
                                        #     Parent Loop BB5_5 Depth=2
                                        #       Parent Loop BB5_6 Depth=3
                                        #         Parent Loop BB5_7 Depth=4
                                        # =>        This Loop Header: Depth=5
                                        #             Child Loop BB5_9 Depth 6
	movq	%rax, %rdi
	shlq	$11, %rdi
	leaq	(%rdi,%rdi,2), %rbx
	leaq	(%r13,%rbx), %rdi
	movaps	(%r9,%rdi), %xmm11
	movaps	16(%r9,%rdi), %xmm6
	movaps	32(%r9,%rdi), %xmm9
	movaps	48(%r9,%rdi), %xmm5
	movaps	(%r10,%rdi), %xmm12
	movaps	16(%r10,%rdi), %xmm10
	movaps	32(%r10,%rdi), %xmm0
	movaps	%xmm0, 48(%rsp)                 # 16-byte Spill
	movaps	48(%r10,%rdi), %xmm0
	movaps	%xmm0, 32(%rsp)                 # 16-byte Spill
	movaps	(%r11,%rdi), %xmm1
	movaps	16(%r11,%rdi), %xmm0
	movaps	%xmm0, 80(%rsp)                 # 16-byte Spill
	movaps	32(%r11,%rdi), %xmm8
	movaps	48(%r11,%rdi), %xmm0
	movaps	%xmm0, 64(%rsp)                 # 16-byte Spill
	movaps	(%rbp,%rdi), %xmm0
	movaps	16(%rbp,%rdi), %xmm4
	movaps	32(%rbp,%rdi), %xmm7
	movaps	48(%rbp,%rdi), %xmm3
	movq	$-256, %r8
	movq	%r12, %rdi
	.p2align	4, 0x90
.LBB5_9:                                # %polly.loop_header19
                                        #   Parent Loop BB5_4 Depth=1
                                        #     Parent Loop BB5_5 Depth=2
                                        #       Parent Loop BB5_6 Depth=3
                                        #         Parent Loop BB5_7 Depth=4
                                        #           Parent Loop BB5_8 Depth=5
                                        # =>          This Inner Loop Header: Depth=6
	movaps	%xmm8, 160(%rsp)                # 16-byte Spill
	movaps	%xmm4, 96(%rsp)                 # 16-byte Spill
	movaps	%xmm7, 192(%rsp)                # 16-byte Spill
	movaps	%xmm3, 208(%rsp)                # 16-byte Spill
	movaps	%xmm11, %xmm3
	unpcklps	%xmm6, %xmm3                    # xmm3 = xmm3[0],xmm6[0],xmm3[1],xmm6[1]
	movaps	%xmm5, %xmm7
	movlhps	%xmm9, %xmm7                    # xmm7 = xmm7[0],xmm9[0]
	shufps	$36, %xmm7, %xmm3               # xmm3 = xmm3[0,1],xmm7[2,0]
	movaps	%xmm6, %xmm7
	shufps	$17, %xmm11, %xmm7              # xmm7 = xmm7[1,0],xmm11[1,0]
	movaps	%xmm9, %xmm8
	unpcklps	%xmm5, %xmm8                    # xmm8 = xmm8[0],xmm5[0],xmm8[1],xmm5[1]
	shufps	$226, %xmm8, %xmm7              # xmm7 = xmm7[2,0],xmm8[2,3]
	movaps	%xmm11, %xmm2
	unpckhps	%xmm6, %xmm2                    # xmm2 = xmm2[2],xmm6[2],xmm2[3],xmm6[3]
	movaps	%xmm5, %xmm8
	unpckhpd	%xmm9, %xmm8                    # xmm8 = xmm8[1],xmm9[1]
	shufps	$36, %xmm8, %xmm2               # xmm2 = xmm2[0,1],xmm8[2,0]
	shufps	$51, %xmm11, %xmm6              # xmm6 = xmm6[3,0],xmm11[3,0]
	unpckhps	%xmm5, %xmm9                    # xmm9 = xmm9[2],xmm5[2],xmm9[3],xmm5[3]
	shufps	$226, %xmm9, %xmm6              # xmm6 = xmm6[2,0],xmm9[2,3]
	movaps	-160(%rdi), %xmm8
	movaps	-144(%rdi), %xmm5
	movaps	%xmm5, %xmm13
	movlhps	%xmm8, %xmm13                   # xmm13 = xmm13[0],xmm8[0]
	movaps	-192(%rdi), %xmm4
	movaps	-176(%rdi), %xmm9
	movaps	%xmm4, %xmm11
	unpcklps	%xmm9, %xmm11                   # xmm11 = xmm11[0],xmm9[0],xmm11[1],xmm9[1]
	shufps	$36, %xmm13, %xmm11             # xmm11 = xmm11[0,1],xmm13[2,0]
	movaps	%xmm8, %xmm13
	unpcklps	%xmm5, %xmm13                   # xmm13 = xmm13[0],xmm5[0],xmm13[1],xmm5[1]
	movaps	%xmm9, %xmm14
	shufps	$17, %xmm4, %xmm14              # xmm14 = xmm14[1,0],xmm4[1,0]
	shufps	$226, %xmm13, %xmm14            # xmm14 = xmm14[2,0],xmm13[2,3]
	movaps	%xmm5, %xmm15
	unpckhpd	%xmm8, %xmm15                   # xmm15 = xmm15[1],xmm8[1]
	movaps	%xmm4, %xmm13
	unpckhps	%xmm9, %xmm13                   # xmm13 = xmm13[2],xmm9[2],xmm13[3],xmm9[3]
	shufps	$36, %xmm15, %xmm13             # xmm13 = xmm13[0,1],xmm15[2,0]
	unpckhps	%xmm5, %xmm8                    # xmm8 = xmm8[2],xmm5[2],xmm8[3],xmm5[3]
	shufps	$51, %xmm4, %xmm9               # xmm9 = xmm9[3,0],xmm4[3,0]
	shufps	$226, %xmm8, %xmm9              # xmm9 = xmm9[2,0],xmm8[2,3]
	movss	256(%rdx,%r8), %xmm4            # xmm4 = mem[0],zero,zero,zero
	shufps	$0, %xmm4, %xmm4                # xmm4 = xmm4[0,0,0,0]
	mulps	%xmm4, %xmm11
	addps	%xmm3, %xmm11
	mulps	%xmm4, %xmm14
	addps	%xmm7, %xmm14
	mulps	%xmm4, %xmm13
	addps	%xmm2, %xmm13
	mulps	%xmm4, %xmm9
	movaps	%xmm4, %xmm8
	addps	%xmm6, %xmm9
	movaps	%xmm13, %xmm3
	unpckhps	%xmm9, %xmm3                    # xmm3 = xmm3[2],xmm9[2],xmm3[3],xmm9[3]
	movaps	%xmm14, %xmm2
	shufps	$51, %xmm11, %xmm2              # xmm2 = xmm2[3,0],xmm11[3,0]
	shufps	$226, %xmm3, %xmm2              # xmm2 = xmm2[2,0],xmm3[2,3]
	movaps	%xmm2, 240(%rsp)                # 16-byte Spill
	movaps	%xmm9, %xmm3
	unpckhpd	%xmm13, %xmm3                   # xmm3 = xmm3[1],xmm13[1]
	movaps	%xmm11, %xmm2
	unpckhps	%xmm14, %xmm2                   # xmm2 = xmm2[2],xmm14[2],xmm2[3],xmm14[3]
	shufps	$36, %xmm3, %xmm2               # xmm2 = xmm2[0,1],xmm3[2,0]
	movaps	%xmm2, 224(%rsp)                # 16-byte Spill
	movaps	%xmm13, %xmm3
	unpcklps	%xmm9, %xmm3                    # xmm3 = xmm3[0],xmm9[0],xmm3[1],xmm9[1]
	movaps	%xmm14, %xmm2
	shufps	$17, %xmm11, %xmm2              # xmm2 = xmm2[1,0],xmm11[1,0]
	shufps	$226, %xmm3, %xmm2              # xmm2 = xmm2[2,0],xmm3[2,3]
	movaps	%xmm2, 176(%rsp)                # 16-byte Spill
	movlhps	%xmm13, %xmm9                   # xmm9 = xmm9[0],xmm13[0]
	unpcklps	%xmm14, %xmm11                  # xmm11 = xmm11[0],xmm14[0],xmm11[1],xmm14[1]
	shufps	$36, %xmm9, %xmm11              # xmm11 = xmm11[0,1],xmm9[2,0]
	movaps	%xmm12, %xmm3
	unpcklps	%xmm10, %xmm3                   # xmm3 = xmm3[0],xmm10[0],xmm3[1],xmm10[1]
	movaps	32(%rsp), %xmm5                 # 16-byte Reload
	movaps	%xmm5, %xmm4
	movaps	48(%rsp), %xmm2                 # 16-byte Reload
	movlhps	%xmm2, %xmm4                    # xmm4 = xmm4[0],xmm2[0]
	shufps	$36, %xmm4, %xmm3               # xmm3 = xmm3[0,1],xmm4[2,0]
	movaps	%xmm10, %xmm7
	shufps	$17, %xmm12, %xmm7              # xmm7 = xmm7[1,0],xmm12[1,0]
	movaps	%xmm2, %xmm4
	unpcklps	%xmm5, %xmm4                    # xmm4 = xmm4[0],xmm5[0],xmm4[1],xmm5[1]
	shufps	$226, %xmm4, %xmm7              # xmm7 = xmm7[2,0],xmm4[2,3]
	movaps	%xmm12, %xmm15
	unpckhps	%xmm10, %xmm15                  # xmm15 = xmm15[2],xmm10[2],xmm15[3],xmm10[3]
	movaps	%xmm5, %xmm4
	unpckhpd	%xmm2, %xmm4                    # xmm4 = xmm4[1],xmm2[1]
	shufps	$36, %xmm4, %xmm15              # xmm15 = xmm15[0,1],xmm4[2,0]
	shufps	$51, %xmm12, %xmm10             # xmm10 = xmm10[3,0],xmm12[3,0]
	unpckhps	%xmm5, %xmm2                    # xmm2 = xmm2[2],xmm5[2],xmm2[3],xmm5[3]
	shufps	$226, %xmm2, %xmm10             # xmm10 = xmm10[2,0],xmm2[2,3]
	movaps	-96(%rdi), %xmm4
	movaps	-80(%rdi), %xmm6
	movaps	%xmm6, %xmm13
	movlhps	%xmm4, %xmm13                   # xmm13 = xmm13[0],xmm4[0]
	movaps	-112(%rdi), %xmm9
	movaps	-128(%rdi), %xmm2
	movaps	%xmm2, %xmm12
	unpcklps	%xmm9, %xmm12                   # xmm12 = xmm12[0],xmm9[0],xmm12[1],xmm9[1]
	shufps	$36, %xmm13, %xmm12             # xmm12 = xmm12[0,1],xmm13[2,0]
	movaps	%xmm4, %xmm13
	unpcklps	%xmm6, %xmm13                   # xmm13 = xmm13[0],xmm6[0],xmm13[1],xmm6[1]
	movaps	%xmm9, %xmm14
	shufps	$17, %xmm2, %xmm14              # xmm14 = xmm14[1,0],xmm2[1,0]
	shufps	$226, %xmm13, %xmm14            # xmm14 = xmm14[2,0],xmm13[2,3]
	movaps	%xmm6, %xmm5
	unpckhpd	%xmm4, %xmm5                    # xmm5 = xmm5[1],xmm4[1]
	movaps	%xmm2, %xmm13
	unpckhps	%xmm9, %xmm13                   # xmm13 = xmm13[2],xmm9[2],xmm13[3],xmm9[3]
	shufps	$36, %xmm5, %xmm13              # xmm13 = xmm13[0,1],xmm5[2,0]
	unpckhps	%xmm6, %xmm4                    # xmm4 = xmm4[2],xmm6[2],xmm4[3],xmm6[3]
	shufps	$51, %xmm2, %xmm9               # xmm9 = xmm9[3,0],xmm2[3,0]
	shufps	$226, %xmm4, %xmm9              # xmm9 = xmm9[2,0],xmm4[2,3]
	movaps	%xmm8, 144(%rsp)                # 16-byte Spill
	mulps	%xmm8, %xmm12
	addps	%xmm3, %xmm12
	mulps	%xmm8, %xmm14
	addps	%xmm7, %xmm14
	mulps	%xmm8, %xmm13
	addps	%xmm15, %xmm13
	mulps	%xmm8, %xmm9
	addps	%xmm10, %xmm9
	movaps	%xmm13, %xmm2
	unpckhps	%xmm9, %xmm2                    # xmm2 = xmm2[2],xmm9[2],xmm2[3],xmm9[3]
	movaps	%xmm14, %xmm3
	shufps	$51, %xmm12, %xmm3              # xmm3 = xmm3[3,0],xmm12[3,0]
	shufps	$226, %xmm2, %xmm3              # xmm3 = xmm3[2,0],xmm2[2,3]
	movaps	%xmm3, 32(%rsp)                 # 16-byte Spill
	movaps	%xmm9, %xmm2
	unpckhpd	%xmm13, %xmm2                   # xmm2 = xmm2[1],xmm13[1]
	movaps	%xmm12, %xmm3
	unpckhps	%xmm14, %xmm3                   # xmm3 = xmm3[2],xmm14[2],xmm3[3],xmm14[3]
	shufps	$36, %xmm2, %xmm3               # xmm3 = xmm3[0,1],xmm2[2,0]
	movaps	%xmm3, 48(%rsp)                 # 16-byte Spill
	movaps	%xmm13, %xmm2
	unpcklps	%xmm9, %xmm2                    # xmm2 = xmm2[0],xmm9[0],xmm2[1],xmm9[1]
	movaps	%xmm14, %xmm8
	shufps	$17, %xmm12, %xmm8              # xmm8 = xmm8[1,0],xmm12[1,0]
	shufps	$226, %xmm2, %xmm8              # xmm8 = xmm8[2,0],xmm2[2,3]
	movlhps	%xmm13, %xmm9                   # xmm9 = xmm9[0],xmm13[0]
	unpcklps	%xmm14, %xmm12                  # xmm12 = xmm12[0],xmm14[0],xmm12[1],xmm14[1]
	shufps	$36, %xmm9, %xmm12              # xmm12 = xmm12[0,1],xmm9[2,0]
	movaps	%xmm1, %xmm3
	movaps	80(%rsp), %xmm7                 # 16-byte Reload
	unpcklps	%xmm7, %xmm3                    # xmm3 = xmm3[0],xmm7[0],xmm3[1],xmm7[1]
	movaps	64(%rsp), %xmm5                 # 16-byte Reload
	movaps	%xmm5, %xmm2
	movaps	160(%rsp), %xmm6                # 16-byte Reload
	movlhps	%xmm6, %xmm2                    # xmm2 = xmm2[0],xmm6[0]
	shufps	$36, %xmm2, %xmm3               # xmm3 = xmm3[0,1],xmm2[2,0]
	movaps	%xmm7, %xmm10
	shufps	$17, %xmm1, %xmm10              # xmm10 = xmm10[1,0],xmm1[1,0]
	movaps	%xmm6, %xmm2
	unpcklps	%xmm5, %xmm2                    # xmm2 = xmm2[0],xmm5[0],xmm2[1],xmm5[1]
	shufps	$226, %xmm2, %xmm10             # xmm10 = xmm10[2,0],xmm2[2,3]
	movaps	%xmm1, %xmm2
	unpckhps	%xmm7, %xmm2                    # xmm2 = xmm2[2],xmm7[2],xmm2[3],xmm7[3]
	movaps	%xmm5, %xmm4
	unpckhpd	%xmm6, %xmm4                    # xmm4 = xmm4[1],xmm6[1]
	shufps	$36, %xmm4, %xmm2               # xmm2 = xmm2[0,1],xmm4[2,0]
	shufps	$51, %xmm1, %xmm7               # xmm7 = xmm7[3,0],xmm1[3,0]
	unpckhps	%xmm5, %xmm6                    # xmm6 = xmm6[2],xmm5[2],xmm6[3],xmm5[3]
	shufps	$226, %xmm6, %xmm7              # xmm7 = xmm7[2,0],xmm6[2,3]
	movaps	-32(%rdi), %xmm4
	movaps	-16(%rdi), %xmm5
	movaps	%xmm5, %xmm6
	movlhps	%xmm4, %xmm6                    # xmm6 = xmm6[0],xmm4[0]
	movaps	-48(%rdi), %xmm9
	movaps	-64(%rdi), %xmm15
	movaps	%xmm15, %xmm1
	unpcklps	%xmm9, %xmm1                    # xmm1 = xmm1[0],xmm9[0],xmm1[1],xmm9[1]
	shufps	$36, %xmm6, %xmm1               # xmm1 = xmm1[0,1],xmm6[2,0]
	movaps	%xmm4, %xmm6
	unpcklps	%xmm5, %xmm6                    # xmm6 = xmm6[0],xmm5[0],xmm6[1],xmm5[1]
	movaps	%xmm9, %xmm14
	shufps	$17, %xmm15, %xmm14             # xmm14 = xmm14[1,0],xmm15[1,0]
	shufps	$226, %xmm6, %xmm14             # xmm14 = xmm14[2,0],xmm6[2,3]
	movaps	%xmm5, %xmm6
	unpckhpd	%xmm4, %xmm6                    # xmm6 = xmm6[1],xmm4[1]
	movaps	%xmm15, %xmm13
	unpckhps	%xmm9, %xmm13                   # xmm13 = xmm13[2],xmm9[2],xmm13[3],xmm9[3]
	shufps	$36, %xmm6, %xmm13              # xmm13 = xmm13[0,1],xmm6[2,0]
	unpckhps	%xmm5, %xmm4                    # xmm4 = xmm4[2],xmm5[2],xmm4[3],xmm5[3]
	shufps	$51, %xmm15, %xmm9              # xmm9 = xmm9[3,0],xmm15[3,0]
	shufps	$226, %xmm4, %xmm9              # xmm9 = xmm9[2,0],xmm4[2,3]
	movaps	144(%rsp), %xmm4                # 16-byte Reload
	mulps	%xmm4, %xmm1
	addps	%xmm3, %xmm1
	mulps	%xmm4, %xmm14
	addps	%xmm10, %xmm14
	movaps	%xmm8, %xmm10
	mulps	%xmm4, %xmm13
	addps	%xmm2, %xmm13
	mulps	%xmm4, %xmm9
	addps	%xmm7, %xmm9
	movaps	%xmm13, %xmm2
	unpckhps	%xmm9, %xmm2                    # xmm2 = xmm2[2],xmm9[2],xmm2[3],xmm9[3]
	movaps	%xmm14, %xmm3
	shufps	$51, %xmm1, %xmm3               # xmm3 = xmm3[3,0],xmm1[3,0]
	shufps	$226, %xmm2, %xmm3              # xmm3 = xmm3[2,0],xmm2[2,3]
	movaps	%xmm3, 64(%rsp)                 # 16-byte Spill
	movaps	%xmm9, %xmm2
	unpckhpd	%xmm13, %xmm2                   # xmm2 = xmm2[1],xmm13[1]
	movaps	%xmm1, %xmm8
	unpckhps	%xmm14, %xmm8                   # xmm8 = xmm8[2],xmm14[2],xmm8[3],xmm14[3]
	shufps	$36, %xmm2, %xmm8               # xmm8 = xmm8[0,1],xmm2[2,0]
	movaps	%xmm13, %xmm2
	unpcklps	%xmm9, %xmm2                    # xmm2 = xmm2[0],xmm9[0],xmm2[1],xmm9[1]
	movaps	%xmm14, %xmm3
	shufps	$17, %xmm1, %xmm3               # xmm3 = xmm3[1,0],xmm1[1,0]
	shufps	$226, %xmm2, %xmm3              # xmm3 = xmm3[2,0],xmm2[2,3]
	movaps	%xmm3, 80(%rsp)                 # 16-byte Spill
	movlhps	%xmm13, %xmm9                   # xmm9 = xmm9[0],xmm13[0]
	unpcklps	%xmm14, %xmm1                   # xmm1 = xmm1[0],xmm14[0],xmm1[1],xmm14[1]
	shufps	$36, %xmm9, %xmm1               # xmm1 = xmm1[0,1],xmm9[2,0]
	movaps	%xmm0, %xmm3
	movaps	96(%rsp), %xmm5                 # 16-byte Reload
	unpcklps	%xmm5, %xmm3                    # xmm3 = xmm3[0],xmm5[0],xmm3[1],xmm5[1]
	movaps	208(%rsp), %xmm6                # 16-byte Reload
	movaps	%xmm6, %xmm2
	movaps	192(%rsp), %xmm9                # 16-byte Reload
	movlhps	%xmm9, %xmm2                    # xmm2 = xmm2[0],xmm9[0]
	shufps	$36, %xmm2, %xmm3               # xmm3 = xmm3[0,1],xmm2[2,0]
	movaps	%xmm5, %xmm7
	shufps	$17, %xmm0, %xmm7               # xmm7 = xmm7[1,0],xmm0[1,0]
	movaps	%xmm9, %xmm2
	unpcklps	%xmm6, %xmm2                    # xmm2 = xmm2[0],xmm6[0],xmm2[1],xmm6[1]
	shufps	$226, %xmm2, %xmm7              # xmm7 = xmm7[2,0],xmm2[2,3]
	movaps	%xmm0, %xmm2
	unpckhps	%xmm5, %xmm2                    # xmm2 = xmm2[2],xmm5[2],xmm2[3],xmm5[3]
	movaps	%xmm6, %xmm4
	unpckhpd	%xmm9, %xmm4                    # xmm4 = xmm4[1],xmm9[1]
	shufps	$36, %xmm4, %xmm2               # xmm2 = xmm2[0,1],xmm4[2,0]
	shufps	$51, %xmm0, %xmm5               # xmm5 = xmm5[3,0],xmm0[3,0]
	unpckhps	%xmm6, %xmm9                    # xmm9 = xmm9[2],xmm6[2],xmm9[3],xmm6[3]
	shufps	$226, %xmm9, %xmm5              # xmm5 = xmm5[2,0],xmm9[2,3]
	movaps	%xmm5, 96(%rsp)                 # 16-byte Spill
	movaps	32(%rdi), %xmm4
	movaps	48(%rdi), %xmm5
	movaps	%xmm5, %xmm6
	movlhps	%xmm4, %xmm6                    # xmm6 = xmm6[0],xmm4[0]
	movaps	16(%rdi), %xmm9
	movaps	(%rdi), %xmm15
	movaps	%xmm15, %xmm0
	unpcklps	%xmm9, %xmm0                    # xmm0 = xmm0[0],xmm9[0],xmm0[1],xmm9[1]
	shufps	$36, %xmm6, %xmm0               # xmm0 = xmm0[0,1],xmm6[2,0]
	movaps	%xmm4, %xmm6
	unpcklps	%xmm5, %xmm6                    # xmm6 = xmm6[0],xmm5[0],xmm6[1],xmm5[1]
	movaps	%xmm9, %xmm14
	shufps	$17, %xmm15, %xmm14             # xmm14 = xmm14[1,0],xmm15[1,0]
	shufps	$226, %xmm6, %xmm14             # xmm14 = xmm14[2,0],xmm6[2,3]
	movaps	%xmm5, %xmm6
	unpckhpd	%xmm4, %xmm6                    # xmm6 = xmm6[1],xmm4[1]
	movaps	%xmm15, %xmm13
	unpckhps	%xmm9, %xmm13                   # xmm13 = xmm13[2],xmm9[2],xmm13[3],xmm9[3]
	shufps	$36, %xmm6, %xmm13              # xmm13 = xmm13[0,1],xmm6[2,0]
	movaps	176(%rsp), %xmm6                # 16-byte Reload
	unpckhps	%xmm5, %xmm4                    # xmm4 = xmm4[2],xmm5[2],xmm4[3],xmm5[3]
	shufps	$51, %xmm15, %xmm9              # xmm9 = xmm9[3,0],xmm15[3,0]
	shufps	$226, %xmm4, %xmm9              # xmm9 = xmm9[2,0],xmm4[2,3]
	movaps	144(%rsp), %xmm4                # 16-byte Reload
	mulps	%xmm4, %xmm0
	addps	%xmm3, %xmm0
	mulps	%xmm4, %xmm14
	addps	%xmm7, %xmm14
	mulps	%xmm4, %xmm13
	addps	%xmm2, %xmm13
	mulps	%xmm4, %xmm9
	addps	96(%rsp), %xmm9                 # 16-byte Folded Reload
	movaps	%xmm13, %xmm2
	unpckhps	%xmm9, %xmm2                    # xmm2 = xmm2[2],xmm9[2],xmm2[3],xmm9[3]
	movaps	%xmm14, %xmm3
	shufps	$51, %xmm0, %xmm3               # xmm3 = xmm3[3,0],xmm0[3,0]
	shufps	$226, %xmm2, %xmm3              # xmm3 = xmm3[2,0],xmm2[2,3]
	movaps	%xmm9, %xmm2
	unpckhpd	%xmm13, %xmm2                   # xmm2 = xmm2[1],xmm13[1]
	movaps	%xmm0, %xmm7
	unpckhps	%xmm14, %xmm7                   # xmm7 = xmm7[2],xmm14[2],xmm7[3],xmm14[3]
	shufps	$36, %xmm2, %xmm7               # xmm7 = xmm7[0,1],xmm2[2,0]
	movaps	%xmm13, %xmm2
	unpcklps	%xmm9, %xmm2                    # xmm2 = xmm2[0],xmm9[0],xmm2[1],xmm9[1]
	movaps	%xmm14, %xmm4
	shufps	$17, %xmm0, %xmm4               # xmm4 = xmm4[1,0],xmm0[1,0]
	shufps	$226, %xmm2, %xmm4              # xmm4 = xmm4[2,0],xmm2[2,3]
	movlhps	%xmm13, %xmm9                   # xmm9 = xmm9[0],xmm13[0]
	unpcklps	%xmm14, %xmm0                   # xmm0 = xmm0[0],xmm14[0],xmm0[1],xmm14[1]
	movaps	240(%rsp), %xmm5                # 16-byte Reload
	shufps	$36, %xmm9, %xmm0               # xmm0 = xmm0[0,1],xmm9[2,0]
	movaps	224(%rsp), %xmm9                # 16-byte Reload
	addq	$6144, %rdi                     # imm = 0x1800
	addq	$4, %r8
	jne	.LBB5_9
# %bb.10:                               # %polly.loop_exit21
                                        #   in Loop: Header=BB5_8 Depth=5
	leaq	(%rbx,%r9), %rdi
	movaps	%xmm6, 16(%r13,%rdi)
	movaps	%xmm11, (%r13,%rdi)
	movaps	%xmm9, 32(%r13,%rdi)
	movaps	%xmm5, 48(%r13,%rdi)
	leaq	(%rbx,%r10), %rdi
	movaps	32(%rsp), %xmm2                 # 16-byte Reload
	movaps	%xmm2, 48(%r13,%rdi)
	movaps	%xmm12, (%r13,%rdi)
	movaps	%xmm10, 16(%r13,%rdi)
	movaps	48(%rsp), %xmm2                 # 16-byte Reload
	movaps	%xmm2, 32(%r13,%rdi)
	leaq	(%rbx,%r11), %rdi
	movaps	64(%rsp), %xmm2                 # 16-byte Reload
	movaps	%xmm2, 48(%r13,%rdi)
	movaps	%xmm1, (%r13,%rdi)
	movaps	80(%rsp), %xmm1                 # 16-byte Reload
	movaps	%xmm1, 16(%r13,%rdi)
	movaps	%xmm8, 32(%r13,%rdi)
	addq	%rbp, %rbx
	movaps	%xmm7, 32(%r13,%rbx)
	movaps	%xmm3, 48(%r13,%rbx)
	movaps	%xmm0, (%r13,%rbx)
	movaps	%xmm4, 16(%r13,%rbx)
	addq	$6144, %rdx                     # imm = 0x1800
	cmpq	%rsi, %rax
	leaq	1(%rax), %rax
	jl	.LBB5_8
# %bb.11:                               # %polly.loop_exit15
                                        #   in Loop: Header=BB5_7 Depth=4
	addq	$393216, %r12                   # imm = 0x60000
	addq	$256, %r15                      # imm = 0x100
	cmpq	$1472, %r14                     # imm = 0x5C0
	leaq	64(%r14), %r14
	jb	.LBB5_7
# %bb.12:                               # %polly.loop_exit9
                                        #   in Loop: Header=BB5_6 Depth=3
	movq	136(%rsp), %r12                 # 8-byte Reload
	addq	$256, %r12                      # imm = 0x100
	movq	128(%rsp), %rax                 # 8-byte Reload
	cmpq	$1472, %rax                     # imm = 0x5C0
	leaq	64(%rax), %rax
	jb	.LBB5_6
# %bb.13:                               # %polly.loop_exit3
                                        #   in Loop: Header=BB5_5 Depth=2
	addq	$64, %rcx
	addq	$393216, 8(%rsp)                # 8-byte Folded Spill
                                        # imm = 0x60000
	cmpq	120(%rsp), %rcx                 # 8-byte Folded Reload
	jle	.LBB5_5
# %bb.3:                                # %polly.par.checkNext.loopexit
                                        #   in Loop: Header=BB5_4 Depth=1
	leaq	24(%rsp), %rdi
	leaq	16(%rsp), %rsi
	callq	GOMP_loop_runtime_next@PLT
	testb	%al, %al
	jne	.LBB5_4
.LBB5_2:                                # %polly.par.exit
	callq	GOMP_loop_end_nowait@PLT
	addq	$264, %rsp                      # imm = 0x108
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end5:
	.size	main_polly_subfn_1, .Lfunc_end5-main_polly_subfn_1
	.cfi_endproc
                                        # -- End function
	.type	A,@object                       # @A
	.bss
	.globl	A
	.p2align	4, 0x0
A:
.LA$local:
	.zero	9437184
	.size	A, 9437184

	.type	B,@object                       # @B
	.globl	B
	.p2align	4, 0x0
B:
.LB$local:
	.zero	9437184
	.size	B, 9437184

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%lf "
	.size	.L.str, 5

	.type	C,@object                       # @C
	.bss
	.globl	C
	.p2align	4, 0x0
C:
.LC$local:
	.zero	9437184
	.size	C, 9437184

	.ident	"clang version 14.0.6"
	.section	".note.GNU-stack","",@progbits
