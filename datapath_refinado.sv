// =============================================================
// Datapath Refinado — Multiplicador Inteiro de 32 bits
// Disciplina: Organização e Arquitetura de Computadores
// =============================================================
// Registrador de Produto: 65 bits (64 bits resultado + 1 carry)
// ALU: 32 bits (opera apenas sobre P[64:32])
// Iterações: 32 ciclos
// =============================================================

module datapath_refinado (
    input  logic        clk,
    input  logic        rst,
    // Sinais de controle vindos da FSM
    input  logic        init_regs,   // zera P e carrega B
    input  logic        add_ctrl,    // 1 = somar A à parte alta de P
    input  logic        shift_en,    // 1 = shift aritmético em P e B
    // Entradas de dados
    input  logic [31:0] A,           // multiplicando
    input  logic [31:0] B_in,        // multiplicador
    // Saídas
    output logic [63:0] produto,     // resultado final P[63:0]
    output logic        B_lsb        // B[0] para a FSM decidir add_ctrl
);

    logic [64:0] P;        // 65 bits: [64]=carry, [63:32]=alto, [31:0]=baixo
    logic [31:0] B;
    logic [32:0] alu_out;  // 32 bits resultado + 1 carry-out

    // ----------------------------------------------------------
    // ALU de 32 bits: soma P[64:32] com A (se add_ctrl=1) ou 0
    // ----------------------------------------------------------
    always_comb begin
        logic [31:0] operando;
        operando = add_ctrl ? A : 32'b0;
        alu_out  = {1'b0, P[63:32]} + {1'b0, operando};
    end

    // ----------------------------------------------------------
    // Registradores sequenciais
    // ----------------------------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            P <= 65'b0;
            B <= 32'b0;
        end else if (init_regs) begin
            P <= 65'b0;   // produto começa em zero
            B <= B_in;    // carrega multiplicador
        end else if (shift_en) begin
            // Monta P_next com carry e soma da ALU, depois shifta
            logic [64:0] P_next;
            P_next[64]    = alu_out[32];    // carry-out -> P[64]
            P_next[63:32] = alu_out[31:0];  // resultado da soma -> parte alta
            P_next[31:0]  = P[31:0];        // parte baixa inalterada antes do shift

            // Shift aritmético de 1 bit à direita no bloco inteiro
            P <= $signed(P_next) >>> 1;

            // Shift lógico no multiplicador para expor o próximo bit
            B <= B >> 1;
        end
    end

    assign B_lsb  = B[0];
    assign produto = P[63:0];

endmodule
