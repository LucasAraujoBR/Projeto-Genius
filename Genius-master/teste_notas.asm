.text

vermelho: 	
	#brilhar cor
	li $v0, 33
	li 	$a0, 69
	li	$a1, 1000
	li	$a2, 56
	li	$a3, 50
	syscall
	
azul:
	li $v0, 33
	li 	$a0, 64
	li 	$a1, 1000
	li	$a2, 56
	li	$a3, 50
	syscall

verde:
	li $v0, 33
	li 	$a0, 62
	li 	$a1, 1000
	li	$a2, 56
	li	$a3, 50
	syscall

amarelo:
	li $v0, 33
	li 	$a0, 67
	li 	$a1, 1000
	li	$a2, 56
	li	$a3, 50
	syscall
	j end_game
	
end_game:

	li $v0, 10
	syscall
	