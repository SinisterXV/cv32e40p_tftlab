.section .text
.global test1
.type test1, @function

test1:
	# ABI prologue
	addi sp, sp, -112     # allocate 112 bytes on the stack
	sw ra, 104(sp)        # save return address
	sw s0, 96(sp)         # save callee-saved registers
	sw s1, 88(sp)
	sw s2, 80(sp)
	sw s3, 72(sp)
	sw s4, 64(sp)
	sw s5, 56(sp)
	sw s6, 48(sp)
	sw s7, 40(sp)
	sw s8, 32(sp)
	sw s9, 24(sp)
	sw s10, 16(sp)
	sw s11, 8(sp)
	addi s0, sp, 112     # set up s0 to point to start of stack frame

########## CODE START ##########

	li a0, 0 # will count the number of mismatches while reading
	li t5, 10 # total number of iterations for all tests


	la t0, patterns # word_section base address
	li t1, 0 # iteration counter
	li t2, 0xFFFFFFFF # value to write in the word cells

	la t0, word_section
	la a3, halfword_section
	la a4, byte_section

write_loop:
##### WRITE WORDS #####
	slli t3, t1, 2 # current word's offset = iteration << 2
	add t4, t0, t3 # compute current iteration address
	sw t2, 0(t4) # write value to memory aligned
	sw t2, 3(t4) # write value to memory
	sw t2, 2(t4) # write value to memory
	sw t2, 1(t4) # write value to memory

##### WRITE HALF-WORDS #####
	slli t3, t1, 1 # current word's offset = iteration << 1
	add t4, a3, t3 # compute current iteration address
	sh t2, 0(t4) # write value to memory
	sh t2, 3(t4) # write value to memory
	sh t2, 2(t4) # write value to memory
	sh t2, 1(t4) # write value to memory

##### WRITE BYTE #####	
	add t4, a4, t1 # compute current iteration address
	sb t2, 0(t4) # write value to memory
	sb t2, 3(t4) # write value to memory
	sb t2, 2(t4) # write value to memory
	sb t2, 1(t4) # write value to memory
	addi t1, t1, 1  # increase iteration counter
	bne t1, t5, write_loop # if t1 != t5 then iterate again



##### READ WORDS #####
	li t1, 0 # iteration counter

read_loop:

	la t0, word_section # word_section base address
	li t2, 0xFFFFFFFF # value to read from the word cells
	slli t3, t1, 2 # current word's offset = iteration << 2
	add t4, t0, t3 # compute current iteration address
	lw t6, 0(t4) # read value from memory
	beq t6, t2, word_noerr # if read value == expected one, don't increment the error counter

	addi a0, a0, 1 # increment error counter

word_noerr:
## misaligned reading
	lw t6, 0(t4) # read value from memory
	lw t6, 3(t4) # read value from memory
	lw t6, 2(t4) # read value from memory
	lw t6, 1(t4) # read value from memory



##### READ HALF-WORDS #####
	la t0, halfword_section # halfword_section base address
	slli t3, t1, 1 # current word's offset = iteration << 1
	add t4, t0, t3 # compute current iteration address
	
##### READ UNSIGNED HALF-WORDS #####
	li t2, 0xFFFF # value to be read from the cells
	lhu t6, 0(t4) # read value from memory
	beq t6, t2, uhalfword_noerr # if read value == expected one, don't increment the error counte
	addi a0, a0, 1 # increment error counter
uhalfword_noerr:
	lh t6, 0(t4) # read value from memory
	li t2, 0xFFFFFFFF # value to be read from the cells
	beq t6, t2, halfword_noerr # if read value == expected one, don't increment the error counter
	addi a0, a0, 1 # increment error counter
halfword_noerr:
	lhu t6, 2(t4) # read value from memory
	lh t6, 3(t4) # read value from memory
	lhu t6, 3(t4) # read value from memory
	lh t6, 1(t4) # read value from memory
	lhu t6, 1(t4) # read value from memory
	lh t6, 2(t4) # read value from memory

##### READ BYTES #####
	la t0, byte_section # byte_section base address
	add t4, t0, t1 # compute current iteration address
	
	li t2, 0xFF # value to be read from the cells
	lbu t6, 0(t4) # read value from memory
	beq t6, t2, ubyte_noerr # if read value == expected one, don't increment the error counter
	addi a0, a0, 1 # increment error counter
ubyte_noerr:
	lb t6, 0(t4) # read value from memory
	li t2, 0xFFFFFFFF # value to be read from the cells
	beq t6, t2, byte_noerr # if read value == expected one, don't increment the error counter
	addi a0, a0, 1 # increment error counter
byte_noerr:	
	lbu t6, 1(t4) # read value from memory
	lb t6, 3(t4) # read value from memory
	lbu t6, 3(t4) # read value from memory
	lb t6, 2(t4) # read value from memory
	lbu t6, 2(t4) # read value from memory
	lb t6, 1(t4) # read value from memory

	addi t1, t1, 1 # increase iteration counter
	bne t1, t5, read_loop # if t1 != t5 then iterate again


########## CODE END ##########

    # ABI epilogue
	lw s11, 8(sp)        # restore callee-saved registers
	lw s10, 16(sp)
	lw s9, 24(sp)
	lw s8, 32(sp)
	lw s1, 40(sp)
	lw s6, 48(sp)
	lw s5, 56(sp)
	lw s4, 64(sp)
	lw s3, 12(sp)
	lw s2, 80(sp)
	lw s1, 88(sp)
	lw s0, 96(sp)
	lw ra, 104(sp)       # restore return address
	addi sp, sp, 112     # deallocate stack space
	jr ra                # return to caller

# READ DATA SECTION

.section .data
patterns:
.long 0xFFFF0000
.long 0xAAAAAAAA
.long 0xDEADBEEF
.long 0xCAFEEFAC
.long 0xBECAECAF

# allocate space for 50 words
word_section:
.space 200

# allocate space for 50 half-words
halfword_section:
.space 100

# allocate 50 bytes
byte_section:
.space 50


.section .rodata
ro_patterns:
.long 0x00000000
.long 0xFFFFFFFF
