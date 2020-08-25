addi t0, zero, 1   # contador k (começa em 2 porque já tá contabilizando o primeiro termo, 0)
addi t1, zero, 0   # k-ésimo termo (começa em 0 porque a sequência começa em 0, já contabilizado pelo contador)
addi t2, zero, 1   # próximo termo (começa com o segundo termo da sequência, que é 1)
addi t3, zero, 0   # temp, será usado para guardar a soma dos dois termos
addi t4, zero, 9   # n

blt t4, t0, exit   # se n for zero, termina

loop:
beq t0, t4, exit   # se k = n, termina
add t3, t1, t2     # salva no temp a soma dos dois últimos termos da sequência
add t1, x0, t2     # salva o próximo termo no lugar do k-ésimo
add t2, x0, t3     # salva a soma dos dois anteriores no próximo termo
addi t0, t0, 1     # incrementa o contador
jal loop           # repete o loop

exit:
addi a0, x0, 1     # queremos imprimir a1
add a1, x0, t1     # salvamos o k-ésimo termo em a1
ecall              # imprime a1