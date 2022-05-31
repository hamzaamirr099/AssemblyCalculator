.data
options: .asciiz "\nChoose your operation:\n0) EXIT\n1) Add\n2) Multiply\n3) Division\n4) Min of list\n5) Sin\n6) Cos\n7) Tan\n8) Square detection\n9) Rectangle detection\n10) Triangle detection\nYour choice : "
answer: .asciiz "\nTHE RESULT IS: "
another_operation: .asciiz "\n\n0) Exit\n1) Another operation\nChoose:"

#Addition/Multiplication/division data
first_number: .asciiz "Enter first number: \n"
second_number: .asciiz "Enter second number \n"

#Min of list data
prompt1: .asciiz "Enter the Array Elements Please:"
MinMessage: .asciiz "\nTHE MIN VALUE IS:"
MyArray:  .space 80 # next saved bytes in data segments, every number needs 4 bytes or 32 bits (The maximum number of elements in this case is 20)
prompt2: .asciiz "Enter the size of array:"

#sin/cos/tan data
sin_cos_tan_Msg: .asciiz"\nenter the angle in degree: "
ToRadian: .float 0.01745	# the value of (PI / 180)
two: .float 2.0
one: .float 1.0
negative: .float -1.0
check: .float 10.0	# loop iterations
zeroValue: .float 0.0

#square/rectangle/triangle detection data
Side_1: .asciiz "enter the first side: "
Side_2: .asciiz "enter the second side: "
Side_3: .asciiz "enter the third side: "
Side_4: .asciiz "enter the fourth side: "
valid_T: .asciiz "\nThis is a triangle"
invalid_T: .asciiz "\nThis is NOT a triangle"
valid_R: .asciiz "\nThis is a Rectangle"
invalid_R: .asciiz "\nThis is NOT a Rectangle"
valid_S: .asciiz "\nThis is a square"
invalid_S: .asciiz "\nThis is NOT a square"

Error_Msg: .asciiz "\nInvalid input, please try again or enter (0) to exit\n"

.text
main:
	#print the options
	li $v0, 4
	la $a0, options
	syscall
	
	switch:
		#take the choice in $v0 and move it to $a0
		li $v0, 5	
		syscall
		move $a0, $v0
		
		#switch case
		beq $a0, 0, Exit_program
		beq $a0, 1, switch1	# Addition
		beq $a0, 2, switch2	# Multiplication
		beq $a0, 3, switch3	# Division
		beq $a0, 4, switch4	# Min of list
		beq $a0, 5, switch5	# Sin
		beq $a0, 6, switch6	# Cos
		beq $a0, 7, switch7	# Tan
		beq $a0, 8, switch8	# Square detection
		beq $a0, 9, switch9	# Rectangle detection
		beq $a0, 10, switch10	# Triangle detection
		
	li $v0, 4
	la $a0, Error_Msg		# Display error message if the input is not from the choices
	syscall
	j switch			# Jump again to take a new input
		
	another_op:			# check if the user wants another operation or not
		li $v0, 4
		la $a0, another_operation
		syscall
		li $v0, 5
		syscall
		
		beq $v0, 1, main
		beq $v0, 0, Exit_program
		j another_op		# jump to (another_op) again if the choisce is wrong

switch1: #The return value of the (Add) procedure is in $f3 register

	#display first message
	li $v0 , 4
	la $a0 , first_number
	syscall
	
	#Take a float input in the f0 register
	li $v0 , 6			
	syscall
	
	#move the value that stored in register $f0 to register $f1
	mov.s  $f1 , $f0
	
	#display the second message	
	li $v0, 4
	la $a0, second_number
	syscall 
	
	#Take a float input in the f0 register
	li $v0 , 6
	syscall
	mov.s $f2, $f0
	
	# Call the Add procedure
	jal Add			
	
	#display the answer message then the result 
	li $v0, 4
	la $a0, answer
	syscall
	
	li $v0, 2			
	mov.s $f12, $f3	# because $f3 has the result
	syscall
	
	# return to ask if the user want another operation or not
	j another_op
	
switch2: #The return value of the (Multiply) procedure is in $f6 register

	li $v0, 4			#system call to print a string
	la $a0, first_number	#the adrees of the string
	syscall 
	
	li $v0, 7  			# system call to get a double in $f0 register
	syscall				# waiting for the input from keyboard and put it in $f0 register
	mov.d $f2, $f0		#move f0 to f2
	
	li $v0, 4
	la $a0, second_number
	syscall
	li $v0, 7
	syscall
	mov.d $f4, $f0		#move f0 to f4
	
	# Call the Multiply procedure
	jal Multiply
	
	#display the result
	li $v0, 4
	la $a0, answer
	syscall
	li $v0, 3			#system call to print double
	mov.d $f12, $f6		# $f6 has the result
	syscall
	
	# return to ask if the user want another operation or not
	j another_op
	
