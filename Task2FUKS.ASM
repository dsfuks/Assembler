;5 вариант. Фукс Д.С БПИ196. Массив В из элементов A, значение которых не совпадает с введённым числом x.
format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strMasSize   db 'Input N(size of massive): ', 0
        strX   db 'Input X: ', 0
        strA   db 'Massive A:  ', 0
        strB   db 'Massive B:  ', 0
        strWrongSize db 'Incorrect size of massive: %d', 10, 0
        strMasElemI  db '%d element: ', 0
        strScanInt   db '%d', 0
        strMasElemOut  db '%d element : %d', 10, 0

        X            dd 0
        mas_size     dd 0
        sum          dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        mas          rd 100
        mas2         rd 100

;--------------------------------------------------------------------------
section '.code' code readable executable
proc task
        mov [tmpStack], esp
        xor ecx, ecx
        mov ebx, mas
        mov edx, mas2
        mov eax,0
        mov esi,0 ; Счетчик количества элементов массива В
putMasLoop2:

        mov [tmp], ebx
        cmp ecx, [mas_size]
        je endOutputMas2
        mov [i], ecx

        mov eax, [ebx]
        cmp eax,[X]
        je next ; Если число Х равно элементу массива, то переходим к следующему элементу массива A
        mov dword[edx], eax
        add edx,4
        add esi,1

next:
        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putMasLoop2
endOutputMas2:
        mov esp, [tmpStack]
        ret
endp
start:
; 1) vector input
        ; Заполнение массива A
        call MasInput

        push strX
        call [printf]
        add esp, 4

        push X
        push strScanInt
        call [scanf]
        add esp, 8

        call task  ; вызов процедуры

        ; вывод массивов
        push strB
        call [printf]
        add esp, 4
        mov edi,[mas_size]
        mov ebx, mas2
        mov dword [mas_size], esi
        call MasOut

        push strA
        call [printf]
        add esp, 4
        mov ebx, mas
        mov dword [mas_size], edi
        call MasOut

finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
MasInput:
        push strMasSize
        call [printf]
        add esp, 4

        push mas_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [mas_size]
        cmp eax, 0
        jg  getVector
        push mas_size
        push strWrongSize
        call [printf]
        push 0
        call [ExitProcess]

getVector:
        mov ecx, 0
        mov ebx, mas
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [mas_size]
        jge endInputVector


        mov [i], ecx
        push ecx
        push strMasElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------
MasOut:
        mov [tmpStack], esp
        xor ecx, ecx
putMasLoop:
        mov [tmp], ebx
        cmp ecx, [mas_size]
        je endOutputMas
        mov [i], ecx


        push dword [ebx]
        push ecx
        push strMasElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putMasLoop
endOutputMas:
        mov esp, [tmpStack]
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'