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
	subq	$232, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	callq	.Linit_array$local
	leaq	.LC$local(%rip), %rbx
	xorl	%eax, %eax
	movq	%rax, -48(%rbp)                 # 8-byte Spill
	movl	$9437184, %edx                  # imm = 0x900000
	movq	%rbx, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	movl	$64, %eax
	leaq	.LA$local(%rip), %rcx
	movq	%rcx, -56(%rbp)                 # 8-byte Spill
	.p2align	4, 0x90
.LBB2_1:                                # %polly.loop_header8
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #       Child Loop BB2_3 Depth 3
                                        #         Child Loop BB2_4 Depth 4
                                        #           Child Loop BB2_5 Depth 5
	leaq	.LB$local+192(%rip), %rsi
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB2_2:                                # %polly.loop_header14
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_3 Depth 3
                                        #         Child Loop BB2_4 Depth 4
                                        #           Child Loop BB2_5 Depth 5
	movq	%rcx, -152(%rbp)                # 8-byte Spill
	leaq	(,%rcx,4), %r8
	movq	%r8, %r9
	orq	$64, %r9
	movq	%r8, %r10
	orq	$128, %r10
	movq	%r8, %r11
	orq	$192, %r11
	movq	-56(%rbp), %rcx                 # 8-byte Reload
	movq	%rsi, -160(%rbp)                # 8-byte Spill
	xorl	%r13d, %r13d
	.p2align	4, 0x90
.LBB2_3:                                # %polly.loop_header20
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_4 Depth 4
                                        #           Child Loop BB2_5 Depth 5
	movq	%rcx, %r15
	movq	-48(%rbp), %r14                 # 8-byte Reload
	.p2align	4, 0x90
.LBB2_4:                                # %polly.loop_header26
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_2 Depth=2
                                        #       Parent Loop BB2_3 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB2_5 Depth 5
	movq	%r14, %rdx
	shlq	$11, %rdx
	leaq	(%rdx,%rdx,2), %rdx
	leaq	(%rbx,%rdx), %rdi
	movaps	(%r8,%rdi), %xmm11
	movaps	16(%r8,%rdi), %xmm6
	movaps	32(%r8,%rdi), %xmm9
	movaps	48(%r8,%rdi), %xmm5
	movaps	(%r9,%rdi), %xmm12
	movaps	16(%r9,%rdi), %xmm10
	movaps	32(%r9,%rdi), %xmm0
	movaps	%xmm0, -96(%rbp)                # 16-byte Spill
	movaps	48(%r9,%rdi), %xmm0
	movaps	%xmm0, -80(%rbp)                # 16-byte Spill
	movaps	(%r10,%rdi), %xmm1
	movaps	16(%r10,%rdi), %xmm0
	movaps	%xmm0, -128(%rbp)               # 16-byte Spill
	movaps	32(%r10,%rdi), %xmm8
	movaps	48(%r10,%rdi), %xmm0
	movaps	%xmm0, -112(%rbp)               # 16-byte Spill
	movaps	(%r11,%rdi), %xmm0
	movaps	16(%r11,%rdi), %xmm4
	movaps	32(%r11,%rdi), %xmm7
	movaps	48(%r11,%rdi), %xmm3
	movq	%rsi, %r12
	movl	$0, %edi
	.p2align	4, 0x90
