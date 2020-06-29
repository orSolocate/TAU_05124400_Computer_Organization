add $t2, $zero, $imm, 1						  # $t2 = 1
out $t2, $zero, $imm, 0						  # enable irq0
add $t3, $zero, $imm, 255                     # $t3 = 255
lw $s1, $zero, $imm, 1024                     # load MEM[1024] = 195955
lw $s0, $zero, $imm, 1025                     # load MEM[1025] = 200000
lw $s2, $zero, $imm, 1026                     # load MEM[1026] = 200005
out $t3, $zero, $imm, 13                      # timermax = 255 , frequency = 256HZ
out $t2, $zero, $imm, 11                      # timerenable=1
add $t0, $zero, $imm, 6						  # set $t0 = 6
out $s1, $zero, $imm, 10                      # display the time
out $imm, $t0, $zero, Int_handler			  # irqhandler=Int_handler  
 
Loop 
    in $s1, $zero, $imm, 10                       # $s1=display
	beq $imm, $s1, $s2, Exit                      # stay in loop until display=200005
	beq $imm, $zero, $zero, Loop				  # back to Loop

	
Int_handler
	add $t3, $zero, $imm, 9                       # $t3 = 9 
	and $s1, $imm, $t0, 0xf                       # sampling the 4 LSB
	beq $imm, $s1, $t3, CriticTime                # if 195959 then jump to CriticTime
	add $s1, $t0, $imm, 1                         # $t0= $t0 + 1 
Update_time:
	out $s1, $zero, $imm, 10                      # display the time
	add $t1, $zero, $zero, 0					  # $t1=0
	out $t1, $zero, $imm, 3						  # irqstatus=0
	reti $zero, $zero, $zero, 0					  # return from interrupt

CriticTime:
	lw $s1, $zero, $imm, 1025                     # load MEM[1025] = 200000
	beq $imm, $zero, $zero, Update_time           # Loop again , with 2000000
	
Exit
	halt $zero, $zero, $zero, 0

	.word 1024 0X195955                                           # start time
	.word 1025 0x1fffff                                           # time before 20:00:00 , critic time
	.word 1026 0x200005                                           # time before 20:00:05 , end time