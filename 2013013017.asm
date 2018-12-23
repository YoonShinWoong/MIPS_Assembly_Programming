# 2013013017_Yoon Shin Woong
# Variable list
.data
	input : .space 	100
	control_message1 : .asciiz	"Enter the number: "
	control_message2 : .asciiz	"Input string: "
	control_message3 : .asciiz	"Floating point number detected\n"
	control_message4 : .asciiz	"Integer number detected\n"
	control_message5 : .asciiz	"Half of the input: "
	control_message6 : .asciiz	"Binary number: "
	control_message7 : .asciiz	"\nHexa number: "
	linePrint : .asciiz		"\n"
	spacePrint : .asciiz		" "
	
	f : .float			0.0
	fp : .float			0.1
	mfp : .float			-0.1
	
	A : .asciiz			"A"
	B : .asciiz			"B"
	C : .asciiz			"C"
	D : .asciiz			"D"
	E : .asciiz			"E"
	F : .asciiz			"F"
	
	
# Code 
.text
##############################################################################################
main:
	# syscall 4 is print syscall
	li 	$v0, 4
	la	$a0, control_message1
	syscall
	
	# syscall 8 is scan String(input) 
	li 	$v0, 8
	la 	$a0, input
	li 	$a1, 100 		# space for input
	syscall
	
	# Control_message1 display 
	li 	$v0, 4
	la 	$a0, control_message2 	# input string:
	syscall
	
	# Control_message2 display 
	li 	$v0, 4
	la 	$a0, input
	syscall

##############################################################################################
	# INT OR FLOAT CHECK
	la 	$s0, input		# s0 = input(address)
	li 	$t0, 0	 		# t0(i) = 0
	li 	$t1, 46			# t1 = '.' for check Float

# Loop
CheckLoop :
	add 	$t2, $s0, $t0		# t2 = input[i]'s address (s0 =input addr, t0 = i)
	lb 	$t3, 0($t2)		# t3 = input[i]'s value( for check '.')
	add	$s2, $t0, $zero		# s2 = input length
	beq	$t3, $t1, Float		# if input[i] == '.' -> go to Float lable
	beq	$t3, $zero, Int		# if input[i] == null -> go to Int lable ( all check but not find '.')
	addi	$t0, $t0, 1		# i++
	j	CheckLoop 


##############################################################################################
# Float
Float :
	# Control_message3 display
	li	$v0, 4 			# print
	la	$a0, control_message3	# Float print
	syscall

	# Get Value(s1) from String(input)
	li	$s1, 0			# s1 = 0(value)
	li	$t0, 0			# t0(i) = 0
	li	$t1, 10			# t1 = 10 (for * 10)
	li	$t4, 1			# t4 = 1 (if <plus> -> t4 =1 , if <minus> -> t4 = -1)
	la	$t7, fp			# t7 = 0.1 (if <plus> -> t7 =0.1 , if <minus> -> t7 = -0.1)
	
	lb	$t2, 0($s0)		# t2 = input[0]
	li	$t3, 45			# t3 = '-'
	beq	$t2, $t3, FloatMinus	# if input[0] == '-' -> go to MinusValue Setting
	subi	$s2, $s2, 0		# s2 (length)
	j	FloatValue		# jum to FloatValue

# minus setting
FloatMinus :
	li	$t4, -1			# t4 = -1 (for minus)
	subi	$s2, $s2, 1		# s2-- (length)
	addi	$s0, $s0, 1		# s0 = string start

# FloatValue(for Int)		
# Loop
FloatValue :
	beq	$s2, $t0, FloatValue2bf	# if s2(arr_length) = t0(i) -> go to Flaotvalue2bf
	add 	$t5, $s0, $t0		# t5 = input[i]'s address (s0 =input addr, t0 = i)
	lb 	$t6, 0($t5)		# t6 = input[i]'s value( for check '.')
	subi	$t6, $t6, 48		# t6 = t6-'0'
	mul	$t6, $t6, $t4		# plus / minus
	mul 	$s1, $s1, $t1		# sum = sum * 10
	add	$s1, $s1, $t6		# sum = sum + input[i]
	addi	$t0, $t0, 1		# i++
	j	FloatValue		# jump to FloatValue(while)

# FloatValue(for .xxx)
# Loop
FloatValue2bf :
	li	$s3, 0			# s3 = 0
	addi	$s4, $s2, 1  		# s4 = .xxx 's start point
	
