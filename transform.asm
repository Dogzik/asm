			global		fdct
			global		idct
			section		.text

fdct:
			movaps		[rsp + 8], xmm6
			movaps		[rsp + 8 + 16], xmm7
			sub			rsp, 8
			push		rbx
			push		rbp
			push		rsi
			push		rdi
			push		r12
			push		r13
			push		r14
			push		r15
			sub			rsp, 16 * 8
			movaps		[rsp + 16 * 0], xmm8
			movaps		[rsp + 16 * 1], xmm9
			movaps		[rsp + 16 * 2], xmm10
			movaps		[rsp + 16 * 3], xmm11
			movaps		[rsp + 16 * 4], xmm12
			movaps		[rsp + 16 * 5], xmm13
			movaps		[rsp + 16 * 6], xmm14
			movaps		[rsp + 16 * 7], xmm15

			xor			rax, rax
			movaps		xmm8, [rel cos2]
			movaps		xmm9, [rel cos4]
			movaps		xmm10, [rel	cos8]
			movaps		xmm11, [rel cos16]
			movaps		xmm12, [rel div256]
row_loop:
			movaps		xmm0, [rcx + rax]
			movaps		xmm1, [rcx + rax + 16]
			movaps		xmm2, [rcx + rax + 32]
			movaps		xmm3, [rcx + rax + 48]
			call		fdct16
			mulps		xmm0, xmm12
			mulps		xmm1, xmm12
			mulps		xmm2, xmm12
			mulps		xmm3, xmm12
			movaps		[rdx + rax], xmm0	
			movaps		[rdx + rax + 16], xmm1
			movaps		[rdx + rax + 32], xmm2
			movaps		[rdx + rax + 48], xmm3
			add			rax, 4 * 16
			cmp			rax, 4 * 16 * 16
			jb			row_loop

			xor			rax, rax
