//------------ Imports and Defintions ------------//
import mips_pkg::*;
`define GET_REG(idx) u_mips_datapath.u_mips_datapath_regfile.registers[idx]
`define GET_HI u_mips_datapath.u_mips_datapath_lo_hi_reg.hi_reg
`define GET_LO u_mips_datapath.u_mips_datapath_lo_hi_reg.lo_reg
`define JTA {$past(pc[31:28]),instr_jaddr,2'b0}
`define BTA ($past(pc) + 4 + (SignImm << 2))
`define GET_RA `GET_REG('d31)
typedef bit[31:0] uint32_t;
typedef bit[63:0] uint64_t;

//------------ Assertion Module ------------//

module mips_sva
(	input clk,rst_n,
	// To instruction Memory
	input [PC_WIDTH-1:0]     pc,
	input  [INSTR_WITDTH-1:0] instr,
	input logic arth_overflow_exception,
	// output [31:0] s0,
	// To Data Memory
	input memwrite,
	input [DATA_MEM_WIDTH-1:0] memaddr,writedata,
	input [DATA_MEM_WIDTH-1:0] readdata
);
//------------ Instruction Decoding ------------//
	
    opcode_t    instr_opcode;
    funct_t     instr_funct;
    rfaddr_t    instr_rs,instr_rt,instr_rd;
    shmat_t     instr_shmat;
    immediate_t instr_imm;
    jaddress_t  instr_jaddr;
	uint32_t    SignImm,ZeroImm;
    
    assign instr_opcode = opcode_t'(instr[31:26]);
    assign instr_funct  = funct_t'(instr[5:0]);
    assign instr_rs  	= rfaddr_t'(instr[25:21]);
    assign instr_rt  	= rfaddr_t'(instr[20:16]);
    assign instr_rd  	= rfaddr_t'(instr[15:11]);
    assign instr_imm 	= immediate_t'(instr[15:0]);
    assign instr_shmat 	= shmat_t'(instr[10:6]);
    assign instr_jaddr 	= jaddress_t'(instr[25:0]);
	assign SignImm   	= {{16{instr_imm[15]}},instr_imm};
	assign ZeroImm		= {{16{1'b0}},instr_imm};
//------------ Sequential Assertions ------------// 
// ALU Instructions
	// ADD
		property ADD_PROPERTY;
			@(posedge clk) disable iff(!rst_n) 
			(instr_opcode == RType && instr_funct == ADD)
			|=> 
			(({arth_overflow_exception,`GET_REG($past(instr_rd,1))} == ($signed(`GET_REG($past(instr_rs,1))) + $signed(`GET_REG($past(instr_rt,1))))));
		endproperty
		ADD_ASSERT: assert property (ADD_PROPERTY)
			else $error("ADD: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h,overflow = %b",
			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))),$sampled(arth_overflow_exception));
		ADD_COVER:	cover property (ADD_PROPERTY);
		
	// SUB
		property SUB_PROPERTY;
			@(posedge clk) disable iff(!rst_n) 
			(instr_opcode == RType && instr_funct == SUB) 
			|=>
			(({arth_overflow_exception,`GET_REG($past(instr_rd,1))} == ($signed(`GET_REG($past(instr_rs,1))) - $signed(`GET_REG($past(instr_rt,1))))));
		endproperty
		SUB_ASSERT: assert property (SUB_PROPERTY) 
			else $error("SUB: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h,overflow = %b",
			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))),$sampled(arth_overflow_exception));
		SUB_COVER: cover property (SUB_PROPERTY);

	// AND
		property AND_PROPERTY;
			@(posedge clk) disable iff(!rst_n) 
			(instr_opcode == RType && instr_funct == AND) 
			|=>
			(`GET_REG($past(instr_rd,1)) == (`GET_REG($past(instr_rs,1)) & `GET_REG($past(instr_rt,1))))
		endproperty
		AND_ASSERT: assert property (AND_PROPERTY) 
			else $error("AND: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h",
			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))));
		AND_COVER: cover property (AND_PROPERTY);

	// OR
		property OR_PROPERTY;
			@(posedge clk) disable iff(!rst_n) 
			(instr_opcode == RType && instr_funct == OR) 
			|=>
			(`GET_REG($past(instr_rd,1)) == (`GET_REG($past(instr_rs,1)) | `GET_REG($past(instr_rt,1))))
		endproperty
		OR_ASSERT: assert property (OR_PROPERTY) 
			else $error("OR: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h",
			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))));
		OR_COVER: cover property(OR_PROPERTY);

	// XOR
		property XOR_PROPERTY;
			@(posedge clk) disable iff(!rst_n) 
			(instr_opcode == RType && instr_funct == XOR) 
			|=>
			(`GET_REG($past(instr_rd,1)) == (`GET_REG($past(instr_rs,1)) ^ `GET_REG($past(instr_rt,1))))
		endproperty
		XOR_ASSERT: assert property (XOR_PROPERTY) 
			else $error("XOR: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h",
			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))));
		XOR_COVER: cover property (XOR_PROPERTY);
	
	// NOR
		property NOR_PROPERTY;
			@(posedge clk) disable iff(!rst_n) 
			(instr_opcode == RType && instr_funct == NOR) 
			|=>
			(`GET_REG($past(instr_rd,1)) == ~(`GET_REG($past(instr_rs,1)) | `GET_REG($past(instr_rt,1))))
		endproperty
		NOR_ASSERT: assert property (NOR_PROPERTY) 
		else $error("NOR: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h",
			 $time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))));
		NOR_COVER: cover property (NOR_PROPERTY);

	// SLT 
		property SLT_PROPERTY;
			@(posedge clk) disable iff(!rst_n) 
			(instr_opcode == RType && instr_funct == SLT) 
			|=>
			(`GET_REG($past(instr_rd,1)) == ($signed(`GET_REG($past(instr_rs,1))) < $signed(`GET_REG($past(instr_rt,1)))))
		endproperty
		SLT_ASSERT: assert property (SLT_PROPERTY) 
		else $error("SLT: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h",
			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))));
		SLT_COVER: cover property (SLT_PROPERTY);
	
	// SLL_ASSERT: 
	// 	assert property 
	// 	(
	// 		@(posedge clk) disable iff(!rst_n) 
	// 		(instr_opcode == RType && instr_funct == SLL) 
	// 		|=>
	// 		(`GET_REG($past(instr_rd,1)) == (`GET_REG($past(instr_rt,1)) << instr_shmat))
	// 	) 
	// 	else
	// 	$error("SLL: Time %0t: Sampled rd= %h, Sampled rt= %h, Sampled shmat= %h",
	// 		$time,$sampled(`GET_REG($past(instr_rd,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG(instr_shmat)));
	
	// SRL_ASSERT: 
	// 	assert property 
	// 	(
	// 		@(posedge clk) disable iff(!rst_n) 
	// 		(instr_opcode == RType && instr_funct == SRL) 
	// 		|=>
	// 		(`GET_REG($past(instr_rd,1)) == (`GET_REG($past(instr_rt,1)) >> instr_shmat))
	// 	) 
	// 	else
	// 	$error("SRL: Time %0t: Sampled rd= %h, Sampled rt= %h, Sampled shmat= %h",
	// 		$time,$sampled(`GET_REG($past(instr_rd,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG(instr_shmat)));
	
	// SRA_ASSERT: 
	// 	assert property 
	// 	(
	// 		@(posedge clk) disable iff(!rst_n) 
	// 		(instr_opcode == RType && instr_funct == SRA) 
	// 		|=>
	// 		(`GET_REG($past(instr_rd,1)) == (`GET_REG($past(instr_rt,1)) >>> instr_shmat))
	// 	) 
	// 	else
	// 	$error("SRL: Time %0t: Sampled rd= %h, Sampled rt= %h, Sampled shmat= %h",
	// 		$time,$sampled(`GET_REG($past(instr_rd,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG(instr_shmat)));
	
	// SLLV_ASSERT: 
	// 	assert property 
	// 	(
	// 		@(posedge clk) disable iff(!rst_n) 
	// 		(instr_opcode == RType && instr_funct == SLLV) 
	// 		|=>
	// 		(`GET_REG($past(instr_rd,1)) == (`GET_REG($past(instr_rt,1)) << `GET_REG($past(instr_rs,1))[4:0]))
	// 	) 
	// 	else
	// 	$error("SLLV: Time %0t: Sampled rd= %h, Sampled rt= %h, Sampled rs[4:0]= %h",
	// 		$time,$sampled(`GET_REG($past(instr_rd,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rs,1))[4:0]));
	
	// SRLV_ASSERT: 
	// 	assert property 
	// 	(
	// 		@(posedge clk) disable iff(!rst_n) 
	// 		(instr_opcode == RType && instr_funct == SRLV) 
	// 		|=>
	// 		(`GET_REG($past(instr_rd,1)) == (`GET_REG($past(instr_rt,1)) >> `GET_REG($past(instr_rs,1))[4:0]))
	// 	) 
	// 	else
	// 	$error("SRLV: Time %0t: Sampled rd= %h, Sampled rt= %h, Sampled rs[4:0]= %h",
	// 		$time,$sampled(`GET_REG($past(instr_rd,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rs,1))[4:0]));
	
	// SRAV_ASSERT: 
	// 	assert property 
	// 	(
	// 		@(posedge clk) disable iff(!rst_n) 
	// 		(instr_opcode == RType && instr_funct == SRAV) 
	// 		|=>
	// 		(`GET_REG($past(instr_rd,1)) == (`GET_REG($past(instr_rt,1)) >>> `GET_REG($past(instr_rs,1))[4:0]))
	// 	) 
	// 	else
	// 	$error("SRAV: Time %0t: Sampled rd= %h, Sampled rt= %h, Sampled rs[4:0]= %h",
	// 		$time,$sampled(`GET_REG($past(instr_rd,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rs,1))[4:0]));

