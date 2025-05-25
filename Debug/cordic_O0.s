	.file	"cordic.c"
	.intel_syntax noprefix
	.text
	.globl	K
	.data
	.align 8
K:
	.long	-1256890314
	.long	1071869597
	.globl	_angles
	.align 32
_angles:
	.long	1413777120
	.long	1072243195
	.long	90276502
	.long	1071492199
	.long	-115491822
	.long	1070553973
	.long	-1703361215
	.long	1069536698
	.long	-1221205575
	.long	1068496219
	.long	-1155246312
	.long	1067449685
	.long	1527207137
	.long	1066401621
	.long	1484366646
	.long	1065353173
	.long	1358364373
	.long	1064304629
	.long	1355686842
	.long	1063256061
	.long	1527955685
	.long	1062207487
	.long	-922337204
	.long	1061158911
	.long	-922337204
	.long	1060110335
	.long	-922337204
	.long	1059061759
	.long	-1066787083
	.long	1058013184
	.long	-1066787083
	.long	1056964608
	.globl	y_1
	.bss
	.align 32
y_1:
	.space 1024
	.globl	y_2
	.align 32
y_2:
	.space 1024
	.section .rdata,"dr"
.LC6:
	.ascii "[%3.2lf] x: %lf %lf (%lf)\12\0"
.LC7:
	.ascii "[%3.2lf] y: %lf %lf (%lf)\12\12\0"
.LC8:
	.ascii "[%3.2lf] r: %lf %lf (%lf)\12\12\0"
.LC11:
	.ascii "%llx\12\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 208
	.seh_stackalloc	208
	.seh_endprologue
	call	__main
	movsd	xmm0, QWORD PTR .LC0[rip]
	movsd	QWORD PTR -16[rbp], xmm0
	mov	QWORD PTR -24[rbp], 0
	mov	rax, QWORD PTR K[rip]
	movsd	xmm0, QWORD PTR .LC1[rip]
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	pow
	movq	rax, xmm0
	mov	QWORD PTR -48[rbp], rax
	pxor	xmm0, xmm0
	movsd	QWORD PTR -40[rbp], xmm0
	pxor	xmm0, xmm0
	movsd	QWORD PTR -64[rbp], xmm0
	movsd	xmm0, QWORD PTR .LC3[rip]
	movsd	QWORD PTR -56[rbp], xmm0
	pxor	xmm0, xmm0
	movsd	QWORD PTR -8[rbp], xmm0
	jmp	.L2