# Loop( for Check Float length)
CheckLoop2 :
	add 	$t2, $s0, $t0		# t2 = input[i]'s address (s0 =input addr, t0 = i)
	lb 	$t3, 0($t2)		# t3 = input[i]'s value
	add	$s3, $t0, $zero		# s3 = arr_float_length
	beq	$t3, $zero, FloatValue2	# if input[i] == null -> go to Int lable ( all check but not find '.')
	addi	$t0, $t0, 1		# i++
	j	CheckLoop2 

FloatValue2 :
	add	$t0, $s4, $zero 	# t0 = start Point
	la	$t1, f			# t1 = 0.0
	lwc1	$f1, 0($t1)		# f1 = sum(0.0)
	lwc1	$f10, 0($t1)		# f10 = 0.0
	lwc1	$f2, 0($t7)		# f2 = 0.1 
	lwc1	$f3, 0($t7)		# f7 = 0.1
	subi	$s3, $s3, 1		# length --
	
	
FloatValue2Loop :
	beq	$t0, $s3, FloatAdd	# if t6 == 0 -> go to FloatAdd
	add 	$t5, $s0, $t0		# t5 = input[i]'s address (s0 =input addr, t0 = i)
	lb 	$t6, 0($t5)		# t6 = input[i]'s value( for check '.')
	subi	$t6, $t6, 48		# t6 = t6-'0'
	mul	$t6, $t6, $t4		# plus / minus
	
	sw	$t6, -88($fp)		# int -> float
	lwc1	$f6, -88($fp)		# int -> float / f0 
	cvt.s.w $f0, $f6
	
	mul.s	$f0, $f0, $f3		# f0 = f0 * 10 ^ -f3
	add.s	$f1, $f1, $f0		# f1 = f1(sum) + f0
	mul.s 	$f3, $f3, $f2		# 0.1 -> 0.01 -> ...
	addi	$t0, $t0, 1		# t0++
	
	j	FloatValue2Loop
	
		
FloatAdd :
	
	# div float
	li	$t0, 2			# for div 2.0
	sw	$t0, -88($fp)		# 2.0
	lwc1	$f6, -88($fp)		# f6 = 2.0
	cvt.s.w	$f3, $f6		# single precision(f3 = 2.0)
	div.s	$f4, $f1, $f3 		# f4 = f1 / 2.0
	
	# load int & div int
	sw	$s1, -84($fp)
	lwc1	$f6, -84($fp)		# f6 = int
	cvt.s.w	$f2, $f6		# single precision 
	add.s	$f1, $f1, $f2		# add f1 = f1+f2
	div.s	$f2, $f2, $f3		# f2 = f2 / 2.0
	add.s	$f4, $f4, $f2		# int + float
	

# for value / 2
FloatHalf :

	# Control_message3 display
	li	$v0, 4 			# print
	la	$a0, control_message5	# Float print
	syscall

	
	# halfValue display
	li	$v0, 2
	add.s	$f12, $f10, $f4		# f12 argument load 
	syscall
	
	# Line display
	li	$v0, 4 			# print
	la	$a0, linePrint	# Int print
	syscall
	
	# f1 -> s1 store
	mfc1	$s1, $f1
	
	j	Binary			# jump to Binary
	
##############################################################################################
# Int
Int :
	# Control_message3 display
	li	$v0, 4 			# print
	la	$a0, control_message4	# Int print
	syscall

	# Get Value(s1) from String(input)
	li	$s1, 0			# s1 = 0(value)
	li	$t0, 0			# t0(i) = 0
	li	$t1, 10			# t1 = 10 (for * 10)
	li	$t4, 1			# t4 = 1 (if <plus> -> t4 =1 , if <minus> -> t4 = -1)
	
	lb	$t2, 0($s0)		# t2 = input[0]
	li	$t3, 45			# t3 = '-'
	beq	$t2, $t3, IntMinus	# if input[0] == '-' -> go to MinusValue Setting
	subi	$s2, $s2, 1		# s2-- (length)
	j	IntValue		# jum to IntValue

# minus setting
IntMinus :
	li	$t4, -1			# t4 = -1 (for minus)
	subi	$s2, $s2, 2		# s2--, s2-- (length)
	addi	$s0, $s0, 1		# s0 = string start
		
# Loop
IntValue :
	beq	$s2, $t0, IntHalf	# if s2(arr_length) = t0(i) -> go to Inthalf
	add 	$t5, $s0, $t0		# t5 = input[i]'s address (s0 =input addr, t0 = i)
	lb 	$t6, 0($t5)		# t6 = input[i]'s value( for check '.')
	subi	$t6, $t6, 48		# t6 = t6-'0'
	mul	$t6, $t6, $t4		# plus / minus
	mul 	$s1, $s1, $t1		# sum = sum * 10
	add	$s1, $s1, $t6		# sum = sum + input[i]
	addi	$t0, $t0, 1		# i++
	j	IntValue		# jump to IntValue(while)