colum_loop:
			movaps		xmm12, [rdx + rax]
			movaps		xmm13, [rdx + rax + 16 * 4 * 1]
			movaps		xmm14, [rdx + rax + 16 * 4 * 2]
			movaps		xmm15, [rdx + rax + 16 * 4 * 3]

			mov			rsi, [rdx + rax + 16 * 4 * 4]
			mov			rdi, [rdx + rax + 16 * 4 * 5]
			mov			rbx, [rdx + rax + 16 * 4 * 6]
			mov			rcx, [rdx + rax + 16 * 4 * 7]

			mov			r8, [rdx + rax + 16 * 4 * 8]
			mov			r9, [rdx + rax + 16 * 4 * 9]
			mov			r10, [rdx + rax + 16 * 4 * 10]
			mov			r11, [rdx + rax + 16 * 4 * 11]

			mov			r12, [rdx + rax + 16 * 4 * 12]
			mov			r13, [rdx + rax + 16 * 4 * 13]
			mov			r14, [rdx + rax + 16 * 4 * 14]
			mov			r15, [rdx + rax + 16 * 4 * 15]


			insertps	xmm0, xmm12, 00000000b
			insertps	xmm0, xmm13, 00010000b
			insertps	xmm0, xmm14, 00100000b
			insertps	xmm0, xmm15, 00110000b

			pinsrd		xmm1, esi, 00000000b
			pinsrd		xmm1, edi, 00000001b
			pinsrd		xmm1, ebx, 00000010b
			pinsrd		xmm1, ecx, 00000011b

			pinsrd		xmm2, r8d, 00000000b
			pinsrd		xmm2, r9d, 00000001b
			pinsrd		xmm2, r10d, 00000010b
			pinsrd		xmm2, r11d, 00000011b

			pinsrd		xmm3, r12d, 00000000b
			pinsrd		xmm3, r13d, 00000001b
			pinsrd		xmm3, r14d, 00000010b
			pinsrd		xmm3, r15d, 00000011b

			call		fdct16

			insertps	xmm12, xmm0, 00000000b 
			insertps	xmm13, xmm0, 01000000b
			insertps	xmm14, xmm0, 10000000b
			insertps	xmm15, xmm0, 11000000b
			insertps	xmm0, xmm12, 01000000b
			insertps	xmm0, xmm13, 01010000b
			insertps	xmm0, xmm14, 01100000b
			insertps	xmm0, xmm15, 01110000b
				
			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			pinsrd		xmm1, ebp, 00000000b
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			pinsrd		xmm1, ebp, 00000001b
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			pinsrd		xmm1, ebp, 00000010b
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			pinsrd		xmm1, ebp, 00000011b

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			pinsrd		xmm2, ebp, 00000000b
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			pinsrd		xmm2, ebp, 00000001b
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			pinsrd		xmm2, ebp, 00000010b
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			pinsrd		xmm2, ebp, 00000011b

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			pinsrd		xmm3, ebp, 00000000b
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			pinsrd		xmm3, ebp, 00000001b
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			pinsrd		xmm3, ebp, 00000010b
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			pinsrd		xmm3, ebp, 00000011b

			call		fdct16

			insertps	xmm12, xmm0, 00010000b 
			insertps	xmm13, xmm0, 01010000b
			insertps	xmm14, xmm0, 10010000b
			insertps	xmm15, xmm0, 11010000b

			insertps	xmm0, xmm12, 10000000b
			insertps	xmm0, xmm13, 10010000b
			insertps	xmm0, xmm14, 10100000b
			insertps	xmm0, xmm15, 10110000b

			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			xor			rsi, rbp
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			xor			rdi, rbp
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			xor			rbx, rbp
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			xor			rcx, rbp

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			xor			r8, rbp
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			xor			r9, rbp
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			xor			r10, rbp
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			xor			r11, rbp

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			xor			r12, rbp
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			xor			r13, rbp
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			xor			r14, rbp
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			xor			r15, rbp

			mov			[rdx + rax + 16 * 4 * 4], rsi
			mov			[rdx + rax + 16 * 4 * 5], rdi
			mov			[rdx + rax + 16 * 4 * 6], rbx
			mov			[rdx + rax + 16 * 4 * 7], rcx

			mov			[rdx + rax + 16 * 4 * 8], r8
			mov			[rdx + rax + 16 * 4 * 9], r9
			mov			[rdx + rax + 16 * 4 * 10], r10
			mov			[rdx + rax + 16 * 4 * 11], r11

			mov			[rdx + rax + 16 * 4 * 12], r12
			mov			[rdx + rax + 16 * 4 * 13], r13
			mov			[rdx + rax + 16 * 4 * 14], r14
			mov			[rdx + rax + 16 * 4 * 15], r15

			add			rax, 8

			mov			rsi, [rdx + rax + 16 * 4 * 4]
			mov			rdi, [rdx + rax + 16 * 4 * 5]
			mov			rbx, [rdx + rax + 16 * 4 * 6]
			mov			rcx, [rdx + rax + 16 * 4 * 7]

			mov			r8, [rdx + rax + 16 * 4 * 8]
			mov			r9, [rdx + rax + 16 * 4 * 9]
			mov			r10, [rdx + rax + 16 * 4 * 10]
			mov			r11, [rdx + rax + 16 * 4 * 11]

			mov			r12, [rdx + rax + 16 * 4 * 12]
			mov			r13, [rdx + rax + 16 * 4 * 13]
			mov			r14, [rdx + rax + 16 * 4 * 14]
			mov			r15, [rdx + rax + 16 * 4 * 15]

			
			pinsrd		xmm1, esi, 00000000b
			pinsrd		xmm1, edi, 00000001b
			pinsrd		xmm1, ebx, 00000010b
			pinsrd		xmm1, ecx, 00000011b

			pinsrd		xmm2, r8d, 00000000b
			pinsrd		xmm2, r9d, 00000001b
			pinsrd		xmm2, r10d, 00000010b
			pinsrd		xmm2, r11d, 00000011b

			pinsrd		xmm3, r12d, 00000000b
			pinsrd		xmm3, r13d, 00000001b
			pinsrd		xmm3, r14d, 00000010b
			pinsrd		xmm3, r15d, 00000011b

			call		fdct16

			insertps	xmm12, xmm0, 00100000b 
			insertps	xmm13, xmm0, 01100000b
			insertps	xmm14, xmm0, 10100000b
			insertps	xmm15, xmm0, 11100000b

			insertps	xmm0, xmm12, 11000000b
			insertps	xmm0, xmm13, 11010000b
			insertps	xmm0, xmm14, 11100000b
			insertps	xmm0, xmm15, 11110000b

			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			pinsrd		xmm1, ebp, 00000000b
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			pinsrd		xmm1, ebp, 00000001b
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			pinsrd		xmm1, ebp, 00000010b
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			pinsrd		xmm1, ebp, 00000011b

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			pinsrd		xmm2, ebp, 00000000b
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			pinsrd		xmm2, ebp, 00000001b
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			pinsrd		xmm2, ebp, 00000010b
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			pinsrd		xmm2, ebp, 00000011b

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			pinsrd		xmm3, ebp, 00000000b
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			pinsrd		xmm3, ebp, 00000001b
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			pinsrd		xmm3, ebp, 00000010b
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			pinsrd		xmm3, ebp, 00000011b

			call		fdct16

			insertps	xmm12, xmm0, 00110000b 
			insertps	xmm13, xmm0, 01110000b
			insertps	xmm14, xmm0, 10110000b
			insertps	xmm15, xmm0, 11110000b

			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			xor			rsi, rbp
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			xor			rdi, rbp
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			xor			rbx, rbp
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			xor			rcx, rbp

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			xor			r8, rbp
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			xor			r9, rbp
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			xor			r10, rbp
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			xor			r11, rbp

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			xor			r12, rbp
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			xor			r13, rbp
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			xor			r14, rbp
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			xor			r15, rbp

			movaps		[rdx + rax - 8], xmm12
			movaps		[rdx + rax + 16 * 4 * 1 - 8], xmm13
			movaps		[rdx + rax + 16 * 4 * 2 - 8], xmm14
			movaps		[rdx + rax + 16 * 4 * 3 - 8], xmm15

			mov			[rdx + rax + 16 * 4 * 4], rsi
			mov			[rdx + rax + 16 * 4 * 5], rdi
			mov			[rdx + rax + 16 * 4 * 6], rbx
			mov			[rdx + rax + 16 * 4 * 7], rcx

			mov			[rdx + rax + 16 * 4 * 8], r8
			mov			[rdx + rax + 16 * 4 * 9], r9
			mov			[rdx + rax + 16 * 4 * 10], r10
			mov			[rdx + rax + 16 * 4 * 11], r11

			mov			[rdx + rax + 16 * 4 * 12], r12
			mov			[rdx + rax + 16 * 4 * 13], r13
			mov			[rdx + rax + 16 * 4 * 14], r14
			mov			[rdx + rax + 16 * 4 * 15], r15

			add			rax, 8
			cmp			rax, 4 * 16
			jb			colum_loop


			movaps		xmm8, [rsp + 16 * 0]
			movaps		xmm9, [rsp + 16 * 1]
			movaps		xmm10, [rsp + 16 * 2]
			movaps		xmm11, [rsp + 16 * 3]
			movaps		xmm12, [rsp + 16 * 4]
			movaps		xmm13, [rsp + 16 * 5]
			movaps		xmm14, [rsp + 16 * 6]
			movaps		xmm15, [rsp + 16 * 7]
			add			rsp, 16 * 8
			pop			r15
			pop			r14
			pop			r13
			pop			r12
			pop			rdi
			pop			rsi
			pop			rbp
			pop			rbx
			add			rsp, 8
			movaps		xmm6, [rsp + 8]
			movaps		xmm7, [rsp + 8 + 16]

			ret


fdct16:
			movaps		xmm4, xmm0
			movaps		xmm6, xmm0	
			movaps		xmm5, xmm1
			movaps		xmm7, xmm1
			shufps		xmm2, xmm2, 00011011b
			shufps		xmm3, xmm3, 00011011b

			addps		xmm4, xmm3
			addps		xmm5, xmm2
			subps		xmm6, xmm3
			subps		xmm7, xmm2			
			mulps		xmm6, xmm11
			mulps		xmm7, [rel cos16 + 16]

			jmp			fdct8_1
