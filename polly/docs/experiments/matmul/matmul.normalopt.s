	.text
	.file	"matmul.c"
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0                          # -- Begin function init_array
.LCPI0_0:
	.quad	2                               # 0x2
	.quad	3                               # 0x3
.LCPI0_1:
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	1                               # 0x1
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
	.byte	0                               # 0x0
.LCPI0_2:
	.long	1023                            # 0x3ff
	.long	1023                            # 0x3ff
	.long	1023                            # 0x3ff
	.long	1023                            # 0x3ff
.LCPI0_3:
	.quad	0x3fe0000000000000              # double 0.5
	.quad	0x3fe0000000000000              # double 0.5
.LCPI0_4:
	.quad	4                               # 0x4
	.quad	4                               # 0x4
	.text
	.globl	init_array
	.p2align	4, 0x90
	.type	init_array,@function
init_array:                             # @init_array
.Linit_array$local:
	.type	.Linit_array$local,@function
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	xorl	%eax, %eax
	movdqa	.LCPI0_0(%rip), %xmm0           # xmm0 = [2,3]
	movdqa	.LCPI0_1(%rip), %xmm1           # xmm1 = [0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]
	movaps	.LCPI0_2(%rip), %xmm2           # xmm2 = [1023,1023,1023,1023]
	pcmpeqd	%xmm3, %xmm3
	movapd	.LCPI0_3(%rip), %xmm4           # xmm4 = [5.0E-1,5.0E-1]
	leaq	.LA$local(%rip), %rcx
	leaq	.LB$local(%rip), %rdx
	movdqa	.LCPI0_4(%rip), %xmm5           # xmm5 = [4,4]
	xorl	%esi, %esi
	.p2align	4, 0x90
.LBB0_1:                                # %vector.ph
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	movq	%rsi, %xmm6
	pshufd	$68, %xmm6, %xmm6               # xmm6 = xmm6[0,1,0,1]
	xorl	%edi, %edi
	movdqa	%xmm1, %xmm7
	movdqa	%xmm0, %xmm8
	.p2align	4, 0x90
.LBB0_2:                                # %vector.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movdqa	%xmm7, %xmm9
	pmuludq	%xmm6, %xmm9
	movdqa	%xmm8, %xmm10
	pmuludq	%xmm6, %xmm10
	shufps	$136, %xmm10, %xmm9             # xmm9 = xmm9[0,2],xmm10[0,2]
	andps	%xmm2, %xmm9
	psubd	%xmm3, %xmm9
	cvtdq2pd	%xmm9, %xmm10
	pshufd	$238, %xmm9, %xmm9              # xmm9 = xmm9[2,3,2,3]
	cvtdq2pd	%xmm9, %xmm9
	mulpd	%xmm4, %xmm9
	mulpd	%xmm4, %xmm10
	cvtpd2ps	%xmm10, %xmm10
	cvtpd2ps	%xmm9, %xmm9
	unpcklpd	%xmm9, %xmm10                   # xmm10 = xmm10[0],xmm9[0]
	leaq	(%rax,%rdi), %r8
	movapd	%xmm10, (%rcx,%r8)
	movapd	%xmm10, (%rdx,%r8)
	paddq	%xmm5, %xmm7
	paddq	%xmm5, %xmm8
	addq	$16, %rdi
	cmpq	$6144, %rdi                     # imm = 0x1800
	jne	.LBB0_2
# %bb.3:                                # %middle.block
                                        #   in Loop: Header=BB0_1 Depth=1
	incq	%rsi
	addq	$6144, %rax                     # imm = 0x1800
	cmpq	$1536, %rsi                     # imm = 0x600
	jne	.LBB0_1
# %bb.4:
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
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	callq	.Linit_array$local
	leaq	.LA$local(%rip), %rax
	xorl	%ecx, %ecx
	leaq	.LB$local(%rip), %rdx
	leaq	.LC$local(%rip), %rsi
	.p2align	4, 0x90
.LBB2_1:                                # %.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #       Child Loop BB2_3 Depth 3
	movq	%rdx, %rdi
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB2_2:                                #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_3 Depth 3
	leaq	(%rcx,%rcx,2), %r9
	shlq	$11, %r9
	addq	%rsi, %r9
	leaq	(%r9,%r8,4), %r9
	xorps	%xmm0, %xmm0
	movl	$2, %r10d
	movq	%rdi, %r11
	.p2align	4, 0x90
.LBB2_3:                                #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movss	-8(%rax,%r10,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	mulss	(%r11), %xmm1
	movss	-4(%rax,%r10,4), %xmm2          # xmm2 = mem[0],zero,zero,zero
	addss	%xmm0, %xmm1
	mulss	6144(%r11), %xmm2
	addss	%xmm1, %xmm2
	movss	(%rax,%r10,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	mulss	12288(%r11), %xmm0
	addss	%xmm2, %xmm0
	addq	$3, %r10
	addq	$18432, %r11                    # imm = 0x4800
	cmpq	$1538, %r10                     # imm = 0x602
	jne	.LBB2_3
# %bb.4:                                #   in Loop: Header=BB2_2 Depth=2
	movss	%xmm0, (%r9)
	incq	%r8
	addq	$4, %rdi
	cmpq	$1536, %r8                      # imm = 0x600
	jne	.LBB2_2
# %bb.5:                                #   in Loop: Header=BB2_1 Depth=1
	incq	%rcx
	addq	$6144, %rax                     # imm = 0x1800
	cmpq	$1536, %rcx                     # imm = 0x600
	jne	.LBB2_1
# %bb.6:
	xorl	%eax, %eax
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