switch3: #The return value of the (Division) procedure is in $f3 register

	li $v0, 4
	la $a0, first_number  	#printing messsage to enter the first number
	syscall
	li $v0, 6  			#scanning the float 
	syscall
	mov.s $f1, $f0 		#save the first number in f1

	li $v0, 4
	la $a0, second_number  	#printing message to enter the second number
	syscall
	li $v0, 6  			#scanning the float 
	syscall
	mov.s $f2, $f0 		#save the second number in f2
	jal Division			# Call the Division procedure
	
	li $v0, 4
	la $a0, answer
	syscall
	
	li $v0, 2
	mov.s $f12, $f3		#$f3 has the result
	syscall
	
	# return to ask if the user want another operation or not
	j another_op
	
switch4: #The return value of the (Min of list) procedure is in $s0 register
	
	li $v0, 4
      	la $a0, prompt2
      	syscall 
       	li $v0, 5
      	syscall 
      	
      	add $t3, $zero, $v0
      
      	li $v0, 4
      	la $a0, prompt1
      	syscall 
     
      	li $t0, 0 			#Array Index
      	li $s0, 0 			#Looping Counter

      	loop:
      		li $v0, 5 			#Read an integer number
      		syscall

      		sw $v0, MyArray($t0) 	#the first element is stored in array index zero
      		addi $t0, $t0, 4 		#increment to go to next element ,updated each loop
      		addi $s0, $s0, 1 		#increment the loop counter by one
      		blt $s0, $t3, loop 		#If the counter is less than the number of elements in the array, loop once again
     	
      	jal Min_of_list			# Calling  the Min of list procedure
      	
      	li $v0, 4 
     	la $a0, MinMessage                     
       	syscall
       	move $a0, $s0			# $s0 has the result
       	# printing the solution (minimum number) 		
   	li $v0, 1
       	syscall
       	 
       	# return to ask if the user want another operation or not
	j another_op
	
switch5: #The return value of the (sin) procedure is in $f28 register
        
        li $v0, 4                   	#Issue a print string system call
        la $a0, sin_cos_tan_Msg	#Adress of string to print
        syscall                     	#Display the message to the user
        
        li $v0, 6                   	#Indication to go to $f0 to Read float input from user 
        syscall		          	#Take the input and store it in $f0 register
        
        jal Sin            		#Jump to procedure calculateSin and back to main after finishing
        
        li $v0, 4
	la $a0, answer
	syscall
       
        li $v0, 2                    	#Print float service
        mov.s $f12, $f28           	#Move the procedure result from $f28 to $f12 so that we can issue a print float service 
        syscall                     	#Call system to print
	
	# return to ask if the user want another operation or not
	j another_op

switch6: #The return value of the (Cos) procedure is in $f11 register

	#display the first output
	li $v0, 4
	la $a0, sin_cos_tan_Msg
	syscall
	
	#take the input and store it in $f0
	li $v0, 6
	syscall
		
	#calling the cosine function
	jal Cos
	
	li $v0, 4
	la $a0, answer
	syscall
	# printing the value
	li $v0, 2
	mov.s $f12, $f11		#$f11 has the result. So, move it to $f12 to print it
	syscall
	
	# return to ask if the user want another operation or not
	j another_op

switch7: #The return value of the (Tan) procedure is in $f3 register
	
        li $v0, 4                   	#Issue a print string system call
        la $a0, sin_cos_tan_Msg 	#Adress of string to print
        syscall                     	#Display the message to the user
        
        li $v0, 6                    	#Indication to go to $f0 to Read float input from user 
        syscall				#Take the input and store it in $f0

        jal Tan            		#Jump to procedure calculateTan and back to main after finishing
        
       	li $v0, 4
	la $a0, answer
	syscall     
        	          		
        li $v0, 2                    	#Print float service
	mov.s $f12, $f3
        syscall                     	#Call system to print       
           
	# return to ask if the user want another operation or not
	j another_op
	
switch8: 

	#display first message
	li $v0, 4
	la $a0, Side_1
	syscall
	
	#scan a float input to $f0
	li $v0, 6
	syscall
	mov.s $f1, $f0		#move the value in f0 to f1
	
	li $v0, 4
	la $a0, Side_2
	syscall
	li $v0, 6
	syscall
	mov.s $f2, $f0		#move the value in f0 to f2
	
	li $v0, 4
	la $a0, Side_3
	syscall
	li $v0, 6
	syscall
	mov.s $f3, $f0		#move the value in f0 to f3
	
	li $v0, 4
	la $a0, Side_4
	syscall
	li $v0, 6
	syscall
	mov.s $f4, $f0		#move the value in f0 to f4

	jal Square_detection	# Calling the Square detection procedure
	
	# return to ask if the user want another operation or not
	j another_op
	
