# Определение наиболее часто встречающегося в массиве значения 
# Результат работы подпрограммы в a4
# t0 - текущее число
# t1 - счетчик повторений текущего числа
# t2 - элемент для сравнения
# s0 - длина массива
# s1 - адрес нулевого элемента массива
# a2 - адрес i
# a3 - адрес j
# a4 - текущий результат
# a5 - счетчик общего результата
# a6 - счетчик loop_i
# a7 - счетчик loop_j

__start:
.globl __start
 la s0, array_length   # установка регистра s0 в значение адреса, соответствующего метке array_length
 lw s0, 0(s0)          # s0 = <длина массива>
 addi s0, s0, -1
 la s1, array          # установка регистра s1 в значение адреса, соответствующего метке array
 li a5, 0              # a5 = 0 
 li a6, 0              # a6 = 0 
 
 beq s0, zero, len1    # if (s0 == 0), goto len1

loop_i: 

 beq a6, s0, loop_exit # if (a6 == s0), goto loop_exit
 slli a2, a6, 2        # a2 = a6 << 2 = a6 * 4
 add a2, s1, a2        # a2 = s1 + a2 = s1 + a6 * 4 = i
 addi a3, a2, 4        # a3 = a2 + 4 = a2 + 4 = i + 1
 lw t0, 0(a2)          # t0 = array[i]
 addi a7, a6, 1        # a7 = a6 + 1

loop_j:                # сравнение со всеми остальными элементами массива

 bgt a7, s0, loop_max_check # if (a7 > s0) goto loop_max_check
 lw t2, 0(a3)          # t2 = array[j]
 bne t0, t2 skip       # if (t0 != t2) goto skip, пропускаем увеличение счетчика текущего числа
 addi t1, t1, 1        # t1++

skip:                     
  
 addi a7, a7, 1        # a7 += 1
 addi a3, a3, 4        # a3 += 4 = j + 1
 jal zero, loop_j      # goto loop_j

loop_max_check:        # проверяем на число на наибольшее количество повторений в массиве

 addi a6, a6, 1        # a6 += 1
 bge a5, t1 skip_change#(a5 >= t1) goto skip_change, пропускаем изменение 
 add a5, t1, zero      # a5 = t1
 add a4, t0, zero      # a4 = t0

skip_change:

 jal zero, loop_i      # goto loop_i
 
len1:

 slli a2, a6, 2        # a2 = a6 << 2 = a6 * 4
 add a2, s1, a2        # a2 = s1 + a2 = s1 + a6 * 4 = i
 lb t0, 0(a2)          # t0 = array[i]

 add a4, t0, zero      # a4 = t0
 jal zero, loop_exit   # goto loop_exit
 
loop_exit:

finish:

 li a0, 4             
 la a1, string        
 ecall                    

 li a0, 1            
 mv a1, a4           
 ecall                   
 
 li a0, 10            # a0 = 10 
 ecall                # ecall при значении a0 = 10 => останов симулятора 
 
.rodata
array_length:
 .word 10
string:
 .string "The most common value: "
array:
 .word 15, 7, 6, 6, 8, 99, 0, 1, 6, 7