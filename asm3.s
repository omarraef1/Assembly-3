# Omar R. Gebril

.data
space:		.asciiz " "
newline:	.asciiz "\n"
FirstMessage:	.asciiz "collatz("
SecondMessage:	.asciiz ") completed after " 
ThirdMessage:	.asciiz " calls to collatz_line().\n"

.text

#__________START TASK 1_________#

# Prints parameter passed and divides by 2 until it reaches an odd number 
# and returns it.

.globl collatz_line

collatz_line:
	#Function Prologue
	addiu   $sp, $sp, -24   # allocate stack space -- default of 24 here
        sw      $fp, 0($sp)     # save caller's frame pointer
        sw      $ra, 4($sp)     # save return address
        addiu   $fp, $sp, 20    # setup main's frame pointer
	
	add   $t0, $a0, $zero		# t0 = val passed to collatz = cur

	
firstLoop:	
	andi  $t1, $t0, 0x1		# t1 = cur%2
	bne   $t1, $zero, FirstEnd	# if cur is odd branch out
	
	addi $v0, $zero, 1		# print cur
	add  $a0, $zero, $t0		
	syscall
	addi $v0, $zero, 4		# print space
	la   $t3, space			
	add  $a0, $zero, $t3		
	syscall
	
	sra  $t0, $t0, 1		# cur = cur/2
	j firstLoop			# jump back to loop
	
FirstEnd:
	# print last number
	addi $v0, $zero, 1		# print cur
	add  $a0, $zero, $t0		
	syscall
	
	addi $v0, $zero, 4		# print newLine
	la   $t3, newline		
	add  $a0, $zero, $t3		
	syscall
	
	add  $v0, $t0, $zero		# return cur

	# Function epilogue
	lw      $ra, 4($sp)     # get return address from stack
        lw      $fp, 0($sp)     # restore the caller's frame pointer
        addiu   $sp, $sp, 24    # restore the caller's stack pointer
        jr      $ra             # return to caller's code

#__________END TASK 1_________#





#__________START TASK 2_________#

# Same as previous function only it keeps dividing till it hits the value of 1

.globl collatz

collatz:
	# standard prologue
	addiu $sp, $sp, -24 		# increase stack space
	sw    $fp, 0($sp) 		# save caller’s frame pointer
	sw    $ra, 4($sp) 		# save return address
	addiu $fp, $sp, 20 		# setup frame pointer
	
	add   $t0, $a0, $zero		# t0 = cur
	add   $t7, $a0, $zero		# t7 = value passed
	add   $t8, $zero, $zero		# t8 = calls
	
	addiu $sp, $sp, -8		# allocate space for 2 words
	sw    $t7, 0($sp)		# store t7 & t8
	sw    $t8, 4($sp)		
	
	add   $a0, $zero, $a0		# call collatz_line(cur)
	jal   collatz_line
	add   $t0, $zero, $v0		# cur = collatz_line(cur)
	
	lw    $t8, 4($sp)		# load t8 & t7
	sw    $t7, 0($sp)		
	addiu $sp, $sp, 8		# free stack space
	
secondLoop:
	addi  $t1, $zero, 1
	beq   $t0, $t1, secondEnd	# if cur == 1, branch outs
	
	# cur = 3n+1 (n = cur)
	sll   $t2, $t0, 1		# t2 = 2 * cur
	add   $t0, $t0, $t2		# cur = 3 * cur = 2 * cur + cur
	addi  $t0, $t0, 1		# cur = 3 * cur + 1
	
	add   $a0, $zero, $t0
	jal   collatz_line		# collatz_line(cur)
	add   $t0, $zero, $v0		# cur = collatz_line(cur)
	addi  $t8, $t8, 1		# increment calls var by 1
	
	j     secondLoop		# jump back to loop

secondEnd:
	addi $v0, $zero, 4		# print first part of message
	la   $t3, FirstMessage		
	add  $a0, $zero, $t3
	syscall
	
	addi $v0, $zero, 1		# print parameter
	add  $a0, $zero, $t7		
	syscall
	
	addi $v0, $zero, 4		# print middle part of message
	la   $t3, SecondMessage		
	add  $a0, $zero, $t3
	syscall
	
	addi $v0, $zero, 1		# print integer
	add  $a0, $zero, $t8		
	syscall
	
	addi $v0, $zero, 4		# print message ending
	la   $t3, ThirdMessage		
	add  $a0, $zero, $t3
	syscall
	
	# newLine
	addi $v0, $zero, 4		# print newLine
	la   $t3, newline		
	add  $a0, $zero, $t3		
	syscall
	
	# standard epilogue
	lw    $ra, 4($sp) 		# get $ra from the stack
	lw    $fp, 0($sp) 		# restore the caller’s frame pointer
	addiu $sp, $sp, 24 		# restore the caller’s stack pointer
	jr    $ra			# jump back to caller