switch9:
	
	li $v0, 4 		# print output1
	la $a0, Side_1
	syscall

	li $v0, 6  		# scan first number
	syscall
	mov.s $f1, $f0

	li $v0, 4  		# print output2
	la $a0, Side_2
	syscall
	
	li $v0, 6  		#scan second number
	syscall
	mov.s $f2, $f0
	
	li $v0, 4 		# print output3	
	la $a0, Side_3
	syscall
	
	li $v0, 6  		#scan the third number 
	syscall
	mov.s $f3, $f0
	
	li $v0, 4 		#print output4
	la $a0, Side_4
	syscall
	
	li $v0, 6 		#scan the fourth number 
	syscall
	mov.s $f4, $f0

	jal Rectangle_detection		# Calling the Rectangle detection procedure
	
	# return to ask if the user want another operation or not
	j another_op

switch10:
	
	li $v0, 4
	la $a0, Side_1
	syscall
	li $v0, 6
	syscall
	mov.s $f1, $f0		#move the value from f0 to f1
	
	li $v0, 4
	la $a0, Side_2
	syscall
	li $v0, 6
	syscall
	mov.s $f2, $f0		#move the value in f0 to f2
	
	li $v0, 4
	la $a0, Side_3
	syscall
	li $v0, 6
	syscall
	mov.s $f3, $f0		#move the value in f0 to f3
	
	jal Triangle_detection	# Calling the Triangle detection procedure

	# return to ask if the user want another operation or not
	j another_op
	
Exit_program:
	li $v0, 10
	syscall


Add:
	add.s $f3 , $f1, $f2
	jr $ra
	
Multiply:
	mul.d $f6, $f2, $f4
	jr $ra
	
Division:
	div.s $f3, $f1, $f2  	# division operation
	jr $ra

Min_of_list:

       	li $t0, 0 				# declration of array index
       	lw $s0, MyArray($t0) 		#stores the first element of the array in $s0 to begin looping and comparing ( $s0 = MyArray[0] )
       	li $t1, 1 				# increment the array index so the loop start from 1 not zero
 
	again:
 		beq $t1, $t3, Endloop 	#reahced the end so go to end loop
        	add $t0, $t0, 4 		#to refer to next element of array
        	lw  $s1, MyArray($t0)	#array index i is inside s1
        	ble $s0, $s1, nochange 	#if mini value is smaller than Array[i] we don't have to change anything,No change Function
        	move $s0, $s1 		#otherwise move value of value of that index in the mini value which is S0 
         
	nochange:
		add $t1, $t1,1  		#add one to loop counter
	 	j  again
	
	Endloop: 	
	     	jr $ra

Sin:
	lwc1 $f8, zeroValue         	#Load a float zero in coprocessor 1 to use it for float operations
        addi $t5, $zero,5
        addi $t6, $zero,6
        addi $t7, $zero,7
	lwc1 $f1, ToRadian          	#Load f1 with the value of PI which is 3.14
     	mul.s $f12, $f0, $f1       		#Multiply the previous result with angle and then store it back in angle
	add.s $f4, $f12, $f8               	#Store angle content into term variable, f4 is term 
      	add.s $f28, $f8, $f4               	#Store term variable into lastValue, f5 is lastValue
      	lwc1 $f21, one                  	#This represents f21: n 
      	lwc1 $f11, one                    	#This will always represent 1
      	addi $t0, $zero, 0               	#Ensure the register=zero so that we can use it as the loop counter, t0 is i
              
      	while5:                          	#While loop to calculate Taylor's Series
        	bgt $t0, 10, exit5          	#If the value of $t0 which is the counter is bigger than 10 then it will go to Exit5 label
           	lwc1 $f19, two
           	mul.s $f24, $f21, $f19     	#multiply n with 2
           	add.s $f27, $f24, $f11      #Use the previous result to add 1 
           	mul.s $f30, $f27, $f21      	#Multiply the previous result with 2
          	mul.s $f26, $f30, $f19     	#f26 is now the denominator
              
          	lwc1 $f13, negative
           	mul.s $f18, $f4, $f13       	#Negative the term
           	mul.s $f3, $f12, $f18       	#Multiply the term with angle
           	mul.s $f3, $f3, $f12        	#Multiply angle ith previous result again
           	div.s $f4, $f3, $f26        	#Divide the previous output over the denominator
                                           
          	add.s $f28, $f28, $f4          	#lastValue = lastValue + term;
           	add.s $f21, $f11, $f21     	#Increments the value of n
           	addi $t0, $t0, 1             	#Increments the value of counter
           	j while5                     	#The flow jumps back to the while loop if the condition is fullfilled        
        exit5:                          		#Return function result stored in $f5 which is lastValue 
        
       		jr $ra                        	#Returns to the function caller