fdct16_end:
			movaps		xmm2, xmm7
			movaps		xmm3, xmm6

			palignr		xmm2, xmm3, 4
			movaps		xmm3, xmm7
			psrldq		xmm3, 4

			addps		xmm6, xmm2
			addps		xmm7, xmm3

			movaps		xmm0, xmm4
			movaps		xmm1, xmm4
			movaps		xmm2, xmm5
			movaps		xmm3, xmm5

			punpckldq	xmm0, xmm6
			punpckhdq	xmm1, xmm6
			punpckldq	xmm2, xmm7
			punpckhdq	xmm3, xmm7

			ret

fdct8_1:
			movaps		xmm0, xmm4
			movaps		xmm1, xmm4
			shufps		xmm5, xmm5, 00011011b

			addps		xmm0, xmm5
			subps		xmm1, xmm5
			mulps		xmm1, xmm10

			jmp			fdct4_1
fdct8_1_end:
			movaps		xmm5, xmm1
			psrldq		xmm5, 4
			addps		xmm1, xmm5

			movaps		xmm4, xmm0
			movaps		xmm5, xmm0

			punpckldq	xmm4, xmm1
			punpckhdq	xmm5, xmm1

			jmp			fdct8_2

fdct4_1:
			pshufd		xmm4, xmm0, 01010000b
			shufps		xmm0, xmm0, 10101111b
			addsubps	xmm4, xmm0
			shufps		xmm4, xmm4, 10001101b
			mulps		xmm4, xmm9

			movaps		xmm0, xmm4
			mulps		xmm0, xmm8
			haddps		xmm4, xmm0
			insertps	xmm0, xmm4, 11011101b
			addps		xmm0, xmm4


			pshufd		xmm5, xmm1, 01010000b
			shufps		xmm1, xmm1, 10101111b
			addsubps	xmm5, xmm1
			shufps		xmm5, xmm5, 10001101b
			mulps		xmm5, xmm9

			movaps		xmm1, xmm5
			mulps		xmm1, xmm8
			haddps		xmm5, xmm1
			insertps	xmm1, xmm5, 11011101b
			addps		xmm1, xmm5
			
			jmp			fdct8_1_end
			
fdct8_2:
			movaps		xmm2, xmm6
			movaps		xmm3, xmm6
			shufps		xmm7, xmm7, 00011011b

			addps		xmm2, xmm7
			subps		xmm3, xmm7
			mulps		xmm3, xmm10

			jmp			fdct4_2
fdct8_2_end:
			movaps		xmm7, xmm3
			psrldq		xmm7, 4
			addps		xmm3, xmm7

			movaps		xmm6, xmm2
			movaps		xmm7, xmm2

			punpckldq	xmm6, xmm3
			punpckhdq	xmm7, xmm3

			jmp			fdct16_end

fdct4_2:
			pshufd		xmm6, xmm2, 01010000b
			shufps		xmm2, xmm2, 10101111b
			addsubps	xmm6, xmm2
			shufps		xmm6, xmm6, 10001101b
			mulps		xmm6, xmm9

			movaps		xmm2, xmm6
			mulps		xmm2, xmm8
			haddps		xmm6, xmm2
			insertps	xmm2, xmm6, 11011101b			
			addps		xmm2, xmm6


			pshufd		xmm7, xmm3, 01010000b
			shufps		xmm3, xmm3, 10101111b
			addsubps	xmm7, xmm3
			shufps		xmm7, xmm7, 10001101b
			mulps		xmm7, xmm9

			movaps		xmm3, xmm7
			mulps		xmm3, xmm8
			haddps		xmm7, xmm3
			insertps	xmm3, xmm7, 11011101b
			addps		xmm3, xmm7
			
			jmp			fdct8_2_end


idct:
			movaps		[rsp + 8], xmm6
			movaps		[rsp + 8 + 16], xmm7
			sub			rsp, 8
			push		rbx
			push		rbp
			push		rsi
			push		rdi
			push		r12
			push		r13
			push		r14
			push		r15
			sub			rsp, 16 * 8
			movaps		[rsp + 16 * 0], xmm8
			movaps		[rsp + 16 * 1], xmm9
			movaps		[rsp + 16 * 2], xmm10
			movaps		[rsp + 16 * 3], xmm11
			movaps		[rsp + 16 * 4], xmm12
			movaps		[rsp + 16 * 5], xmm13
			movaps		[rsp + 16 * 6], xmm14
			movaps		[rsp + 16 * 7], xmm15

			jmp			copy_to_dst
