#setup.s
.text
__start:
.globl __start

  call main
    
finish:
  mv a1, a0      # a1 = a0
  li a0, 17      # a0 = 17
  ecall          # выход с кодом завершения  


# main.s
.text
main:
.globl main
 la a0, array             # установка регистра a0 в значение адреса, соответствующего метке array, a0 = <адрес 0-го элемента массива>
 la a1, array_length      # установка регистра a1 в значение адреса, соответствующего метке array_length, 
 lw a1, 0(a1)             # a1 = <длина массива>
 
 addi sp, sp, -16         # выделение памяти в стеке
 sw ra, 12(sp)            # сохранение в ra
 
 call mostcommon

 li     a0, 4             # a0 = 4 ecall code to print string
 la     a1, string        # a1 = index of string
 ecall                    # print string

 li     a0, 24            # a0 = 24 ecall code to print int
 mv     a1, a4            # a1 = a4
 ecall                    # print int from a1
 
 lw ra, 12(sp)            # воссстановление ra
 addi sp, sp, 16          # освобождение памяти в стеке
 ret 
 
 .rodata
array_length:
 .word 15
string:
 .ascii "The most common value: "
 .word 0
array:
 .word 15, 7, 5, 6, 55, 99, 0, 1, 6, 7, 5, 5, 10, 7, 5
         
 
# mostcommon.s
# Определение наиболее часто встречающегося в массиве значения .
# В a1 - длина массива, в a0 - адрес первого элемента массива.
# Результат работы подпрограммы в a4.
.text
mostcommon:
.globl mostcommon

li      a5, 0             # a5 = 0
li      a6, 0             # a6 = 0 

loop_i: 

 bgt   a6, a1, loop_exit  # if (a6 > a1), переходим в loop_exit
 slli   a2, a6, 2         # a2 = a6 << 2 = a6 * 4
 add    a2, a0, a2        # a2 = a0 + a2 = a0 + a6 * 4 = i
 addi   a3, a2, 4         # a3 = a2 + 4 = a2 + 4 = i + 1
 lw     t0, 0(a2)         # t0 = array[i]
 li     t1, 1             # t1 = 1
 addi   a7, a6, 1         # a7 = a6 + 1

loop_j:                   # сравнение со всеми остальными элементами массива

 bgt    a7, a1, loop_max_check# if (a7 > a1) goto loop_max_check
 lw     t2, 0(a3)         # t2 = array[j]
 bne    t0, t2 skip       # if (t0 != t2) goto skip, пропускаем увеличение счетчика текущего числа
 addi   t1, t1, 1         # t1++

skip:                     
  
 addi   a7, a7, 1         # a7 += 1
 addi   a3, a3, 4         # a3 += 4 = j + 1
 jal    zero, loop_j      # goto loop_j


loop_max_check:           # проверяем на число на наибольшее количество повторений в массиве

 addi   a6, a6, 1         # a6 += 1
 bgt    a5, t1 skip_change#(a5 > t1) goto skip_change, пропускаем изменение 
 add    a5, t1, zero      # a5 = t1
 add    a4, t0, zero      # a4 = t0

skip_change:

 jal    zero, loop_i      # goto loop_i

loop_exit:
 ret
 
