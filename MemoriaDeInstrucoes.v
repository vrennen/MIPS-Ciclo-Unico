module MemoriaDeInstrucoes(
    input wire [31:0] addr,      // Endereço da instrução
    output wire [31:0] instrucao // Instrução lida
);

    // Memória de instruções (256 palavras de 32 bits)
    reg [31:0] memoria [255:0];

    // Inicialização da memória com algumas instruções
    // integer i;
    initial begin
        /*
        memoria[0] = 32'h20080001;  // addi $t0, $zero, 1
        memoria[1] = 32'h20090002;  // addi $t1, $zero, 2
        memoria[2] = 32'h01095020;  // add $t2, $t0, $t1
        memoria[3] = 32'hAC0A0000;  // sw $t2, 0($zero)
        memoria[4] = 32'b000100_11111_01010_0000000000000100;
        for (i = 5; i < 256; i = i + 1) begin
            memoria[i] = 32'b0;      // Zera o restante da memória
        end
        */
        $readmemh("instrucoes.bin", memoria);
    end

    // Leitura combinacional
    assign instrucao = memoria[addr[9:2]]; // Usa os bits 9:2 para indexar (alinhado em palavras)
endmodule
