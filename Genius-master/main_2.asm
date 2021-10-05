.data
frameBuffer:
.space 0x80000

msg_menu_1: .asciiz "1 - Iniciar o jogo\n"
msg_menu_2: .asciiz "2 - Encerrar programa\n"
msg_ativacoes: .asciiz "Insira o número de ativações (máx 32): \n"
msg_tempo: .asciiz "Insira o tempo das notas: 250, 500 ou 1000 (ms) \n"
msg_insercao_invalida: .asciiz "inserção invalida"
msg_play_again: .asciiz "Jogar novamente?\n 1 - Sim \n2 - Não\n"
.text

main: 
menu_inicial:
	la $a0, msg_menu_1
	li $v0, 4
	syscall
	
	la $a0, msg_menu_2
	syscall
	
	li $v0, 5
	syscall
	
	
	beq $v0, 1, start_game
	beq $v0, 2, end_game
	
	j insercao_invalida
	
start_game:
#desenho do display 
li $t0, 0xf9f270 # color: amarelo claro f9f270 amarelo escuro 15793920
li $a0,120		#cord x
li $a1,75		#largra
li $a2,90		#CORD Y
li $a3,75		#altura
jal rectangle

li $t0, 0x7bcaf2	#azul escuro 1275 azul claro 2452479
li $a0,220		#cord x
li $a1, 75		#largra
li $a2, 177		#CORD Y
li $a3, 75		#altura
jal rectangle

li $t0, 0x9cf691	#9cf691 verde claro 587264 escuro
li $a0, 220		#cord x
li $a1, 75		#largra
li $a2, 5		#CORD Y
li $a3, 75		#altura
jal rectangle

li $t0, 0xf98383	#vermelho aceso 16711680 vermelho apagado: 12648962
li $a0,325		#cord x
li $a1,75		#largra
li $a2,90		#CORD Y
li $a3,75		#altura

jal rectangle

	j ativacoes
	
number_generator: 	
	li $v0, 41
	syscall

	rem $a0, $a0, 4
	bltz $a0, convert
	j escolha_nota
		
convert:
	mul 	$t1, $a0, -1
	move	$a0, $t1
	j escolha_nota
	
escolha_nota:
 	beq $a0, 0, vermelho
 	beq $a0, 1, azul
 	beq $a0, 2, verde
 	beq $a0, 3, amarelo
 	
 	j end_game
 	
vermelho: 	
	#brilhar cor
	li $t0, 0xfe0000	#vermelho aceso 16711680 vermelho apagado: 12648962
	li $a0,325		#cord x
	li $a1,75		#largra
	li $a2,90		#CORD Y
	li $a3,75		#altura
	jal rectangle
	
	li $v0, 33
	li 	$a0, 69
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
	
	li $t0, 0xf98383	#vermelho aceso 16711680 vermelho apagado: 12648962
	li $a0,325		#cord x
	li $a1,75		#largra
	li $a2,90		#CORD Y
	li $a3,75		#altura
	jal rectangle
	
	j end_game
	
azul:
	li $t0, 0x007ebe 	#azul escuro 1275 azul claro 2452479
	li $a0,220		#cord x
	li $a1, 75		#largra
	li $a2, 177		#CORD Y
	li $a3, 75		#altura
	jal rectangle
	
	li $v0, 33
	li 	$a0, 64
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
	li $t0, 0x7bcaf2	
	li $a0,220		#cord x
	li $a1, 75		#largra
	li $a2, 177		#CORD Y
	li $a3, 75		#altura
	jal rectangle
	
	j end_game
	
verde:
	li $t0, 0x1dff00	#505389 verde claro 587264 escuro
	li $a0, 220		#cord x
	li $a1, 75		#largra
	li $a2, 5		#CORD Y
	li $a3, 75		#altura
	jal rectangle

	li $v0, 33
	li 	$a0, 62
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
	
	li $t0, 0x9cf691	#9cf691 verde claro 587264 escuro
	li $a0, 220		#cord x
	li $a1, 75		#largra
	li $a2, 5		#CORD Y
	li $a3, 75		#altura
	jal rectangle

	j end_game
amarelo:
	li $t0, 0xfff200 # color: amarelo claro f9f270 amarelo escuro fff200
	li $a0,120		#cord x
	li $a1,75		#largra
	li $a2,90		#CORD Y
	li $a3,75		#altura
	jal rectangle
	
	li $v0, 33
	li 	$a0, 67
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
	li $t0, 0xf9f270 # color: amarelo claro f9f270 amarelo escuro fff200
	li $a0,120		#cord x
	li $a1,75		#largra
	li $a2,90		#CORD Y
	li $a3,75		#altura
	jal rectangle
	
	j end_game
	
