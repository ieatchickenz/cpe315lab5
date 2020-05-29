main:
    # Use $a0-$a3 for arguments
    addi $s0, $0, 1    #use for 1
    or  $s1, $0, $0

    #Circle(30,100,20) head
    addi  $a0, $0, 30
    addi  $a1, $0, 100
    addi  $a2, $0, 20
    jal Circle

    #Line(30,80,30,30)  body
    addi  $a0, $0, 30
    addi  $a1, $0, 80
    addi  $a2, $0, 30
    addi  $a3, $0, 30
    jal Line

    # #Line(20,1,30,30) left leg
    addi  $a0, $0, 20
    addi  $a1, $0, 1
    addi  $a2, $0, 30
    addi  $a3, $0, 30
    jal Line

	# #Line(40,1,30,30) right leg
    addi  $a0, $0, 40
    addi  $a1, $0, 1
    addi  $a2, $0, 30
    addi  $a3, $0, 30
    jal Line

	# #Line(15,60,30,50) left arm
    addi  $a0, $0, 15
    addi  $a1, $0, 60
    addi  $a2, $0, 30
    addi  $a3, $0, 50
    jal Line

	# #Line(30,50,45,60) right arm
    addi  $a0, $0, 30
    addi  $a1, $0, 50
    addi  $a2, $0, 45
    addi  $a3, $0, 60
    jal Line

	# #Circle(24,105,3) left eye
    addi  $a0, $0, 24
    addi  $a1, $0, 105
    addi  $a2, $0, 3
    jal Circle

	# #Circle(36,105,3) right eye
    addi  $a0, $0, 36
    addi  $a1, $0, 105
    addi  $a2, $0, 3
    jal Circle

	# #Line(25,90,35,90) mouth center
    addi  $a0, $0, 25
    addi  $a1, $0, 90
    addi  $a2, $0, 35
    addi  $a3, $0, 90
    jal Line

	# #Line(25,90,20,95) mouth left
    addi  $a0, $0, 25
    addi  $a1, $0, 90
    addi  $a2, $0, 20
    addi  $a3, $0, 95
    jal Line

	# #Line(35,90,40,95) mouth right
    addi  $a0, $0, 35
    addi  $a1, $0, 90
    addi  $a2, $0, 40
    addi  $a3, $0, 95
    jal Line

    j   end

Line:
    #$a0 = x0
    #$a1 = y0
    #$a2 = x1
    #$a3 = y1
    
    #use $t9 as a place to store $ra so we dont have to use stack
    or  $t9, $0, $ra

    #t3 = st
    add $t3, $0, $0
    #$s2 = ystep
    add $s2, $0, $0
 
    sub $t0, $a3, $a1
    or  $t8, $0, $t0
    slt $t1, $t0, $0
    beq $t1, $0, skip1
    jal abs
    or  $t0, $0, $t8

skip1:
    sub $t2, $a2, $a0
    or  $t8, $0, $t2
    slt $t1, $t2, $0
    beq $t1, $0, skip2
    jal abs
    or  $t2, $0, $t8

skip2:
    #if 1
    slt $t1, $t2, $t0
    beq $t1, $0, stelse
    addi $t3, $0, 1

stelse:
    #if 2
    bne $t3, $s0, if3
    #swap x0, y0
    or  $t4, $0, $a0
    or  $a0, $0, $a1
    or  $a1, $0, $t4
    #swap x1, y1
    or  $t4, $0, $a2
    or  $a2, $0, $a3
    or  $a3, $0, $t4 

if3:
    #if3
    slt $t1, $a2, $a0
    beq $t1, $0, endif3
    #swap x0, x1
    or  $t4, $0, $a0
    or  $a0, $0, $a2
    or  $a2, $0, $t4
    #swap y0, y1
    or  $t4, $0, $a1
    or  $a1, $0, $a3
    or  $a3, $0, $t4

