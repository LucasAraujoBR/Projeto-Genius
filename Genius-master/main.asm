.data
<<<<<<< HEAD

frameBuffer:	.space 0x80000

time:			.word 0
num_actv:		.word 0

array:		.word 0:32		# Vetor que armazena a sequência do jogo

msg_menu_1:		.asciiz "1 - Iniciar o jogo\n"
msg_menu_2:		.asciiz "2 - Encerrar programa\n"
msg_ativacoes:	.asciiz "Insira o número de ativações (máx 32): \n"
msg_tempo:		.asciiz "Insira o tempo das notas: 250, 500 ou 1000 (ms) \n"
msg_play_again: 	.asciiz "Jogar novamente?\n 1 - Sim \n2 - Não\n"
msg_insercao_invalida: .asciiz "Inserção inválida."

.text

main: 
	la	$a0, msg_menu_1
	li	$v0, 4
	syscall
	
	la	$a0, msg_menu_2
	syscall
	
	li	$v0, 5
	syscall
	
	beq	$v0, 1, start_game
	beq	$v0, 2, end_game
	j	invalid_insertion
	
start_game:
	
	jal	draw_game
	
ativacoes:
	
	li	$v0, 4
	la	$a0, msg_ativacoes
	syscall
	
	li	$v0, 5
	syscall
	
	blez	$v0, invalid_insertion
	bgt	$v0, 32, invalid_insertion	
	
	move	$s0, $v0				# $s0 contém o número de ativações
		
tempo_ativacoes:

	li	$v0, 4
	la	$a0, msg_tempo
	syscall
	
	li	$v0, 5
	syscall
	
	sw	$v0, time 				# 

	beq	$v0, 250, game
	beq	$v0, 500, game
	beq	$v0, 1000, game

	j	invalid_insertion
	
	
play_again:
	
	li	$v0, 4
	la	$a0, msg_play_again
	syscall
	
	li	$v0, 5
	syscall
	
	bne	$v0, 1, end_game
=======
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
	j invalid_insertion
	
start_game:
	jal draw_game
ativacoes:	
	li $v0, 4
	la $a0, msg_ativacoes
	syscall
	
	li $v0, 5
	syscall
	
	bltz $v0, invalid_insertion
	bgt $v0, 32, invalid_insertion	
	
	move $s0, $v0
		
tempo_ativacoes:

	li $v0, 4
	la $a0, msg_tempo
	syscall
	li $v0, 5
	syscall
	move $s1, $v0 
	j end_game
	beq $v0, 250, end_game
	beq $v0, 500, end_game
	beq $v0, 1000, end_game
	j end_game 
	j invalid_insertion
	
	
play_again:

	li $v0, 32
	li $a0, 2000
	
	li $v0, 4
	la $a0, msg_play_again
	syscall
	li $v0, 5
	syscall
	
	bne $v0, 1, end_game
>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
	j main
	
invalid_insertion:
	
<<<<<<< HEAD
	li	$v0, 4
	la	$a0, msg_insercao_invalida
	syscall
	
	j	end_game
	
end_game:

	li	$v0, 10
	syscall
	
game:

		
	
	
#--------------------------------------------------Funções de desenhar--------------------------------------------------#

rectangle:
	

	beq	$a1, $zero, rectangleReturn # zero width: draw nothing
	beq	$a3, $zero, rectangleReturn # zero height: draw nothing

	la	$t1, frameBuffer
	add	$a1, $a1, $a0 # simplify loop tests by switching to first too-far value
	add	$a3, $a3, $a2
	sll	$a0, $a0, 2 # scale x values to bytes (4 bytes per pixel)
	sll	$a1, $a1, 2
	sll	$a2, $a2, 11 # scale y values to bytes (512*4 bytes per display row)
	sll	$a3, $a3, 11
	addu	$t2, $a2, $t1 # translate y values to display row starting addresses
	addu	$a3, $a3, $t1
	addu	$a2, $t2, $a0 # translate y values to rectangle row starting addresses
	addu	$a3, $a3, $a0
	addu	$t2, $t2, $a1 # and compute the ending address for first rectangle row
	li	$t4, 0x800 # bytes per display row

rectangleYloop:

	move	$t3, $a2 # pointer to current pixel for X loop; start at left edge

rectangleXloop:

	sw	$t0, ($t3)
	addiu	$t3, $t3, 4
	bne	$t3, $t2,rectangleXloop # keep going if not past the right edge of the rectangle

	addu	$a2, $a2, $t4 # advace one row worth for the left edge
	addu	$t2, $t2, $t4 # and right edge pointers
	bne	$a2, $a3, rectangleYloop # keep going if not off the bottom of the rectangle

rectangleReturn:

	jr	$ra

