		;global	_print
		section	.text
_print:
		pushad
		
		mov		esi, [esp + 36 + 8]

		xor		ecx, ecx
		xor		edx, edx
		xor		ebx, ebx
		xor		edi, edi
		xor		ebp, ebp

		cmp		byte[esi], 0 
		je		read_end
		
		cmp		byte[esi], '-'
		jne		read_loop
		mov		ebp, 1
		inc		esi
		cmp		byte[esi], 0
		je		read_end

read_loop:
		shld	ebx, ecx, 4
		shld	ecx, edx, 4
		shld	edx, edi, 4
		shl		edi, 4
		call	get_cur_digit
		or		edi, eax
		inc		esi
		cmp		byte[esi], 0
		jne		read_loop

read_end:
		cmp		ebp, 1
		jne		getting_sign
		not		ebx
		not		ecx
		not		edx
		not		edi
		clc
		adc		edi, 1
		adc		edx, 0
		adc		ecx, 0
		adc		ebx, 0

getting_sign:
		xor		ebp, ebp
		test	ebx, (1 << 31)
		jz		converting
		mov		ebp, 1
		not		ebx
		not		ecx
		not		edx
		not		edi
		clc
		adc		edi, 1
		adc		edx, 0
		adc		ecx, 0
		adc		ebx, 0

converting:
		mov		[raw_number], ebx
		mov		[raw_number + 4], ecx
		mov		[raw_number + 8], edx
		mov		[raw_number + 12], edi

		mov		esi, ebp
		mov		edi, [esp + 36]
		mov		ebp, [esp + 36 + 4]
		xor		ecx, ecx
		mov		ebx, 10


converting_loop:
		xor		edx, edx

		mov		eax, [raw_number]
		div		ebx
		mov		[raw_number], eax

		mov		eax, [raw_number + 4]
		div		ebx
		mov		[raw_number + 4], eax

		mov		eax, [raw_number + 8]
		div		ebx
		mov		[raw_number + 8], eax

		mov		eax, [raw_number + 12]
		div		ebx
		mov		[raw_number + 12], eax

		add		dl, '0'
		mov		[module + ecx], dl
		inc		ecx
		
		cmp		dword[raw_number], 0
		jne		converting_loop
		cmp		dword[raw_number + 4], 0
		jne		converting_loop
		cmp		dword[raw_number + 8], 0
		jne		converting_loop
		cmp		dword[raw_number + 12], 0
		jne		converting_loop

		mov		ebx, esi
		xor		esi, esi
		xor		eax, eax

flags_paesing:
		cmp		byte[ebp], 0
		je		flags_parsed
		cmp		byte[ebp], '1'
		jb		flag
		cmp		byte[ebp], '9'
		ja		flag
		jmp		width_paesing
flag:
		cmp		byte[ebp], '0'
		je		zero
		cmp		byte[ebp], '+'
		je		plus
		cmp		byte[ebp], '-'
		je		minus
		or		bh,	1000b
		jmp		next_flag
zero:
		or		bh,	1b
		jmp		next_flag
plus:
		or		bh, 10b
		jmp		next_flag
minus:
		or		bh, 100b
next_flag:
		inc		ebp
		jmp		flags_paesing

width_paesing:
		mov		edx, 10
		mul		edx
		mov		dl, [ebp]
		sub		dl,	'0'
		add		eax, edx
		inc		ebp
		cmp		byte[ebp], 0
		jne		width_paesing
	
		mov		esi, eax

flags_parsed:
		test	bl, 1b
		jnz		sign_set
		test	bh, 10b
		jnz		plus_setting
		test	bh, 1000b
		jnz		space_setting
		jmp		sign_set
plus_setting:
		or		bl, 10b
		jmp		sign_set
space_setting:
		or		bl,	100b

sign_set:
		test	bl, 111b
		jz		no_sign
		inc		ecx
		cmp		esi, ecx
		jae		len_fix
		mov		esi, ecx
len_fix:
		dec		ecx
		jmp		width_fixed
no_sign:
		cmp		esi, ecx
		jae		width_fixed
		mov		esi, ecx

width_fixed:
		test	bh, 100b
		jz		right_padding
		call	place_sign_at_start
printing_number1:
		mov		al,	[module + ecx - 1]
		mov		[edi], al
		dec		ecx
		dec		esi
		inc		edi
		test	ecx, ecx
		jnz		printing_number1

printing_spaces1:
		test	esi, esi
		jz		exit
		mov		byte[edi], ' '
		inc		edi
		dec		esi
		jmp		printing_spaces1

right_padding:
		xor		edx, edx
		mov		ebp, esi
		dec		ebp
printing_number2:
		mov		al, [module + edx]
		mov		[edi + ebp], al
		inc		edx
		dec		ebp
		cmp		edx, ecx
		jb		printing_number2

		test	bh,	1b
		jnz		lead_zeros
		mov		edx, edi
		add		ebp, edi
		test	bl, 111b
		jz		fix_ebp
		mov		edi, ebp
		call	place_sign_at_start
		inc		esi
		mov		edi, edx
		jmp		lead_spaces
fix_ebp:
		inc		ebp

lead_spaces:
		cmp		edx, ebp
		je		pre_space_exit
		mov		byte[edx], ' '
		inc		edx
		jmp		lead_spaces

pre_space_exit:
		add		edi, esi
		jmp		exit

lead_zeros:
		call	place_sign_at_start
		sub		esi, ecx
place_zeroes:
		test	esi, esi
		jz		pre_zero_exit
		mov		byte[edi], '0'
		inc		edi
		dec		esi
		jmp		place_zeroes
pre_zero_exit:
		add		edi, ecx

exit:
		mov		byte[edi], 0
		popad
		ret



place_sign_at_start:
		test	bl, 111b
		jz		sign_placed
		test	bl, 1b
		jnz		minus_placing
		test	bl, 10b
		jnz		plus_placing
		mov		byte[edi], ' '
		jmp		fix_values
minus_placing:
		mov		byte[edi], '-'
		jmp		fix_values
plus_placing:
		mov		byte[edi], '+'
fix_values:
		inc		edi
		dec		esi
sign_placed:
		ret



get_cur_digit:
		xor		eax, eax
		mov		al, [esi]
		cmp		al, '0'
		jb		letter
		cmp		al,	'9'
		ja		letter
		sub		al, '0'
		ret
letter:
		add		al, 10
		cmp		al, 'a'
		jb		big
		cmp		al, 'z'
		ja		big
		sub		al,	'a'
		ret
big:
		sub		al, 'A'
		ret
	

		section .bss
raw_number:	resd	4
module:		resb	40