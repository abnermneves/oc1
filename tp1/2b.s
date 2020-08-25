# tentei de alguns jeitos, nesse eu segui aquele vídeo, mas mesmo assim não deu

main:
	addi a0, x0, 4			# n
    addi t3, x0, 3			# valor 3
    jal ra, fib
    
fib:
	bge a0, t3, fib_rec		# se n >= 3, chama a função recursiva
    addi a1, a0, -1			# se não, n-1 é o resultado (considerando que a seuqência começa com 0)
    jalr x0, 0(ra)			# volta para o procedimento que chamou
    
fib_rec:
	addi sp, sp, -12		# aloca espaço na pilha
    sw ra, 0(sp)		# salva o return address
    sw a0, 4(sp)		# salva n
    
    addi a0, a0, -1		# n -= 1
    jal fib				# chama fib(n-1)
    
    sw a1, 8(sp)		# salva o resultado de fib(n-1)
    lw a0, 4(sp)		# restaura n
    
    addi a0, a0, -2		# n -= 2
    jal fib				# chama fib(n-2). o resultado ficará em a1
    
    lw t0, 8(sp)		# resgata o resultado de fib(n-1)
    
    add t2, t0, a1		# soma de fib(n-1) e fib(n-2)
    
    lw ra, 0(sp)		# restaura o return address
    addi sp, sp, 12		# desaloca o espaço na pilha
    
    jalr x0, 0(ra)
    
exit:
	addi a0, x0, 1
    add a1, x0, t2
    ecall
	