// // Multiply and Divide Instructions
// 	MUL_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == MUL) 
// 			|=>
// 			(`GET_REG($past(instr_rd,1)) == uint32_t'(`GET_REG($past(instr_rs,1)) * `GET_REG($past(instr_rt,1))))
// 		) 
// 		else
// 		$error("MUL: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h,",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))),$sampled(`GET_REG($past(instr_rd,1))));

// 	MULT_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == MULT) 
// 			|=>
// 			({`GET_HI,`GET_LO} == uint64_t'(`GET_REG($past(instr_rs,1)) * `GET_REG($past(instr_rt,1))))
// 		) 
// 		else
// 		$error("MULT: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled Hi= %h ,Sampled Lo= %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_HI),$sampled(`GET_LO));

// 	DIV_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == DIV) 
// 			|=>
// 			((`GET_HI == (`GET_REG($past(instr_rs,1)) / `GET_REG($past(instr_rt,1)))) && (`GET_LO== (`GET_REG($past(instr_rs,1)) % `GET_REG($past(instr_rt,1)))))
// 		) 
// 		else
// 		$error("DIV: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled Hi= %h ,Sampled Lo= %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_HI),$sampled(`GET_LO));

// // Move Hi and Lo instructions 
// 	MFHI_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == MFHI) 
// 			|=>
// 			(`GET_REG($past(instr_rd,1)) == `GET_HI)
// 		) 
// 		else
// 		$error("MFHI: Time %0t: Sampled rd= %h, Sampled Hi= %h",
// 			$time,$sampled(`GET_REG($past(instr_rd,1))),$sampled(`GET_HI));
	
// 	MFLO_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == MFLO) 
// 			|=>
// 			(`GET_REG($past(instr_rd,1)) == `GET_LO)
// 		) 
// 		else
// 		$error("MFLO: Time %0t: Sampled rd= %h, Sampled Lo= %h",
// 			$time,$sampled(`GET_REG($past(instr_rd,1))),$sampled(`GET_LO));
	
// 	MTHI_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == MTHI) 
// 			|=>
// 			(`GET_HI == `GET_REG($past(instr_rs,1)))
// 		) 
// 		else
// 		$error("MTHI: Time %0t: Sampled rs= %h, Sampled Hi= %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_HI));
	
// 	MTLO_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == MTLO) 
// 			|=>
// 			(`GET_LO == `GET_REG($past(instr_rs,1)))
// 		) 
// 		else
// 		$error("MTLO: Time %0t: Sampled rs= %h, Sampled Lo= %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_LO));
	
// 	LUI_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == LUI) 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == {instr_imm,16'b0})
// 		) 
// 		else
// 		$error("LUI: Time %0t: Sampled rt= %h, Sampled Imm= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(instr_imm));

// // ALU Unsigned Instructions
// 	ADDIU_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == ADDIU && (instr_rt != 'd0))  // reg[0] always = zero 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == ($unsigned(`GET_REG($past(instr_rs,1))) + $unsigned(SignImm)))
// 		) 
// 		else
// 		$error("ADDIU: Time %0t: Sampled rt= %h, Sampled rs= %h, Sampled SignImm= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(`GET_REG($past(instr_rs,1))), $sampled(SignImm));	

// 	SLTIU_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == SLTIU && (instr_rt != 'd0))  // reg[0] always = zero 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == ($unsigned(`GET_REG($past(instr_rs,1))) < $unsigned(SignImm)))
// 		) 
// 		else
// 		$error("SLTIU: Time %0t: Sampled rt= %h, Sampled rs= %h, Sampled SignImm= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(`GET_REG($past(instr_rs,1))), $sampled(SignImm));	
	
