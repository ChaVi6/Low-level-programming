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

 li a0, 4              
 la a1, string        
 ecall                    
 
 li a0, 1            
 mv a1, a4           
 ecall                   
 
 li a0, 10                # a0 = 10 
 ecall                    # ecall при значении a0 = 10 => останов симулятора 
 
 lw ra, 12(sp)            # воссстановление ra
 addi sp, sp, 16          # освобождение памяти в стеке
 
 ret 
 
 .rodata
array_length:
 .word 15
string:
 .string "The most common value: "
array:
 .word 15, 7, 5, 6, 55, 99, 0, 1, 6, 7, 5, 5, 10, 7, 5
         
 
# mostcommon.s
# Определение наиболее часто встречающегося в массиве значения .
# В a1 - длина массива, в a0 - адрес нулевого элемента массива.
# Результат работы подпрограммы в a4.
.text
mostcommon:
.globl mostcommon

 li a5, 0                  # a5 = 0
 li a6, 0                  # a6 = 0
 addi a1, a1, -1 
 
 beq a1, zero, len1        # if (a1 == 0), goto len1

loop_i: 

 beq a6, a1, loop_exit     # if (a6 == a1), goto loop_exit
 slli a2, a6, 2            # a2 = a6 << 2 = a6 * 4
 add a2, a0, a2            # a2 = a0 + a2 = a0 + a6 * 4 = i
 addi a3, a2, 4            # a3 = a2 + 4 = a2 + 4 = i + 1
 lw t0, 0(a2)              # t0 = array[i]
 addi a7, a6, 1            # a7 = a6 + 1

loop_j:                    # сравнение со всеми остальными элементами массива

 bgt a7, a1, loop_max_check# if (a7 > a1) goto loop_max_check
 lw t2, 0(a3)              # t2 = array[j]
 bne t0, t2 skip           # if (t0 != t2) goto skip, пропускаем увеличение счетчика текущего числа
 addi t1, t1, 1            # t1++

skip:                     
  
 addi a7, a7, 1            # a7 += 1
 addi a3, a3, 4            # a3 += 4 = j + 1
 jal zero, loop_j          # goto loop_j


loop_max_check:            # проверяем на число на наибольшее количество повторений в массиве

 addi a6, a6, 1            # a6 += 1
 bge a5, t1 skip_change    #(a5 >= t1) goto skip_change, пропускаем изменение
 add a5, t1, zero          # a5 = t1
 add a4, t0, zero          # a4 = t0

skip_change:

 jal zero, loop_i          # goto loop_i
 
len1:

 slli a2, a6, 2            # a2 = a6 << 2 = a6 * 4
 add a2, a0, a2            # a2 = a0 + a2 = a0 + a6 * 4 = i
 lb t0, 0(a2)              # t0 = array[i]

 add a4, t0, zero          # a4 = t0
 jal zero, loop_exit       # goto loop_exit

loop_exit:
 ret
 