# for value / 2
IntHalf :

	# Control_message3 display
	li	$v0, 4 			# print
	la	$a0, control_message5	# Int print
	syscall

	
	# halfValue display
	li	$t0, 2			# t0 = 2
	div	$t1, $s1, $t0		# t1 = value / 2
	li	$v0, 1			# print int
	add	$a0, $t1, $zero		# move t1 -> a0
	syscall				
	
	
	# Line display
	li	$v0, 4 			# print
	la	$a0, linePrint	# Int print
	syscall


##############################################################################################	
# Binary	
Binary :

	# Control_message6 display
	li	$v0, 4 			# print
	la	$a0, control_message6	# message print
	syscall
	
	slt	$t0, $s1, $zero 	# s1 <0 -> t0 =1
	beq	$t0, $zero, plusBinary	# if t0 ==0 -> +
	j	minusBinary
	
# plus print
plusBinary:
	li	$v0, 1
	li	$a0, 0
	syscall
	
	j Binary2

# minus print
minusBinary:
	li	$v0, 1
	li	$a0, 1
	syscall
	
	j Binary2

# binary main
Binary2:
	
	# t0 = mask -> 2^31
	li	$t2, 0			# t2 = last
	li	$t0, 1			# t0 -> mask
	li	$t1, 1			# t1 -> print check 4bit space
	li	$t4, 4			# For 4bit check
	li	$t5, 1			# For 4bit check
	sll	$t0, $t0, 30		# t0 -> 2^31
	
	
BinaryLoop:
	beq	$t0, $t2, Hex		# if mask(t0) == 0(t2) -> jump to End
	and	$t3, $s1, $t0		# s0 & mask(t0) -> t3
	div	$t3, $t3, $t0		# t3= t3/t0(mask)
	
	li	$v0, 1	
	add	$a0, $t3, $zero		# print
	syscall
	
	srl	$t0, $t0, 1		# mask >> 1
	addi	$t1, $t1, 1	 	# t1 print check 4bit space
	bne	$t1, $t4, BinaryLoop	# t1 != 4 -> next Loop
	
	# " " print
	li	$v0, 4
	la	$a0, spacePrint
	syscall
	
	sub	$t1, $t1, $t4		# t1 = t1 - 4
	j 	BinaryLoop		# loop 


##############################################################################################	
# Hex
Hex :
	# Control_message7 display
	li	$v0, 4			# print
	la	$a0, control_message7	# message print
	syscall
	
	# register
	li	$t0, 8			# t0 = 8n
	li	$t1, 40			# 40 For Break While
	li	$t2, 10			# A
	li	$t3, 11			# B
	li	$t4, 12			# C
	li	$t5, 13			# D
	li	$t6, 14			# E
	li	$t7, 15			# F
	
#Loop
HexLoop :
	li	$t1, 40			# 40 For Break While
	beq	$t0, $t1, End		# if t0 = 40 -> End
	rol	$s5, $s1, $t0		# s5 = rol 8n
	sb	$s5, -88($fp)		# sb
	lb	$s6, -88($fp)		# lb
	
# first hex 4 bit
HexPart1 :
	li	$t8, 0			# 4 bit sum = 0(init)
	li	$t9, 1			# mask = 1(init)
	 
	rol	$s6, $s5, 28		# rotate left 28 bit
	sb	$s6, -88($fp)		# sb
	lb	$s7, -88($fp)		# lb (s7 = first char)
	
# sum
	and	$k0, $s7, $t9		# k0 = mask bit value
	add	$t8, $t8, $k0		# t8(sum) += k0(value)
	sll	$t9, $t9, 1		# t9 << 1
	
	and	$k0, $s7, $t9		# k0 = mask bit value
	add	$t8, $t8, $k0		# t8(sum) += k0(value)
	sll	$t9, $t9, 1		# t9 << 1
	
	and	$k0, $s7, $t9		# k0 = mask bit value
	add	$t8, $t8, $k0		# t8(sum) += k0(value)
	sll	$t9, $t9, 1		# t9 << 1
	
	and	$k0, $s7, $t9		# k0 = mask bit value
	add	$t8, $t8, $k0		# t8(sum) += k0(value)
	sll	$t9, $t9, 1		# t9 << 1
	
