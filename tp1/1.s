addi t0, zero, 0   # contador
addi t1, zero, 7   # a
addi t2, zero, 5   # b
addi a1, zero, 1   # resultado

loop:
beq t0, t2, exit   # se contador = b, termina
mul a1, a1, t1     # multiplica por a o resultado que temos até agora
addi t0, t0, 1     # incrementa o contador
jal loop           # repete o loop

exit:
addi a0, x0, 1     # queremos imprimir a1
ecall              # imprime a1