Cos:
	#All of these are initial values to calculate the equations
	lwc1 $f31, one 			# this is the counter 
	lwc1 $f1, one
	lwc1 $f2, two
	lwc1 $f3, ToRadian		#The value of (PI/180) which is 0.01745
	lwc1 $f8, negative			#The value -1
	lwc1 $f9, one
	lwc1 $f11, one			# $f11 has the sum (Result)
	lwc1 $f14, check			#the number of iterations
	
	mul.s $f4, $f0, $f3			#convert the degree to radian
	 
	loop6:
		mul.s $f5, $f4, $f4		#(x*x)
	
		#(2*i-1)
		mul.s $f6, $f31, $f2		
		sub.s $f6, $f6, $f1
	
		mul.s $f7, $f31, $f2 	#(2*i)
	
		# collecting them together to put them in R ($f5)
		div.s $f5, $f5, $f6		
		div.s $f5, $f5, $f7		
		mul.s $f5, $f5, $f8		# put the negative sign 
	
		mul.s $f10, $f5, $f9		# t1 = R * t0  ($f10 = t1)
		add.s $f11, $f11, $f10	# sum = sum+t1
		mov.s $f9, $f10		# t0 = t1
		add.s $f31, $f31, $f1	# counter++
		c.eq.s $f31, $f14		# is i = 10
		bc1t exit6			# if the previous condition is true branch to exit label
		j loop6			# if the condition is false loop again from the (loop) label
	
	exit6:
		jr $ra
		
Tan:
	move $s0, $ra			#Store the location of the function caller, to allow us to use the ( jal ) operation again
	jal Sin					#Jumb to the Sin procedure and the result will be stored in $f28 register
	jal Cos				#Jumb to the Cos procedure and the result will be stored is $f11 register
	div.s $f3, $f28, $f11			#Divide Sin by Cos ( Tan = Sin / Cos )
	
	jr $s0					#Jumb back to the function caller of (Tan)
	                         	
Square_detection:

	c.eq.s $f1, $f2			#Check for the first and second sides
	bc1f exit8 				#if they are not equal jumb to exit8, else continue to the next check, and so on
	c.eq.s $f1, $f3
	bc1f exit8
	c.eq.s $f1, $f4
	bc1f exit8

	li $v0, 4
	la $a0, valid_S
	syscall	
	jr $ra
	
	exit8:					#This will be executed if it is not a square
		li $v0, 4
		la $a0, invalid_S
		syscall
		jr $ra


Rectangle_detection:

	c.eq.s $f1, $f2 			#if this two sides are equal jumb to label L to check for the other two sides
	bc1f L
	c.eq.s  $f3, $f4			#if this two sides are equal jumb to label L to check for the other two sides
	bc1f L
	li $v0, 4 	
	la $a0, valid_R
	syscall
	jr $ra
	
	L: 
		c.eq.s $f1, $f4		#Check if these two sides are equal or not and place the boolean value in the bclf
		bc1f  L1			#if these two sides are not equal jumb to L1, otherwise continue to check for the other two sides
		c.eq.s $f2, $f3		
		bc1f L1
		li $v0, 4 
		la $a0, valid_R		#this will execute if the two previous conditions are true. so, it is a rectangle
		syscall
		jr $ra
	
	L1:
		c.eq.s $f1, $f3
		bc1f L2
		c.eq.s $f2, $f4
		bc1f L2
		li $v0, 4 
		la $a0, valid_R
		syscall
		jr $ra
	
	L2:
		#if this execute then this is not a rectangle
		li $v0, 4 		
		la $a0, invalid_R
		syscall
		jr $ra

Triangle_detection:
	
	add.s $f4, $f1, $f2
	add.s $f5, $f2, $f3
	add.s $f6, $f3, $f1 
	c.le.s $f4, $f3		#if f4 (which is the summation of f1 and f2) is less than or equal the third side (f3)
	bc1t exit10			#then jumb to exit10 (and this is not a triangle), otherwise continue
	c.le.s $f5, $f1
	bc1t exit10
	c.le.s $f6, $f2
	bc1t exit10

	li $v0, 4			#if this executes then this is a triangle
	la $a0, valid_T
	syscall	
	jr $ra

	exit10:
		li $v0, 4
		la $a0, invalid_T
		syscall
		jr $ra
