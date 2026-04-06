// =============================================================
// Testbench — Multiplicador Inteiro Refinado de 32 bits
// Disciplina: Organização e Arquitetura de Computadores
// =============================================================
// Testa casos: zero, um, valores simples, max unsigned, negativos
// =============================================================

`timescale 1ns/1ps

module tb_multiplicador_refinado;

    logic        clk, rst, start, done;
    logic [31:0] A, B;
    logic [63:0] produto;

    // Instância do DUT
    multiplicador_refinado dut (
        .clk     (clk),
        .rst     (rst),
        .start   (start),
        .A       (A),
        .B       (B),
        .produto (produto),
        .done    (done)
    );

    // Clock de 10 ns
    initial clk = 0;
    always #5 clk = ~clk;

    // Tarefa auxiliar: aplica A e B, aguarda done, verifica resultado
    task run_test(
        input logic [31:0] a_in, b_in,
        input logic [63:0] esperado,
        input string       descricao
    );
        A     = a_in;
        B     = b_in;
        start = 1;
        @(posedge clk); #1;
        start = 0;

        // Aguarda done (máximo 40 ciclos de margem)
        repeat (40) begin
            if (done) break;
            @(posedge clk); #1;
        end

        if (!done)
            $display("TIMEOUT  | %s", descricao);
        else if (produto === esperado)
            $display("OK       | %s | %0d x %0d = %0d", descricao, a_in, b_in, produto);
        else
            $display("FALHOU   | %s | esperado=%0d obtido=%0d", descricao, esperado, produto);

        // Pausa de 2 ciclos entre testes
        @(posedge clk); @(posedge clk);
    endtask

    initial begin
        // Reset inicial
        rst   = 1; start = 0; A = 0; B = 0;
        repeat (3) @(posedge clk);
        rst = 0;
        @(posedge clk); #1;

        $display("=== Iniciando testes ===");

        // Casos básicos
        run_test(32'd0,  32'd0,  64'd0,          "0 x 0");
        run_test(32'd1,  32'd1,  64'd1,          "1 x 1");
        run_test(32'd2,  32'd3,  64'd6,          "2 x 3");
        run_test(32'd10, 32'd10, 64'd100,        "10 x 10");
        run_test(32'd0,  32'd999, 64'd0,         "0 x 999");
        run_test(32'd999, 32'd0, 64'd0,          "999 x 0");

        // Potências de 2
        run_test(32'd256, 32'd256, 64'd65536,    "256 x 256");
        run_test(32'h8000_0000, 32'd2, 64'h1_0000_0000, "2^31 x 2");

        // Máximo unsigned
        run_test(32'hFFFF_FFFF, 32'hFFFF_FFFF,
                 64'hFFFF_FFFE_0000_0001, "MAX x MAX");

        $display("=== Testes concluídos ===");
        $finish;
    end

    // Dump de ondas (compatível com GTKWave)
    initial begin
        $dumpfile("tb_multiplicador_refinado.vcd");
        $dumpvars(0, tb_multiplicador_refinado);
    end

endmodule
