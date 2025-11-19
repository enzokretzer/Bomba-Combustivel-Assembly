.data
	zeroD:			.double 0
	cemD:			.double 100
	milD:			.double 1000
	precoComum: 		.double 6.14
	precoAditivada:		.double 6.34
	precoAlcool:		.double 4.13
	
	keyTable:
		.byte	0x11,0x21,0x41,0x81
		.byte	0x12,0x22,0x42,0x82
		.byte	0x14,0x24,0x44,0x84
		.byte	0x18,0x28,0x48,0x88
		
	newline:	.asciiz "\n"
	iniciando:	.asciiz "=== INICIANDO SISTEMA DE BOMBA DE COMBUSTÍVEL ===\n\n"
	finalizando:	.asciiz "== FINALIZANDO SISTEMA DE BOMBA DE COMBUSTÍVEL ==\n"
	getCombM1:	.asciiz "Indique o Combustível desejado:\n"
	getCombM2:	.asciiz "1 - Gasolina Comum R$"
	getCombM3:	.asciiz "2 - Gasolina Aditivada R$"
	getCombM4:	.asciiz "3 - Álcool R$"
	ChangeCombM1:	.asciiz "Deseja modificar o preço dos combustíveis?\n"
	ChangeCombM2:	.asciiz "Modificando preço dos combustíveis...\n\n"
	ChangeCombM3:	.asciiz "Insira o novo valor para Gasolina Comum: "
	ChangeCombM4:	.asciiz "Insira o novo valor para Gasolina Aditivada: "
	ChangeCombM5:	.asciiz "Insira o novo valor para Álcool: "
	ChangeCombM6:	.asciiz "Valores alterados!\n\n"
	getPagM1:	.asciiz "Pagar combustível por:\n"
	getPagM2:	.asciiz "1 - Valor monetário\n"
	getPagM3:	.asciiz "2 - Litro\n\n"
	monetarioM:	.asciiz "Digite o valor pago (Duas casas após vírgula)\n"
	litrosM:	.asciiz "Digite quantos litros deseja encher\n"
	valorM:		.asciiz "Valor escolhido: "
	encherM:	.asciiz "Enchendo o tanque...\n"
	enchidoM:	.asciiz "Tanque enchido!\n\n"
	finalizaM:	.asciiz "Continuar rodando sistema?\n"
	simOptM:	.asciiz "1 - Sim\n"
	naoOptM:	.asciiz "2 - Não\n"
	
	notaBuffer:	.space 32
	notaNumBuffer:	.space 12
	notaTitleBuffer:.space 20
	notaPrecoBuffer:.space 64
	notaPrefix:	.asciiz "NotaFiscal-"
	notaSufix:	.asciiz ".txt"
	notaCarro:	.asciiz "CARRO "
	notaPrecoStart:	.asciiz "Total: "
	comb1:		.asciiz "Combustível: Gasolina Comum\n"
	comb2:		.asciiz "Combustível: Gasolina Aditivada\n"
	comb3:		.asciiz "Combustível: Álcool\n"
	comma:		.asciiz ","
	dot:		.asciiz "."
.text

main:
	li	$v0, 4
	la	$a0, iniciando
	syscall

	li	$s0, 1	# Iteração
	li	$s1, 1	# Sinal de continua programa (1 = continua)
	main_while:
		bne	$s1, 1, main_while_end	# while (continua)
		
		addi	$sp, $sp, -8
		sw	$s1, 4($sp)
		sw	$s0, 0($sp)
		
		jal	getCombustivel
		move	$s2, $v0	# $s2 recebe -> Combustivel solicitado
		
		lw	$s0, 0($sp)
		lw	$s1, 4($sp)
		addi	$sp, $sp, 8
		
		addi	$sp, $sp, -12
		sw	$s2, 8($sp)
		sw	$s1, 4($sp)
		sw	$s0, 0($sp)
		
		jal	getFormaPagamento
		move	$s3, $v0	# $s3 recebe -> Forma de pagamento
		
		lw	$s0, 0($sp)
		lw	$s1, 4($sp)
		lw	$s2, 8($sp)
		addi	$sp, $sp, 12
		
		addi	$sp, $sp, -16
		sw	$s3, 12($sp)
		sw	$s2, 8($sp)
		sw	$s1, 4($sp)
		sw	$s0, 0($sp)
		
		move	$a0, $s2
		jal	getPrecoLitro
		mov.d	$f20, $f0	# $f20 recebe -> Preco do litro
		
		lw	$s0, 0($sp)
		lw	$s1, 4($sp)
		lw	$s2, 8($sp)
		lw	$s3, 12($sp)
		addi	$sp, $sp, 16
		
		addi	$sp, $sp, -16
		sw	$s3, 12($sp)
		sw	$s2, 8($sp)
		sw	$s1, 4($sp)
		sw	$s0, 0($sp)
		
		move	$a0, $s3
		mov.d	$f12, $f20
		jal	pagarCombustivel
		mov.d	$f22, $f0	# $f22 recebe -> Total pago
		
		lw	$s0, 0($sp)
		lw	$s1, 4($sp)
		lw	$s2, 8($sp)
		lw	$s3, 12($sp)
		addi	$sp, $sp, 16
		
		addi	$sp, $sp, -16
		sw	$s3, 12($sp)
		sw	$s2, 8($sp)
		sw	$s1, 4($sp)
		sw	$s0, 0($sp)
		
		move	$a0, $s0
		move	$a1, $s2
		mov.d	$f12, $f22
		jal	emitirNotaFiscal
		
		lw	$s0, 0($sp)
		lw	$s1, 4($sp)
		lw	$s2, 8($sp)
		lw	$s3, 12($sp)
		addi	$sp, $sp, 16
		
		addi	$sp, $sp, -4
		sw	$s0, 0($sp)
		
		jal	getContinuaSist
		move	$s1, $v0	# $s1 recebe -> continuar (1) / não continuar (2)
		
		lw	$s0, 0($sp)
		addi	$sp, $sp, 4
		
		addi	$s0, $s0, 1
		j	main_while	# Retorna ao início do laço
	main_while_end:
	
	li	$v0, 4
	la	$a0, finalizando
	syscall				# Mensagem de finalização
		
	li	$v0, 10
	syscall
	

# getPrecoLitro recebe como argumento o combustivel solicitado pelo usuário
# e retorna o preço desse combustível
#
# $a0 -> Combustível solicitado
# $f0 -> Preço do combustível solicitado em double
getPrecoLitro:
	beq	$a0, 1, case_comum
	beq	$a0, 2, case_aditivada
	beq	$a0, 3, case_alcool
	l.d	$f0, zeroD		# Case Default - Retorna 0
	jr	$ra
	
	# Switch case comum
	case_comum:
		l.d	$f0, precoComum
		jr 	$ra
	case_aditivada:
		l.d	$f0, precoAditivada
		jr 	$ra
	case_alcool:
		l.d	$f0, precoAlcool
		jr 	$ra
	
		