endif3:
    #$t5 is deltax
    #$t0 is deltay
    #$t6 is error
    #$a1 is y
    #$s2 is ystep
    sub $t5, $a2, $a0
    or  $t6, $0, $0

    sub $t0, $a3, $a1
    or  $t8, $0, $t0
    slt $t1, $t0, $0
    beq $t1, $0, endabs
    jal abs
    or  $t0, $0, $t8

endabs:
    slt $t1, $a1, $a3
    beq $t1, $0, ystepelse
    addi $s2, $0, 1
    addi $a2, $a2, 1
    j   forloop

ystepelse:
    sub $s2, $0, $s0
    addi $a2, $a2, 1

forloop:
    #for x from x0 to x1
    beq $a0, $a2, endFor
    #if st==1
    bne $t3, $s0, stelse2
    #do the plots
    #(y,x)
    sw  $a1, 0($s1)
    sw  $a0, 1($s1)
    addi $s1, $s1, 2
    j   endstif2

stelse2:
    #(x,y)
    sw  $a0, 0($s1)
    sw  $a1, 1($s1)
    addi $s1, $s1, 2 

endstif2:
    #error
    add $t6, $t6, $t0

    #last if 2*error >= deltax
    sll $t7, $t6, 1
    slt $t1, $t7, $t5
    beq $t1, $s0, errorif
    add $a1, $a1, $s2
    sub $t6, $t6, $t5

errorif:
    addi $a0, $a0, 1
    j forloop

endFor:
    jr  $t9

abs:
    #have to use $t8 as passing register
    sub $t8, $0, $t8
    jr  $ra 

Circle:
    #$a0 = xc
    #$a1 = yc
    #$a2 = r

    add $t0, $0, $0 #x
    or  $t1, $0, $a2 #y
    
    sll $a2, $a2, 1  #*2
    addi $t2, $0, 3
    sub $t2, $t2, $a2 #g = 3-2*r

    sll $a2, $a2, 1 #*2 -> *4
    addi $t3, $0, 10
    sub $t3, $t3, $a2  #diagonalInc

    addi $t4, $0, 6 #rightInc

cwhile:
    slt $t5, $t1, $t0
    beq $t5, $s0, endWhile

    #do the plots
    #1
    add $t8, $a0, $t0
    sw  $t8, 0($s1)
    add $t9, $a1, $t1
    sw  $t9, 1($s1)
    addi $s1, $s1, 2 
    
    #2
    add $t8, $a0, $t0
    sw  $t8, 0($s1)
    sub $t9, $a1, $t1
    sw  $t9, 1($s1)
    addi $s1, $s1, 2 
    
    #3
    sub $t8, $a0, $t0
    sw  $t8, 0($s1)
    add $t9, $a1, $t1
    sw  $t9, 1($s1)
    addi $s1, $s1, 2 
    
    #4
    sub $t8, $a0, $t0
    sw  $t8, 0($s1)
    sub $t9, $a1, $t1
    sw  $t9, 1($s1)
    addi $s1, $s1, 2 

    #5
    add $t8, $a0, $t1
    sw  $t8, 0($s1)
    add $t9, $a1, $t0
    sw  $t9, 1($s1)
    addi $s1, $s1, 2 

    #6
    add $t8, $a0, $t1
    sw  $t8, 0($s1)
    sub $t9, $a1, $t0
    sw  $t9, 1($s1)
    addi $s1, $s1, 2 

    #7
    sub $t8, $a0, $t1
    sw  $t8, 0($s1)
    add $t9, $a1, $t0
    sw  $t9, 1($s1)
    addi $s1, $s1, 2 

    #8
    sub $t8, $a0, $t1
    sw  $t8, 0($s1)
    sub $t9, $a1, $t0
    sw  $t9, 1($s1)
    addi $s1, $s1, 2 

    #if statement
    slt $t5, $t2, $0
    beq $t5, $s0, elseg
    add $t2, $t2, $t3
    addi $t3, $t3, 8
    addi $t1, $t1, -1 
    j endelseg

elseg:
    add $t2, $t2, $t4
    addi $t3, $t3, 4 

endelseg:
    addi $t4, $t4, 4
    addi $t0, $t0, 1
    j cwhile

endWhile:
    jr  $ra 

end: