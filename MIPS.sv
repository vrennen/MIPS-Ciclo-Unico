`include "ALU.v"
`include "MemoriaDeInstrucoes.v"
`include "ControlLogicUnit.v"
`include "Mux2x1_5bit.v"
`include "Mux2x1_32bit.v"
`include "ALUControl.v"
`include "DataMemory.v"
//`include "Registradores.sv"
`include "SignalExtend.v"
`include "ShiftLeft2.v"
`include "ShiftLeft2_Jump.v"

module MIPS(
    input clk,
    input reset,
	 output [31:0] inst,
	 output [17:0] ProgramCounter,
	 output [31:0] dump_registradores [31:0]
);
    wire [31:0] instrucao;
	 assign inst = instrucao;
    wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [1:0] CLU_ALUOp;

    wire [4:0] WriteRegister;
    wire [31:0] Reg_ReadData1, Reg_ReadData2;
    wire [31:0] Reg_WriteData;

    wire [31:0] sinalExtendido;
    wire [31:0] ALUMemoriaB;
    wire [31:0] Mem_Address;

    wire [3:0] Control_ALUOperation;

    wire [31:0] Memoria_ReadData;

    wire [31:0] sinalShift;
    wire [27:0] sinalShift_Jump;
    wire [31:0] AddressDesvio;


    reg [31:0] PC;
	 assign ProgramCounter = PC[17:0];
    wire [31:0] PC_mais4;
    wire [31:0] PCOuBranch;
    wire [31:0] proximo_PC;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 32'b0;
        end else begin;
            PC <= proximo_PC;
        end
    end

    ALU soma_pc(
        .A(PC),
        .B(32'd4),
        .ALUOperation(4'b0010),
        .ALUResult(PC_mais4),
        .Zero()
    );
    MemoriaDeInstrucoes memoria(
        .addr(PC),
        .instrucao(instrucao)
    );
    
    ControlLogicUnit controleLogico(
        .opcode(instrucao[31:26]),
        .RegDst(RegDst),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(CLU_ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    Mux2x1_5bit mux1(
        .A(instrucao[20:16]),
        .B(instrucao[15:11]),
        .S(RegDst),
        .Out(WriteRegister)
    );

    Registradores registradores(
        .ReadRegister1(instrucao[25:21]),
        .ReadRegister2(instrucao[20:16]),
        .WriteRegister(WriteRegister),
        .WriteData(Reg_WriteData),
        .RegWrite(RegWrite),
        .clock(clk),
        .ReadData1(Reg_ReadData1),
        .ReadData2(Reg_ReadData2),
		  .dump(dump_registradores)
    );

    SignalExtend extensor(
        .in(instrucao[15:0]),
        .out(sinalExtendido)
    );

    Mux2x1_32bit mux2(
        .A(Reg_ReadData2),
        .B(sinalExtendido),
        .S(ALUSrc),
        .Out(ALUMemoriaB)
    );

    ALUControl controleALU(
        .ALUOp(CLU_ALUOp),
        .Instruction(instrucao[5:0]),
        .Operation(Control_ALUOperation)
    );

    ALU alu_memoria(
        .A(Reg_ReadData1),
        .B(ALUMemoriaB),
        .ALUOperation(Control_ALUOperation),
        .ALUResult(Mem_Address),
        .Zero(BranchEquals)
    );

    DataMemory memoriaDados(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(Mem_Address),
        .writeData(Reg_ReadData2),
        .readData(Memoria_ReadData)
    );

    Mux2x1_32bit mux3(
        .A(Mem_Address),
        .B(Memoria_ReadData),
        .S(MemtoReg),
        .Out(Reg_WriteData)
    );

    ShiftLeft2 shift(
        .in(sinalExtendido),
        .out(sinalShift)
    );

    ALU alu_desvio(
        .A(PC),
        .B(sinalShift),
        .ALUOperation(4'b0010),
        .ALUResult(AddressDesvio),
        .Zero()
    );

    Mux2x1_32bit mux4(
        .A(PC_mais4),
        .B(AddressDesvio),
        .S(Branch & BranchEquals),
        .Out(PCOuBranch)
    );

    ShiftLeft2_Jump shift_jump(
        .in(instrucao[25:0]),
        .out(sinalShift_Jump)
    );

    Mux2x1_32bit mux5(
        .A(PCOuBranch),
        .B({PC_mais4[31:28], sinalShift_Jump}),
        .S(Jump),
        .Out(proximo_PC)
    );

endmodule
