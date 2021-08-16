# This program was written by Mahi Rahman
# v1.0.0
#
	# Requires:
	# - [no external symbols]
	#
	# Provides:
	# - Global variables:
	.globl	symbols
	.globl	grid
	.globl	snake_body_row
	.globl	snake_body_col
	.globl	snake_body_len
	.globl	snake_growth
	.globl	snake_tail

	# - Utility global variables:
	.globl	last_direction
	.globl	rand_seed
	.globl  input_direction__buf

	# - Functions for you to implement
	.globl	main
	.globl	init_snake
	.globl	update_apple
	.globl	move_snake_in_grid
	.globl	move_snake_in_array

	# - Utility functions provided for you
	.globl	set_snake
	.globl  set_snake_grid
	.globl	set_snake_array
	.globl  print_grid
	.globl	input_direction
	.globl	get_d_row
	.globl	get_d_col
	.globl	seed_rng
	.globl	rand_value

########################################################################
# Constant definitions.

N_COLS          = 15
N_ROWS          = 15
MAX_SNAKE_LEN   = N_COLS * N_ROWS

EMPTY           = 0
SNAKE_HEAD      = 1
SNAKE_BODY      = 2
APPLE           = 3

NORTH       = 0
EAST        = 1
SOUTH       = 2
WEST        = 3

########################################################################
# .DATA
	.data

# const char symbols[4] = {'.', '#', 'o', '@'}
symbols:
	.byte	'.', '#', 'o', '@'

	.align 2
# int8_t grid[N_ROWS][N_COLS] = { EMPTY }
grid:
	.space	N_ROWS * N_COLS

	.align 2
# int8_t snake_body_row[MAX_SNAKE_LEN] = { EMPTY }
snake_body_row:
	.space	MAX_SNAKE_LEN

	.align 2
# int8_t snake_body_col[MAX_SNAKE_LEN] = { EMPTY }
snake_body_col:
	.space	MAX_SNAKE_LEN

# int snake_body_len = 0
snake_body_len:
	.word	0

# int snake_growth = 0
snake_growth:
	.word	0

# int snake_tail = 0
snake_tail:
	.word	0

# Game over prompt, for your convenience...
main__game_over:
	.asciiz	"Game over! Your score was "

########################################################################
# .TEXT <main>
	.text
main:

	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    $ra
	# Uses:	    $a0, $t0, $v0, $t1, $t2, $t3
	# Clobbers: $a0
	#
	# Locals:
	#   - 'int direction' in $a0
	#   - ' int score' in $t3
	#
	# Structure:
	#   main
	#   -> [prologue]
	#   -> body
	#     -> loop
	#   -> [epilogue]

	# Code:
main__prologue:
	# set up stack frame
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

main__body:

	jal	init_snake			# initialise the snake
	jal	update_apple		# intialise the apple position

main__body_loop:
	jal	print_grid			# prints the grid
	jal	input_direction		# returns the current int direction into $v0

	move $a0, $v0			# copy $v0 (int direction) into $a0

	jal	update_snake		# update_snake(direction)
							# returns $v0 (boolean value)

	# if update_snake(direction) == true then main__body_loop
	beq	$v0, 1, main__body_loop

	lw	$t1, snake_body_len			# load snake_body_len into $t1
	li 	$t2, 3						# load 3 into $t2

	div	$t1, $t2		# snake_body_len / 3 ($t1 / $t2)
	mflo $t3			# current score ($t3)

	# printf("Game over! Your score was %d\n", score)

	# "Game over! Your score was "
	li	$v0,	4		
	la	$a0, main__game_over
	syscall

	# "%d"
	li	$v0, 1
	move $a0, $t3
	syscall	

	# "\n"
	li	$a0, '\n'
	li	$v0, 11
	syscall

main__epilogue:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu	$sp, $sp, 4

	# return 0
	li	$v0, 0
	jr	$ra

########################################################################
# .TEXT <init_snake>
	.text
