.data
	zeroD:			.double 0
	precoComum: 		.double 6.14
	precoAditivada:		.double 6.34
	precoAlcool:		.double 4.13
.text

main:
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