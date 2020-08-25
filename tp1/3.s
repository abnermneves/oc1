.data
source:
	.word	10
    .word	13
    .word	1
    .word	6
    .word	24
    .word	5
    .word	7
    .word	-1
    
dest:
	.word 0
    .word 0
    .word 0
    .word 0
    .word 0
	.word 0
    .word 0
    .word 0
    .word 0
    .word 0
    
.text

main:
	addi t0, x0, 0			# k = 0
	addi t1, x0, 0			# sum = 0
    la t2, source			# t2 = &source
    la t3, dest				# t3 = &dest

loop:
    slli t4, t0, 2			# t4 = k * 4
    add t4, t4, t2			# t4 = &source[k]
    lw t4, 0(t4)			# t4 = source[k]
    
    blt t4, x0, exitloop		# condição do for
    							# ---- begin for
	    addi t5, x0, 2			# t5 = 2
    	rem t5, t0, t5			# t5 = k % 2
    
    	beq t5, x0, exitif		# if (k % 2 != 0)
   			add a0, x0, t4			# a0 = source[k] para usar na função
    		jal ra, squarePlusOne	    # resultado em a1
   
    		slli t6, t0, 2			# t6 = k * 4
    		add t6, t6, t3			# t6 = &dest[k]
            lw t6, 0(t6)			# t6 = dest[k]
    		sw a1, 0(t6)			# dest[k] = squarePlusOne(source[k])
    		add t1, t1, a1			# sum += dest[k]
  		exitif:
    						# ---- end for
    addi t0, t0, 1			# k++
    
    beq x0, x0, loop
    
    
squarePlusOne: 				# parametro vai ficar em a0 e resultado vai ficar em a1
	addi a2, x0, 2
    rem a2, a0, a2 			# a2 = x % 2
    bne a2, x0, exitSPO
    add a1, x0, a0

    exitSPO:
    addi a1, a0, 1			# a1 = x + 1
    mul a1, a0, a1			# a1 = x * (x + 1)
    jalr x0, 0(ra)
    

exitloop:
	addi a0, x0, 1
   	add a1, x0, t1
    ecall
    