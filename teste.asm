.data 
	localArquivo: .asciiz "/home/lucaraj/Documentos/Mars Simulador/ProjetoMips/entrada.txt"
	conteudoArquivo: .space 1024
.text
	#abrir o arquivo no modo leitura
	li $v0, 13 #solicita a abertura
	la $a0, localArquivo #endereço do arquivo em $a0
	li $a1, 0 # 0: leitura; 1: escrita
	syscall #descritor do arquivo vai para $v0
	move $s0, $v0 #copia do descritor
	
	move $a0, $s0
	li $v0, 14 #ler conteúdo do arquivo referenciado por $a0
	la $a1, conteudoArquivo #buffer que armazena o conteúdo
	li $a2, 1024 #tamanho do buffer
	syscall #leitura realizada
	
	
	#imprimir o conteúdo do arquivo
	li $v0, 4
	move $a0, $a1
	syscall
	
	#fechar o arquivo
	li $v0, 16
	move $a0, $s0
	syscall