module Mux2x1_32bit(
    input [31:0] A,
    input [31:0] B,
    input S,
    output reg [31:0] Out
);
    always @(*) begin
        case(S)
            1'b0: Out = A;
            1'b1: Out = B;
            default: Out = 4'b0000;
        endcase
    end
endmodule