idct_mark:

			
			movaps		xmm8, [rel cos2]
			movaps		xmm9, [rel icos4]
			movaps		xmm10, [rel cos8]
			movaps		xmm11, [rel cos16]

			xor			rax, rax
			;first iter goes here
			movaps		xmm12, [rdx + rax]
			movaps		xmm13, [rdx + rax + 16 * 4 * 1]
			movaps		xmm14, [rdx + rax + 16 * 4 * 2]
			movaps		xmm15, [rdx + rax + 16 * 4 * 3]
			mov			rsi, [rdx + rax + 16 * 4 * 4]
			mov			rdi, [rdx + rax + 16 * 4 * 5]
			mov			rbx, [rdx + rax + 16 * 4 * 6]
			mov			rcx, [rdx + rax + 16 * 4 * 7]
			mov			r8, [rdx + rax + 16 * 4 * 8]
			mov			r9, [rdx + rax + 16 * 4 * 9]
			mov			r10, [rdx + rax + 16 * 4 * 10]
			mov			r11, [rdx + rax + 16 * 4 * 11]
			mov			r12, [rdx + rax + 16 * 4 * 12]
			mov			r13, [rdx + rax + 16 * 4 * 13]
			mov			r14, [rdx + rax + 16 * 4 * 14]
			mov			r15, [rdx + rax + 16 * 4 * 15]
			insertps	xmm0, xmm12, 00000000b
			insertps	xmm0, xmm13, 00010000b
			insertps	xmm0, xmm14, 00100000b
			insertps	xmm0, xmm15, 00110000b
			pinsrd		xmm1, esi, 00000000b
			pinsrd		xmm1, edi, 00000001b
			pinsrd		xmm1, ebx, 00000010b
			pinsrd		xmm1, ecx, 00000011b
			pinsrd		xmm2, r8d, 00000000b
			pinsrd		xmm2, r9d, 00000001b
			pinsrd		xmm2, r10d, 00000010b
			pinsrd		xmm2, r11d, 00000011b
			pinsrd		xmm3, r12d, 00000000b
			pinsrd		xmm3, r13d, 00000001b
			pinsrd		xmm3, r14d, 00000010b
			pinsrd		xmm3, r15d, 00000011b

			call	idct16

			movaps		xmm6, [rel div2]
			mulps		xmm0, xmm6
			mulps		xmm1, xmm6
			mulps		xmm2, xmm6
			mulps		xmm3, xmm6
			
			insertps	xmm12, xmm0, 00000000b 
			insertps	xmm13, xmm0, 01000000b
			insertps	xmm14, xmm0, 10000000b
			insertps	xmm15, xmm0, 11000000b
			insertps	xmm0, xmm12, 01000000b
			insertps	xmm0, xmm13, 01010000b
			insertps	xmm0, xmm14, 01100000b
			insertps	xmm0, xmm15, 01110000b
				
			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			pinsrd		xmm1, ebp, 00000000b
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			pinsrd		xmm1, ebp, 00000001b
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			pinsrd		xmm1, ebp, 00000010b
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			pinsrd		xmm1, ebp, 00000011b

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			pinsrd		xmm2, ebp, 00000000b
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			pinsrd		xmm2, ebp, 00000001b
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			pinsrd		xmm2, ebp, 00000010b
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			pinsrd		xmm2, ebp, 00000011b

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			pinsrd		xmm3, ebp, 00000000b
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			pinsrd		xmm3, ebp, 00000001b
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			pinsrd		xmm3, ebp, 00000010b
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			pinsrd		xmm3, ebp, 00000011b

			call		idct16

			insertps	xmm12, xmm0, 00010000b 
			insertps	xmm13, xmm0, 01010000b
			insertps	xmm14, xmm0, 10010000b
			insertps	xmm15, xmm0, 11010000b

			insertps	xmm0, xmm12, 10000000b
			insertps	xmm0, xmm13, 10010000b
			insertps	xmm0, xmm14, 10100000b
			insertps	xmm0, xmm15, 10110000b

			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			xor			rsi, rbp
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			xor			rdi, rbp
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			xor			rbx, rbp
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			xor			rcx, rbp

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			xor			r8, rbp
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			xor			r9, rbp
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			xor			r10, rbp
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			xor			r11, rbp

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			xor			r12, rbp
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			xor			r13, rbp
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			xor			r14, rbp
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			xor			r15, rbp

			mov			[rdx + rax + 16 * 4 * 4], rsi
			mov			[rdx + rax + 16 * 4 * 5], rdi
			mov			[rdx + rax + 16 * 4 * 6], rbx
			mov			[rdx + rax + 16 * 4 * 7], rcx

			mov			[rdx + rax + 16 * 4 * 8], r8
			mov			[rdx + rax + 16 * 4 * 9], r9
			mov			[rdx + rax + 16 * 4 * 10], r10
			mov			[rdx + rax + 16 * 4 * 11], r11

			mov			[rdx + rax + 16 * 4 * 12], r12
			mov			[rdx + rax + 16 * 4 * 13], r13
			mov			[rdx + rax + 16 * 4 * 14], r14
			mov			[rdx + rax + 16 * 4 * 15], r15

			add			rax, 8

			mov			rsi, [rdx + rax + 16 * 4 * 4]
			mov			rdi, [rdx + rax + 16 * 4 * 5]
			mov			rbx, [rdx + rax + 16 * 4 * 6]
			mov			rcx, [rdx + rax + 16 * 4 * 7]

			mov			r8, [rdx + rax + 16 * 4 * 8]
			mov			r9, [rdx + rax + 16 * 4 * 9]
			mov			r10, [rdx + rax + 16 * 4 * 10]
			mov			r11, [rdx + rax + 16 * 4 * 11]

			mov			r12, [rdx + rax + 16 * 4 * 12]
			mov			r13, [rdx + rax + 16 * 4 * 13]
			mov			r14, [rdx + rax + 16 * 4 * 14]
			mov			r15, [rdx + rax + 16 * 4 * 15]

			
			pinsrd		xmm1, esi, 00000000b
			pinsrd		xmm1, edi, 00000001b
			pinsrd		xmm1, ebx, 00000010b
			pinsrd		xmm1, ecx, 00000011b

			pinsrd		xmm2, r8d, 00000000b
			pinsrd		xmm2, r9d, 00000001b
			pinsrd		xmm2, r10d, 00000010b
			pinsrd		xmm2, r11d, 00000011b

			pinsrd		xmm3, r12d, 00000000b
			pinsrd		xmm3, r13d, 00000001b
			pinsrd		xmm3, r14d, 00000010b
			pinsrd		xmm3, r15d, 00000011b

			call		idct16

			insertps	xmm12, xmm0, 00100000b 
			insertps	xmm13, xmm0, 01100000b
			insertps	xmm14, xmm0, 10100000b
			insertps	xmm15, xmm0, 11100000b

			insertps	xmm0, xmm12, 11000000b
			insertps	xmm0, xmm13, 11010000b
			insertps	xmm0, xmm14, 11100000b
			insertps	xmm0, xmm15, 11110000b

			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			pinsrd		xmm1, ebp, 00000000b
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			pinsrd		xmm1, ebp, 00000001b
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			pinsrd		xmm1, ebp, 00000010b
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			pinsrd		xmm1, ebp, 00000011b

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			pinsrd		xmm2, ebp, 00000000b
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			pinsrd		xmm2, ebp, 00000001b
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			pinsrd		xmm2, ebp, 00000010b
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			pinsrd		xmm2, ebp, 00000011b

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			pinsrd		xmm3, ebp, 00000000b
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			pinsrd		xmm3, ebp, 00000001b
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			pinsrd		xmm3, ebp, 00000010b
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			pinsrd		xmm3, ebp, 00000011b

			call		idct16

			insertps	xmm12, xmm0, 00110000b 
			insertps	xmm13, xmm0, 01110000b
			insertps	xmm14, xmm0, 10110000b
			insertps	xmm15, xmm0, 11110000b

			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			xor			rsi, rbp
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			xor			rdi, rbp
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			xor			rbx, rbp
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			xor			rcx, rbp

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			xor			r8, rbp
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			xor			r9, rbp
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			xor			r10, rbp
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			xor			r11, rbp

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			xor			r12, rbp
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			xor			r13, rbp
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			xor			r14, rbp
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			xor			r15, rbp

			movaps		[rdx + rax - 8], xmm12
			movaps		[rdx + rax + 16 * 4 * 1 - 8], xmm13
			movaps		[rdx + rax + 16 * 4 * 2 - 8], xmm14
			movaps		[rdx + rax + 16 * 4 * 3 - 8], xmm15

			mov			[rdx + rax + 16 * 4 * 4], rsi
			mov			[rdx + rax + 16 * 4 * 5], rdi
			mov			[rdx + rax + 16 * 4 * 6], rbx
			mov			[rdx + rax + 16 * 4 * 7], rcx

			mov			[rdx + rax + 16 * 4 * 8], r8
			mov			[rdx + rax + 16 * 4 * 9], r9
			mov			[rdx + rax + 16 * 4 * 10], r10
			mov			[rdx + rax + 16 * 4 * 11], r11

			mov			[rdx + rax + 16 * 4 * 12], r12
			mov			[rdx + rax + 16 * 4 * 13], r13
			mov			[rdx + rax + 16 * 4 * 14], r14
			mov			[rdx + rax + 16 * 4 * 15], r15

			add			rax, 8

