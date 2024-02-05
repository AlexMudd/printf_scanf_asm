section .bss
    buf resb 8

section .text
    global _printf

_printf:
    pop r15
    mov r14, rbx
    mov r13, rbp

    push r9
    push r8
    push rcx
    push rdx
    push rsi
   
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
        ;mov rsi, rdi
        ;add rsi, r8
        lea rsi, [rdi + r8]

        push rdi
        mov rax, 1
        mov rdi, 1
        mov rdx, 1

        push rcx
        push r11

        syscall
        
        pop r11
        pop rcx
        pop rdi

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
        mov [buf], r12
        mov rax,1
        mov rsi, buf
        push rdi
        mov rdi, 1
        mov rdx, 1

        push rcx
        push r11

        syscall

        pop r11
        pop rcx
        pop rdi

        inc r8
        jmp .printing

    .print_string:
        pop rsi
        xor rdx, rdx
        dec rdx
        call .str_len

        push rcx
        push r11
        push rdi

        mov rdi, 1
        mov rax, 1
        syscall

        pop rdi
        pop r11
        pop rcx

        inc r8
        jmp .printing

        .str_len:
            inc rdx
            mov al, [rsi + rdx]
            cmp al, 0
            jne .str_len
            ret

    .print_percent:
        mov [buf], byte'%'
        mov rax,1
        mov rsi, buf
        push rdi
        mov rdi, 1
        mov rdx, 1

        push rcx
        push r11

        syscall

        pop r11
        pop rcx
        pop rdi

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
            push rdi
            push rcx
            push r11
            add edx, '0'
            mov [buf], edx
            mov rax, 1
            mov rdi, 1
            mov rsi, buf
            mov rdx, 1
            syscall

            pop r11
            pop rcx
            pop rdi
            
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

            mov rax, '-'
            mov [buf], rax

            push rdi
            push rcx
            push r11

            mov rax, 1
            mov rdi, 1
            mov rsi, buf
            mov rdx, 1
            syscall

            pop r11
            pop rcx
            pop rdi
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
            push rdi
            push rcx
            push r11
            add edx, '0'
            mov [buf], edx
            mov rax, 1
            mov rdi, 1
            mov rsi, buf
            mov rdx, 1
            syscall

            pop r11
            pop rcx
            pop rdi
            
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
            push rdi
            push rcx
            push r11
            add edx, '0'
            mov [buf], edx
            mov rax, 1
            mov rdi, 1
            mov rsi, buf
            mov rdx, 1
            syscall

            pop r11
            pop rcx
            pop rdi
            
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
            push rdi
            push rcx
            push r11
            add edx, '0'
            mov [buf], edx
            mov rax, 1
            mov rdi, 1
            mov rsi, buf
            mov rdx, 1
            syscall

            pop r11
            pop rcx
            pop rdi
            
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
            push rdi
            push rcx
            push r11
            add edx, '0'
            mov [buf], edx
            mov rax, 1
            mov rdi, 1
            mov rsi, buf
            mov rdx, 1
            syscall

            pop r11
            pop rcx
            pop rdi
            
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
        mov rbp, r13
        mov rbx, r14
        push r15
        ret