.L3:
	movsd	xmm1, QWORD PTR -8[rbp]
	movsd	xmm0, QWORD PTR .LC4[rip]
	mulsd	xmm0, xmm1
	lea	rcx, -128[rbp]
	mov	rax, QWORD PTR -48[rbp]
	mov	rdx, QWORD PTR -40[rbp]
	mov	QWORD PTR -144[rbp], rax
	mov	QWORD PTR -136[rbp], rdx
	lea	rax, -144[rbp]
	movapd	xmm2, xmm0
	mov	rdx, rax
	call	GRF
	movsd	xmm1, QWORD PTR -8[rbp]
	movsd	xmm0, QWORD PTR .LC4[rip]
	mulsd	xmm0, xmm1
	lea	rcx, -96[rbp]
	mov	rax, QWORD PTR -48[rbp]
	mov	rdx, QWORD PTR -40[rbp]
	mov	QWORD PTR -144[rbp], rax
	mov	QWORD PTR -136[rbp], rdx
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR -160[rbp], rax
	mov	QWORD PTR -152[rbp], rdx
	lea	rdx, -160[rbp]
	lea	rax, -144[rbp]
	mov	DWORD PTR 32[rsp], 1
	movapd	xmm3, xmm0
	mov	r8, rdx
	mov	rdx, rax
	call	CORDIC
	movsd	xmm0, QWORD PTR -96[rbp]
	movsd	xmm1, QWORD PTR -128[rbp]
	subsd	xmm0, xmm1
	movsd	xmm4, QWORD PTR -96[rbp]
	movsd	xmm3, QWORD PTR -128[rbp]
	movsd	xmm2, QWORD PTR -104[rbp]
	movsd	xmm1, QWORD PTR .LC5[rip]
	mulsd	xmm1, xmm2
	movapd	xmm2, xmm4
	movapd	xmm4, xmm2
	movq	rcx, xmm2
	movapd	xmm2, xmm3
	movq	rdx, xmm3
	movapd	xmm3, xmm1
	movapd	xmm1, xmm3
	movq	rax, xmm3
	movsd	QWORD PTR 32[rsp], xmm0
	movapd	xmm3, xmm4
	mov	r9, rcx
	mov	r8, rdx
	mov	rdx, rax
	lea	rax, .LC6[rip]
	mov	rcx, rax
	call	printf
	movsd	xmm0, QWORD PTR -88[rbp]
	movsd	xmm1, QWORD PTR -120[rbp]
	subsd	xmm0, xmm1
	movsd	xmm4, QWORD PTR -88[rbp]
	movsd	xmm3, QWORD PTR -120[rbp]
	movsd	xmm2, QWORD PTR -72[rbp]
	movsd	xmm1, QWORD PTR .LC5[rip]
	mulsd	xmm1, xmm2
	movapd	xmm2, xmm4
	movapd	xmm4, xmm2
	movq	rcx, xmm2
	movapd	xmm2, xmm3
	movq	rdx, xmm3
	movapd	xmm3, xmm1
	movapd	xmm1, xmm3
	movq	rax, xmm3
	movsd	QWORD PTR 32[rsp], xmm0
	movapd	xmm3, xmm4
	mov	r9, rcx
	mov	r8, rdx
	mov	rdx, rax
	lea	rax, .LC7[rip]
	mov	rcx, rax
	call	printf
	movsd	xmm0, QWORD PTR -80[rbp]
	movsd	xmm1, QWORD PTR -112[rbp]
	subsd	xmm0, xmm1
	movsd	xmm4, QWORD PTR -80[rbp]
	movsd	xmm3, QWORD PTR -112[rbp]
	movsd	xmm2, QWORD PTR -72[rbp]
	movsd	xmm1, QWORD PTR .LC5[rip]
	mulsd	xmm1, xmm2
	movapd	xmm2, xmm4
	movapd	xmm4, xmm2
	movq	rcx, xmm2
	movapd	xmm2, xmm3
	movq	rdx, xmm3
	movapd	xmm3, xmm1
	movapd	xmm1, xmm3
	movq	rax, xmm3
	movsd	QWORD PTR 32[rsp], xmm0
	movapd	xmm3, xmm4
	mov	r9, rcx
	mov	r8, rdx
	mov	rdx, rax
	lea	rax, .LC8[rip]
	mov	rcx, rax
	call	printf
	movsd	xmm1, QWORD PTR -8[rbp]
	movsd	xmm0, QWORD PTR .LC9[rip]
	addsd	xmm0, xmm1
	movsd	QWORD PTR -8[rbp], xmm0
.L2:
	movsd	xmm0, QWORD PTR .LC9[rip]
	comisd	xmm0, QWORD PTR -8[rbp]
	ja	.L3
	mov	rax, QWORD PTR .LC10[rip]
	mov	edx, 62
	movq	xmm0, rax
	call	lf2fp
	mov	rdx, rax
	lea	rax, .LC11[rip]
	mov	rcx, rax
	call	printf
	mov	eax, 0
	add	rsp, 208
	pop	rbp
	ret
	.seh_endproc
	.globl	lf2fp
	.def	lf2fp;	.scl	2;	.type	32;	.endef
	.seh_proc	lf2fp
lf2fp:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	lea	rbp, [rsp]
	.seh_setframe	rbp, 0
	.seh_endprologue
	movsd	QWORD PTR 24[rbp], xmm0
	mov	DWORD PTR 32[rbp], edx
	lea	rax, 24[rbp]
	mov	rax, QWORD PTR [rax]
	shr	rax, 52
	and	eax, 2047
	mov	edx, eax
	mov	eax, DWORD PTR 32[rbp]
	add	eax, edx
	sub	eax, 1075
	mov	ebx, eax
	cmp	ebx, 63
	jle	.L6
	movabs	rax, 9223372036854775807
	jmp	.L7
.L6:
	cmp	ebx, -63
	jge	.L8
	mov	eax, 0
	jmp	.L7
.L8:
	test	ebx, ebx
	js	.L9
	lea	rax, 24[rbp]
	mov	rax, QWORD PTR [rax]
	movabs	rdx, 4503599627370495
	and	rdx, rax
	movabs	rax, 4503599627370496
	or	rax, rdx
	mov	ecx, ebx
	sal	rax, cl
	mov	rbx, rax
	jmp	.L10
