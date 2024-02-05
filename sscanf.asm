section .bss
    buf resb 8

section .text
    global _sscanf

_sscanf:
    pop r15
    mov r14, rbx
    mov r13, rbp

    push rdi
    push rsi
    pop rdi
    pop rsi

    push r9
    push r8
    push rcx
    push rdx

   
    xor r8, r8
    xor r10, r10
    .scanning:
        mov al, [rdi + r8]
        cmp al, 0
        je .exit

        cmp al, 10
        je .exit

        cmp al, '%'
        je .spec

        inc r8
        jmp .scanning

    .spec:
        inc r8
        mov al, [rdi + r8]

        cmp al, 'c'
        je .char

        cmp al, 's'
        je .string

        cmp al, 'u'
        je .uint32

        cmp al, 'd'
        je .int32

        cmp al, 'i'
        je .int32

        cmp al, 'o'
        je .oct

        cmp al, 'x'
        je .hex

        cmp al, 'X'
        je .HEX



        inc r8
        jmp .scanning
    
    .char:
        pop r12

        mov r11b, [rsi + r10]
        mov [r12], r11b
        inc r10
        inc r10

        inc r8
        jmp .scanning

    .string:
        pop r12

        .string_loop:
            mov al, [rsi + r10]
            inc r10

            cmp al, 10
            je .string_finish

            cmp al, 32
            je .string_finish

            mov [r12], al

            inc r12
            jmp .string_loop

        .string_finish:
            inc r8
            jmp .scanning

    .int32:
        pop r12

        mov ebx, 10

        xor rax, rax
        xor r9, r9

        .int32_loop:
            xor rcx, rcx
            mov cl, [rsi + r10]
            inc r10

            cmp cl, '-'
            je .minus

            cmp cl, 10
            je .int32_pre_finish

            cmp cl, 32
            je .int32_pre_finish

            mul ebx

            sub cl, '0'
            add eax, ecx
            jmp .int32_loop

        .minus:
            mov r9, 1
            jmp .int32_loop

        .negative:
            neg eax
            jmp .int32_finish

        .int32_pre_finish:
            cmp r9, 1
            je .negative

        .int32_finish:
            mov [r12], eax
            inc r8
            jmp .scanning

    .uint32:
        pop r12

        mov ebx, 10

        xor rax, rax
        .uint32_loop:
            xor rcx, rcx
            mov cl, [rsi + r10]
            inc r10

            cmp cl, 10
            je .uint32_finish

            cmp cl, 32
            je .uint32_finish

            mul ebx

            sub cl, '0'
            add eax, ecx
            jmp .uint32_loop

        .uint32_finish:
            mov [r12], eax
            inc r8
            jmp .scanning

    .oct:
        pop r12

        mov ebx, 8

        xor rax, rax
        .oct_loop:
            xor rcx, rcx
            mov cl, [rsi + r10]
            inc r10

            cmp cl, 10
            je .oct_finish

            cmp cl, 32
            je .oct_finish

            mul ebx

            sub cl, '0'
            add eax, ecx
            jmp .oct_loop

        .oct_finish:
            mov [r12], eax
            inc r8
            jmp .scanning

    .hex:
        pop r12
        mov ebx, 16

        xor rax, rax
        .hex_loop:
            xor rcx, rcx
            mov cl, [rsi + r10]
            inc r10

            cmp cl, 10
            je .hex_finish

            cmp cl, 32
            je .hex_finish

            cmp cl, '9'
            jg .transform_hex

            mul ebx

            sub cl, '0'
            add eax, ecx
            jmp .hex_loop

        .transform_hex:
            sub cl, 'a'
            add cl, 10

            mul ebx
            add eax, ecx
            jmp .hex_loop


        .hex_finish:
            mov [r12], eax
            inc r8
            jmp .scanning

    .HEX:
        pop r12
        mov ebx, 16

        xor rax, rax
        .HEX_loop:
            xor rcx, rcx
            mov cl, [rsi + r10]
            inc r10

            cmp cl, 10
            je .HEX_finish

            cmp cl, 32
            je .HEX_finish

            cmp cl, '9'
            jg .transform_HEX

            mul ebx

            sub cl, '0'
            add eax, ecx
            jmp .HEX_loop

        .transform_HEX:
            sub cl, 'A'
            add cl, 10

            mul ebx
            add eax, ecx
            jmp .HEX_loop


        .HEX_finish:
            mov [r12], eax
            inc r8
            jmp .scanning


    .exit:
        mov rbp, r13
        mov rbx, r14
        push r15
        ret