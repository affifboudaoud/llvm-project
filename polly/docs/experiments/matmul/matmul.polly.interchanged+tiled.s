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
	subq	$264, %rsp                      # imm = 0x108
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	callq	.Linit_array$local
	leaq	.LC$local(%rip), %r12
	xorl	%eax, %eax
	movq	%rax, -48(%rbp)                 # 8-byte Spill
	movl	$9437184, %edx                  # imm = 0x900000
	movq	%r12, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	movl	$64, %eax
	movq	%rax, -64(%rbp)                 # 8-byte Spill
	leaq	.LA$local(%rip), %rax
	movq	%rax, -56(%rbp)                 # 8-byte Spill
	.p2align	4, 0x90
.LBB2_1:                                # %polly.loop_header8
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #       Child Loop BB2_3 Depth 3
                                        #         Child Loop BB2_4 Depth 4
                                        #           Child Loop BB2_5 Depth 5
	leaq	.LB$local+240(%rip), %r8
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB2_2:                                # %polly.loop_header14
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB2_3 Depth 3
                                        #         Child Loop BB2_4 Depth 4
                                        #           Child Loop BB2_5 Depth 5
	movq	%rax, -200(%rbp)                # 8-byte Spill
	leaq	(,%rax,4), %rbx
	movq	%rbx, %rdx
	orq	$16, %rdx
	movq	%rbx, %r13
	orq	$32, %r13
	movq	%rbx, %rsi
	orq	$48, %rsi
	movq	%rbx, %rax
	orq	$64, %rax
	movq	%rax, -136(%rbp)                # 8-byte Spill
	movq	%rbx, %rcx
	orq	$80, %rcx
	movq	%rbx, %r9
	orq	$96, %r9
	movq	%rbx, %r10
	orq	$112, %r10
	movq	%rbx, %r14
	orq	$128, %r14
	movq	%rbx, %r11
	orq	$144, %r11
	movq	%r11, -128(%rbp)                # 8-byte Spill
	movq	%rbx, %r11
	orq	$160, %r11
	movq	%r11, -120(%rbp)                # 8-byte Spill
	movq	%rbx, %rdi
	orq	$176, %rdi
	movq	%rdi, -112(%rbp)                # 8-byte Spill
	movq	%rbx, %rdi
	orq	$192, %rdi
	movq	%rdi, -104(%rbp)                # 8-byte Spill
	movq	%rbx, %rdi
	orq	$208, %rdi
	movq	%rdi, -96(%rbp)                 # 8-byte Spill
	movq	%rbx, %rdi
	orq	$224, %rdi
	movq	%rdi, -88(%rbp)                 # 8-byte Spill
	movq	%rbx, %rax
	movq	%rbx, %rdi
	orq	$240, %rdi
	movq	%rdi, -80(%rbp)                 # 8-byte Spill
	movq	-56(%rbp), %r11                 # 8-byte Reload
	movq	%r8, -208(%rbp)                 # 8-byte Spill
	movq	%r8, -72(%rbp)                  # 8-byte Spill
	xorl	%r8d, %r8d
	movq	%rcx, -288(%rbp)                # 8-byte Spill
	movq	%r9, -280(%rbp)                 # 8-byte Spill
	movq	%rsi, -272(%rbp)                # 8-byte Spill
	movq	%r10, -264(%rbp)                # 8-byte Spill
	movq	%r13, -256(%rbp)                # 8-byte Spill
	movq	%r14, -248(%rbp)                # 8-byte Spill
	movq	%rbx, -240(%rbp)                # 8-byte Spill
	movq	%rdx, -232(%rbp)                # 8-byte Spill
	.p2align	4, 0x90
.LBB2_3:                                # %polly.loop_header20
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB2_4 Depth 4
                                        #           Child Loop BB2_5 Depth 5
	movq	%r8, -216(%rbp)                 # 8-byte Spill
	movq	%r11, -224(%rbp)                # 8-byte Spill
	movq	-48(%rbp), %r8                  # 8-byte Reload
	movq	-88(%rbp), %rdi                 # 8-byte Reload
	movq	-80(%rbp), %rbx                 # 8-byte Reload
	.p2align	4, 0x90