ativacoes:
	li $v0, 4
	la $a0, msg_ativacoes
	syscall
	
	li $v0, 5
	syscall
	
	bltz $v0, insercao_invalida
	bgt $v0, 32, insercao_invalida	
	
	move $s0, $v0
	
	j tempo_ativacoes
	
	
tempo_ativacoes:

	li $v0, 4
	la $a0, msg_tempo
	syscall
	li $v0, 5
	syscall
	move $s1, $v0 
	
	beq $v0, 250, number_generator
	beq $v0, 500, number_generator
	beq $v0, 1000, number_generator
	
	j insercao_invalida
	
insercao_invalida:
	
	li $v0, 4
	la $a0, msg_insercao_invalida
	syscall
	
	j end_game
musica_vitoria:
	
			
musica_derrota:
#Parte 1:

	li $v0, 32
	li $a0, 2000
#sol
	li $v0, 33
	li $a0, 79
	li $a1, 250
	li $a2, 72
	li $a3, 50
	syscall
#mi	
	li $v0, 33
	li $a0, 76
	li $a1, 250
	li $a2, 72
	li $a3, 50
	syscall
#do	
	li $v0, 33
	li $a0, 72
	li $a1, 2000
	li $a2, 72
	li $a3, 50
	syscall

#Parte 2:	
#mi
	li $v0, 33
	li $a0, 76
	li $a1, 450
	li $a2, 72
	li $a3, 50
	syscall
#sol	
	li $v0, 33
	li $a0, 79
	li $a1, 450
	li $a2, 72
	li $a3, 50
	syscall
#la	
	li $v0, 33
	li $a0, 81
	li $a1, 1000
	li $a2, 72
	li $a3, 50
	syscall
	
#mi
	li $v0, 33
	li $a0, 76
	li $a1, 2500
	li $a2, 72
	li $a3, 50
	syscall
	
#Parte 3:
#sol
	li $v0, 33
	li $a0, 79
	li $a1, 2000
	li $a2, 72
	li $a3, 50
	syscall
	
#fa#
	li $v0, 33
	li $a0, 78
	li $a1, 450
	li $a2, 72
	li $a3, 50
	syscall
	
#sol
	li $v0, 33
	li $a0, 79
	li $a1, 450
	li $a2, 72
	li $a3, 50
	syscall
	
#la	
	li $v0, 33
	li $a0, 81
	li $a1, 450
	li $a2, 72
	li $a3, 50
	syscall
	
#re	
	li $v0, 33
	li $a0, 74
	li $a1, 450
	li $a2, 72
	li $a3, 50
	syscall
	
#si	
	li $v0, 33
	li $a0, 83
	li $a1, 2000
	li $a2, 72
	li $a3, 50
	syscall
	
#la	
	li $v0, 33
	li $a0, 81
	li $a1, 2000
	li $a2, 72
	li $a3, 50
	syscall
	
	j play_again
	
play_again:

	li $v0, 32
	li $a0, 2000
	
	li $v0, 4
	la $a0, msg_play_again
	syscall
	li $v0, 5
	syscall
	
	bne $v0, 1, end_game
	j main
	
rectangle:
# $a0 is xmin (i.e., left edge; must be within the display)
# $a1 is width (must be nonnegative and within the display)
# $a2 is ymin  (i.e., top edge, increasing down; must be within the display)
# $a3 is height (must be nonnegative and within the display)

beq $a1,$zero,rectangleReturn # zero width: draw nothing
beq $a3,$zero,rectangleReturn # zero height: draw nothing

la $t1,frameBuffer
add $a1,$a1,$a0 # simplify loop tests by switching to first too-far value
add $a3,$a3,$a2
sll $a0,$a0,2 # scale x values to bytes (4 bytes per pixel)
sll $a1,$a1,2
sll $a2,$a2,11 # scale y values to bytes (512*4 bytes per display row)
sll $a3,$a3,11
addu $t2,$a2,$t1 # translate y values to display row starting addresses
addu $a3,$a3,$t1
addu $a2,$t2,$a0 # translate y values to rectangle row starting addresses
addu $a3,$a3,$a0
addu $t2,$t2,$a1 # and compute the ending address for first rectangle row
li $t4,0x800 # bytes per display row

rectangleYloop:
move $t3,$a2 # pointer to current pixel for X loop; start at left edge

rectangleXloop:
sw $t0,($t3)
addiu $t3,$t3,4
bne $t3,$t2,rectangleXloop # keep going if not past the right edge of the rectangle

addu $a2,$a2,$t4 # advace one row worth for the left edge
addu $t2,$t2,$t4 # and right edge pointers
bne $a2,$a3,rectangleYloop # keep going if not off the bottom of the rectangle

rectangleReturn:
jr $ra
		
end_game:

	li $v0, 10
	syscall
	

