.globl str_ge, recCheck

.data

maria:    .string "Maria"
markos:   .string "Markos"
marios:   .string "Marios"
marianna: .string "Marianna"

.align 4  # make sure the string arrays are aligned to words (easier to see in ripes memory view)

# These are string arrays
# The labels below are replaced by the respective addresses
arraySorted:    .word maria, marianna, marios, markos

arrayNotSorted: .word marianna, markos, maria, marios

.text

            la   a0, arrayNotSorted
            li   a1, 4
            jal  recCheck

            li   a7, 10
            ecall

str_ge:
#---------
# Write the subroutine code here
        loop:
            lb t0, 0(a0)
            lb t1, 0(a1)
            
            blt t0, t1, return
            bgt t0, t1, exit        
            beq t0, zero, exit

            
            addi a0, a0, 1
            addi a1, a1, 1            
            j loop
            
        return:
            li a0, 0
            jr   ra
         exit:
             li a0, 1
             jr ra
# ----------------------------------------------------------------------------
# recCheck(array, size)
# if size == 0 or size == 1
#     return 1
# if str_ge(array[1], array[0])      # if first two items in ascending order,
#     return recCheck(&(array[1]), size-1)  # check from 2nd element onwards
# else
#     return 0

recCheck:
#---------
# Write the subroutine code here
            #check size
            li t6, 1
            beq a1, t6, return1
            beq a1, zero, return1
            
            #load strs from array
            lw t0, 0(a0)
            lw t1, 4(a0)
            
            #call str_ge
            addi sp, sp, -4
            sw ra, 0(sp)
            
            add a0, t1, zero
            add a1, t0, zero
            
            jal str_ge
            
            lw ra, 0(sp)
            addi sp, sp, 4
            
            beq a0, zero, return0
            
            #continue
            addi a0, a0, 4
            addi a1, a1, -1
            jal recCheck
            
            jr ra
            
        return1:
            addi a0, zero, 1
            jr ra
            
        return0:
            li a0, 0
            jr ra
            
#  You may move jr ra   if you wish.
#---------
