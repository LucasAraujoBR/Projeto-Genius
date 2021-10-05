.data

frameBuffer:	.space 0x80000

time:			.word 0
num_actv:		.word 0

array:		.word 0:32		# Vetor que armazena a sequência do jogo

key_flag:		.word 0
key_value:		.word 0

msg_menu_1:		.asciiz "1 - Iniciar o jogo\n"
msg_menu_2:		.asciiz "2 - Encerrar programa\n"
msg_ativacoes:	.asciiz "Insira o número de ativações (máx 32): \n"
msg_tempo:		.asciiz "Insira o tempo das notas: 250, 500 ou 1000 (ms) \n"
msg_play_again: 	.asciiz "Jogar novamente?\n 1 - Sim \n2 - Não\n"
msg_insercao_invalida: .asciiz "Inserção inválida."

.text

main: 
	la	$gp, time
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
	move	$s1, $v0
	
	sw	$v0, time 				

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
	j main
	
invalid_insertion:
	
	li	$v0, 4
	la	$a0, msg_insercao_invalida
	syscall
	
	j	end_game
	
end_game:

	li	$v0, 10
	syscall
	
game:

	# ativar interrupção do teclado
	la	$t0, 0xffff0000
	li	$t4, 0x2
	sw	$t4, 0($t0)

	jal number_generator

	li	$s7, 1	# variável auxiliar "j"
	
	#passar para o $a0 o número contido no array para o choose_colour e então piscar a cor correspondente
	
	check_for_geral:
	ble	$s7, $s0, for_geral
	j	end_game	# checar se vai para o end_game mesmo
	
	for_geral:
		
		li	$s6, 0	# variável auxiliar "i"
		la	$s5, array
		
		check_for_1:
		
		blt	$s6, $s7, for_1
		j	end_for_1	# checar se vai para o end_game mesmo
			
		for_1:
			lw	$a0, 0($s5) 
		
			jal	choose_colour
			
			addi	$s6, $s6, 1
			addi	$s5, $s5, 4	# vai para a próxima posição do vetor
			j	check_for_1
			
		end_for_1:
		
		li	$s6, 0
		la	$s5, array
		
		check_for_2:			# for_2 pega a tecla que o usuário digitou 
			
		blt	$s6, $s7, for_2
		j	end_for_2
			
		for_2:
		
		key_loop:
		# if(key_flag)
		lw	$t4, key_flag
		beqz	$t4, skip
			li	$t4, 0
			sw	$t4, key_flag		# zera a flag
			lw	$t4, key_value		# carrega valor da tecla
			# escreve no display a tecla pressionada
			beq	$t4,'a', check_amarelo
			beq	$t4,'s', check_azul
			beq	$t4,'w', check_verde
			beq	$t4,'d', check_vermelho
			jal defeat_song
			j invalid_insertion
			
			check_amarelo:
			
			 	lw $t3, 0($s5)
			 	beq $t3, 0, end_key_loop
			 	jal defeat_song
				j end_game
			
			check_azul:
			
				lw $t3, 0($s5)
				beq $t3, 1, end_key_loop
				jal defeat_song	
				j end_game
				
			check_verde:
				
				lw $t3, 0($s5)
				beq $t3, 2, end_key_loop
				jal defeat_song
				j end_game
			
			check_vermelho:
			
				lw $t3, 0($s5)	
				beq $t3, 3, end_key_loop
				jal defeat_song	
				j end_game 	 
		skip:
		j	key_loop
		end_key_loop:
		
		move	$a0, $t3
		jal	choose_colour
		addi	$s6, $s6, 1
		addi	$s5, $s5, 4
		j	check_for_2
		
		end_for_2:
		
	addi	$s7, $s7, 1
			
	j	check_for_geral
		
	end_for_geral:
	
	jal	victory_song
	
	j	end_game
		
		
			
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
	li 	$a0, 67
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
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
	li 	$a0, 64
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
	li	$t0, 0x7bcaf2	#azul apagado
	li	$a0, 220		#cord x
	li	$a1, 75		#largura
	li	$a2, 177		#cord y
	li	$a3, 75		#altura
	jal	rectangle
	
	lw	$ra, 16($sp)
	addi	$sp, $sp, 24
	
	jr $ra
	
flash_green:

	addi	$sp, $sp, -24
	sw	$ra, 16($sp)

	li	$t0, 0x1dff00	#verde aceso
	li	$a0, 220		#cord x
	li	$a1, 75		#largura
	li	$a2, 5		#cord y
	li	$a3, 75		#altura
	jal	rectangle

	li	$v0, 33
	li 	$a0, 62
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
	
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
	li 	$a0, 69
	move	$a1, $s1
	li	$a2, 56
	li	$a3, 50
	syscall
	
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

	jr	$ra

#--------------------------------------------------Funções gerais--------------------------------------------------#

number_generator: 	

	la $a1, array
	move $t0, $s0
	
	for:
	li	$v0, 41
	syscall

	rem	$a0, $a0, 4
	bltz	$a0, convert
	
	convert_exit:
	
	sw $a0, ($a1)
	beq $t0, 1, for_exit
	addi $a1, $a1, 4
	addi $t0, $t0, -1
	j for
	
	
	#lw	$ra, 16($sp)
	#addi	$sp, $sp, 24

convert:

	mul	$t5, $a0, -1
	move	$a0, $t5
	#jal	choose_colour
	#lw	$ra, 16($sp)
	#addi	$sp, $sp, 24
	j convert_exit
	
for_exit:

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
		
.kdata
temp_regs: .space 8


.ktext 0x80000180
move	$k1, $at			# salva o $at pois instruções podem modificá-lo sem querer

la	$k0, temp_regs		# carrega local para salvar o estado de registradores que queremos usar
sw	$a0, 0($k0)			# salva $a0, pois será usado na interrupção
sw	$a1, 4($k0)			# salva $a1, pois será usado na interrupção

mfc0	$k0, $13			# pega o registrador de causa
srl	$a0, $k0, 2			# * passo 1 para testar se foi exceção
andi	$a0, $a0, 0xf		# * passo 2 para testar se foi exceção
beqz	$a0, interrupt_handler	# se $a0 for 0, foi interrupção e não exceção

# trata exceção finalizando o programa
li	$v0, 10
syscall

interrupt_handler:
andi	$a0, $k0, 0x0100		# limpa todos os bits, exceto o bit 2 (interrupção do teclado)
beqz	$a0, exit_kernel		# se for 0, não foi a interrupção do teclado

# trata interrupção do teclado
li	$a0, 1
sw	$a0, key_flag
la	$a0, 0xffff0004
lw	$a0, 0($a0)
sw	$a0, key_value

exit_kernel:
la	$k0, temp_regs		# recuperação dos registradores usados
lw	$a0, 0($k0)
lw	$a1, 4($k0)
move	$at, $k1
eret
