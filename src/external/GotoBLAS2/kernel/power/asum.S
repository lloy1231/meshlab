/*********************************************************************/
/*                                                                   */
/*             Optimized BLAS libraries                              */
/*                     By Kazushige Goto <kgoto@tacc.utexas.edu>     */
/*                                                                   */
/* Copyright (c) The University of Texas, 2009. All rights reserved. */
/* UNIVERSITY EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES CONCERNING  */
/* THIS SOFTWARE AND DOCUMENTATION, INCLUDING ANY WARRANTIES OF      */
/* MERCHANTABILITY, FITNESS FOR ANY PARTICULAR PURPOSE,              */
/* NON-INFRINGEMENT AND WARRANTIES OF PERFORMANCE, AND ANY WARRANTY  */
/* THAT MIGHT OTHERWISE ARISE FROM COURSE OF DEALING OR USAGE OF     */
/* TRADE. NO WARRANTY IS EITHER EXPRESS OR IMPLIED WITH RESPECT TO   */
/* THE USE OF THE SOFTWARE OR DOCUMENTATION.                         */
/* Under no circumstances shall University be liable for incidental, */
/* special, indirect, direct or consequential damages or loss of     */
/* profits, interruption of business, or related expenses which may  */
/* arise from use of Software or Documentation, including but not    */
/* limited to those resulting from defects in Software and/or        */
/* Documentation, or loss or inaccuracy of data of any kind.         */
/*********************************************************************/

#define ASSEMBLER
#include "common.h"
	
#define N	r3
#define X	r4
#define INCX	r5	

#define PREA	r8

#define FZERO	f0

#define STACKSIZE 160

	PROLOGUE
	PROFCODE

	addi	SP, SP, -STACKSIZE
	li	r0,   0

	stfd	f14,    0(SP)
	stfd	f15,    8(SP)
	stfd	f16,   16(SP)
	stfd	f17,   24(SP)

	stfd	f18,   32(SP)
	stfd	f19,   40(SP)
	stfd	f20,   48(SP)
	stfd	f21,   56(SP)

	stfd	f22,   64(SP)
	stfd	f23,   72(SP)
	stfd	f24,   80(SP)
	stfd	f25,   88(SP)

	stfd	f26,   96(SP)
	stfd	f27,  104(SP)
	stfd	f28,  112(SP)
	stfd	f29,  120(SP)

	stfd	f30,  128(SP)
	stfd	f31,  136(SP)

	stw	r0,   144(SP)
	lfs	FZERO,144(SP)

#ifdef F_INTERFACE
	LDINT	N,    0(N)
	LDINT	INCX, 0(INCX)
#endif

	slwi	INCX, INCX, BASE_SHIFT

	fmr	f1,  FZERO
	fmr	f2,  FZERO
	fmr	f3,  FZERO
	fmr	f4,  FZERO
	fmr	f5,  FZERO
	fmr	f6,  FZERO
	fmr	f7,  FZERO

	li	PREA, L1_PREFETCHSIZE

	cmpwi	cr0, N, 0
	ble-	LL(999)

	cmpwi	cr0, INCX, 0
	ble-	LL(999)

	cmpwi	cr0, INCX, SIZE
	bne-	cr0, LL(100)

	srawi.	r0, N, 4
	mtspr	CTR, r0
	beq-	cr0, LL(50)
	.align 4

	LFD	f8,    0 * SIZE(X)
	LFD	f9,    1 * SIZE(X)
	LFD	f10,   2 * SIZE(X)
	LFD	f11,   3 * SIZE(X)
	LFD	f12,   4 * SIZE(X)
	LFD	f13,   5 * SIZE(X)
	LFD	f14,   6 * SIZE(X)
	LFD	f15,   7 * SIZE(X)

	LFD	f24,   8 * SIZE(X)
	LFD	f25,   9 * SIZE(X)
	LFD	f26,  10 * SIZE(X)
	LFD	f27,  11 * SIZE(X)
	LFD	f28,  12 * SIZE(X)
	LFD	f29,  13 * SIZE(X)
	LFD	f30,  14 * SIZE(X)
	LFD	f31,  15 * SIZE(X)

	fabs	f16, f8
	fabs	f17, f9
	fabs	f18, f10
	fabs	f19, f11

	fabs	f20, f12
	fabs	f21, f13
	fabs	f22, f14
	fabs	f23, f15
	bdz	LL(20)
	.align 4