.LBB2_4:                                # %polly.loop_header26
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_2 Depth=2
                                        #       Parent Loop BB2_3 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB2_5 Depth 5
	movq	%r8, -296(%rbp)                 # 8-byte Spill
	shlq	$11, %r8
	leaq	(%r8,%r8,2), %r15
	leaq	(%r12,%r15), %r8
	movaps	(%rax,%r8), %xmm15
	movaps	(%rdx,%r8), %xmm0
	movaps	%xmm0, -160(%rbp)               # 16-byte Spill
	movaps	(%r13,%r8), %xmm14
	movaps	(%rsi,%r8), %xmm13
	movq	-136(%rbp), %rax                # 8-byte Reload
	movaps	(%rax,%r8), %xmm12
	movaps	(%rcx,%r8), %xmm11
	movaps	(%r9,%r8), %xmm10
	movaps	(%r10,%r8), %xmm9
	movaps	(%r14,%r8), %xmm8
	movq	-128(%rbp), %rax                # 8-byte Reload
	movaps	(%rax,%r8), %xmm7
	movq	-120(%rbp), %rax                # 8-byte Reload
	movaps	(%rax,%r8), %xmm6
	movq	-112(%rbp), %rax                # 8-byte Reload
	movaps	(%rax,%r8), %xmm5
	movq	-104(%rbp), %rax                # 8-byte Reload
	movaps	(%rax,%r8), %xmm4
	movq	-96(%rbp), %rax                 # 8-byte Reload
	movaps	(%rax,%r8), %xmm0
	movaps	%xmm0, -176(%rbp)               # 16-byte Spill
	movaps	(%rdi,%r8), %xmm3
	movaps	(%rbx,%r8), %xmm2
	movq	-72(%rbp), %r13                 # 8-byte Reload
	movl	$0, %r8d
	.p2align	4, 0x90
