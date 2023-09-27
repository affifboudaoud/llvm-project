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
	xorl	%eax, %eax
	movdqa	.LCPI0_0(%rip), %xmm0           # xmm0 = [0,1,2,3]
	movdqa	.LCPI0_1(%rip), %xmm1           # xmm1 = [1023,1023,1023,1023]
	pcmpeqd	%xmm2, %xmm2
	movapd	.LCPI0_2(%rip), %xmm3           # xmm3 = [5.0E-1,5.0E-1]
	leaq	.LA$local(%rip), %rcx
	leaq	.LB$local(%rip), %rdx
	movdqa	.LCPI0_3(%rip), %xmm4           # xmm4 = [4,4,4,4]
	xorl	%esi, %esi
	.p2align	4, 0x90
.LBB0_1:                                # %polly.loop_header
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	movd	%esi, %xmm5
	pshufd	$0, %xmm5, %xmm5                # xmm5 = xmm5[0,0,0,0]
	xorl	%edi, %edi
	movdqa	%xmm0, %xmm6
	.p2align	4, 0x90
.LBB0_2:                                # %vector.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movdqa	%xmm6, %xmm7
	pmuludq	%xmm5, %xmm7
	pshufd	$232, %xmm7, %xmm7              # xmm7 = xmm7[0,2,2,3]
	pshufd	$245, %xmm5, %xmm8              # xmm8 = xmm5[1,1,3,3]
	pshufd	$245, %xmm6, %xmm9              # xmm9 = xmm6[1,1,3,3]
	pmuludq	%xmm8, %xmm9
	pshufd	$232, %xmm9, %xmm8              # xmm8 = xmm9[0,2,2,3]
	punpckldq	%xmm8, %xmm7            # xmm7 = xmm7[0],xmm8[0],xmm7[1],xmm8[1]
	pand	%xmm1, %xmm7
	psubd	%xmm2, %xmm7
	cvtdq2pd	%xmm7, %xmm8
	pshufd	$238, %xmm7, %xmm7              # xmm7 = xmm7[2,3,2,3]
	cvtdq2pd	%xmm7, %xmm7
	mulpd	%xmm3, %xmm7
	mulpd	%xmm3, %xmm8
	cvtpd2ps	%xmm8, %xmm8
	cvtpd2ps	%xmm7, %xmm7
	unpcklpd	%xmm7, %xmm8                    # xmm8 = xmm8[0],xmm7[0]
	leaq	(%rax,%rdi), %r8
	movapd	%xmm8, (%rcx,%r8)
	movapd	%xmm8, (%rdx,%r8)
	paddd	%xmm4, %xmm6
	addq	$16, %rdi
	cmpq	$6144, %rdi                     # imm = 0x1800
	jne	.LBB0_2
# %bb.3:                                # %polly.loop_exit3
                                        #   in Loop: Header=BB0_1 Depth=1
	incq	%rsi
	addq	$6144, %rax                     # imm = 0x1800
	cmpq	$1536, %rsi                     # imm = 0x600
	jne	.LBB0_1
# %bb.4:                                # %polly.exiting
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
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	callq	.Linit_array$local
	movq	$-1535, %rbx                    # imm = 0xFA01
	leaq	.LA$local-9431032(%rip), %r14
	xorl	%r15d, %r15d
	leaq	.LC$local(%rip), %r12
	leaq	.LB$local(%rip), %r13
	jmp	.LBB2_1
.LBB2_13:                               # %polly.loop_header1.us.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	movl	$6144, %edx                     # imm = 0x1800
	xorl	%esi, %esi
	callq	memset@PLT
	.p2align	4, 0x90
.LBB2_11:                               # %polly.loop_exit3
                                        #   in Loop: Header=BB2_1 Depth=1
	incq	%rbx
	incq	%r15
	addq	$6144, %r14                     # imm = 0x1800
	cmpq	$3071, %r15                     # imm = 0xBFF
	je	.LBB2_12
