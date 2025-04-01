# codigo exemplo que esta escrito em instrucoes.bin
addi $8, $zero, 32
addi $9, $zero, 16
add $10, $8, $9
loop:
beq $8, $9, end
addi $9, $9, 8
j loop
end:
and $10, $9, $8