.LBB2_5:                                # %polly.loop_header32
                                        #   Parent Loop BB2_1 Depth=1
                                        #     Parent Loop BB2_2 Depth=2
                                        #       Parent Loop BB2_3 Depth=3
                                        #         Parent Loop BB2_4 Depth=4
                                        # =>        This Inner Loop Header: Depth=5
	movaps	%xmm2, -192(%rbp)               # 16-byte Spill
	movss	(%r11,%r8,4), %xmm0             # xmm0 = mem[0],zero,zero,zero
	shufps	$0, %xmm0, %xmm0                # xmm0 = xmm0[0,0,0,0]
	movaps	-240(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm15
	movaps	-224(%r13), %xmm1
	mulps	%xmm0, %xmm1
	movaps	-160(%rbp), %xmm2               # 16-byte Reload
	addps	%xmm1, %xmm2
	movaps	%xmm2, -160(%rbp)               # 16-byte Spill
	movaps	-208(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm14
	movaps	-192(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm13
	movaps	-176(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm12
	movaps	-160(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm11
	movaps	-144(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm10
	movaps	-128(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm9
	movaps	-112(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm8
	movaps	-96(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm7
	movaps	-80(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm6
	movaps	-64(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm5
	movaps	-48(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm4
	movaps	-32(%r13), %xmm1
	mulps	%xmm0, %xmm1
	movaps	%xmm15, %xmm2
	movaps	%xmm14, %xmm15
	movaps	%xmm13, %xmm14
	movaps	%xmm12, %xmm13
	movaps	%xmm11, %xmm12
	movaps	%xmm10, %xmm11
	movaps	%xmm9, %xmm10
	movaps	%xmm8, %xmm9
	movaps	%xmm7, %xmm8
	movaps	%xmm6, %xmm7
	movaps	%xmm5, %xmm6
	movaps	%xmm4, %xmm5
	movaps	-176(%rbp), %xmm4               # 16-byte Reload
	addps	%xmm1, %xmm4
	movaps	%xmm4, -176(%rbp)               # 16-byte Spill
	movaps	%xmm5, %xmm4
	movaps	%xmm6, %xmm5
	movaps	%xmm7, %xmm6
	movaps	%xmm8, %xmm7
	movaps	%xmm9, %xmm8
	movaps	%xmm10, %xmm9
	movaps	%xmm11, %xmm10
	movaps	%xmm12, %xmm11
	movaps	%xmm13, %xmm12
	movaps	%xmm14, %xmm13
	movaps	%xmm15, %xmm14
	movaps	%xmm2, %xmm15
	movaps	-16(%r13), %xmm1
	mulps	%xmm0, %xmm1
	addps	%xmm1, %xmm3
	mulps	(%r13), %xmm0
	movaps	-192(%rbp), %xmm2               # 16-byte Reload
	addps	%xmm0, %xmm2
	movaps	%xmm2, -192(%rbp)               # 16-byte Spill
	movaps	-192(%rbp), %xmm2               # 16-byte Reload
	incq	%r8
	addq	$6144, %r13                     # imm = 0x1800
	cmpq	$64, %r8
	jne	.LBB2_5
# %bb.6:                                # %polly.loop_exit34
                                        #   in Loop: Header=BB2_4 Depth=4
	movq	-240(%rbp), %rax                # 8-byte Reload
	leaq	(%r15,%rax), %r8
	leaq	.LC$local(%rip), %r12
	movaps	%xmm15, (%r12,%r8)
	movq	-232(%rbp), %rdx                # 8-byte Reload
	leaq	(%r15,%rdx), %r8
	movaps	-160(%rbp), %xmm0               # 16-byte Reload
	movaps	%xmm0, (%r12,%r8)
	movq	-256(%rbp), %r13                # 8-byte Reload
	leaq	(%r15,%r13), %r8
	movaps	%xmm14, (%r12,%r8)
	movq	-272(%rbp), %rsi                # 8-byte Reload
	leaq	(%r15,%rsi), %r8
	movaps	%xmm13, (%r12,%r8)
	movq	-136(%rbp), %rcx                # 8-byte Reload
	leaq	(%r15,%rcx), %r8
	movaps	%xmm12, (%r12,%r8)
	movq	-288(%rbp), %rcx                # 8-byte Reload
	leaq	(%r15,%rcx), %r8
	movaps	%xmm11, (%r12,%r8)
	movq	-280(%rbp), %r9                 # 8-byte Reload
	leaq	(%r15,%r9), %r8
	movaps	%xmm10, (%r12,%r8)
	movq	-264(%rbp), %r10                # 8-byte Reload
	leaq	(%r15,%r10), %r8
	movaps	%xmm9, (%r12,%r8)
	movq	-248(%rbp), %r14                # 8-byte Reload
	leaq	(%r15,%r14), %r8
	movaps	%xmm8, (%r12,%r8)
	movq	-128(%rbp), %rdi                # 8-byte Reload
	leaq	(%r15,%rdi), %r8
	movaps	%xmm7, (%r12,%r8)
	movq	-120(%rbp), %rdi                # 8-byte Reload
	leaq	(%r15,%rdi), %r8
	movaps	%xmm6, (%r12,%r8)
	movq	-112(%rbp), %rdi                # 8-byte Reload
	leaq	(%r15,%rdi), %r8
	movaps	%xmm5, (%r12,%r8)
	movq	-104(%rbp), %rdi                # 8-byte Reload
	leaq	(%r15,%rdi), %r8
	movaps	%xmm4, (%r12,%r8)
	movq	-96(%rbp), %rdi                 # 8-byte Reload
	leaq	(%r15,%rdi), %r8
	movaps	-176(%rbp), %xmm0               # 16-byte Reload
	movaps	%xmm0, (%r12,%r8)
	movq	-88(%rbp), %rdi                 # 8-byte Reload
	leaq	(%r15,%rdi), %r8
	movaps	%xmm3, (%r12,%r8)
	movq	-80(%rbp), %rbx                 # 8-byte Reload
	addq	%rbx, %r15
	movaps	%xmm2, (%r12,%r15)
	movq	-296(%rbp), %r8                 # 8-byte Reload
	incq	%r8
	addq	$6144, %r11                     # imm = 0x1800
	cmpq	-64(%rbp), %r8                  # 8-byte Folded Reload
	jne	.LBB2_4
# %bb.7:                                # %polly.loop_exit28
                                        #   in Loop: Header=BB2_3 Depth=3
	movq	-216(%rbp), %rdi                # 8-byte Reload
	leaq	64(%rdi), %r8
	addq	$393216, -72(%rbp)              # 8-byte Folded Spill
                                        # imm = 0x60000
	movq	-224(%rbp), %r11                # 8-byte Reload
	addq	$256, %r11                      # imm = 0x100
	cmpq	$1472, %rdi                     # imm = 0x5C0
	jb	.LBB2_3
# %bb.8:                                # %polly.loop_exit22
                                        #   in Loop: Header=BB2_2 Depth=2
	movq	-200(%rbp), %rcx                # 8-byte Reload
	leaq	64(%rcx), %rax
	movq	-208(%rbp), %r8                 # 8-byte Reload
	addq	$256, %r8                       # imm = 0x100
	cmpq	$1472, %rcx                     # imm = 0x5C0
	jb	.LBB2_2
# %bb.9:                                # %polly.loop_exit16
                                        #   in Loop: Header=BB2_1 Depth=1
	movq	-48(%rbp), %rcx                 # 8-byte Reload
	leaq	64(%rcx), %rax
	addq	$64, -64(%rbp)                  # 8-byte Folded Spill
	addq	$393216, -56(%rbp)              # 8-byte Folded Spill
                                        # imm = 0x60000
	cmpq	$1472, %rcx                     # imm = 0x5C0
	movq	%rax, -48(%rbp)                 # 8-byte Spill
	jb	.LBB2_1
# %bb.10:                               # %polly.exiting
	xorl	%eax, %eax
	addq	$264, %rsp                      # imm = 0x108
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