.LBB2_1:                                # %polly.loop_header
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #       Child Loop BB2_4 Depth 3
                                        #     Child Loop BB2_8 Depth 2
                                        #       Child Loop BB2_9 Depth 3
	movq	%r15, %rax
	shlq	$11, %rax
	leaq	(%rax,%rax,2), %rax
	movq	%r12, %rdi
	subq	%rax, %rdi
	addq	$9431040, %rdi                  # imm = 0x8FE800
	movq	%rbx, %rax
	shlq	$11, %rax
	leaq	(%rax,%rax,2), %rax
	movq	%rax, %rcx
	negq	%rcx
	testq	%rbx, %rbx
	jle	.LBB2_6
# %bb.2:                                # %polly.loop_header1.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	movq	%r13, %rcx
	xorl	%edx, %edx
	.p2align	4, 0x90
.LBB2_3:                                # %polly.loop_header1
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_4 Depth 3
	leaq	(,%rdx,4), %rsi
	leaq	(%rax,%rdx,4), %rdi
	movss	(%r12,%rdi), %xmm0              # xmm0 = mem[0],zero,zero,zero
	movq	%rcx, %rdi
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB2_4:                                # %polly.loop_header11
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movss	-8(%r14,%r8,4), %xmm1           # xmm1 = mem[0],zero,zero,zero
	mulss	(%rdi), %xmm1
	movss	-4(%r14,%r8,4), %xmm2           # xmm2 = mem[0],zero,zero,zero
	addss	%xmm0, %xmm1
	mulss	6144(%rdi), %xmm2
	addss	%xmm1, %xmm2
	movss	(%r14,%r8,4), %xmm0             # xmm0 = mem[0],zero,zero,zero
	mulss	12288(%rdi), %xmm0
	addss	%xmm2, %xmm0
	addq	$3, %r8
	addq	$18432, %rdi                    # imm = 0x4800
	cmpq	$1536, %r8                      # imm = 0x600
	jne	.LBB2_4
# %bb.5:                                # %polly.merge8.loopexit
                                        #   in Loop: Header=BB2_3 Depth=2
	addq	%rax, %rsi
	movss	%xmm0, (%r12,%rsi)
	incq	%rdx
	addq	$4, %rcx
	cmpq	$1536, %rdx                     # imm = 0x600
	jne	.LBB2_3
	jmp	.LBB2_11
	.p2align	4, 0x90
.LBB2_6:                                # %polly.loop_header.split.us
                                        #   in Loop: Header=BB2_1 Depth=1
	js	.LBB2_13
# %bb.7:                                # %polly.loop_header1.us.us.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	movq	%r13, %rdx
	xorl	%esi, %esi
	.p2align	4, 0x90
.LBB2_8:                                # %polly.loop_header1.us.us
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_9 Depth 3
	leaq	(,%rsi,4), %rdi
	leaq	(%rcx,%rsi,4), %r8
	movl	$0, (%r12,%r8)
	leaq	(%rax,%rsi,4), %r8
	movss	(%r12,%r8), %xmm0               # xmm0 = mem[0],zero,zero,zero
	movq	%rdx, %r8
	xorl	%r9d, %r9d
	.p2align	4, 0x90
.LBB2_9:                                # %polly.loop_header11.us.us
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_8 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movss	-8(%r14,%r9,4), %xmm1           # xmm1 = mem[0],zero,zero,zero
	mulss	(%r8), %xmm1
	movss	-4(%r14,%r9,4), %xmm2           # xmm2 = mem[0],zero,zero,zero
	addss	%xmm0, %xmm1
	mulss	6144(%r8), %xmm2
	addss	%xmm1, %xmm2
	movss	(%r14,%r9,4), %xmm0             # xmm0 = mem[0],zero,zero,zero
	mulss	12288(%r8), %xmm0
	addss	%xmm2, %xmm0
	addq	$3, %r9
	addq	$18432, %r8                     # imm = 0x4800
	cmpq	$1536, %r9                      # imm = 0x600
	jne	.LBB2_9
# %bb.10:                               # %polly.merge8.loopexit.us.us
                                        #   in Loop: Header=BB2_8 Depth=2
	addq	%rax, %rdi
	movss	%xmm0, (%r12,%rdi)
	incq	%rsi
	addq	$4, %rdx
	cmpq	$1536, %rsi                     # imm = 0x600
	jne	.LBB2_8
	jmp	.LBB2_11
.LBB2_12:                               # %polly.exiting
	xorl	%eax, %eax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
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
