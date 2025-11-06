.data
	keyTable:
		.byte	0x11,0x21,0x41,0x81
		.byte	0x12,0x22,0x42,0x82
		.byte	0x14,0x24,0x44,0x84
		.byte	0x18,0x28,0x48,0x88

.text
main:
	li	$s0, 0xFFFF0012		# line enable address
	li	$s1, 0xFFFF0014		# key pressed data address
	j	readLoopReset

readLoopReset:
	li	$t0, 1			# key row selector
	li	$t1, 0			# row counter
	la	$s3, keyTable
	j	readLoop

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
	beq	$t3, $t5, storeValue 	# checking if equal
	addi	$t6, $t6, 1		# incrementing if not equal
	addi	$s3, $s3, 1
	j	findKey

storeValue:
	mul	$t7, $t1, 4
	add	$s5, $t7, $t6
	
	sgt	$t8, $s5, 9
	bnez	$t8, end
	
	j	waitRelease

waitRelease:
	lb	$t5, 0($s1)		# read key output
	bnez	$t5, waitRelease	# repeat while not zero (key pressed)

	j	readLoopReset		# reset program
	
end:
	li	$v0, 10
	syscall