.L9:
	lea	rax, 24[rbp]
	mov	rax, QWORD PTR [rax]
	movabs	rdx, 4503599627370495
	and	rdx, rax
	movabs	rax, 4503599627370496
	or	rdx, rax
	mov	eax, ebx
	neg	eax
	mov	rbx, rdx
	mov	ecx, eax
	shr	rbx, cl
.L10:
	lea	rax, 24[rbp]
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	jns	.L11
	neg	rbx
.L11:
	mov	rax, rbx
.L7:
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.globl	fp2lf
	.def	fp2lf;	.scl	2;	.type	32;	.endef
	.seh_proc	fp2lf
fp2lf:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 64
	.seh_stackalloc	64
	lea	rbp, 48[rsp]
	.seh_setframe	rbp, 48
	movups	XMMWORD PTR 0[rbp], xmm6
	.seh_savexmm	xmm6, 48
	.seh_endprologue
	mov	rax, rcx
	mov	DWORD PTR 40[rbp], edx
	test	rax, rax
	jne	.L13
	pxor	xmm0, xmm0
	jmp	.L14
.L13:
	pxor	xmm6, xmm6
	cvtsi2sd	xmm6, rax
	mov	eax, DWORD PTR 40[rbp]
	neg	eax
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, eax
	mov	rax, QWORD PTR .LC1[rip]
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	pow
	mulsd	xmm0, xmm6
	movsd	QWORD PTR -8[rbp], xmm0
	movsd	xmm0, QWORD PTR -8[rbp]