#__________END TASK 2_________#





#__________START TASK 3_________#



# searches the string passed and searches for the '%' character
# once found it returns the index of it

.globl percentSearch

percentSearch:
	# Function prologue
	addiu   $sp, $sp, -24   # allocate stack space -- default of 24 here
        sw      $fp, 0($sp)     # save caller's frame pointer
        sw      $ra, 4($sp)     # save return address
        addiu   $fp, $sp, 20    # setup main's frame pointer
	
	addi  $t8, $zero, 37			# t8 = 37, (ASCII value for '%' char)
	add   $t0, $a0, $zero			
	lb    $t1, 0($t0)			
	
thirdLoop:
	beq   $t1, $zero, thirdEnd		# if the cur byte is 0 branch out
	beq   $t1, $t8, found			# if the cur byte is 37 branch in
	
	addi  $t0, $t0, 1			# increment address by 1
	lb    $t1, 0($t0)			# t1 = t0
	j     thirdLoop				# jump back to loop

found:
	# return index
	sub   $t0, $t0, $a0			# t0 = length between beginning of string and '%'
	add   $v0, $zero, $t0			# return value = index of '%' char
	j     tskThreeEnd

thirdEnd:
	addi  $v0, $zero, -1			# return value = -1
	j     tskThreeEnd
	
tskThreeEnd:
	#Function epilogue
	lw      $ra, 4($sp)     # get return address from stack
        lw      $fp, 0($sp)     # restore the caller's frame pointer
        addiu   $sp, $sp, 24    # restore the caller's stack pointer
        jr      $ra             # return to caller's code


#__________END TASK 3_________#




#__________START TASK 4_________#


.globl letterTree

letterTree:
	# Function prologue
	addiu   $sp, $sp, -24   # allocate stack space -- default of 24 here
        sw      $fp, 0($sp)     # save caller's frame pointer
        sw      $ra, 4($sp)     # save return address
        addiu   $fp, $sp, 20    # setup main's frame pointer
        

	addi $t6, $zero, 0			# t6 = pos = 0
	addi $t7, $zero, 1			# t7 = count incremented
	add  $t8, $zero, $a0			# t8 = step

fourthLoop:
	addiu $sp, $sp, -12			# allocate stack space
	sw    $t6, 0($sp)			# store t6, t7, & t8
	sw    $t7, 4($sp)			
	sw    $t8, 8($sp)			
	
	
	add  $a0, $zero, $t6			# put pos in a0
	jal  getNextLetter
	add  $t5, $zero, $v0			# t5 = c
	
				
	lw    $t6, 0($sp)			# load t6, t7, t8
	lw    $t7, 4($sp)			
	lw    $t8, 8($sp)			
	
	addiu $sp, $sp, 12			# free stack space

	beq  $t5, $zero, fourthEnd	# if c == 0: break
	
	addi $t0, $zero, 0			# i = 0
fifthLoop:
	beq  $t0, $t7, fifthEnd		# if i == count: break
	
	# print c
	addi $v0, $zero, 11			# print char c
	add  $a0, $zero, $t5			
	syscall
	
	addi $t0, $t0, 1			# i++
	j    fifthLoop			# jump back to loop

fifthEnd:
	# newline
	addi $v0, $zero, 4			# print a string
	la   $t3, newline			# print '\n'
	add  $a0, $zero, $t3		
	syscall
	
	addi $t7, $t7, 1			# count++
	add  $t6, $t6, $t8			# pos += step
	j    fourthLoop			# jump back to loop
	
fourthEnd:
	add  $v0, $zero, $t6			# return pos
	
	# Function epilogue
	lw      $ra, 4($sp)     # get return address from stack
        lw      $fp, 0($sp)     # restore the caller's frame pointer
        addiu   $sp, $sp, 24    # restore the caller's stack pointer
        jr      $ra             # return to caller's code



#__________END TASK 4_________#