idct_colum:
			movaps		xmm12, [rdx + rax]
			movaps		xmm13, [rdx + rax + 16 * 4 * 1]
			movaps		xmm14, [rdx + rax + 16 * 4 * 2]
			movaps		xmm15, [rdx + rax + 16 * 4 * 3]

			mov			rsi, [rdx + rax + 16 * 4 * 4]
			mov			rdi, [rdx + rax + 16 * 4 * 5]
			mov			rbx, [rdx + rax + 16 * 4 * 6]
			mov			rcx, [rdx + rax + 16 * 4 * 7]

			mov			r8, [rdx + rax + 16 * 4 * 8]
			mov			r9, [rdx + rax + 16 * 4 * 9]
			mov			r10, [rdx + rax + 16 * 4 * 10]
			mov			r11, [rdx + rax + 16 * 4 * 11]

			mov			r12, [rdx + rax + 16 * 4 * 12]
			mov			r13, [rdx + rax + 16 * 4 * 13]
			mov			r14, [rdx + rax + 16 * 4 * 14]
			mov			r15, [rdx + rax + 16 * 4 * 15]


			insertps	xmm0, xmm12, 00000000b
			insertps	xmm0, xmm13, 00010000b
			insertps	xmm0, xmm14, 00100000b
			insertps	xmm0, xmm15, 00110000b

			pinsrd		xmm1, esi, 00000000b
			pinsrd		xmm1, edi, 00000001b
			pinsrd		xmm1, ebx, 00000010b
			pinsrd		xmm1, ecx, 00000011b

			pinsrd		xmm2, r8d, 00000000b
			pinsrd		xmm2, r9d, 00000001b
			pinsrd		xmm2, r10d, 00000010b
			pinsrd		xmm2, r11d, 00000011b

			pinsrd		xmm3, r12d, 00000000b
			pinsrd		xmm3, r13d, 00000001b
			pinsrd		xmm3, r14d, 00000010b
			pinsrd		xmm3, r15d, 00000011b

			call		idct16

			insertps	xmm12, xmm0, 00000000b 
			insertps	xmm13, xmm0, 01000000b
			insertps	xmm14, xmm0, 10000000b
			insertps	xmm15, xmm0, 11000000b
			insertps	xmm0, xmm12, 01000000b
			insertps	xmm0, xmm13, 01010000b
			insertps	xmm0, xmm14, 01100000b
			insertps	xmm0, xmm15, 01110000b
				
			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			pinsrd		xmm1, ebp, 00000000b
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			pinsrd		xmm1, ebp, 00000001b
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			pinsrd		xmm1, ebp, 00000010b
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			pinsrd		xmm1, ebp, 00000011b

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			pinsrd		xmm2, ebp, 00000000b
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			pinsrd		xmm2, ebp, 00000001b
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			pinsrd		xmm2, ebp, 00000010b
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			pinsrd		xmm2, ebp, 00000011b

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			pinsrd		xmm3, ebp, 00000000b
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			pinsrd		xmm3, ebp, 00000001b
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			pinsrd		xmm3, ebp, 00000010b
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			pinsrd		xmm3, ebp, 00000011b

			call		idct16

			insertps	xmm12, xmm0, 00010000b 
			insertps	xmm13, xmm0, 01010000b
			insertps	xmm14, xmm0, 10010000b
			insertps	xmm15, xmm0, 11010000b

			insertps	xmm0, xmm12, 10000000b
			insertps	xmm0, xmm13, 10010000b
			insertps	xmm0, xmm14, 10100000b
			insertps	xmm0, xmm15, 10110000b

			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			xor			rsi, rbp
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			xor			rdi, rbp
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			xor			rbx, rbp
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			xor			rcx, rbp

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			xor			r8, rbp
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			xor			r9, rbp
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			xor			r10, rbp
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			xor			r11, rbp

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			xor			r12, rbp
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			xor			r13, rbp
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			xor			r14, rbp
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			xor			r15, rbp

			mov			[rdx + rax + 16 * 4 * 4], rsi
			mov			[rdx + rax + 16 * 4 * 5], rdi
			mov			[rdx + rax + 16 * 4 * 6], rbx
			mov			[rdx + rax + 16 * 4 * 7], rcx

			mov			[rdx + rax + 16 * 4 * 8], r8
			mov			[rdx + rax + 16 * 4 * 9], r9
			mov			[rdx + rax + 16 * 4 * 10], r10
			mov			[rdx + rax + 16 * 4 * 11], r11

			mov			[rdx + rax + 16 * 4 * 12], r12
			mov			[rdx + rax + 16 * 4 * 13], r13
			mov			[rdx + rax + 16 * 4 * 14], r14
			mov			[rdx + rax + 16 * 4 * 15], r15

			add			rax, 8

			mov			rsi, [rdx + rax + 16 * 4 * 4]
			mov			rdi, [rdx + rax + 16 * 4 * 5]
			mov			rbx, [rdx + rax + 16 * 4 * 6]
			mov			rcx, [rdx + rax + 16 * 4 * 7]

			mov			r8, [rdx + rax + 16 * 4 * 8]
			mov			r9, [rdx + rax + 16 * 4 * 9]
			mov			r10, [rdx + rax + 16 * 4 * 10]
			mov			r11, [rdx + rax + 16 * 4 * 11]

			mov			r12, [rdx + rax + 16 * 4 * 12]
			mov			r13, [rdx + rax + 16 * 4 * 13]
			mov			r14, [rdx + rax + 16 * 4 * 14]
			mov			r15, [rdx + rax + 16 * 4 * 15]

			
			pinsrd		xmm1, esi, 00000000b
			pinsrd		xmm1, edi, 00000001b
			pinsrd		xmm1, ebx, 00000010b
			pinsrd		xmm1, ecx, 00000011b

			pinsrd		xmm2, r8d, 00000000b
			pinsrd		xmm2, r9d, 00000001b
			pinsrd		xmm2, r10d, 00000010b
			pinsrd		xmm2, r11d, 00000011b

			pinsrd		xmm3, r12d, 00000000b
			pinsrd		xmm3, r13d, 00000001b
			pinsrd		xmm3, r14d, 00000010b
			pinsrd		xmm3, r15d, 00000011b

			call		idct16

			insertps	xmm12, xmm0, 00100000b 
			insertps	xmm13, xmm0, 01100000b
			insertps	xmm14, xmm0, 10100000b
			insertps	xmm15, xmm0, 11100000b

			insertps	xmm0, xmm12, 11000000b
			insertps	xmm0, xmm13, 11010000b
			insertps	xmm0, xmm14, 11100000b
			insertps	xmm0, xmm15, 11110000b

			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			pinsrd		xmm1, ebp, 00000000b
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			pinsrd		xmm1, ebp, 00000001b
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			pinsrd		xmm1, ebp, 00000010b
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			pinsrd		xmm1, ebp, 00000011b

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			pinsrd		xmm2, ebp, 00000000b
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			pinsrd		xmm2, ebp, 00000001b
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			pinsrd		xmm2, ebp, 00000010b
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			pinsrd		xmm2, ebp, 00000011b

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			pinsrd		xmm3, ebp, 00000000b
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			pinsrd		xmm3, ebp, 00000001b
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			pinsrd		xmm3, ebp, 00000010b
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			pinsrd		xmm3, ebp, 00000011b

			call		idct16

			insertps	xmm12, xmm0, 00110000b 
			insertps	xmm13, xmm0, 01110000b
			insertps	xmm14, xmm0, 10110000b
			insertps	xmm15, xmm0, 11110000b

			mov			rbp, rsi
			shr			rbp, 32
			extractps	esi, xmm1, 00000000b
			shl			rsi, 32
			xor			rsi, rbp
			mov			rbp, rdi
			shr			rbp, 32
			extractps	edi, xmm1, 00000001b
			shl			rdi, 32
			xor			rdi, rbp
			mov			rbp, rbx
			shr			rbp, 32
			extractps	ebx, xmm1, 00000010b
			shl			rbx, 32
			xor			rbx, rbp
			mov			rbp, rcx
			shr			rbp, 32
			extractps	ecx, xmm1, 00000011b
			shl			rcx, 32
			xor			rcx, rbp

			mov			rbp, r8
			shr			rbp, 32
			extractps	r8d, xmm2, 00000000b
			shl			r8, 32
			xor			r8, rbp
			mov			rbp, r9
			shr			rbp, 32
			extractps	r9d, xmm2, 00000001b
			shl			r9, 32
			xor			r9, rbp
			mov			rbp, r10
			shr			rbp, 32
			extractps	r10d, xmm2, 00000010b
			shl			r10, 32
			xor			r10, rbp
			mov			rbp, r11
			shr			rbp, 32
			extractps	r11d, xmm2, 00000011b
			shl			r11, 32
			xor			r11, rbp

			mov			rbp, r12
			shr			rbp, 32
			extractps	r12d, xmm3, 00000000b
			shl			r12, 32
			xor			r12, rbp
			mov			rbp, r13
			shr			rbp, 32
			extractps	r13d, xmm3, 00000001b
			shl			r13, 32
			xor			r13, rbp
			mov			rbp, r14
			shr			rbp, 32
			extractps	r14d, xmm3, 00000010b
			shl			r14, 32
			xor			r14, rbp
			mov			rbp, r15
			shr			rbp, 32
			extractps	r15d, xmm3, 00000011b
			shl			r15, 32
			xor			r15, rbp

			movaps		[rdx + rax - 8], xmm12
			movaps		[rdx + rax + 16 * 4 * 1 - 8], xmm13
			movaps		[rdx + rax + 16 * 4 * 2 - 8], xmm14
			movaps		[rdx + rax + 16 * 4 * 3 - 8], xmm15

			mov			[rdx + rax + 16 * 4 * 4], rsi
			mov			[rdx + rax + 16 * 4 * 5], rdi
			mov			[rdx + rax + 16 * 4 * 6], rbx
			mov			[rdx + rax + 16 * 4 * 7], rcx

			mov			[rdx + rax + 16 * 4 * 8], r8
			mov			[rdx + rax + 16 * 4 * 9], r9
			mov			[rdx + rax + 16 * 4 * 10], r10
			mov			[rdx + rax + 16 * 4 * 11], r11

			mov			[rdx + rax + 16 * 4 * 12], r12
			mov			[rdx + rax + 16 * 4 * 13], r13
			mov			[rdx + rax + 16 * 4 * 14], r14
			mov			[rdx + rax + 16 * 4 * 15], r15

			add			rax, 8
			cmp			rax, 4 * 16
			jb			idct_colum


			xor			rax, rax