draw_game:
	
	addi	$sp, $sp, -24
	sw	$ra, 16($sp)
	
	li	$t0, 0xf9f270 	#amarelo apagado
	li	$a0,120		#cord x
	li	$a1,75		#largra
	li	$a2,90		#CORD Y
	li	$a3,75		#altura
	jal	rectangle

	li	$t0, 0x7bcaf2	#azul apagado
	li	$a0,220		#cord x
	li	$a1, 75		#largra
	li	$a2, 177		#CORD Y
	li	$a3, 75		#altura
	jal	rectangle

	li	$t0, 0x9cf691	#verde apagado
	li	$a0, 220		#cord x
	li	$a1, 75		#largra
	li	$a2, 5		#CORD Y
	li	$a3, 75		#altura
	jal	rectangle

	li	$t0, 0xf98383	#vermelho apagado
	li	$a0, 325		#cord x
	li	$a1, 75		#largra
	li	$a2, 90		#CORD Y
	li	$a3, 75		#altura
	jal	rectangle

	lw	$ra, 16($sp)
	addi	$sp, $sp, 24

	jr $ra

flash_yellow:

	addi	$sp, $sp, -24
	sw	$ra, 16($sp)

	li	$t0, 0xfff200 	#amarelo aceso
	li	$a0, 120		#cord x
	li	$a1, 75		#largura
	li	$a2, 90		#cord y
	li	$a3, 75		#altura
	jal	rectangle
	
	li	$v0, 33
=======
	li $v0, 4
	la $a0, msg_insercao_invalida
	syscall
	
	j end_game
	
	
end_game:

	li $v0, 10
	syscall
	
#------------------------------------Funcoes de desenhar-----------------------------------------------------------------

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

draw_game:
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

jr $ra

flash_yellow:

	li $t0, 0xfff200 # color: amarelo claro f9f270 amarelo escuro fff200
	li $a0,120		#cord x
	li $a1,75		#largra
	li $a2,90		#CORD Y
	li $a3,75		#altura
	jal rectangle
	
	li $v0, 33
>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
	li 	$a0, 67
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
<<<<<<< HEAD
	li	$t0, 0xf9f270 	#amarelo apagado
	li	$a0, 120		#cord x
	li	$a1, 75		#largura
	li	$a2, 90		#cord y
	li	$a3, 75		#altura
	jal	rectangle
	
	lw	$ra, 16($sp)
	addi	$sp, $sp, 24
	
	jr	$ra

flash_blue:

	addi	$sp, $sp, -24
	sw	$ra, 16($sp)

	li	$t0, 0x007ebe 	#azul aceso
	li	$a0, 220		#cord x
	li	$a1, 75		#largura
	li	$a2, 177		#CORD Y
	li	$a3, 75		#altura
	jal	rectangle
	
	li	$v0, 33
=======
	li $t0, 0xf9f270 # color: amarelo claro f9f270 amarelo escuro fff200
	li $a0,120		#cord x
	li $a1,75		#largra
	li $a2,90		#CORD Y
	li $a3,75		#altura
	jal rectangle
	
	jr $ra

flash_blue:

	li $t0, 0x007ebe 	#azul escuro 1275 azul claro 2452479
	li $a0,220		#cord x
	li $a1, 75		#largra
	li $a2, 177		#CORD Y
	li $a3, 75		#altura
	jal rectangle
	
	li $v0, 33
>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
	li 	$a0, 64
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
<<<<<<< HEAD
	li	$t0, 0x7bcaf2	#azul apagado
	li	$a0, 220		#cord x
	li	$a1, 75		#largura
	li	$a2, 177		#cord y
	li	$a3, 75		#altura
	jal	rectangle
	
	lw	$ra, 16($sp)
	addi	$sp, $sp, 24
	
=======
	li $t0, 0x7bcaf2	
	li $a0,220		#cord x
	li $a1, 75		#largra
	li $a2, 177		#CORD Y
	li $a3, 75		#altura
	jal rectangle

>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
	jr $ra
	
flash_green:

<<<<<<< HEAD
	addi	$sp, $sp, -24
	sw	$ra, 16($sp)

	li	$t0, 0x1dff00	#verde aceso
	li	$a0, 220		#cord x
	li	$a1, 75		#largura
	li	$a2, 5		#cord y
	li	$a3, 75		#altura
	jal	rectangle

	li	$v0, 33
=======
	li $t0, 0x1dff00	#505389 verde claro 587264 escuro
	li $a0, 220		#cord x
	li $a1, 75		#largra
	li $a2, 5		#CORD Y
	li $a3, 75		#altura
	jal rectangle

	li $v0, 33
>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
	li 	$a0, 62
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
	
