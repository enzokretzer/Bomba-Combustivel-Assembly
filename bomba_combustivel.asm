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
	li	$s1, 1	# Sinal de continua
	main_while:
		bne	$s1, 1, main_while_end
		
		addi	$sp, $sp, -8
		sw	$s1, 4($sp)
		sw	$s0, 0($sp)
		
		jal	getCombustivel
		move	$s2, $v0	# Combustivel solicitado
		
		lw	$s0, 0($sp)
		lw	$s1, 4($sp)
		addi	$sp, $sp, 8
		
		addi	$sp, $sp, -12
		sw	$s2, 8($sp)
		sw	$s1, 4($sp)
		sw	$s0, 0($sp)
		
		jal	getFormaPagamento
		move	$s3, $v0	# Forma de pagamento
		
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
		mov.d	$f20, $f0	# Preco do litro
		
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
		mov.d	$f22, $f0
		
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
		move	$s1, $v0
		
		lw	$s0, 0($sp)
		addi	$sp, $sp, 4
		
		addi	$s0, $s0, 1
		j	main_while
	main_while_end:
	
	li	$v0, 4
	la	$a0, finalizando
	syscall
		
	li	$v0, 10
	syscall
	
# $a0 -> Combustível solicitado
# $f0 -> Preço do combustível solicitado em double
getPrecoLitro:
	beq	$a0, 1, case_comum
	beq	$a0, 2, case_aditivada
	beq	$a0, 3, case_alcool
	l.d	$f0, zeroD
	jr	$ra
	
	case_comum:
		l.d	$f0, precoComum
		jr 	$ra
	case_aditivada:
		l.d	$f0, precoAditivada
		jr 	$ra
	case_alcool:
		l.d	$f0, precoAlcool
		jr 	$ra
		
# $v0 -> Valor recebido
getHexKeyboardInput:
	li	$s0, 0xFFFF0012		# line enable address
	li	$s1, 0xFFFF0014		# key pressed data address
	readLoopReset:
		li	$t0, 1			# key row selector
		li	$t1, 0			# row counter
		la	$s3, keyTable

	readLoop:
		beq	$t1, 4, readLoopReset	# if 4 rows are read, reset

		sb	$t0, 0($s0)		# enabling line

		lb	$t3, 0($s1)		# loading data in register
		bnez	$t3, rowIncrement	# if not zero, key read
	
		addi	$t1, $t1, 1		# incrementing counter
		sll	$t0, $t0, 1		# going to next row
		j	readLoop

	rowIncrement:
		mul	$t2, $t1, 4             # offset = row * 4
		add	$s3, $s3, $t2
		move	$t6, $zero
		j	findKey
	
	findKey:
		lb	$t5, 0($s3)		# loading keyTable first value
		beq	$t3, $t5, getValue 	# checking if equal
		addi	$t6, $t6, 1		# incrementing if not equal
		addi	$s3, $s3, 1
		j	findKey

	getValue:
		mul	$t7, $t1, 4
		add	$v0, $t7, $t6
	
		j	waitRelease

	waitRelease:
		lb	$t5, 0($s1)		# read key output
		bnez	$t5, waitRelease	# repeat while not zero (key pressed)

		jr	$ra
		
# $v0 -> Combustível selecionado
getCombustivel:
	addi	$sp, $sp -4
	sw	$ra, 0($sp)
	jal	updatePrecoCombustivel
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

# Não retorna nada	
updatePrecoCombustivel:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
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
	validPrecoCombustivelOpt:
		jal	getHexKeyboardInput
		move	$t0, $v0
		seq	$t1, $t0, 0
		sgt	$t2, $t0, 2
		or	$t1, $t1, $t2
		bnez	$t1, validPrecoCombustivelOpt
	
	beq	$t0, 2, END_IF_CHANGE
	
	la	$a0, ChangeCombM2
	li	$v0, 4
	syscall
	
	la	$a0, ChangeCombM3
	li	$v0, 4
	syscall
	
	jal	getDoubleValue
	s.d	$f0, precoComum
	
	mov.d	$f12, $f0
	li	$v0, 3
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	la	$a0, ChangeCombM4
	li	$v0, 4
	syscall
	
	jal	getDoubleValue
	s.d	$f0, precoAditivada
	
	mov.d	$f12, $f0
	li	$v0, 3
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	la	$a0, ChangeCombM5
	li	$v0, 4
	syscall
	
	jal	getDoubleValue
	s.d	$f0, precoAlcool
	
	mov.d	$f12, $f0
	li	$v0, 3
	syscall
	
	la	$a0, newline
	li	$v0, 4
	syscall
	
	la	$a0, ChangeCombM6
	li	$v0, 4
	syscall
	
	END_IF_CHANGE:

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
# $v0 -> Forma de pagamento selecionada
getFormaPagamento:
	addi	$sp, $sp -4
	sw	$ra, 0($sp)
	
	la	$a0, getPagM1
	li	$v0, 4
	syscall
	
	la	$a0, getPagM2
	syscall
	
	la	$a0, getPagM3
	syscall
	validPagamentoLoop:
		jal	getHexKeyboardInput
		move	$t0, $v0
		seq	$t1, $t0, 0
		sgt	$t2, $t0, 2
		or	$t1, $t1, $t2
		bnez	$t1, validPagamentoLoop
	
	move	$v0, $t0
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
# $f0 -> retorna um valor 
getDoubleValue:
	addi	$sp, $sp -4
	sw	$ra, 0($sp)
	
	move	$s0, $zero
	getDoubleValueLoop:
		validDoubleValueLoop:
			addi	$sp, $sp -4
			sw	$s0, 0($sp)
			
			jal	getHexKeyboardInput
			move	$t1, $v0
			
			lw	$s0, 0($sp)
			addi	$sp, $sp, 4
			
			bnez	$s0, contDouble		# Apenas na primeira iteração
			beqz	$t1, validDoubleValueLoop	# Não adiciona zeros à esquerda
			contDouble:
			sgt	$t2, $t1, 10
			bnez	$t2, validDoubleValueLoop
			
		beq	$t1, 10, endDoubleValueLoop
		addi	$sp, $sp, -4
		sw	$t1, 0($sp)
		addi	$s0, $s0, 1
		j	getDoubleValueLoop
		
	endDoubleValueLoop:
		slti	$t5, $s0, 2
		bnez	$t5, getDoubleValueLoop
		move	$t1, $zero	#iterador
		li	$t2, 1		# multiplicador
		move	$t4, $zero
	translateDoubleValue:
		lw	$t3, 0($sp)
		mul	$t3, $t3, $t2
		add	$t4, $t4, $t3
		addi	$t1, $t1, 1
		addi	$sp, $sp, 4
		mul	$t2, $t2, 10
		bne	$t1, $s0, translateDoubleValue
		
	mtc1	$t4, $f4
	cvt.d.w	$f4, $f4
	l.d	$f6, cemD
	div.d	$f4, $f4, $f6
	mov.d	$f0, $f4
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