.LBB2_5:                                # %polly.loop_header32
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_2 Depth=2
                                        #       Parent Loop BB2_3 Depth=3
                                        #         Parent Loop BB2_4 Depth=4
                                        # =>        This Inner Loop Header: Depth=5
	movaps	%xmm8, -192(%rbp)               # 16-byte Spill
	movaps	%xmm4, -144(%rbp)               # 16-byte Spill
	movaps	%xmm7, -224(%rbp)               # 16-byte Spill
	movaps	%xmm3, -240(%rbp)               # 16-byte Spill
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
	movaps	-160(%r12), %xmm8
	movaps	-144(%r12), %xmm5
	movaps	%xmm5, %xmm13
	movlhps	%xmm8, %xmm13                   # xmm13 = xmm13[0],xmm8[0]
	movaps	-192(%r12), %xmm4
	movaps	-176(%r12), %xmm9
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
	movss	(%r15,%rdi,4), %xmm4            # xmm4 = mem[0],zero,zero,zero
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
	movaps	%xmm2, -272(%rbp)               # 16-byte Spill
	movaps	%xmm9, %xmm3
	unpckhpd	%xmm13, %xmm3                   # xmm3 = xmm3[1],xmm13[1]
	movaps	%xmm11, %xmm2
	unpckhps	%xmm14, %xmm2                   # xmm2 = xmm2[2],xmm14[2],xmm2[3],xmm14[3]
	shufps	$36, %xmm3, %xmm2               # xmm2 = xmm2[0,1],xmm3[2,0]
	movaps	%xmm2, -256(%rbp)               # 16-byte Spill
	movaps	%xmm13, %xmm3
	unpcklps	%xmm9, %xmm3                    # xmm3 = xmm3[0],xmm9[0],xmm3[1],xmm9[1]
	movaps	%xmm14, %xmm2
	shufps	$17, %xmm11, %xmm2              # xmm2 = xmm2[1,0],xmm11[1,0]
	shufps	$226, %xmm3, %xmm2              # xmm2 = xmm2[2,0],xmm3[2,3]
	movaps	%xmm2, -208(%rbp)               # 16-byte Spill
	movlhps	%xmm13, %xmm9                   # xmm9 = xmm9[0],xmm13[0]
	unpcklps	%xmm14, %xmm11                  # xmm11 = xmm11[0],xmm14[0],xmm11[1],xmm14[1]
	shufps	$36, %xmm9, %xmm11              # xmm11 = xmm11[0,1],xmm9[2,0]
	movaps	%xmm12, %xmm3
	unpcklps	%xmm10, %xmm3                   # xmm3 = xmm3[0],xmm10[0],xmm3[1],xmm10[1]
	movaps	-80(%rbp), %xmm5                # 16-byte Reload
	movaps	%xmm5, %xmm4
	movaps	-96(%rbp), %xmm2                # 16-byte Reload
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
	movaps	-96(%r12), %xmm4
	movaps	-80(%r12), %xmm6
	movaps	%xmm6, %xmm13
	movlhps	%xmm4, %xmm13                   # xmm13 = xmm13[0],xmm4[0]
	movaps	-112(%r12), %xmm9
	movaps	-128(%r12), %xmm2
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
	movaps	%xmm8, -176(%rbp)               # 16-byte Spill
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
	movaps	%xmm3, -80(%rbp)                # 16-byte Spill
	movaps	%xmm9, %xmm2
	unpckhpd	%xmm13, %xmm2                   # xmm2 = xmm2[1],xmm13[1]
	movaps	%xmm12, %xmm3
	unpckhps	%xmm14, %xmm3                   # xmm3 = xmm3[2],xmm14[2],xmm3[3],xmm14[3]
	shufps	$36, %xmm2, %xmm3               # xmm3 = xmm3[0,1],xmm2[2,0]
	movaps	%xmm3, -96(%rbp)                # 16-byte Spill
	movaps	%xmm13, %xmm2
	unpcklps	%xmm9, %xmm2                    # xmm2 = xmm2[0],xmm9[0],xmm2[1],xmm9[1]
	movaps	%xmm14, %xmm8
	shufps	$17, %xmm12, %xmm8              # xmm8 = xmm8[1,0],xmm12[1,0]
	shufps	$226, %xmm2, %xmm8              # xmm8 = xmm8[2,0],xmm2[2,3]
	movlhps	%xmm13, %xmm9                   # xmm9 = xmm9[0],xmm13[0]
	unpcklps	%xmm14, %xmm12                  # xmm12 = xmm12[0],xmm14[0],xmm12[1],xmm14[1]
	shufps	$36, %xmm9, %xmm12              # xmm12 = xmm12[0,1],xmm9[2,0]
	movaps	%xmm1, %xmm3
	movaps	-128(%rbp), %xmm7               # 16-byte Reload
	unpcklps	%xmm7, %xmm3                    # xmm3 = xmm3[0],xmm7[0],xmm3[1],xmm7[1]
	movaps	-112(%rbp), %xmm5               # 16-byte Reload
	movaps	%xmm5, %xmm2
	movaps	-192(%rbp), %xmm6               # 16-byte Reload
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
	movaps	-32(%r12), %xmm4
	movaps	-16(%r12), %xmm5
	movaps	%xmm5, %xmm6
	movlhps	%xmm4, %xmm6                    # xmm6 = xmm6[0],xmm4[0]
	movaps	-48(%r12), %xmm9
	movaps	-64(%r12), %xmm15
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
	movaps	-176(%rbp), %xmm4               # 16-byte Reload
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
	movaps	%xmm3, -112(%rbp)               # 16-byte Spill
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
	movaps	%xmm3, -128(%rbp)               # 16-byte Spill
	movlhps	%xmm13, %xmm9                   # xmm9 = xmm9[0],xmm13[0]
	unpcklps	%xmm14, %xmm1                   # xmm1 = xmm1[0],xmm14[0],xmm1[1],xmm14[1]
	shufps	$36, %xmm9, %xmm1               # xmm1 = xmm1[0,1],xmm9[2,0]
	movaps	%xmm0, %xmm3
	movaps	-144(%rbp), %xmm5               # 16-byte Reload
	unpcklps	%xmm5, %xmm3                    # xmm3 = xmm3[0],xmm5[0],xmm3[1],xmm5[1]
	movaps	-240(%rbp), %xmm6               # 16-byte Reload
	movaps	%xmm6, %xmm2
	movaps	-224(%rbp), %xmm9               # 16-byte Reload
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
	movaps	%xmm5, -144(%rbp)               # 16-byte Spill
	movaps	32(%r12), %xmm4
	movaps	48(%r12), %xmm5
	movaps	%xmm5, %xmm6
	movlhps	%xmm4, %xmm6                    # xmm6 = xmm6[0],xmm4[0]
	movaps	16(%r12), %xmm9
	movaps	(%r12), %xmm15
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
	movaps	-208(%rbp), %xmm6               # 16-byte Reload
	unpckhps	%xmm5, %xmm4                    # xmm4 = xmm4[2],xmm5[2],xmm4[3],xmm5[3]
	shufps	$51, %xmm15, %xmm9              # xmm9 = xmm9[3,0],xmm15[3,0]
	shufps	$226, %xmm4, %xmm9              # xmm9 = xmm9[2,0],xmm4[2,3]
	movaps	-176(%rbp), %xmm4               # 16-byte Reload
	mulps	%xmm4, %xmm0
	addps	%xmm3, %xmm0
	mulps	%xmm4, %xmm14
	addps	%xmm7, %xmm14
	mulps	%xmm4, %xmm13
	addps	%xmm2, %xmm13
	mulps	%xmm4, %xmm9
	addps	-144(%rbp), %xmm9               # 16-byte Folded Reload
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
	movaps	-272(%rbp), %xmm5               # 16-byte Reload
	shufps	$36, %xmm9, %xmm0               # xmm0 = xmm0[0,1],xmm9[2,0]
	movaps	-256(%rbp), %xmm9               # 16-byte Reload
	incq	%rdi
	addq	$6144, %r12                     # imm = 0x1800
	cmpq	$64, %rdi
	jne	.LBB2_5