# getHexKeyboardInput faz a leitura do teclado hexadecimal do Digital Lab Sim
# e retorna o input inserido pelo usuário.
#
# $v0 -> Valor recebido
getHexKeyboardInput:
	li	$s0, 0xFFFF0012		# Endereço de habilitação da linha
	li	$s1, 0xFFFF0014		# Endereço dos dados da tecla pressionada
	readLoopReset:
		li	$t0, 1			# Seletor da linha da tecla
		li	$t1, 0			# Contador de linha
		la	$s3, keyTable

	readLoop:
		beq	$t1, 4, readLoopReset	# Reinicia se já passou por todas as linhas

		sb	$t0, 0($s0)

		lb	$t3, 0($s1)
		bnez	$t3, rowIncrement	# Se dado em $t3 não for 0, linha da tecla pressionada encontrada
	
		addi	$t1, $t1, 1		# Incrementa o contador de linha
		sll	$t0, $t0, 1		# Vai para a próxima linha
		j	readLoop

	rowIncrement:
		mul	$t2, $t1, 4             # Offset = row * 4
		add	$s3, $s3, $t2		# $s3 aponta para o inicío da linha com tecla pressionada
		move	$t6, $zero
		j	findKey
	
	findKey:
		lb	$t5, 0($s3)
		beq	$t3, $t5, getValue	# Verifica em qual coluna está o valor pressionado
		addi	$t6, $t6, 1		# $s6 armazena a coluna atual (no fim, a da tecla pressionada)
		addi	$s3, $s3, 1		# Aponta para o próximo endereço da linha (próxima coluna)
		j	findKey

	getValue:
		mul	$t7, $t1, 4
		add	$v0, $t7, $t6		# $v0 armazena o valor escolhido (inteiro)
	
		j	waitRelease

	# Espera soltar o botão do teclado
	waitRelease:
		lb	$t5, 0($s1)
		bnez	$t5, waitRelease

		jr	$ra

# getCombustivel pede para o usuário inserir o combustível desejado
# para encher o tanque. Outro procedimento é chamado no processo, caso
# o frentista deseje alterar o preço dos combustíveis. Ao fim do procedimento
# o combustível selecionado pelo usuário é retornado.
#
# $v0 -> Combustível selecionado
getCombustivel:
	addi	$sp, $sp -4
	sw	$ra, 0($sp)
	jal	updatePrecoCombustivel	# Procedimento para atualização de preços
	
	# === Mensagens no console ===
	
	la	$a0, getCombM1
	li	$v0, 4
	syscall
	
	
	la	$a0, getCombM2
	syscall
	
	l.d	$f12, precoComum
	li	$v0, 3
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	la	$a0, getCombM3
	syscall
	
	l.d	$f12, precoAditivada
	li	$v0, 3
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	la	$a0, getCombM4
	syscall
	
	l.d	$f12, precoAlcool
	li	$v0, 3
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	# ============================
	
	# Verifica se o input escolhido é válido [1,3]
	validCombustivelLoop:
		jal	getHexKeyboardInput
		move	$t0, $v0
		seq	$t1, $t0, 0
		sgt	$t2, $t0, 3
		or	$t1, $t1, $t2
		bnez	$t1, validCombustivelLoop
	
	move	$v0, $t0
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

