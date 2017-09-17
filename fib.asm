title Fibonacci Program (fib.asm)

; This program displays the first 24 numbers
; of the fibonacci sequence

.model small

.stack 100h

.data
numbersToDisplay dw 24              ; amount of fibonacci sequence numbers to display
separator db ", ",'$'               ; separator that appears between numbers in the sequence

.code
main proc
    mov ax, @data                   ; store the address of the data segment
    mov ds, ax                      ; in the data segment register

    mov ax, 1                       ; initialize ax to be 1st fib sequence number
    mov bx, 1                       ; initialize bx to be 2nd fib sequence number
    mov cx, numbersToDisplay        ; set the number of fib numbers to display

    call printInt                   ; print the first number in the sequence
    dec cx                          ; decrement cx because we just printed first number

L1:
    call printSeparator             ; print the separator
    call calcFibNumber              ; calculate the next number in the sequence
    call printInt                   ; print out the current sequence number
loop L1

    mov ax, 4C00h                   ; return control
    int 21h                         ; to DOS
main endp

;------------------------------------------
; Current highest fib number (bx)
; added to previous number (ax)
; then swap so bx still highest fib number
;------------------------------------------
calcFibNumber proc
    add ax,bx               ; ax becomes next num
    xchg ax,bx              ; swap to ensure bx newest num
    ret
calcFibNumber endp

;------------------------------------------
; Prints the current unsigned integer in ax
;------------------------------------------
printInt proc
    push ax                 ; save ax (current sequence number)
    push bx                 ; save bx (next sequence number)
    push cx                 ; save cx (numbers left to print)
    push dx                 ; save dx (just in case)

    mov bx, 0               ; init character counter to 0
    mov cx, 10              ; move 10 into cx

L2:
    mov dx, 0               ; initialize dx to 0
    div cx                  ; divide ax by 10, remainder (current digit) into dx, quotient in ax

    add dl, '0'             ; convert the current digit (dx) to ascii

    inc bx                  ; increment the character counter
    push dx                 ; push the current character onto the stack

    cmp ax, 0               ; if the quotient (ax) is not 0, repeat
jnz L2

L3:
    pop dx                  ; pop the digit from the stack
    dec bx                  ; decrement the counter of how many digits remain
    mov ah, 2               ; 2 is the function number of output char in the DOS Services.
    int 21h                 ; calls DOS Services
    cmp bx, 0               ; if digit counter is not zero, set zero flag
jnz L3                      ; if zero flag is not set, repeat

    pop dx                  ; restore dx
    pop cx                  ; restore cx
    pop bx                  ; restore bx
    pop ax                  ; restore ax

    ret
printInt endp

printSeparator proc
    push ax                     ; save the current sequence number (ax)
    mov dx, offset separator    ; put the separator address in dx
    mov ax, 0900h               ; put the function call number in ax
    int 21h                     ; print the separator
    pop ax                      ; restore the current sequence number
    ret
printSeparator endp

end main