.L14:
	movups	xmm6, XMMWORD PTR 0[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	GRF
	.def	GRF;	.scl	2;	.type	32;	.endef
	.seh_proc	GRF
GRF:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 136
	.seh_stackalloc	136
	lea	rbp, 80[rsp]
	.seh_setframe	rbp, 80
	movups	XMMWORD PTR 0[rbp], xmm6
	.seh_savexmm	xmm6, 80
	movups	XMMWORD PTR 16[rbp], xmm7
	.seh_savexmm	xmm7, 96
	movups	XMMWORD PTR 32[rbp], xmm8
	.seh_savexmm	xmm8, 112
	.seh_endprologue
	mov	QWORD PTR 80[rbp], rcx
	mov	rbx, rdx
	mov	rax, QWORD PTR [rbx]
	mov	rdx, QWORD PTR 8[rbx]
	mov	QWORD PTR -48[rbp], rax
	mov	QWORD PTR -40[rbp], rdx
	movsd	QWORD PTR 96[rbp], xmm2
	pxor	xmm0, xmm0
	movups	XMMWORD PTR -32[rbp], xmm0
	movups	XMMWORD PTR -16[rbp], xmm0
	mov	rax, QWORD PTR 96[rbp]
	movq	xmm0, rax
	call	cos
	movapd	xmm6, xmm0
	movsd	xmm7, QWORD PTR -48[rbp]
	movsd	xmm8, QWORD PTR -40[rbp]
	mov	rax, QWORD PTR 96[rbp]
	movq	xmm0, rax
	call	tan
	movapd	xmm1, xmm8
	mulsd	xmm1, xmm0
	subsd	xmm7, xmm1
	movapd	xmm0, xmm7
	mulsd	xmm0, xmm6
	movsd	QWORD PTR -32[rbp], xmm0
	mov	rax, QWORD PTR 96[rbp]
	movq	xmm0, rax
	call	cos
	movapd	xmm6, xmm0
	movsd	xmm7, QWORD PTR -40[rbp]
	movsd	xmm8, QWORD PTR -48[rbp]
	mov	rax, QWORD PTR 96[rbp]
	movq	xmm0, rax
	call	tan
	mulsd	xmm0, xmm8
	addsd	xmm0, xmm7
	mulsd	xmm0, xmm6
	movsd	QWORD PTR -24[rbp], xmm0
	mov	rax, QWORD PTR -32[rbp]
	movsd	xmm0, QWORD PTR .LC1[rip]
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	pow
	movapd	xmm6, xmm0
	mov	rax, QWORD PTR -24[rbp]
	movsd	xmm0, QWORD PTR .LC1[rip]
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	pow
	addsd	xmm6, xmm0
	movq	rax, xmm6
	movq	xmm0, rax
	call	sqrt
	movq	rax, xmm0
	mov	QWORD PTR -16[rbp], rax
	movsd	xmm0, QWORD PTR -32[rbp]
	mov	rax, QWORD PTR -24[rbp]
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	atan2
	movq	rax, xmm0
	mov	QWORD PTR -8[rbp], rax
	mov	rcx, QWORD PTR 80[rbp]
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
	mov	rax, QWORD PTR 80[rbp]
	movups	xmm6, XMMWORD PTR 0[rbp]
	movups	xmm7, XMMWORD PTR 16[rbp]
	movups	xmm8, XMMWORD PTR 32[rbp]
	add	rsp, 136
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC12:
	.ascii "[%2d] deg: %.2lf   %lf   %lf  y_target: %lf\12\0"
	.text
	.globl	CORDIC
	.def	CORDIC;	.scl	2;	.type	32;	.endef
	.seh_proc	CORDIC
CORDIC:
	push	rbp
	.seh_pushreg	rbp
	push	rsi
	.seh_pushreg	rsi
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 176
	.seh_stackalloc	176
	lea	rbp, 176[rsp]
	.seh_setframe	rbp, 176
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx
	mov	rbx, rdx
	mov	rax, QWORD PTR [rbx]
	mov	rdx, QWORD PTR 8[rbx]
	mov	QWORD PTR -112[rbp], rax
	mov	QWORD PTR -104[rbp], rdx
	mov	rbx, r8
	mov	rax, QWORD PTR [rbx]
	mov	rdx, QWORD PTR 8[rbx]
	mov	QWORD PTR -128[rbp], rax
	mov	QWORD PTR -120[rbp], rdx
	movsd	QWORD PTR 56[rbp], xmm3
	pxor	xmm0, xmm0
	movsd	QWORD PTR -8[rbp], xmm0
	mov	DWORD PTR -12[rbp], 0
	mov	rax, QWORD PTR -112[rbp]
	mov	edx, 62
	movq	xmm0, rax
	call	lf2fp
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -104[rbp]
	mov	edx, 62
	movq	xmm0, rax
	call	lf2fp
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -128[rbp]
	mov	edx, 62
	movq	xmm0, rax
	call	lf2fp
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -120[rbp]
	mov	edx, 62
	movq	xmm0, rax
	call	lf2fp
	mov	QWORD PTR -40[rbp], rax
	mov	QWORD PTR -64[rbp], 0
	mov	QWORD PTR -56[rbp], 0
	mov	DWORD PTR -16[rbp], 0
	jmp	.L18
.L24:
	cmp	DWORD PTR 64[rbp], 0
	jne	.L19
	movsd	xmm0, QWORD PTR 56[rbp]
	comisd	xmm0, QWORD PTR -8[rbp]
	setnb	al
	jmp	.L20
.L19:
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -40[rbp]
	cmp	rdx, rax
	setl	al
.L20:
	test	al, al
	je	.L21
	mov	r8, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	eax, DWORD PTR -16[rbp]
	mov	ecx, eax
	sar	rdx, cl
	mov	rax, r8
	sub	rax, rdx
	mov	QWORD PTR -64[rbp], rax
	mov	rdx, QWORD PTR -24[rbp]
	mov	r8, QWORD PTR -32[rbp]
	mov	eax, DWORD PTR -16[rbp]
	mov	ecx, eax
	sar	r8, cl
	mov	rax, r8
	add	rax, rdx
	mov	QWORD PTR -56[rbp], rax
	mov	eax, DWORD PTR -16[rbp]
	cdqe
	lea	rdx, 0[0+rax*8]
	lea	rax, _angles[rip]
	movsd	xmm0, QWORD PTR [rdx+rax]
	movsd	xmm1, QWORD PTR -8[rbp]
	addsd	xmm0, xmm1
	movsd	QWORD PTR -8[rbp], xmm0
	jmp	.L22
.L21:
	mov	rdx, QWORD PTR -32[rbp]
	mov	r8, QWORD PTR -24[rbp]
	mov	eax, DWORD PTR -16[rbp]
	mov	ecx, eax
	sar	r8, cl
	mov	rax, r8
	add	rax, rdx
	mov	QWORD PTR -64[rbp], rax
	mov	r8, QWORD PTR -24[rbp]
	mov	rdx, QWORD PTR -32[rbp]
	mov	eax, DWORD PTR -16[rbp]
	mov	ecx, eax
	sar	rdx, cl
	mov	rax, r8
	sub	rax, rdx
	mov	QWORD PTR -56[rbp], rax
	mov	eax, DWORD PTR -16[rbp]
	cdqe
	lea	rdx, 0[0+rax*8]
	lea	rax, _angles[rip]
	movsd	xmm1, QWORD PTR [rdx+rax]
	movsd	xmm0, QWORD PTR -8[rbp]
	subsd	xmm0, xmm1
	movsd	QWORD PTR -8[rbp], xmm0
.L22:
	mov	rax, QWORD PTR -64[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	edx, 62
	mov	rcx, rax
	call	fp2lf
	movq	rsi, xmm0
	mov	rax, QWORD PTR -24[rbp]
	mov	edx, 62
	mov	rcx, rax
	call	fp2lf
	movq	rbx, xmm0
	mov	rax, QWORD PTR -32[rbp]
	mov	edx, 62
	mov	rcx, rax
	call	fp2lf
	movapd	xmm2, xmm0
	movsd	xmm1, QWORD PTR -8[rbp]
	movsd	xmm0, QWORD PTR .LC5[rip]
	mulsd	xmm0, xmm1
	movapd	xmm1, xmm2
	movq	rcx, xmm2
	movapd	xmm2, xmm0
	movapd	xmm0, xmm2
	movq	rdx, xmm2
	mov	eax, DWORD PTR -16[rbp]
	mov	QWORD PTR 40[rsp], rsi
	mov	QWORD PTR 32[rsp], rbx
	movapd	xmm3, xmm1
	mov	r9, rcx
	movapd	xmm2, xmm0
	mov	r8, rdx
	mov	edx, eax
	lea	rax, .LC12[rip]
	mov	rcx, rax
	call	printf
	cmp	DWORD PTR -12[rbp], 0
	jle	.L23
	add	DWORD PTR -16[rbp], 1
	mov	DWORD PTR -12[rbp], 0
	jmp	.L18
.L23:
	add	DWORD PTR -12[rbp], 1
.L18:
	cmp	DWORD PTR -16[rbp], 15
	jle	.L24
	pxor	xmm0, xmm0
	movups	XMMWORD PTR -96[rbp], xmm0
	movups	XMMWORD PTR -80[rbp], xmm0
	mov	rax, QWORD PTR -32[rbp]
	mov	edx, 62
	mov	rcx, rax
	call	fp2lf
	movq	rax, xmm0
	mov	QWORD PTR -96[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	edx, 62
	mov	rcx, rax
	call	fp2lf
	movq	rax, xmm0
	mov	QWORD PTR -88[rbp], rax
	movsd	xmm0, QWORD PTR -8[rbp]
	movq	xmm1, QWORD PTR .LC13[rip]
	xorpd	xmm0, xmm1
	movsd	QWORD PTR -72[rbp], xmm0
	cmp	DWORD PTR 64[rbp], 1
	jne	.L25
	mov	rax, QWORD PTR -96[rbp]
	jmp	.L26
.L25:
	movsd	xmm1, QWORD PTR -96[rbp]
	movsd	xmm0, QWORD PTR -96[rbp]
	mulsd	xmm1, xmm0
	movsd	xmm2, QWORD PTR -88[rbp]
	movsd	xmm0, QWORD PTR -88[rbp]
	mulsd	xmm0, xmm2
	addsd	xmm1, xmm0
	movq	rax, xmm1
	movq	xmm0, rax
	call	sqrt
	movq	rax, xmm0
.L26:
	mov	QWORD PTR -80[rbp], rax
	mov	rcx, QWORD PTR 32[rbp]
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -88[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR -80[rbp]
	mov	rdx, QWORD PTR -72[rbp]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
	mov	rax, QWORD PTR 32[rbp]
	add	rsp, 176
	pop	rbx
	pop	rsi
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC0:
	.long	0
	.long	1071644672
	.align 8
.LC1:
	.long	0
	.long	1073741824
	.align 8
.LC3:
	.long	-396866390
	.long	1072412282
	.align 8
.LC4:
	.long	-1571644103
	.long	1066524486
	.align 8
.LC5:
	.long	442745336
	.long	1078765020
	.align 8
.LC9:
	.long	0
	.long	1079902208
	.align 8
.LC10:
	.long	0
	.long	1072693248
	.align 16
.LC13:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev1, Built by MSYS2 project) 14.2.0"
	.def	pow;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	cos;	.scl	2;	.type	32;	.endef
	.def	tan;	.scl	2;	.type	32;	.endef
	.def	sqrt;	.scl	2;	.type	32;	.endef
	.def	atan2;	.scl	2;	.type	32;	.endef