LL(10):
	FADD	f0, f0, f16
	fabs	f16, f24
	FADD	f1, f1, f17
	fabs	f17, f25

	FADD	f2, f2, f18
	fabs	f18, f26
	FADD	f3, f3, f19
	fabs	f19, f27

	LFD	f8,   16 * SIZE(X)
	LFD	f9,   17 * SIZE(X)
	LFD	f10,  18 * SIZE(X)
	LFD	f11,  19 * SIZE(X)

	FADD	f4, f4, f20
	fabs	f20, f28
	FADD	f5, f5, f21
	fabs	f21, f29

	FADD	f6, f6, f22
	fabs	f22, f30
	FADD	f7, f7, f23
	fabs	f23, f31

	LFD	f12,  20 * SIZE(X)
	LFD	f13,  21 * SIZE(X)
	LFD	f14,  22 * SIZE(X)
	LFD	f15,  23 * SIZE(X)

	FADD	f0, f0, f16
	fabs	f16, f8
	FADD	f1, f1, f17
	fabs	f17, f9

	FADD	f2, f2, f18
	fabs	f18, f10
	FADD	f3, f3, f19
	fabs	f19, f11

	LFD	f24,  24 * SIZE(X)
	LFD	f25,  25 * SIZE(X)
	LFD	f26,  26 * SIZE(X)
	LFD	f27,  27 * SIZE(X)

	FADD	f4, f4, f20
	fabs	f20, f12
	FADD	f5, f5, f21
	fabs	f21, f13

	FADD	f6, f6, f22
	fabs	f22, f14
	FADD	f7, f7, f23
	fabs	f23, f15

	LFD	f28,  28 * SIZE(X)
	LFD	f29,  29 * SIZE(X)
	LFD	f30,  30 * SIZE(X)
	LFD	f31,  31 * SIZE(X)

#ifndef POWER6
	L1_PREFETCH	X, PREA
#endif
	addi	X, X, 16 * SIZE
#ifdef POWER6
	L1_PREFETCH	X, PREA
#endif

	bdnz	LL(10)
	.align 4

LL(20):
	FADD	f0, f0, f16
	fabs	f16, f24
	FADD	f1, f1, f17
	fabs	f17, f25

	FADD	f2, f2, f18
	fabs	f18, f26
	FADD	f3, f3, f19
	fabs	f19, f27

	FADD	f4, f4, f20
	fabs	f20, f28
	FADD	f5, f5, f21
	fabs	f21, f29

	FADD	f6, f6, f22
	fabs	f22, f30
	FADD	f7, f7, f23
	fabs	f23, f31

	FADD	f0, f0, f16
	FADD	f1, f1, f17
	FADD	f2, f2, f18
	FADD	f3, f3, f19

	FADD	f4, f4, f20
	FADD	f5, f5, f21
	FADD	f6, f6, f22
	FADD	f7, f7, f23
	addi	X, X, 16 * SIZE
	.align 4

LL(50):
	andi.	r0,  N, 15
	mtspr	CTR, r0
	beq	LL(999)
	.align 4

LL(60):
	LFD	f8,  0 * SIZE(X)
	addi	X, X,  1 * SIZE

	fabs	f8, f8
	FADD	f0, f0,  f8

	bdnz	LL(60)
	b	LL(999)
	.align 4

LL(100):
	sub	X, X, INCX

	srawi.	r0, N, 4
	mtspr	CTR,  r0
	beq-	LL(150)

	LFDUX	f8,    X, INCX
	LFDUX	f9,    X, INCX
	LFDUX	f10,   X, INCX
	LFDUX	f11,   X, INCX
	LFDUX	f12,   X, INCX
	LFDUX	f13,   X, INCX
	LFDUX	f14,   X, INCX
	LFDUX	f15,   X, INCX

	LFDUX	f24,   X, INCX
	LFDUX	f25,   X, INCX
	LFDUX	f26,   X, INCX
	LFDUX	f27,   X, INCX
	LFDUX	f28,   X, INCX
	LFDUX	f29,   X, INCX
	LFDUX	f30,   X, INCX
	LFDUX	f31,   X, INCX

	fabs	f16, f8
	fabs	f17, f9
	fabs	f18, f10
	fabs	f19, f11

	fabs	f20, f12
	fabs	f21, f13
	fabs	f22, f14
	fabs	f23, f15
	bdz	LL(120)
	.align 4