# updatePrecoCombustivel pede que o usuário (frentista) escolha os novos
# preços para os três combustíveis disponíveis.
#
# $v0 -> void	
updatePrecoCombustivel:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	# === Mensagens no console ===
	
	la	$a0, ChangeCombM1
	li	$v0, 4
	syscall
	
	la	$a0, simOptM
	li	$v0, 4
	syscall
	
	la	$a0, naoOptM
	li	$v0, 4
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	# Verifica se o input escolhido é válido [1,2]
	validPrecoCombustivelOpt:
		jal	getHexKeyboardInput	# Solicita input do teclado
		move	$t0, $v0
		seq	$t1, $t0, 0
		sgt	$t2, $t0, 2
		or	$t1, $t1, $t2
		bnez	$t1, validPrecoCombustivelOpt
	
	beq	$t0, 2, END_IF_CHANGE	# Vai para o fim do procedimento caso não deseje modificações (2)
	
	# === Mensagens no console ===
	
	la	$a0, ChangeCombM2
	li	$v0, 4
	syscall
	
	la	$a0, ChangeCombM3
	li	$v0, 4
	syscall
	
	jal	getDoubleValue		# Solicita double para novo valor do combustível
	s.d	$f0, precoComum		# Modifica preço da gasolina comum
	
	mov.d	$f12, $f0
	li	$v0, 3
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	la	$a0, ChangeCombM4
	li	$v0, 4
	syscall
	
	jal	getDoubleValue		# Solicita double para novo valor do combustível
	s.d	$f0, precoAditivada	# Modifica preço da gasolina aditivada
	
	mov.d	$f12, $f0
	li	$v0, 3
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	la	$a0, ChangeCombM5
	li	$v0, 4
	syscall
	
	jal	getDoubleValue		# Solicita double para novo valor do combustível
	s.d	$f0, precoAlcool	# Modifica preço do álcool
	
	mov.d	$f12, $f0
	li	$v0, 3
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	la	$a0, ChangeCombM6
	li	$v0, 4
	syscall
	
	# ============================
	
	END_IF_CHANGE:

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
# getFormaPagamento pede ao usuário a forma de pagamento desejada.
# O pagamento pode ser por valor monetário (1) ou por litros (2).
# Essa escolha é o retorno do procedimento.	
#
# $v0 -> Forma de pagamento selecionada
getFormaPagamento:
	addi	$sp, $sp -4
	sw	$ra, 0($sp)
	
	# === Mensagens no console ===
	
	la	$a0, getPagM1
	li	$v0, 4
	syscall
	
	la	$a0, getPagM2
	syscall
	
	la	$a0, getPagM3
	syscall
	
	# ============================
	
	# Verifica valores válidos de input [1,2]
	validPagamentoLoop:
		jal	getHexKeyboardInput	# Solicita input do teclado
		move	$t0, $v0
		seq	$t1, $t0, 0
		sgt	$t2, $t0, 2
		or	$t1, $t1, $t2
		bnez	$t1, validPagamentoLoop
	
	move	$v0, $t0
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

# getDoubleValue solicita diversos inputs ao teclado. Retorna um valor Double com
# duas casas decimais. O input inserido pelo usuário deve sempre ser um valor com duas casas decimais.
# Não é possível inserir menos de dois números. Exemplo de valor válido 12340 -> (123,40).
#	
# $f0 -> retorna o double inserido pelo usuário
getDoubleValue:
	addi	$sp, $sp -4
	sw	$ra, 0($sp)
	
	move	$s0, $zero
	getDoubleValueLoop:
		# Verifica se o input está no intervalo [0,10]
		# Não permite que o primeiro valor seja zero (zero à esquerda)
		# Valor 10 (botão A) serve para terminar a inserção de números
		validDoubleValueLoop:
			addi	$sp, $sp -4
			sw	$s0, 0($sp)
			
			jal	getHexKeyboardInput
			move	$t1, $v0
			
			lw	$s0, 0($sp)
			addi	$sp, $sp, 4
			
			bnez	$s0, contDouble			# Apenas na primeira iteração
			beqz	$t1, validDoubleValueLoop	# Não adiciona zeros à esquerda
			contDouble:
			sgt	$t2, $t1, 10
			bnez	$t2, validDoubleValueLoop
			
		beq	$t1, 10, endDoubleValueLoop
		addi	$sp, $sp, -4
		sw	$t1, 0($sp)				# Adiciona valores escolhidos na pilha
		addi	$s0, $s0, 1				# Contador de numeros escolhidos
		j	getDoubleValueLoop
		
	endDoubleValueLoop:
		slti	$t5, $s0, 2
		bnez	$t5, getDoubleValueLoop		# Input inválido (menos que 2 números selecionados)
		move	$t1, $zero			# Iterador (verificação de números retirados da pilha)
		li	$t2, 1				# Multiplicador
		move	$t4, $zero
	translateDoubleValue:
		lw	$t3, 0($sp)			# Retira valor da pilha
		mul	$t3, $t3, $t2			# Pega seu valor de acordo com sua posição (unidade, dezena, centena...)
		add	$t4, $t4, $t3
		addi	$t1, $t1, 1
		addi	$sp, $sp, 4
		mul	$t2, $t2, 10			# Aumenta a posição (multiplica por 10)
		bne	$t1, $s0, translateDoubleValue	# Verifica se todos os números foram retirados da pilha
		
	# Transforma o número em double
	mtc1	$t4, $f4
	cvt.d.w	$f4, $f4
	l.d	$f6, cemD
	div.d	$f4, $f4, $f6	# Divide por 100 (dois últimos números representam as casas decimais)
	mov.d	$f0, $f4
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