// 	ADDU_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == ADDU) 
// 			|=>
// 			($unsigned(`GET_REG($past(instr_rd,1))) == ($unsigned(`GET_REG($past(instr_rs,1))) + $unsigned(`GET_REG($past(instr_rt,1)))))
// 		) 
// 		else
// 		$error("ADDU: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))));	
	
// 	SUBU_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == SUBU) 
// 			|=>
// 			($unsigned(`GET_REG($past(instr_rd,1))) == ($unsigned(`GET_REG($past(instr_rs,1))) - $unsigned(`GET_REG($past(instr_rt,1)))))
// 		) 
// 		else
// 		$error("SUBU: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))));

// 	SLTU_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == SLTU) 
// 			|=>
// 			(`GET_REG($past(instr_rd,1)) == ($unsigned(`GET_REG($past(instr_rs,1))) < $unsigned(`GET_REG($past(instr_rt,1)))))
// 		) 
// 		else
// 		$error("SLTU: Time %0t: Sampled rs= %h, Sampled rt= %h, Sampled rd= %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))), $sampled(`GET_REG($past(instr_rd,1))));

// // ALU Immediate Instructions
// 	ADDI_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == ADDI && (instr_rt != 'd0))  // reg[0] always = zero 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == ($signed(`GET_REG($past(instr_rs,1))) + $signed(SignImm)))
// 			&& (arth_overflow_exception == ((`GET_REG($past(instr_rs,1))[31] == SignImm[31]) && (`GET_REG($past(instr_rt,1))[31] != `GET_REG($past(instr_rs,1))[31])))
// 		) 
// 		else
// 		$error("ADDI: Time %0t: Sampled rt= %h, Sampled rs= %h, Sampled SignImm= %h , overflow = %b , sum = %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(`GET_REG($past(instr_rs,1))), $sampled(SignImm),$sampled(arth_overflow_exception),$sampled(($signed(`GET_REG($past(instr_rs,1))) + $signed(SignImm))));	

// 	SLTI_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == SLTI && (instr_rt != 'd0))  // reg[0] always = zero 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == ($signed(`GET_REG($past(instr_rs,1))) < $signed(SignImm)))
// 		) 
// 		else
// 		$error("SLTI: Time %0t: Sampled rt= %h, Sampled rs= %h, Sampled SignImm= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(`GET_REG($past(instr_rs,1))), $sampled(SignImm));	

// 	ANDI_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == ANDI && (instr_rt != 'd0))  // reg[0] always = zero 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == (`GET_REG($past(instr_rs,1)) & ZeroImm))
// 		) 
// 		else
// 		$error("ANDI: Time %0t: Sampled rt= %h, Sampled rs= %h, Sampled ZeroImm= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(`GET_REG($past(instr_rs,1))), $sampled(ZeroImm));	

// 	ORI_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == ORI && (instr_rt != 'd0))  // reg[0] always = zero 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == (`GET_REG($past(instr_rs,1)) | ZeroImm))
// 		) 
// 		else
// 		$error("ORI: Time %0t: Sampled rt= %h, Sampled rs= %h, Sampled ZeroImm= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(`GET_REG($past(instr_rs,1))), $sampled(ZeroImm));	

// 	XORI_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == XORI && (instr_rt != 'd0))  // reg[0] always = zero 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == (`GET_REG($past(instr_rs,1)) ^ ZeroImm))
// 		) 
// 		else
// 		$error("XORI: Time %0t: Sampled rt= %h, Sampled rs= %h, Sampled ZeroImm= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(`GET_REG($past(instr_rs,1))), $sampled(ZeroImm));	

// // Jump Instructions 
// 	J_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == J) 
// 			|=>
// 			(pc == `JTA)
// 		) 
// 		else
// 		$error("J: Time %0t: PC = %h, JTA = %h",
// 			$time,$sampled(pc),$sampled(`JTA));

// 	JR_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == JR) 
// 			|=>
// 			(pc == `GET_REG($past(instr_rs,1)))
// 		) 
// 		else
// 		$error("JR: Time %0t: PC = %h, rs = %h",
// 			$time,$sampled(pc),$sampled(`GET_REG($past(instr_rs,1))));
	
// 	JALR_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == RType && instr_funct == JALR) 
// 			|=>
// 			((pc == `GET_REG($past(instr_rs,1))) && (`GET_RA == ($past(pc) + 4)))
// 		) 
// 		else
// 		$error("JALR: Time %0t: PC = %h, [rs] = %h ,$ra = %h , Last PC = %h",
// 			$time,$sampled(pc),$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_RA),$sampled($past(pc)));
	