# $v0 -> Valor inteiro obtido	
getIntValue:
	addi	$sp, $sp -4
	sw	$ra, 0($sp)
	
	move	$s0, $zero
	getIntValueLoop:
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
		beqz	$s0, getIntValueLoop
		move	$t1, $zero	#iterador
		li	$t2, 1		# multiplicador
		move	$t4, $zero
	translateIntValue:
		lw	$t3, 0($sp)
		mul	$t3, $t3, $t2
		add	$t4, $t4, $t3
		addi	$t1, $t1, 1
		addi	$sp, $sp, 4
		mul	$t2, $t2, 10
		bne	$t1, $s0, translateIntValue
		
	move	$v0, $t4
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
# $a0 -> Duração da espera em milissegundos
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
	
# $a0 -> forma de pagamento
# $f12 -> preco do combustivel escolhido
# $f0 -> preco pago
pagarCombustivel:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	IF_PAG:
	bne	$a0, 1, ELSE_PAG
	
	la	$a0, monetarioM
	li	$v0, 4
	syscall
	
	jal	getDoubleValue
	mov.d	$f4, $f0
	div.d	$f6, $f4, $f12
	l.d	$f8, milD
	mul.d	$f6, $f6, $f8
	cvt.w.d	$f6, $f6
	mfc1	$a0, $f6
	jal	encher
	mov.d	$f0, $f4
	j	END_IF_PAG
	
	ELSE_PAG:
	
	la	$a0, litrosM
	li	$v0, 4
	syscall
	
	jal	getIntValue
	move	$s0, $v0
	mul	$t0, $s0, 1000
	move	$a0, $t0
	jal	encher
	mtc1	$s0, $f4
	cvt.d.w	$f4, $f4
	mul.d	$f6, $f4, $f12
	mov.d	$f0, $f6
	
	END_IF_PAG:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

# $v0 -> retorna 1 / 2 (Sim/Não)	
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

# $a0  -> Iteração do loop principal (número do carro)
# $a1  -> Tipo de combustível
# $f12 -> Preço pago
emitirNotaFiscal:
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
	
	la	$t0, notaNumBuffer
	itLoop:
		lb	$t1, 0($t0)
		beqz	$t1, itLoopEnd
		sb	$t1, 0($s0)
		addi	$t0, $t0, 1
		addi	$s0, $s0, 1
		j	itLoop
	itLoopEnd:
	
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
	syscall
	move	$s1, $v0
	
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
	
	la	$t0, newline
	lb	$t1, 0($t0)
	sb	$t1, 0($s0)
	addi	$s0, $s0, 1
	addi	$t3, $t3, 1

		
	li	$v0, 15
	move	$a0, $s1
	la	$a1, notaTitleBuffer
	move	$a2, $t3
	syscall
	
	lw	$a2, 0($sp)
	addi	$sp, $sp, 4
	
	beq	$a2, 1, IF_COMB_COMUM
	beq	$a2, 2, IF_COMB_COMUM
	beq	$a2, 3, IF_COMB_ALCOOL
	
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
	syscall
	
	la	$s0, notaPrecoBuffer
	move	$t3, $zero
	
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
		

	trunc.w.d	$f4, $f12
	mfc1		$t5, $f4
		
	cvt.d.w		$f4, $f4
	sub.d		$f6, $f12, $f4
	l.d		$f4, cemD
	mul.d		$f6, $f6, $f4
	round.w.d	$f4, $f6
	mfc1		$t6, $f4	
	
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
	li	$t7, 3
	ftoa_int_pop:
		beqz	$t4, ftoa_int_end
		
		lw	$t2, 0($sp)
		addi	$sp, $sp, 4
		
		sb	$t2, 0($s0)
		addi	$s0, $s0, 1
		addi	$t4, $t4, -1
		addi	$t3, $t3, 1
		addi	$t7, $t7, -1
		bnez	$t7, ftoa_int_pop
		beqz	$t4, ftoa_int_end
		la	$t7, dot
		lb	$t2, 0($t7)
		sb	$t2, 0($s0)
		addi	$s0, $s0, 1
		addi	$t3, $t3, 1
		li	$t7, 3
		j	ftoa_int_pop
	ftoa_int_end:
	
	la	$t0, comma
	lb	$t2, 0($t0)
	sb	$t2, 0($s0)
	addi	$s0, $s0, 1
	addi	$t3, $t3, 1
	
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
	syscall
	
	li	$v0, 16
	move	$a0, $s1
	syscall
		
	jr	$ra
