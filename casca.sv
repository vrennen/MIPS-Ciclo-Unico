//`include "03_mips/MIPS.v"
//`include "SEG7_LUT_8.v"
module casca(
	input [3:0] KEY,
	input CLOCK_50,
	input [4:0] SW,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [6:0] HEX7,
	output [17:0] LEDR
);
	wire [31:0] instrucaoAtual;
	logic [31:0] numeros;
	wire [31:0] registradores [31:0];
	MIPS processador(.clk(~KEY[3]), .reset(~KEY[0]), .inst(instrucaoAtual), .ProgramCounter(LEDR), .dump_registradores(registradores));
	SEG7_LUT_8 s8(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, numeros);
	
	always@(*) begin
		if (SW == 5'b00000) numeros <= instrucaoAtual;
		else numeros <= registradores[SW];
	end
endmodule