# %bb.6:                                # %polly.loop_exit34
                                        #   in Loop: Header=BB2_4 Depth=4
	leaq	(%rdx,%r8), %rdi
	movaps	%xmm6, 16(%rbx,%rdi)
	movaps	%xmm11, (%rbx,%rdi)
	movaps	%xmm9, 32(%rbx,%rdi)
	movaps	%xmm5, 48(%rbx,%rdi)
	leaq	(%rdx,%r9), %rdi
	movaps	-80(%rbp), %xmm2                # 16-byte Reload
	movaps	%xmm2, 48(%rbx,%rdi)
	movaps	%xmm12, (%rbx,%rdi)
	movaps	%xmm10, 16(%rbx,%rdi)
	movaps	-96(%rbp), %xmm2                # 16-byte Reload
	movaps	%xmm2, 32(%rbx,%rdi)
	leaq	(%rdx,%r10), %rdi
	movaps	-112(%rbp), %xmm2               # 16-byte Reload
	movaps	%xmm2, 48(%rbx,%rdi)
	movaps	%xmm1, (%rbx,%rdi)
	movaps	-128(%rbp), %xmm1               # 16-byte Reload
	movaps	%xmm1, 16(%rbx,%rdi)
	movaps	%xmm8, 32(%rbx,%rdi)
	addq	%r11, %rdx
	movaps	%xmm7, 32(%rbx,%rdx)
	movaps	%xmm3, 48(%rbx,%rdx)
	movaps	%xmm0, (%rbx,%rdx)
	movaps	%xmm4, 16(%rbx,%rdx)
	incq	%r14
	addq	$6144, %r15                     # imm = 0x1800
	cmpq	%rax, %r14
	jne	.LBB2_4
# %bb.7:                                # %polly.loop_exit28
                                        #   in Loop: Header=BB2_3 Depth=3
	leaq	64(%r13), %rdx
	addq	$393216, %rsi                   # imm = 0x60000
	addq	$256, %rcx                      # imm = 0x100
	cmpq	$1472, %r13                     # imm = 0x5C0
	movq	%rdx, %r13
	jb	.LBB2_3
# %bb.8:                                # %polly.loop_exit22
                                        #   in Loop: Header=BB2_2 Depth=2
	movq	-152(%rbp), %rdx                # 8-byte Reload
	leaq	64(%rdx), %rcx
	movq	-160(%rbp), %rsi                # 8-byte Reload
	addq	$256, %rsi                      # imm = 0x100
	cmpq	$1472, %rdx                     # imm = 0x5C0
	jb	.LBB2_2
# %bb.9:                                # %polly.loop_exit16
                                        #   in Loop: Header=BB2_1 Depth=1
	movq	-48(%rbp), %rdx                 # 8-byte Reload
	leaq	64(%rdx), %rcx
	addq	$64, %rax
	addq	$393216, -56(%rbp)              # 8-byte Folded Spill
                                        # imm = 0x60000
	cmpq	$1472, %rdx                     # imm = 0x5C0
	movq	%rcx, -48(%rbp)                 # 8-byte Spill
	jb	.LBB2_1
# %bb.10:                               # %polly.exiting
	xorl	%eax, %eax
	addq	$232, %rsp
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