init_snake:

	# Args:     void
	# Returns:  void
	#
	# Frame:    $ra
	# Uses:     $a0, $a1, $a2
	# Clobbers: $a0, $a1, $a2
	#
	# Locals:
	#   - void
	#
	# Structure:
	#   init_snake
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

	# Code:
init_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

init_snake__body:

	li	$a0, 7				# int row = 7
	li	$a1, 7				# int col = 7
	li	$a2, SNAKE_HEAD		# int body_piece = SNAKE_HEAD
	jal	set_snake			# set_snake(7, 7, SNAKE_HEAD)

	li	$a0, 7				# int row = 7
	li	$a1, 6				# int col = 6
	li	$a2, SNAKE_BODY		# int body_piece = SNAKE_BODY
	jal	set_snake			# set_snake(7, 6, SNAKE_BODY)

	li	$a0, 7				# int row = 7
	li	$a1, 5				# int col = 5
	li	$a2, SNAKE_BODY		# int body_piece = SNAKE_BODY
	jal	set_snake			# set_snake(7, 5, SNAKE_BODY)

	li	$a0, 7				# int row = 7
	li	$a1, 4				# int col = 4
	li	$a2, SNAKE_BODY		# int body_piece = SNAKE_BODY
	jal	set_snake			# set_snake(7, 4, SNAKE_BODY)

init_snake__epilogue:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu 	$sp, $sp, 4

	# return
	jr	$ra					

########################################################################
# .TEXT <update_apple>
	.text
update_apple:

	# Args:     void
	# Returns:  void
	#
	# Frame:    $ra
	# Uses:     $a0, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $t4, $t5
	# Clobbers: $a0
	#
	# Locals:
	#   - 'int apple_row' in $s0
	#   - 'int apple_col' in $s1
	#
	# Structure:
	#   update_apple
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

	# Code:
update_apple__prologue:
	# set up stack frame
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

update_apple__body:

	li	$a0, N_ROWS
	jal	rand_value	# rand_value(N_ROWS)
	move $s0, $v0	# apple_row = rand_value(N_ROWS)

	li	$a0, N_COLS
	jal	rand_value	# rand_value(N_COLS)
	move $s1, $v0	# apple_col = rand_value(N_COLS)

	la	$t0, grid
	mul	$t1, $s0, N_COLS
	add	$t2, $t1, $s1
	add	$t3, $t2, $t0

	lb	$t4, ($t3)			# grid[apple_row][apple_col]

	# if grid[apple_row][apple_col] != EMPTY then update_apple__body
	bne	$t4, EMPTY, update_apple__body
	
	li	$t5, APPLE			# load APPLE into $t5
	sb 	$t5, ($t3)			# grid[apple_row][apple_col] = APPLE

update_apple__epilogue:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu 	$sp, $sp, 4

	# return
	jr	$ra

########################################################################
# .TEXT <update_snake>
	.text
update_snake:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: bool
	#
	# Frame:    $ra, $s0, $s1, $s2, $s3, $s4
	# Uses:     $s0, $s1, $s2, $s3, $s4, $t0, $t1, $t2, $t3, $t4, $t5, 
	#	    $t6, $t7, $a0, $a1
	# Clobbers: $t0, $t1, $t2, $t3, $a0, $a1
	#
	# Locals:
	#   - 'int d_row' in $s0
	#   - 'int d_col' in $s1
	#   - 'int head_row' in $t4
	#   - 'int head_col' in $t5
	#   - 'int new_head_row ' in $s0
	#   - 'int new_head_col' in $s1
	#   - 'bool apple' in $s3
	#
	# Structure:
	# update_snake
	# -> [prologue]
	# -> body
	#   -> continue
	#   -> true
	#   -> end
	# -> [epilogue]

	# Code:
update_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -20

	sw	$s0, ($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$ra, 16($sp)

update_snake__body:

	jal	get_d_row		# get_d_row(direction)
	move $s0, $v0		# copy the return into $s0 (int d_row)

	jal	get_d_col		# get_d_col(direction)
	move $s1, $v0		# copy the return into $s1 (int d_col)

	la	$t1, snake_body_row
	lb	$t4, 0($t1)		# int head_row = snake_body_row[0]

	la	$t1, snake_body_col
	lb	$t5, 0($t1)		# int head_col = snake_body_col[0]

	la	$t0, grid
	mul	$t1, $t4, N_COLS
	add	$t2, $t1, $t5
	add	$t3, $t2, $t0

	li	$t1, SNAKE_BODY	# load SNAKE_BODY into $t1
	
	sb 	$t1, 0($t3)		# grid[head_row][head_col] = SNAKE_BODY
	
	add	$s0, $t4, $s0	# int new_head_row = head_row + d_row
	add	$s1, $t5, $s1	# int new_head_col = head_col + d_col

	blt	$s0, 0, update_snake__end		# if (new_head_row < 0)       return false
	bge	$s0, N_ROWS, update_snake__end	# if (new_head_row >= N_ROWS) return false
	blt	$s1, 0, update_snake__end		# if (new_head_col < 0)       return false
	bge	$s1, N_COLS, update_snake__end	# if (new_head_col >= N_COLS) return false

	la	$t2, grid
	mul	$t3, $s0, N_COLS
	add	$t4, $t3, $s1
	add	$t5, $t4, $t2

	lb	$t6, 0($t5)		# grid[new_head_row][new_head_col]

	li	$t7, APPLE		# load APPLE into $t8

	li	$s3, 0			# bool apple = False

	# if grid[new_head_row][new_head_col] != APPLE then update_snake__continue
	bne	$t6, $t7, update_snake__continue

	li	$s3, 1			# bool apple = True

update_snake__continue:

	lw	$s2, snake_body_len
	addi	$s2, $s2, -1	# snake_tail = snake_body_len - 1
	sw	$s2, snake_tail	
	
	move	$a0, $s0		# copy $s0 into $a0 as argument new_head_row
	move	$a1, $s1		# copy $s1 into $a1 as argument new_head_col
	jal	move_snake_in_grid	# move_snake_in_grid(new_head_row, new_head_col)

	li	$t3, 0				# false
	beq	$v0, $t3, update_snake__end	# if (! move_snake_in_grid(new_head_row, new_head_col))
						# return false

	move	$a0, $s0		# copy $s0 into $a0 as argument new_head_row
	move	$a1, $s1		# copy $s1 into $a1 as argument new_head_col
	jal	move_snake_in_array	# move_snake_in_array(new_head_row, new_head_col)
	
	# if apple != true then update_snake__true
	bne	$s3, 1, update_snake__true

	lw	$t0, snake_growth
	addiu $t0, $t0, 3
	sw	$t0, snake_growth	# snake_growth += 3

	jal	update_apple

update_snake__true:

	# return true
	li	$v0, 1
	j	update_snake__epilogue		

update_snake__end:

	# return false
	li	$v0, 0		

update_snake__epilogue:
	# tear down stack frame
	lw	$s0, ($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	
	addiu 	$sp, $sp, 20

	# return
	jr	$ra

########################################################################
# .TEXT <move_snake_in_grid>
	.text
move_snake_in_grid:

	# Args:
	#   - $a0: new_head_row
	#   - $a1: new_head_col
	# Returns:
	#   - $v0: bool
	#
	# Frame:    $ra
	# Uses:     $t0, $t1, $t2, $t3, $t4, $t5, $v0
	# Clobbers: $t0, $t1, $t2, $t3
	#
	# Locals:
	#   - 'int tail' in $t0
	#   - 'int tail_row' in $t4
	#   - 'int tail_col' in $t5
	#
	# Structure:
	# move_snake_in_grid
	# -> [prologue]
	# -> body
	#   -> growth
	#     -> continue_growth
	#   -> false
	# -> [epilogue]

	# Code:
move_snake_in_grid__prologue:
	# set up stack frame
	addiu	$sp, $sp, -4
	sw	$ra, ($sp)

move_snake_in_grid__body:

	lw	$t0, snake_growth	# load snake_growth into $t0
	# if (snake_growth > 0)
	bgt	$t0, 0, move_snake_in_grid_growth

	lw	$t0, snake_tail		# ($t0) int tail = snake_tail

	la	$t1, snake_body_row
	mul	$t2, $t0, 1
	add	$t3, $t2, $t1
	lb	$t4, 0($t3)			# int tail_row = snake_body_row[tail]

	la	$t1, snake_body_col
	mul	$t2, $t0, 1
	add	$t3, $t2, $t1
	lb	$t5, 0($t3)			# int tail_col = snake_body_col[tail]

	la	$t0, grid
	mul	$t1, $t4, N_COLS
	add	$t2, $t1, $t5
	add	$t3, $t2, $t0
	
	li	$t0, EMPTY
	sb	$t0, 0($t3)			# grid[tail_row][tail_col] = EMPTY

move_snake_in_grid_continue_growth:

	la	$t0, grid
	mul	$t1, $a0, N_COLS
	add	$t2, $t1, $a1
	add	$t3, $t2, $t0

	lb	$t4, 0($t3)			# grid[new_head_row][new_head_col]

	# if grid[new_head_row][new_head_col] == SNAKE_BODY then move_snake_in_grid_false
	beq	$t4, SNAKE_BODY, move_snake_in_grid_false
	
	li	$t0, SNAKE_HEAD	# load SNAKE_HEAD into $t0
	sb	$t0, 0($t3)		# grid[new_head_row][new_head_col] = SNAKE_HEAD
	
	# return true
	li	$v0, 1	
	j	move_snake_in_grid__epilogue

move_snake_in_grid_growth:

	lw	$t0, snake_tail
	addi	$t0, $t0, 1		# #snake_tail++
	sw	$t0, snake_tail	
		
	lw	$t1, snake_body_len
	addiu	$t1, $t1, 1
	sw	$t1, snake_body_len	# snake_body_len++

	lw	$t2, snake_growth
	addiu	$t2, $t2, -1
	sw	$t2, snake_growth	# snake_growth--
		
	j	move_snake_in_grid_continue_growth

move_snake_in_grid_false:
	# return false
	li	$v0, 0

move_snake_in_grid__epilogue:
	# tear down stack frame
	lw	$ra, ($sp)
	addiu 	$sp, $sp, 4

	# return true
	jr	$ra			

########################################################################
# .TEXT <move_snake_in_array>
	.text
move_snake_in_array:

	# Arguments:
	#   - $a0: int new_head_row
	#   - $a1: int new_head_col
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1, $s2
	# Uses:     $s0, $s1, $s2, $t0, $t1, $t2, $t3, $t4, $t5, $a0, $a1, $a2
	# Clobbers: $a0, $a1, $a2, $t0, $t1, $t2, $t3, $t4, $t5
	#
	# Locals:
	#   - 'int i' in $s0
	#
	# Structure:
	#   move_snake_in_array
	# -> [prologue]
	# -> body
	# -> move_snake_in_array__loop01
	#   -> move_snake_in_array__end01
	# -> [epilogue]

	# Code:
move_snake_in_array__prologue:
	# set up stack frame
	addiu	$sp, $sp, -16

	sw	$s0, ($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$ra, 12($sp)	

move_snake_in_array__body:
	
	lw	$s0, snake_tail		# ($s0) int i = snake_tail
	move $s1, $a0			# ($s1) int new_head_row
	move $s2, $a1			# ($s2) int new_head_col

move_snake_in_array__loop01:

	# if i < 1 then move_snake_in_array__end01
	blt	$s0, 1, move_snake_in_array__end01	

	addiu $t0, $s0, -1		# index = i - 1

	la	$t1, snake_body_row
	mul	$t2, $t0, 1
	add	$t3, $t2, $t1
	lb	$t4, 0($t3)		# x = snake_body_row[index]

	la	$t1, snake_body_col
	mul	$t2, $t0, 1
	add	$t3, $t2, $t1
	lb	$t5, 0($t3)		# y = snake_body_col[index]

	# move x, y and i as arguments
	move $a0, $t4
	move $a1, $t5
	move $a2, $s0
	jal	set_snake_array		# set_snake_array(x, y, i)

	addiu	$s0, $s0, -1		# i--

	j	move_snake_in_array__loop01
	
move_snake_in_array__end01:

	# move new_head_row and new_head_col as arguments
	move	$a0, $s1
	move 	$a1, $s2
	li	$a2, 0			# load 0 into $a2 as third argument to set_snake_array
	jal set_snake_array	# set_snake_array(new_head_row, new_head_col, 0)

move_snake_in_array__epilogue:
	# tear down stack frame
	lw	$s0, ($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$ra, 12($sp)

	addiu 	$sp, $sp, 16

	jr	$ra			# return

########################################################################

	.data

last_direction:
	.word	EAST

rand_seed:
	.word	0

input_direction__invalid_direction:
	.asciiz	"invalid direction: "

input_direction__bonk:
	.asciiz	"bonk! cannot turn around 180 degrees\n"

	.align	2
input_direction__buf:
	.space	2

########################################################################
# .TEXT <set_snake>
	.text
set_snake:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int body_piece
	# Returns:  void
	#
	# Frame:    $ra, $s0, $s1
	# Uses:     $a0, $a1, $a2, $t0, $s0, $s1
	# Clobbers: $t0
	#
	# Locals:
	#   - `int row` in $s0
	#   - `int col` in $s1
	#
	# Structure:
	#   set_snake
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

	# Code:
set_snake__prologue:
	# set up stack frame
	addiu	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s0, 4($sp)
	sw	$s1,  ($sp)

set_snake__body:
	move	$s0, $a0		# $s0 = row
	move	$s1, $a1		# $s1 = col

	jal	set_snake_grid		# set_snake_grid(row, col, body_piece)

	move	$a0, $s0
	move	$a1, $s1
	lw	$a2, snake_body_len
	jal	set_snake_array		# set_snake_array(row, col, snake_body_len)

	lw	$t0, snake_body_len
	addiu	$t0, $t0, 1
	sw	$t0, snake_body_len	# snake_body_len++

set_snake__epilogue:
	# tear down stack frame
	lw	$s1,  ($sp)
	lw	$s0, 4($sp)
	lw	$ra, 8($sp)
	addiu 	$sp, $sp, 12

	# return
	jr	$ra			

########################################################################
# .TEXT <set_snake_grid>
	.text
set_snake_grid:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int body_piece
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0, $a1, $a2, $t0
	# Clobbers: $t0
	#
	# Locals:   None
	#
	# Structure:
	#   set_snake
	#   -> body

	# Code:
	li	$t0, N_COLS
	mul	$t0, $t0, $a0		#  15 * row
	add	$t0, $t0, $a1		# (15 * row) + col
	sb	$a2, grid($t0)		# grid[row][col] = body_piece

	jr	$ra			# return

########################################################################
# .TEXT <set_snake_array>
	.text
set_snake_array:

	# Args:
	#   - $a0: int row
	#   - $a1: int col
	#   - $a2: int nth_body_piece
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0, $a1, $a2
	# Clobbers: None
	#
	# Locals:   None
	#
	# Structure:
	#   set_snake_array
	#   -> body

	# Code:
	sb	$a0, snake_body_row($a2)	# snake_body_row[nth_body_piece] = row
	sb	$a1, snake_body_col($a2)	# snake_body_col[nth_body_piece] = col

	# return
	jr	$ra

########################################################################
# .TEXT <print_grid>
	.text
print_grid:

	# Args:     void
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $v0, $a0, $t0, $t1, $t2
	# Clobbers: $v0, $a0, $t0, $t1, $t2
	#
	# Locals:
	#   - `int i` in $t0
	#   - `int j` in $t1
	#   - `char symbol` in $t2
	#
	# Structure:
	#   print_grid
	#   -> for_i_cond
	#     -> for_j_cond
	#     -> for_j_end
	#   -> for_i_end

	# Code:
	li	$v0, 11
	li	$a0, '\n'
	syscall				# putchar('\n')

	li	$t0, 0			# int i = 0

print_grid__for_i_cond:
	bge	$t0, N_ROWS, print_grid__for_i_end	# while (i < N_ROWS)

	li	$t1, 0			# int j = 0

print_grid__for_j_cond:
	bge	$t1, N_COLS, print_grid__for_j_end	# while (j < N_COLS)

	li	$t2, N_COLS
	mul	$t2, $t2, $t0		#                             15 * i
	add	$t2, $t2, $t1		#                            (15 * i) + j
	lb	$t2, grid($t2)		#                       grid[(15 * i) + j]
	lb	$t2, symbols($t2)	# char symbol = symbols[grid[(15 * i) + j]]

	li	$v0, 11			# syscall 11: print_character
	move	$a0, $t2
	syscall				# putchar(symbol)

	addiu	$t1, $t1, 1		# j++

	j	print_grid__for_j_cond

print_grid__for_j_end:

	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# putchar('\n')

	addiu	$t0, $t0, 1		# i++

	j	print_grid__for_i_cond

print_grid__for_i_end:

	# return
	jr	$ra			

########################################################################
# .TEXT <input_direction>
	.text
input_direction:

	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0, $a1, $t0, $t1
	# Clobbers: $v0, $a0, $a1, $t0, $t1
	#
	# Locals:
	#   - `int direction` in $t0
	#
	# Structure:
	#   input_direction
	#   -> input_direction__do
	#     -> input_direction__switch
	#       -> input_direction__switch_w
	#       -> input_direction__switch_a
	#       -> input_direction__switch_s
	#       -> input_direction__switch_d
	#       -> input_direction__switch_newline
	#       -> input_direction__switch_null
	#       -> input_direction__switch_eot
	#       -> input_direction__switch_default
	#     -> input_direction__switch_post
	#     -> input_direction__bonk_branch
	#   -> input_direction__while

	# Code:
input_direction__do:
	li	$v0, 8			# syscall 8: read_string
	la	$a0, input_direction__buf
	li	$a1, 2
	syscall				# direction = getchar()

	lb	$t0, input_direction__buf

input_direction__switch:
	beq	$t0, 'w',  input_direction__switch_w	# case 'w':
	beq	$t0, 'a',  input_direction__switch_a	# case 'a':
	beq	$t0, 's',  input_direction__switch_s	# case 's':
	beq	$t0, 'd',  input_direction__switch_d	# case 'd':
	beq	$t0, '\n', input_direction__switch_newline	# case '\n':
	beq	$t0, 0,    input_direction__switch_null	# case '\0':
	beq	$t0, 4,    input_direction__switch_eot	# case '\004':
	j	input_direction__switch_default		# default:

input_direction__switch_w:
	li	$t0, NORTH			# direction = NORTH
	j	input_direction__switch_post	# break

input_direction__switch_a:
	li	$t0, WEST			# direction = WEST
	j	input_direction__switch_post	# break

input_direction__switch_s:
	li	$t0, SOUTH			# direction = SOUTH
	j	input_direction__switch_post	# break

input_direction__switch_d:
	li	$t0, EAST			# direction = EAST
	j	input_direction__switch_post	# break

input_direction__switch_newline:
	j	input_direction__do		# continue

input_direction__switch_null:
input_direction__switch_eot:
	li	$v0, 17			# syscall 17: exit2
	li	$a0, 0
	syscall				# exit(0)

input_direction__switch_default:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, input_direction__invalid_direction
	syscall				# printf("invalid direction: ")

	li	$v0, 11			# syscall 11: print_character
	move	$a0, $t0
	syscall				# printf("%c", direction)

	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# printf("\n")

	j	input_direction__do	# continue

input_direction__switch_post:
	blt	$t0, 0, input_direction__bonk_branch	# if (0 <= direction ...
	bgt	$t0, 3, input_direction__bonk_branch	# ... && direction <= 3 ...

	lw	$t1, last_direction	#     last_direction
	sub	$t1, $t1, $t0		#     last_direction - direction
	abs	$t1, $t1		# abs(last_direction - direction)
	beq	$t1, 2, input_direction__bonk_branch	# ... && abs(last_direction - direction) != 2)

	sw	$t0, last_direction	# last_direction = direction

	move	$v0, $t0
	jr	$ra			# return direction

input_direction__bonk_branch:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, input_direction__bonk
	syscall				# printf("bonk! cannot turn around 180 degrees\n")

input_direction__while:
	j	input_direction__do	# while (true)

########################################################################
# .TEXT <get_d_row>
	.text
get_d_row:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0
	# Clobbers: $v0
	#
	# Locals:   None
	#
	# Structure:
	#   get_d_row
	#   -> get_d_row__south:
	#   -> get_d_row__north:
	#   -> get_d_row__else:

	# Code:
	beq	$a0, SOUTH, get_d_row__south	# if (direction == SOUTH)
	beq	$a0, NORTH, get_d_row__north	# else if (direction == NORTH)
	j	get_d_row__else			# else

get_d_row__south:
	li	$v0, 1
	# return 1
	jr	$ra

get_d_row__north:
	li	$v0, -1
	# return -1
	jr	$ra

get_d_row__else:
	li	$v0, 0
	# return 0
	jr	$ra

########################################################################
# .TEXT <get_d_col>
	.text
get_d_col:

	# Args:
	#   - $a0: int direction
	# Returns:
	#   - $v0: int
	#
	# Frame:    None
	# Uses:     $v0, $a0
	# Clobbers: $v0
	#
	# Locals:   None
	#
	# Structure:
	#   get_d_col
	#   -> get_d_col__east:
	#   -> get_d_col__west:
	#   -> get_d_col__else:

	# Code:
	beq	$a0, EAST, get_d_col__east	# if (direction == EAST)
	beq	$a0, WEST, get_d_col__west	# else if (direction == WEST)
	j	get_d_col__else			# else

get_d_col__east:
	li	$v0, 1
	# return 1
	jr	$ra

get_d_col__west:
	li	$v0, -1
	# return -1
	jr	$ra

get_d_col__else:
	li	$v0, 0
	# return 0
	jr	$ra

########################################################################
# .TEXT <seed_rng>
	.text
seed_rng:

	# Args:
	#   - $a0: unsigned int seed
	# Returns:  void
	#
	# Frame:    None
	# Uses:     $a0
	# Clobbers: None
	#
	# Locals:   None
	#
	# Structure:
	#   seed_rng
	#   -> body

	# Code:
	sw	$a0, rand_seed		# rand_seed = seed

	# return
	jr	$ra

########################################################################
# .TEXT <rand_value>
	.text
rand_value:

	# Args:
	#   - $a0: unsigned int n
	# Returns:
	#   - $v0: unsigned int
	#
	# Frame:    None
	# Uses:     $v0, $a0, $t0, $t1
	# Clobbers: $v0, $t0, $t1
	#
	# Locals:
	#   - `unsigned int rand_seed` cached in $t0
	#
	# Structure:
	#   rand_value
	#   -> body

	# Code:
	lw	$t0, rand_seed		#  rand_seed

	li	$t1, 1103515245
	mul	$t0, $t0, $t1		#  rand_seed * 1103515245

	addiu	$t0, $t0, 12345		#  rand_seed * 1103515245 + 12345

	li	$t1, 0x7FFFFFFF
	and	$t0, $t0, $t1		# (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF

	sw	$t0, rand_seed		# rand_seed = (rand_seed * 1103515245 + 12345) & 0x7FFFFFFF

	rem	$v0, $t0, $a0
	# return rand_seed % n
	jr	$ra