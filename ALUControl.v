module ALUControl(
    input [1:0] ALUOp,
    input [5:0] Instruction,
    output reg [3:0] Operation
);
    always @(*) begin
        casex ({ALUOp, Instruction})
            8'b00??????: Operation = 4'b0010;
            8'b01??????: Operation = 4'b0110;
            8'b10??0000: Operation = 4'b0010;
            8'b10??0010: Operation = 4'b0110;
            8'b10??0100: Operation = 4'b0000;
            8'b10??0101: Operation = 4'b0001;
            8'b10??1010: Operation = 4'b0111;
            8'b11??????: Operation = 4'b0010;
            default:     Operation = 4'b0000;
        endcase
    end
endmodule