# getIntValue solicita vários inputs do teclado decimal para retornar um
# número inteiro com mais de apenas um algarismo. Não que o primeiro número seja zero
# (zero à esquerda).
#
# $v0 -> Valor inteiro obtido	
getIntValue:
	addi	$sp, $sp -4
	sw	$ra, 0($sp)
	
	move	$s0, $zero
	getIntValueLoop:
		# Verifica se o input está no intervalo [0,10]
		# Não permite que o primeiro valor seja zero (zero à esquerda)
		# Valor 10 (botão A) serve para terminar a inserção de números
		validIntValueLoop:
			addi	$sp, $sp -4
			sw	$s0, 0($sp)
			
			jal	getHexKeyboardInput
			move	$t1, $v0
			
			lw	$s0, 0($sp)
			addi	$sp, $sp, 4
			
			bnez	$s0, contInt		# Apenas na primeira iteração
			beqz	$t1, validIntValueLoop	# Não adiciona zeros à esquerda
			contInt:
			sgt	$t2, $t1, 10
			bnez	$t2, validIntValueLoop
			
		beq	$t1, 10, endIntValueLoop
		addi	$sp, $sp, -4
		sw	$t1, 0($sp)
		addi	$s0, $s0, 1
		j	getIntValueLoop
		
	endIntValueLoop:
		beqz	$s0, getIntValueLoop		# Se nenhum valor foi inserido, volta pra inserção
		move	$t1, $zero			# Iterador (verificação de números retirados da pilha)
		li	$t2, 1				# Multiplicador
		move	$t4, $zero
	translateIntValue:
		lw	$t3, 0($sp)			# Retira valor da pilha
		mul	$t3, $t3, $t2			# Pega seu valor de acordo com sua posição (unidade, dezena, centena...)
		add	$t4, $t4, $t3
		addi	$t1, $t1, 1
		addi	$sp, $sp, 4
		mul	$t2, $t2, 10			# Aumenta a posição (multiplica por 10)
		bne	$t1, $s0, translateIntValue	# Verifica se todos os números foram retirados da pilha
		
	move	$v0, $t4
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
# encher recebe como argumento a quantidade de milissegundos que a bomba ficará
# enchendo o tanque do carro. Semelhante à uma função sleep em C.
#
# $a0 -> Duração da espera em milissegundos
# $v0 -> void
encher:
	move	$t0, $a0
	
	la	$a0, encherM
	li	$v0, 4
	syscall
	
	li	$v0, 30
	syscall
	
	add	$t1, $t0, $a0
	
	encher_loop:
		li	$v0, 30
		syscall
		
		blt	$a0, $t1, encher_loop
		
	la	$a0, enchidoM
	li	$v0, 4
	syscall
	
	jr	$ra