# print1
	li	$t1, 10			# 10 for Checking
	blt	$t8, $t1, OnePrint	# sum < 10 -> onePrint2
	j	TwoPrint
	
# INT 	
OnePrint:
	li	$v0, 1
	add	$a0, $t8, $zero		#print
	syscall
	j	HexPart2		# jump to Part 2

# CHAR
# t2 - t7 A~F
TwoPrint:
	# switch
	beq	$t8, $t2, Aprint
	beq	$t8, $t3, Bprint
	beq	$t8, $t4, Cprint
	beq	$t8, $t5, Dprint
	beq	$t8, $t6, Eprint
	beq	$t8, $t7, Fprint

Aprint:
	li	$v0,4
	la	$a0,A			# A print
	syscall
	j 	HexPart2		# jump to Part 2

Bprint:
	li	$v0,4
	la	$a0,B			# B print
	syscall
	j 	HexPart2		# jump to Part 2
	
Cprint:
	li	$v0,4
	la	$a0,C			# C print
	syscall
	j 	HexPart2		# jump to Part 2
	
Dprint:
	li	$v0,4
	la	$a0,D			# D print
	syscall
	j 	HexPart2		# jump to Part 2
	
Eprint:
	li	$v0,4
	la	$a0,E			# E print
	syscall
	j 	HexPart2		# jump to Part 2
	
Fprint:
	li	$v0,4
	la	$a0,F			# F print
	syscall
	j 	HexPart2		# jump to Part 2
	
	 
# second hex 4 bit
HexPart2:
	li	$t8, 0			# 4 bit sum = 0
	li	$t9, 1			# mask = 1(init)
	
	sll	$s6, $s5, 28		# shift left 28 bit
	rol	$s6, $s6, 4		# rotate left 4 bit
	sb	$s6, -88($fp)		# sb
	lb	$s7, -88($fp)		# lb (s7 = second char)
	
# sum2
	and	$k0, $s7, $t9		# k0 = mask bit value
	add	$t8, $t8, $k0		# t8(sum) += k0(value)
	sll	$t9, $t9, 1		# t9 << 1
	
	and	$k0, $s7, $t9		# k0 = mask bit value
	add	$t8, $t8, $k0		# t8(sum) += k0(value)
	sll	$t9, $t9, 1		# t9 << 1
	
	and	$k0, $s7, $t9		# k0 = mask bit value
	add	$t8, $t8, $k0		# t8(sum) += k0(value)
	sll	$t9, $t9, 1		# t9 << 1
	
	and	$k0, $s7, $t9		# k0 = mask bit value
	add	$t8, $t8, $k0		# t8(sum) += k0(value)
	sll	$t9, $t9, 1		# t9 << 1
	
# print2
	li	$t1, 10			# 10 for Checking
	blt	$t8, $t1, OnePrint2	# sum < 10 -> onePrint2
	j	TwoPrint2
	 	
# INT 	
OnePrint2:
	li	$v0, 1
	add	$a0, $t8, $zero		# print
	syscall
	j	HexPart3		# jump to Part 3

# CHAR
# t2 - t7 A~F
TwoPrint2:
	# switch
	beq	$t8, $t2, Aprint2
	beq	$t8, $t3, Bprint2
	beq	$t8, $t4, Cprint2
	beq	$t8, $t5, Dprint2
	beq	$t8, $t6, Eprint2
	beq	$t8, $t7, Fprint2

Aprint2:
	li	$v0,4
	la	$a0,A			# A print
	syscall
	j 	HexPart3		# jump to Part 3

Bprint2:
	li	$v0,4
	la	$a0,B			# B print
	syscall
	j 	HexPart3		# jump to Part 3
	
Cprint2:
	li	$v0,4
	la	$a0,C			# C print
	syscall
	j 	HexPart3		# jump to Part 3
	
Dprint2:
	li	$v0,4
	la	$a0,D			# D print
	syscall
	j 	HexPart3		# jump to Part 3
	
Eprint2:
	li	$v0,4
	la	$a0,E			# E print
	syscall
	j 	HexPart3		# jump to Part 3
	
Fprint2:
	li	$v0,4
	la	$a0,F			# F print
	syscall
	j 	HexPart3		# jump to Part 3
	
	
# next Process
HexPart3:
	addi	$t0, $t0, 8		# t0 = 8n(+=8)
	
	# print Space
	li	$v0, 4
	la	$a0, spacePrint
	syscall
	
	j	HexLoop			# while

##############################################################################################	
# end
End :
	  
	li 	$v0, 10
	syscall