idct_row:
			movaps		xmm0, [rdx + rax]
			movaps		xmm1, [rdx + rax + 16]
			movaps		xmm2, [rdx + rax + 32]
			movaps		xmm3, [rdx + rax + 48]
			call		idct16
			movaps		[rdx + rax], xmm0	
			movaps		[rdx + rax + 16], xmm1
			movaps		[rdx + rax + 32], xmm2
			movaps		[rdx + rax + 48], xmm3
			add			rax, 4 * 16
			cmp			rax, 4 * 16 * 16
			jb			idct_row


			movaps		xmm8, [rsp + 16 * 0]
			movaps		xmm9, [rsp + 16 * 1]
			movaps		xmm10, [rsp + 16 * 2]
			movaps		xmm11, [rsp + 16 * 3]
			movaps		xmm12, [rsp + 16 * 4]
			movaps		xmm13, [rsp + 16 * 5]
			movaps		xmm14, [rsp + 16 * 6]
			movaps		xmm15, [rsp + 16 * 7]
			add			rsp, 16 * 8
			pop			r15
			pop			r14
			pop			r13
			pop			r12
			pop			rdi
			pop			rsi
			pop			rbp
			pop			rbx
			add			rsp, 8
			movaps		xmm6, [rsp + 8]
			movaps		xmm7, [rsp + 8 + 16]

			ret