LL(110):
	FADD	f0, f0, f16
	fabs	f16, f24
	FADD	f1, f1, f17
	fabs	f17, f25

	FADD	f2, f2, f18
	fabs	f18, f26
	FADD	f3, f3, f19
	fabs	f19, f27

	LFDUX	f8,    X, INCX
	LFDUX	f9,    X, INCX
	LFDUX	f10,   X, INCX
	LFDUX	f11,   X, INCX

	FADD	f4, f4, f20
	fabs	f20, f28
	FADD	f5, f5, f21
	fabs	f21, f29

	FADD	f6, f6, f22
	fabs	f22, f30
	FADD	f7, f7, f23
	fabs	f23, f31

	LFDUX	f12,   X, INCX
	LFDUX	f13,   X, INCX
	LFDUX	f14,   X, INCX
	LFDUX	f15,   X, INCX

	FADD	f0, f0, f16
	fabs	f16, f8
	FADD	f1, f1, f17
	fabs	f17, f9

	FADD	f2, f2, f18
	fabs	f18, f10
	FADD	f3, f3, f19
	fabs	f19, f11

	LFDUX	f24,   X, INCX
	LFDUX	f25,   X, INCX
	LFDUX	f26,   X, INCX
	LFDUX	f27,   X, INCX

	FADD	f4, f4, f20
	fabs	f20, f12
	FADD	f5, f5, f21
	fabs	f21, f13

	FADD	f6, f6, f22
	fabs	f22, f14
	FADD	f7, f7, f23
	fabs	f23, f15

	LFDUX	f28,   X, INCX
	LFDUX	f29,   X, INCX
	LFDUX	f30,   X, INCX
	LFDUX	f31,   X, INCX
	bdnz	LL(110)
	.align 4

LL(120):
	FADD	f0, f0, f16
	fabs	f16, f24
	FADD	f1, f1, f17
	fabs	f17, f25

	FADD	f2, f2, f18
	fabs	f18, f26
	FADD	f3, f3, f19
	fabs	f19, f27

	FADD	f4, f4, f20
	fabs	f20, f28
	FADD	f5, f5, f21
	fabs	f21, f29

	FADD	f6, f6, f22
	fabs	f22, f30
	FADD	f7, f7, f23
	fabs	f23, f31

	FADD	f0, f0, f16
	FADD	f1, f1, f17
	FADD	f2, f2, f18
	FADD	f3, f3, f19

	FADD	f4, f4, f20
	FADD	f5, f5, f21
	FADD	f6, f6, f22
	FADD	f7, f7, f23
	.align 4

LL(150):
	andi.	r0,  N, 15
	mtspr	CTR, r0
	beq	LL(999)
	.align 4

LL(160):
	LFDUX	f8,    X, INCX
	fabs	f8, f8
	FADD	f0,  f0, f8
	bdnz	LL(160)
	.align 4

LL(999):
	FADD	f0,  f0,  f1
	FADD	f2,  f2,  f3
	FADD	f4,  f4,  f5
	FADD	f6,  f6,  f7

	FADD	f0,  f0,  f2
	FADD	f4,  f4,  f6
	FADD	f1,  f0,  f4

	lfd	f14,    0(SP)
	lfd	f15,    8(SP)
	lfd	f16,   16(SP)
	lfd	f17,   24(SP)

	lfd	f18,   32(SP)
	lfd	f19,   40(SP)
	lfd	f20,   48(SP)
	lfd	f21,   56(SP)

	lfd	f22,   64(SP)
	lfd	f23,   72(SP)
	lfd	f24,   80(SP)
	lfd	f25,   88(SP)

	lfd	f26,   96(SP)
	lfd	f27,  104(SP)
	lfd	f28,  112(SP)
	lfd	f29,  120(SP)

	lfd	f30,  128(SP)
	lfd	f31,  136(SP)

	addi	SP, SP, STACKSIZE
	blr

	EPILOGUE