<<<<<<< HEAD
	li	$t0, 0x9cf691	#verde apagado
	li 	$a0, 220		#cord x
	li	$a1, 75		#largura
	li	$a2, 5		#cord y
	li	$a3, 75		#altura
	jal	rectangle

	lw	$ra, 16($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
	
flash_red:

	addi	$sp, $sp, -24
	sw	$ra, 16($sp)
	
	move	$t1, $a0
	
	li	$t0, 0xfe0000	#vermelho aceso
	li	$a0,325		#cord x
	li	$a1,75		#largura
	li	$a2,90		#cord y
	li	$a3,75		#altura
	jal	rectangle
	
	li	$v0, 33
=======
	li $t0, 0x9cf691	#9cf691 verde claro 587264 escuro
	li $a0, 220		#cord x
	li $a1, 75		#largra
	li $a2, 5		#CORD Y
	li $a3, 75		#altura
	jal rectangle

	jr $ra
	
flash_red:
	#brilhar cor
	li $t0, 0xfe0000	#vermelho aceso 16711680 vermelho apagado: 12648962
	li $a0,325		#cord x
	li $a1,75		#largra
	li $a2,90		#CORD Y
	li $a3,75		#altura
	jal rectangle
	
	li $v0, 33
>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
	li 	$a0, 69
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
<<<<<<< HEAD
	lw	$a0, time
	li	$v0, 32
	syscall

	li	$t0, 0xf98383	#vermelho apagado
	li	$a0,325		#cord x
	li	$a1,75		#largura
	li	$a2,90		#cord y
	li	$a3,75		#altura
	jal	rectangle

	lw	$ra, 16($sp)
	addi	$sp, $sp, 24	
	
	jr	$ra

#--------------------------------------------------Funções das músicas--------------------------------------------------#

=======
	
	li $t0, 0xf98383	#vermelho aceso 16711680 vermelho apagado: 12648962
	li $a0,325		#cord x
	li $a1,75		#largra
	li $a2,90		#CORD Y
	li $a3,75		#altura
	jal rectangle
	
	jr $ra



#----------------------------------Funcoes de musica--------------------------------------------------
>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
victory_song:

#fa#
	li $v0, 33
	li $a0, 66
	li $a1,450
	li $a2, 72
	li $a3, 50
	syscall
#la
	li $v0, 33
	li $a0, 69
	li $a1, 300
	li $a2, 72
	li $a3, 50
	syscall
	
#dó
	li $v0, 33
	li $a0, 73
	li $a1, 250
	li $a2, 72
	li $a3, 50
	syscall
	
#la
	li $v0, 33
	li $a0, 69
	li $a1, 250
	li $a2, 72
	li $a3, 50
	syscall
	
#fa
	li $v0, 33
	li $a0, 66
	li $a1, 250
	li $a2, 72
	li $a3, 50
	syscall

#re
	li $v0, 33
	li $a0, 62
	li $a1, 100
	li $a2, 72
	li $a3, 50
	syscall
#re
	li $v0, 33
	li $a0, 62
	li $a1, 100
	li $a2, 72
	li $a3, 50
	syscall

#re
	li $v0, 33
	li $a0, 62
	li $a1, 100
	li $a2, 72
	li $a3, 50
	syscall	
	
	jr $ra

defeat_song:

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
<<<<<<< HEAD

=======
>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
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
<<<<<<< HEAD

=======
>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
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

<<<<<<< HEAD
	jr	$ra

#--------------------------------------------------Funções gerais--------------------------------------------------#

number_generator: 	

	addi	$sp, $sp, -24
	sw	$ra, 16($sp)
	
	li	$v0, 41
	syscall

	rem	$a0, $a0, 4
	bltz	$a0, convert

	jal	choose_colour
	
	lw	$ra, 16($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
	
convert:

	mul	$t1, $a0, -1
	move	$a0, $t1
	jal	choose_colour
	
	lw	$ra, 16($sp)
	addi	$sp, $sp, 24
	
	jr	$ra

choose_colour:

	addi	$sp, $sp, -24
	sw	$ra, 16($sp)	

 	beq	$a0, 0, acende_amarelo		
 	beq	$a0, 1, acende_azul
 	beq	$a0, 2, acende_verde
 	beq	$a0, 3, acende_vermelho
 	
 	acende_amarelo:
 		
 		jal	flash_yellow
 	
 		j	end_choose_colour
 	
	acende_azul:
		
		jal 	flash_blue
		
		j	end_choose_colour
		
	acende_verde:
	
		jal	flash_green
		
		j	end_choose_colour

	acende_vermelho:
	
		jal	flash_red
		
	end_choose_colour:
		
		lw	$ra, 16($sp)
		addi	$sp, $sp, 24
		
		jr	$ra
		
=======
jr $ra

#------------------------------------------Funcoes Gerais-------------------------------------------------

number_generator: 	
	li $v0, 41
	syscall

	rem $a0, $a0, 4
	bltz $a0, convert
	jal choose_note
	jr $ra
convert:
	mul 	$t1, $a0, -1
	move	$a0, $t1
	jal choose_note
	jr $ra

choose_note:
 	beq $a0, 0, end_game		#tentei jal flash_cor
 	beq $a0, 1, end_game
 	beq $a0, 2, end_game
 	beq $a0, 3, end_game
 	
 	jr $ra
 	

>>>>>>> cbf634c2b098869e593b74b82e13107d66495f32