# pagarCombustivel recebe a forma de pagamento e o preço do combustível selecionado. A
# partir disso é calculado e retornado o valor total a ser pago. Além disso, também é calculado
# o tempo que a bomba ficara enchendo o tanque. Se a forma de pagamento for valor monetário, o
# total a ser pago já está pronto e o tempo de enchimento é (valor / preco_litro). Se a forma de
# pagamento for por litro, o tempo de enchimento já está pronto e o valor a ser pago é
# (litro * preco_litro).
#
# $a0 -> forma de pagamento
# $f12 -> preco do combustivel escolhido
# $f0 -> preco pago
pagarCombustivel:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	IF_PAG:		# Se pagamento é por valor monetário
	bne	$a0, 1, ELSE_PAG
	
	la	$a0, monetarioM
	li	$v0, 4
	syscall
	
	jal	getDoubleValue	# Solicita quantia que será paga
	mov.d	$f4, $f0
	
	mov.d	$f6, $f12	# Salva valor de $f12 (será sujado)
	
	# ==== Mensagens no console ===
	
	li	$v0, 4
	la	$a0, valorM
	syscall
	
	li	$v0, 3
	mov.d	$f12, $f4	# Suja $f12
	syscall
	
	li	$v0, 4
	la	$a0, newline
	syscall
	
	# ============================
	
	div.d	$f6, $f4, $f6	# (valor / preco_litro)
	l.d	$f8, milD	# Multiplica por mil (tempo em milissegundos)
	mul.d	$f6, $f6, $f8
	cvt.w.d	$f6, $f6	# Converte para inteiro (tipo correto para 'encher')
	mfc1	$t1, $f6	# Armazena em $t1 o tempo de enchimento
	mov.d	$f0, $f4
	j	END_IF_PAG
	
	ELSE_PAG:	# Se pagamento é por litro
	
	la	$a0, litrosM
	li	$v0, 4
	syscall
	
	jal	getIntValue	# Solicita quantidade de litros a serem enchidos
	move	$s0, $v0
	
	# ==== Mensagens no console ===
	
	li	$v0, 4
	la	$a0, valorM
	syscall
	
	li	$v0, 1
	move	$a0, $s0
	syscall
	
	li	$v0, 4
	la	$a0, newline
	syscall
	
	# ============================
	
	mul	$t0, $s0, 1000
	move	$t1, $t0	# Armazena em $t1 o tempo de enchimento
	
	mtc1	$s0, $f4
	cvt.d.w	$f4, $f4	# Converte a quantidade de litros em Double
	mul.d	$f6, $f4, $f12	# (litro * preco_litro)
	mov.d	$f0, $f6
	
	END_IF_PAG:
	
	move	$a0, $t1
	jal	encher		# Enche o tanque
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

# getContinuaSist pergunta ao usuário se deseja continuar o sistema (abastacer mais um carro).
# retorna sim ou não (1 ou 2).
#
# $v0 -> retorna 1 / 2	
getContinuaSist:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	la	$a0, finalizaM
	li	$v0, 4
	syscall
	
	la	$a0, simOptM
	li	$v0, 4
	syscall
	
	la	$a0, naoOptM
	li	$v0, 4
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	validFinalizaOpt:
		jal	getHexKeyboardInput
		move	$t0, $v0
		seq	$t1, $t0, 0
		sgt	$t2, $t0, 2
		or	$t1, $t1, $t2
		bnez	$t1, validFinalizaOpt
	move	$v0, $t0
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

