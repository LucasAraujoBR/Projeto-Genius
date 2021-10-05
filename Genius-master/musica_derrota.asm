.text

#Parte 1:
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
	
exit:
	li $v0, 10
	syscall