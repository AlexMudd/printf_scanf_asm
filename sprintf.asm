section .bss
    buf resb 8

section .text
    global _sprintf

_sprintf:
    pop r15
    mov r14, rbx
    mov r13, rbp
    mov r10, rdi

    mov rdi, rsi

    push r9
    push r8
    push rcx
    push rdx
   
    xor r8, r8

    .printing: 
        xor rax, rax
        mov al, [rdi + r8]
        cmp al, 0
        je .exit

        cmp al, '%'
        je .print_spec

        jmp .print_default

    .print_default:
        mov al, [rdi + r8]
        mov [r10], al
        
        inc r10
        inc r8
        jmp .printing

    .print_spec:
        inc r8
        mov al, [rdi + r8]

        cmp al, 'c'
        je .print_char

        cmp al, 's'
        je .print_string

        cmp al, '%'
        je .print_percent

        cmp al, 'u'
        je .print_uint32

        cmp al, 'd'
        je .print_int32

        cmp al, 'i'
        je .print_int32

        cmp al, 'o'
        je .print_oct

        cmp al, 'x'
        je .print_hex

        cmp al, 'X'
        je .print_HEX

        inc r8
        jmp .printing

    .print_char:
        pop r12
        mov [r10], r12b
        
        inc r10
        inc r8
        jmp .printing

    .print_string:
        pop rsi
        xor rdx, rdx

        .string_loop:
            mov al, [rsi + rdx]

            cmp al, 0
            je .string_finish

            inc rdx
            mov [r10], al
            inc r10
            jmp .string_loop

        .string_finish:
            inc r8
            jmp .printing

    .print_percent:
        mov [r10], byte'%'
        
        inc r10
        inc r8
        jmp .printing

    .print_uint32:
        pop rax
        xor rcx, rcx
        .uint32_div_loop:
            mov ebx, 10
            xor edx, edx
            div ebx
            push rdx
            inc rcx
            cmp eax, 0
            je .uint32_print_loop
            jmp .uint32_div_loop

        .uint32_print_loop:
            pop rdx
            add edx, '0'
            mov [r10], edx
            
            inc r10
            dec rcx
            cmp rcx, 0
            je .uint32_finish
            jmp .uint32_print_loop
        
        .uint32_finish:
            inc r8
            jmp .printing

    .print_int32:
        pop rax
        xor rcx, rcx
        cmp eax, 0
        jge .int32_div_loop

        .int32_minus:
            neg eax
            push rax

            mov al, '-'
            mov [r10], al
            inc r10
            pop rax

        .int32_div_loop:
            mov ebx, 10
            xor edx, edx
            div ebx
            push rdx
            inc rcx
            cmp eax, 0
            je .int32_print_loop
            jmp .int32_div_loop

        .int32_print_loop:
            pop rdx
            add dl, '0'
            mov [r10], dl

            inc r10
            dec rcx
            cmp rcx, 0
            je .int32_finish
            jmp .int32_print_loop
        
        .int32_finish:
            inc r8
            jmp .printing

    .print_oct:
        pop rax
        xor rcx, rcx
        .oct_div_loop:
            mov ebx, 8
            xor edx, edx
            div ebx
            push rdx
            inc rcx
            cmp eax, 0
            je .oct_print_loop
            jmp .oct_div_loop

        .oct_print_loop:
            pop rdx
            add edx, '0'
            mov [r10], dl
            
            inc r10
            dec rcx
            cmp rcx, 0
            je .oct_finish
            jmp .oct_print_loop
        
        .oct_finish:
            inc r8
            jmp .printing

    .print_hex:
        pop rax
        xor rcx, rcx
        .hex_div_loop:
            mov ebx, 16
            xor edx, edx
            div ebx

            cmp rdx, 9
            jg .transform_hex

            push rdx
            inc rcx
            cmp eax, 0
            je .hex_print_loop
            jmp .hex_div_loop

        .hex_print_loop:
            pop rdx
            add edx, '0'
            mov [r10], dl
            
            inc r10
            dec rcx
            cmp rcx, 0
            je .hex_finish
            jmp .hex_print_loop

        .transform_hex:
            sub rdx, 10
            add rdx, 49
            push rdx
            inc rcx
            cmp eax, 0
            je .hex_print_loop
            jmp .hex_div_loop
        
        .hex_finish:
            inc r8
            jmp .printing

    .print_HEX:
        pop rax
        xor rcx, rcx
        .HEX_div_loop:
            mov ebx, 16
            xor edx, edx
            div ebx

            cmp rdx, 9
            jg .transform_HEX

            push rdx
            inc rcx
            cmp eax, 0
            je .HEX_print_loop
            jmp .HEX_div_loop

        .HEX_print_loop:
            pop rdx
            add edx, '0'
            mov [r10], dl
            
            inc r10
            dec rcx
            cmp rcx, 0
            je .HEX_finish
            jmp .HEX_print_loop

        .transform_HEX:
            sub rdx, 10
            add rdx, 17
            push rdx
            inc rcx
            cmp eax, 0
            je .HEX_print_loop
            jmp .HEX_div_loop
        
        .HEX_finish:
            inc r8
            jmp .printing

    .exit:
        mov [r10], byte 0
        mov rbp, r13
        mov rbx, r14
        push r15
        ret