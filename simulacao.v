`timescale 1ns/1ns
`include "MIPS.v"

module Simulacao;

    reg clk;
    reg reset;
    
    MIPS mips(
        .clk(clk),
        .reset(reset)
    );
    always #5 clk = ~clk;

    initial begin 
        clk = 0;
        reset = 0;
        #10
        reset = 1;
        #10
        reset = 0;
        #1200;
        $finish;
    end
    always @(mips.PC) begin
        $display("PC: %d | Instrução: %x | Instrução branch: %b | Instrução jump: %b", mips.PC, mips.instrucao, mips.Branch, mips.Jump);
    end
    integer i;
    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0, Simulacao);
        for (i = 0; i<32; i=i+1) begin
            $dumpvars(1, Simulacao.mips.registradores.registers[i]);
        end
    end

endmodule