// // Branch Instructions 
// 	BEQ_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == BEQ) 
// 			|=> 
// 			if(`GET_REG($past(instr_rs,1)) == `GET_REG($past(instr_rt,1))) 
// 				(pc == `BTA)
// 			else
// 				(pc == $past(pc) + 4)	
// 		) 
// 		else
// 		$error("BEQ: Time %0t: [rs] = %h ,[rt] = %h, BTA = %h,PC = %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))),$sampled(`BTA),$sampled(pc));
// 		// $error("BEQ: Time %0t: [rs] = %h ,[rt] = %h, PC = %h, BTA = %h , PC+4= %h , SignImm << 2 = %h",
// 		// 	$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))),$sampled(pc)
// 		// 	,$sampled(`BTA),$sampled($past(pc)+4),$sampled(SignImm<<2));

// 	BNE_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == BNE) 
// 			|=>
// 			if(`GET_REG($past(instr_rs,1)) != `GET_REG($past(instr_rt,1))) 
// 				(pc == `BTA)
// 			else
// 				(pc == $past(pc) + 4)
// 		) 
// 		else
// 		$error("BNE: Time %0t: [rs] = %h ,[rt] = %h, BTA = %h,PC = %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`GET_REG($past(instr_rt,1))),$sampled(`BTA),$sampled(pc));

// 	BLTZ_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == BLT_BGEZ && instr_rt == 0) 
// 			|=>
// 			if($signed(`GET_REG($past(instr_rs,1))) < 0) 
// 				(pc == `BTA)
// 			else
// 				(pc == $past(pc) + 4)
// 		) 
// 		else
// 		$error("BLTZ: Time %0t: [rs] = %h , BTA = %h,PC = %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`BTA),$sampled(pc));

// 	BGEZ_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == BLT_BGEZ && instr_rt == 1) 
// 			|=>
// 			if($signed(`GET_REG($past(instr_rs,1))) >= 0) 
// 				(pc == `BTA)
// 			else
// 				(pc == $past(pc) + 4)
// 		) 
// 		else
// 		$error("BGEZ: Time %0t: [rs] = %h , BTA = %h,PC = %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`BTA),$sampled(pc));

// 	BLEZ_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == BLEZ) 
// 			|=>
// 			if($signed(`GET_REG($past(instr_rs,1))) <= 0) 
// 				(pc == `BTA)
// 			else
// 				(pc == $past(pc) + 4)
// 		) 
// 		else
// 		$error("BLEZ: Time %0t: [rs] = %h , BTA = %h,PC = %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`BTA),$sampled(pc));

// 	BGTZ_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == BGTZ) 
// 			|=>
// 			if($signed(`GET_REG($past(instr_rs,1))) > 0) 
// 				(pc == `BTA)
// 			else
// 				(pc == $past(pc) + 4)
// 		) 
// 		else
// 		$error("BGTZ: Time %0t: [rs] = %h , BTA = %h,PC = %h",
// 			$time,$sampled(`GET_REG($past(instr_rs,1))),$sampled(`BTA),$sampled(pc));

// // Load Instructions 
// 	LW_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == LW) 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == readdata)
// 		) 
// 		else
// 		$error("LW: Time %0t: Sampled rt= %h, Sampled readdata= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(readdata));	

// 	LB_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == LB) 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == {{24{readdata[7]}},readdata[7:0]})
// 		) 
// 		else
// 		$error("LB: Time %0t: Sampled rt= %h, Sampled readdata= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(readdata));	

// 	LH_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == LH) 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == {{16{readdata[15]}},readdata[15:0]})
// 		) 
// 		else
// 		$error("LH: Time %0t: Sampled rt= %h, Sampled readdata= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(readdata));	

// 	LBU_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == LBU) 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == {{24{1'b0}},readdata[7:0]})
// 		) 
// 		else
// 		$error("LBU: Time %0t: Sampled rt= %h, Sampled readdata= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(readdata));	

// 	LHU_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == LHU) 
// 			|=>
// 			(`GET_REG($past(instr_rt,1)) == {{16{1'b0}},readdata[15:0]})
// 		) 
// 		else
// 		$error("LHU: Time %0t: Sampled rt= %h, Sampled readdata= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(readdata));	

// // Store Instructions
// 	SW_ASSERT: 
// 		assert property 
// 		(
// 			@(posedge clk) disable iff(!rst_n) 
// 			(instr_opcode == Sw) 
// 			|=>
// 			((`GET_REG($past(instr_rt,1)) == writedata) && memwrite)
// 		) 
// 		else
// 		$error("SW: Time %0t: Sampled rt= %h, Sampled writedata= %h",
// 			$time,$sampled(`GET_REG($past(instr_rt,1))),$sampled(writedata));		

endmodule