copy_to_dst:
			movaps		xmm0, [rcx + 4 * 0]
			movaps		xmm1, [rcx + 4 * 4]
			movaps		xmm2, [rcx + 4 * 8]
			movaps		xmm3, [rcx + 4 * 12]
			movaps		xmm4, [rcx + 4 * 16]
			movaps		xmm5, [rcx + 4 * 20]
			movaps		xmm6, [rcx + 4 * 24]
			movaps		xmm7, [rcx + 4 * 28]
			movaps		xmm8, [rcx + 4 * 32]
			movaps		xmm9, [rcx + 4 * 36]
			movaps		xmm10, [rcx + 4 * 40]
			movaps		xmm11, [rcx + 4 * 44]

			movaps		xmm13, [rel mul2]
			mulps		xmm0, xmm13
			mulps		xmm1, xmm13
			mulps		xmm2, xmm13
			mulps		xmm3, xmm13
			mulps		xmm13, xmm13
			movaps		xmm14, xmm13
			movaps		xmm15, xmm13

			mulps		xmm4, xmm14
			mulps		xmm5, xmm14
			mulps		xmm6, xmm14
			mulps		xmm7, xmm14
			mulps		xmm8, xmm15
			mulps		xmm9, xmm15
			mulps		xmm10, xmm15
			mulps		xmm11, xmm15

			movaps		[rdx + 4 * 0], xmm0
			movaps		[rdx + 4 * 4], xmm1
			movaps		[rdx + 4 * 8], xmm2
			movaps		[rdx + 4 * 12], xmm3
			movaps		[rdx + 4 * 16], xmm4
			movaps		[rdx + 4 * 20], xmm5
			movaps		[rdx + 4 * 24], xmm6
			movaps		[rdx + 4 * 28], xmm7
			movaps		[rdx + 4 * 32], xmm8
			movaps		[rdx + 4 * 36], xmm9
			movaps		[rdx + 4 * 40], xmm10
			movaps		[rdx + 4 * 44], xmm11

			add			rcx, 4 * 48
			add			rdx, 4 * 48
			xor			rax, rax

copy_loop:
			movaps		xmm0, [rcx + 4 * 0]
			movaps		xmm1, [rcx + 4 * 4]
			movaps		xmm2, [rcx + 4 * 8]
			movaps		xmm3, [rcx + 4 * 12]
			movaps		xmm4, [rcx + 4 * 16]
			movaps		xmm5, [rcx + 4 * 20]
			movaps		xmm6, [rcx + 4 * 24]
			movaps		xmm7, [rcx + 4 * 28]
			movaps		xmm8, [rcx + 4 * 32]
			movaps		xmm9, [rcx + 4 * 36]
			movaps		xmm10, [rcx + 4 * 40]
			movaps		xmm11, [rcx + 4 * 44]

			mulps		xmm0, xmm13
			mulps		xmm1, xmm13
			mulps		xmm2, xmm13
			mulps		xmm3, xmm13
			mulps		xmm4, xmm14
			mulps		xmm5, xmm14
			mulps		xmm6, xmm14
			mulps		xmm7, xmm14
			mulps		xmm8, xmm15
			mulps		xmm9, xmm15
			mulps		xmm10, xmm15
			mulps		xmm11, xmm15

			movaps		[rdx + 4 * 0], xmm0
			movaps		[rdx + 4 * 4], xmm1
			movaps		[rdx + 4 * 8], xmm2
			movaps		[rdx + 4 * 12], xmm3
			movaps		[rdx + 4 * 16], xmm4
			movaps		[rdx + 4 * 20], xmm5
			movaps		[rdx + 4 * 24], xmm6
			movaps		[rdx + 4 * 28], xmm7
			movaps		[rdx + 4 * 32], xmm8
			movaps		[rdx + 4 * 36], xmm9
			movaps		[rdx + 4 * 40], xmm10
			movaps		[rdx + 4 * 44], xmm11

			add			rcx, 4 * 48
			add			rdx, 4 * 48
			inc			rax
			cmp			rax, 4
			jb			copy_loop

			movaps		xmm0, [rcx + 4 * 0]
			movaps		xmm1, [rcx + 4 * 4]
			movaps		xmm2, [rcx + 4 * 8]
			movaps		xmm3, [rcx + 4 * 12]
			mulps		xmm0, xmm13
			mulps		xmm1, xmm13
			mulps		xmm2, xmm13
			mulps		xmm3, xmm13
			movaps		[rdx + 4 * 0], xmm0
			movaps		[rdx + 4 * 4], xmm1
			movaps		[rdx + 4 * 8], xmm2
			movaps		[rdx + 4 * 12], xmm3

			sub			rdx, 4 * 16 * 15
			jmp			idct_mark



