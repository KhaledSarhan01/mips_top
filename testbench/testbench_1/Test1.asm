# Filename: mips_self_test.asm
# Description: Self-test diagnostic for MIPS ALU and Memory

# --- Part 1: Addition Test ---
addi $s0, $0, 0x0AF0    # Initialize s0 = 2800
addi $s1, $0, 0x04B0    # Initialize s1 = 1200
add  $s2, $s0, $s1      # s2 = s0 + s1
addi $t0, $0, 0x0FA0    # Load expected result (0x0FA0)
beq  $s2, $t0, NEXT1    # Check if s2 == expected
j    ERROR              # If not equal, jump to ERROR

NEXT1:
# --- Part 2: Subtraction Test ---
sub  $s3, $s0, $s1      # s3 = s0 - s1
addi $t1, $0, 0x0640    # Load expected result (0x0640)
beq  $s3, $t1, NEXT2    # Check if s3 == expected
j    ERROR

NEXT2:
# --- Part 3: Logical AND Test ---
and  $s4, $s0, $s1      # s4 = s0 AND s1
addi $t2, $0, 0x00B0    # Load expected result (0x00B0)
beq  $s4, $t2, NEXT3    # Check if s4 == expected
j    ERROR

NEXT3:
# --- Part 4: Logical OR Test ---
or   $s5, $s0, $s1      # s5 = s0 OR s1
addi $t3, $0, 0x0EF0    # Load expected result (0x0EF0)
beq  $s5, $t3, NEXT4    # Check if s5 == expected
j    ERROR

NEXT4:
# --- Part 5: Memory Store/Load Test ---
addi $t4, $0, 0x0064    # Set base register t4 = 100
sw   $s0, 50($t4)       # Store s0 at address (100 + 50) = 150
lw   $t5, 50($t4)       # Load back from address 150 into t5
beq  $s0, $t5, DONE     # Verify loaded value matches stored value
# Fall through to ERROR if mem check fails (implicit logic here, though usually explicit jump is safer)

ERROR:
addi $s0, $0, 0xDEAD    # Load Failure Code into s0
j    SKIP

DONE:
addi $s0, $0, 0xD08E    # Load Success Code into s0

SKIP:
nop                     # End of logic