# emitirNotaFiscal escreve os dados do abastecimento em um arquivo .txt. Recebe como
# argumento o número do carro (iterações do sistema) o tipo de combustível escolhido
# e o preço que foi pago.
#
# $a0  -> Número do carro
# $a1  -> Tipo de combustível
# $f12 -> Preço pago
# $v0  -> void
emitirNotaFiscal:
	# === Escreve num buffer o número do carro ===
	
	la	$s0, notaNumBuffer
	move	$t0, $a0
	li	$t1, 10
	move	$t4, $zero
	
	itoa_push:
		div	$t0, $t1
		mflo	$t0
		mfhi	$t2
		addi	$t2, $t2, 48
		
		addi	$sp, $sp, -4
		sw	$t2, 0($sp)
		addi	$t4, $t4, 1
		
		bnez	$t0, itoa_push
	
	itoa_pop:
		beqz	$t4, itoa_end
		
		lw	$t2, 0($sp)
		addi	$sp, $sp, 4
		
		sb	$t2, 0($s0)
		addi	$s0, $s0, 1
		addi	$t4, $t4, -1
		j	itoa_pop
	itoa_end:
	
	# === Escreve num buffer o nome do arquivo ===
	# Estrutura do nome: NotaFiscal-XX.txt
	
	# Copia para o buffer o prefixo 'NotaFiscal-'
	la	$s0, notaBuffer
	la	$t0, notaPrefix
	prefixLoop:
		lb	$t1, 0($t0)
		beqz	$t1, prefixLoopEnd
		sb	$t1, 0($s0)
		addi	$t0, $t0, 1
		addi	$s0, $s0, 1
		j	prefixLoop
	prefixLoopEnd:
	
	# Copia para o buffer o número do carro 'XX'
	la	$t0, notaNumBuffer
	itLoop:
		lb	$t1, 0($t0)
		beqz	$t1, itLoopEnd
		sb	$t1, 0($s0)
		addi	$t0, $t0, 1
		addi	$s0, $s0, 1
		j	itLoop
	itLoopEnd:
	
	# Copia para o buffer o sufixo (formato do arquivo) '.txt'
	la	$t0, notaSufix
	sufixLoop:
		lb	$t1, 0($t0)
		sb	$t1, 0($s0)
		addi	$s0, $s0, 1
		addi	$t0, $t0, 1
		bnez	$t1, sufixLoop
		
	addi	$sp, $sp, 4
	sw	$a1, 0($sp)
		
	li	$v0, 13
	la	$a0, notaBuffer
	li	$a1, 1
	li	$a2, 0
	syscall			# Faz a abertura do arquivo com o nome escrito no buffer anterior
	move	$s1, $v0
	
	# === Escreve num buffer o título (primeira linha do arquivo) ===
	# Estrutura: CARRO X
	
	# Copia para o buffer o início do título 'CARRO '
	la	$s0, notaTitleBuffer
	la	$t0, notaCarro
	move	$t3, $zero
	titleStartLoop:
		lb	$t1, 0($t0)
		beqz	$t1, titleStartLoopEnd
		sb	$t1, 0($s0)
		addi	$t0, $t0, 1
		addi	$s0, $s0, 1
		addi	$t3, $t3, 1
		j	titleStartLoop
	titleStartLoopEnd:
	
	# Copia para o buffer o número do carro 'X'
	la	$t0, notaNumBuffer
	titleMiddleLoop:
		lb	$t1, 0($t0)
		beqz	$t1, titleMiddleLoopEnd
		sb	$t1, 0($s0)
		addi	$t0, $t0, 1
		addi	$s0, $s0, 1
		addi	$t3, $t3, 1
		j	titleMiddleLoop
	titleMiddleLoopEnd:
	
	# Adiciona ao fim do buffer um caractere de nova linha
	la	$t0, newline
	lb	$t1, 0($t0)
	sb	$t1, 0($s0)
	addi	$s0, $s0, 1
	addi	$t3, $t3, 1

		
	li	$v0, 15
	move	$a0, $s1
	la	$a1, notaTitleBuffer
	move	$a2, $t3
	syscall			# Escreve o título no arquivo
	
	lw	$a2, 0($sp)
	addi	$sp, $sp, 4
	
	# === Escreve no arquivo o combustível escolhido ===
	
	# Switch case para ver qual combustível foi escolhido
	beq	$a2, 1, IF_COMB_COMUM
	beq	$a2, 2, IF_COMB_COMUM
	beq	$a2, 3, IF_COMB_ALCOOL
	
	# Pega o texto de acordo com o combustível
	IF_COMB_COMUM:
		la	$a1, comb1
		li	$a2, 28
	IF_COMB_ADITIVADA:
		la	$a1, comb2
		li	$a2, 32
	IF_COMB_ALCOOL:
		la	$a1, comb3
		li	$a2, 20
	END_IF_COMB:
	
	li	$v0, 15
	move	$a0, $s1
	syscall			# Escreve o combustível escolhido no arquivo
	
	
	# === Escreve num buffer o preco pago pelo abastecimento ===
	# Estrutura: Total: (valor)
	
	la	$s0, notaPrecoBuffer
	move	$t3, $zero
	
	
	# Copia o início da linha para o buffer 'Total: '
	la	$t0, notaPrecoStart
	precoLoop:
		lb	$t1, 0($t0)
		beqz	$t1, precoLoopEnd
		sb	$t1, 0($s0)
		addi	$t0, $t0, 1
		addi	$s0, $s0, 1
		addi	$t3, $t3, 1
		j	precoLoop
	precoLoopEnd:
		
	# Separa parte decimal e parte inteira do valor pago
	trunc.w.d	$f4, $f12
	mfc1		$t5, $f4	# $t5 -> parte inteira
		
	cvt.d.w		$f4, $f4
	sub.d		$f6, $f12, $f4
	l.d		$f4, cemD
	mul.d		$f6, $f6, $f4
	round.w.d	$f4, $f6
	mfc1		$t6, $f4	# $t6 -> parte decimal	
	
	# Escreve no buffer a parte inteira
	move	$t0, $t5
	li	$t1, 10
	move	$t4, $zero
	ftoa_int_push:
		div	$t0, $t1
		mflo	$t0
		mfhi	$t2
		addi	$t2, $t2, 48
		
		addi	$sp, $sp, -4
		sw	$t2, 0($sp)
		addi	$t4, $t4, 1
		
		bnez	$t0, ftoa_int_push
	
	rem	$t7, $t4, 3
	bnez	$t7, ftoa_int_pop
	li	$t7, 3			# $t7 é um controlador para separação do número (XX.XXX)
	ftoa_int_pop:
		beqz	$t4, ftoa_int_end
		
		lw	$t2, 0($sp)
		addi	$sp, $sp, 4
		
		sb	$t2, 0($s0)
		addi	$s0, $s0, 1
		addi	$t4, $t4, -1
		addi	$t3, $t3, 1
		addi	$t7, $t7, -1
		bnez	$t7, ftoa_int_pop	# Se $t7 chega a 0, precisa adicionar um '.'
		beqz	$t4, ftoa_int_end
		# Adição do '.' caso $t7 == 0 e ainda restem números para adicionar
		la	$t7, dot
		lb	$t2, 0($t7)
		sb	$t2, 0($s0)
		addi	$s0, $s0, 1
		addi	$t3, $t3, 1
		li	$t7, 3
		j	ftoa_int_pop
	ftoa_int_end:
	
	# Adicionar uma vírgula
	la	$t0, comma
	lb	$t2, 0($t0)
	sb	$t2, 0($s0)
	addi	$s0, $s0, 1
	addi	$t3, $t3, 1
	
	# Copia os dois dígitos para as casas decimais
	move	$t0, $t6
	li	$t1, 10
	move	$t4, $zero
	ftoa_dec_push:
		div	$t0, $t1
		mflo	$t0
		mfhi	$t2
		addi	$t2, $t2, 48
		
		addi	$sp, $sp, -4
		sw	$t2, 0($sp)
		addi	$t4, $t4, 1
		
		bnez	$t0, ftoa_dec_push
	
	move	$t6, $zero
	ftoa_dec_pop:
		beqz	$t4, ftoa_dec_end

		lw	$t2, 0($sp)
		addi	$sp, $sp, 4
		
		sb	$t2, 0($s0)
		addi	$s0, $s0, 1
		addi	$t4, $t4, -1
		addi	$t3, $t3, 1
		addi	$t6, $t6, 1
		j	ftoa_dec_pop
	ftoa_dec_end:
		
	li	$v0, 15
	move	$a0, $s1
	la	$a1, notaPrecoBuffer
	move	$a2, $t3
	syscall			# Escreve no arquivo o total pago
	
	li	$v0, 16
	move	$a0, $s1
	syscall			# Fecha o arquivo salvando as mudanças feitas
		
	jr	$ra