idct16:
			movaps		xmm4, xmm0
			movaps		xmm5, xmm1
			movaps		xmm6, xmm2
			movaps		xmm7, xmm3

			shufps		xmm4, xmm5, 10001000b
			shufps		xmm6, xmm7, 10001000b
			movaps		xmm5, xmm6

			shufps		xmm0, xmm1, 11011101b
			shufps		xmm2, xmm3, 11011101b
			movaps		xmm1, xmm2

			movaps		xmm3, xmm1
			movaps		xmm2, xmm0
			palignr		xmm3, xmm2, 12
			pslldq		xmm2, 4
			addps		xmm0, xmm2
			addps		xmm1, xmm3

			movaps		xmm6, xmm0
			movaps		xmm7, xmm1

			jmp			idct8_1
idct16_end:
			movaps		xmm0, xmm4
			movaps		xmm1, xmm5
			movaps		xmm2, xmm5
			movaps		xmm3, xmm4

			mulps		xmm6, xmm11
			mulps		xmm7, [rel cos16 + 16]

			movaps		xmm4, xmm6
			movaps		xmm5, xmm7

			addps		xmm0, xmm4
			addps		xmm1, xmm5

			subps		xmm3, xmm6
			subps		xmm2, xmm7

			shufps		xmm2, xmm2, 00011011b
			shufps		xmm3, xmm3,	00011011b

			ret


idct8_1:
			movaps		xmm0, xmm4
			movaps		xmm1, xmm5

			shufps		xmm0, xmm1, 10001000b

			shufps		xmm4, xmm5, 11011101b
			movaps		xmm5, xmm4
			pslldq		xmm5, 4
			addps		xmm4, xmm5
			movaps		xmm1, xmm4

			jmp			idct4_1
idct8_1_end:
		
			movaps		xmm4, xmm0
			movaps		xmm5, xmm0
			mulps		xmm1, xmm10
			movaps		xmm0, xmm1

			addps		xmm4, xmm0
			subps		xmm5, xmm1
			shufps		xmm5, xmm5, 00011011b
			jmp			idct8_2


idct4_1:
			shufps		xmm0, xmm0, 11011000b
			insertps	xmm4, xmm0, 10110111b
			addps		xmm4, xmm0
			movaps		xmm0, xmm4

			shufps		xmm0, xmm0, 10100000b
			shufps		xmm4, xmm4,	11110101b
			mulps		xmm4, xmm8
			addps		xmm0, xmm4

			movaps		xmm4, xmm0

			shufps		xmm0, xmm0, 01010000b
			shufps		xmm4, xmm4, 11111010b

			mulps		xmm4, xmm9
			addsubps	xmm0, xmm4

			shufps		xmm0, xmm0, 00101101b


			shufps		xmm1, xmm1, 11011000b
			insertps	xmm5, xmm1, 10110111b
			addps		xmm5, xmm1
			movaps		xmm1, xmm5

			shufps		xmm1, xmm1, 10100000b
			shufps		xmm5, xmm5,	11110101b
			mulps		xmm5, xmm8
			addps		xmm1, xmm5

			movaps		xmm5, xmm1

			shufps		xmm1, xmm1, 01010000b
			shufps		xmm5, xmm5, 11111010b

			mulps		xmm5, xmm9
			addsubps	xmm1, xmm5

			shufps		xmm1, xmm1, 00101101b

			jmp			idct8_1_end





idct8_2:
			movaps		xmm2, xmm6
			movaps		xmm3, xmm7

			shufps		xmm2, xmm3, 10001000b

			shufps		xmm6, xmm7, 11011101b
			movaps		xmm7, xmm6
			pslldq		xmm7, 4
			addps		xmm6, xmm7
			movaps		xmm3, xmm6

			jmp			idct4_2
idct8_2_end:
		
			movaps		xmm6, xmm2
			movaps		xmm7, xmm2
			mulps		xmm3, xmm10
			movaps		xmm2, xmm3

			addps		xmm6, xmm2
			subps		xmm7, xmm3
			shufps		xmm7, xmm7, 00011011b
			jmp			idct16_end


idct4_2:
			shufps		xmm2, xmm2, 11011000b
			insertps	xmm6, xmm2, 10110111b
			addps		xmm6, xmm2
			movaps		xmm2, xmm6

			shufps		xmm2, xmm2, 10100000b
			shufps		xmm6, xmm6,	11110101b
			mulps		xmm6, xmm8
			addps		xmm2, xmm6

			movaps		xmm6, xmm2

			shufps		xmm2, xmm2, 01010000b
			shufps		xmm6, xmm6, 11111010b

			mulps		xmm6, xmm9
			addsubps	xmm2, xmm6

			shufps		xmm2, xmm2, 00101101b


			shufps		xmm3, xmm3, 11011000b
			insertps	xmm7, xmm3, 10110111b
			addps		xmm7, xmm3
			movaps		xmm3, xmm7

			shufps		xmm3, xmm3, 10100000b
			shufps		xmm7, xmm7,	11110101b
			mulps		xmm7, xmm8
			addps		xmm3, xmm7

			movaps		xmm7, xmm3

			shufps		xmm3, xmm3, 01010000b
			shufps		xmm7, xmm7, 11111010b

			mulps		xmm7, xmm9
			addsubps	xmm3, xmm7

			shufps		xmm3, xmm3, 00101101b

			jmp		idct8_2_end





		 align 16 section  .data

cos16:	dd	0.50241928618815570551167, 0.52249861493968888062857532, 0.566944034816357703680538, 0.64682178335999012954836, 0.788154623451250224734, 1.06067768599034747134045, 1.7224470982383339278159, 5.1011486186891638581

cos8:	dd	0.5097955791041591689419398, 0.6013448869350452805437218239, 0.8999762231364157046385, 2.5629154477415061787960862961777

cos4:	dd	1.0, 1.0, 0.5411961001461969843997232, 1.30656296487637652785664317

cos2:	dd	0.7071067811865475244, -0.7071067811865475244, 0.7071067811865475244, -0.7071067811865475244

div256:	dd	0.00390625, 0.00390625, 0.00390625, 0.00390625

mul2:	dd	2.0, 2.0, 2.0, 2.0

div2:	dd	0.5, 0.5, 0.5, 0.5

icos4:	dd	0.5411961001461969843997232, 0.5411961001461969843997232, 1.30656296487637652785664317, 1.30656296487637652785664317