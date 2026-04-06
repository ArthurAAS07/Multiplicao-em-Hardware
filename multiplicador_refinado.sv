// =============================================================
// Top-level — Multiplicador Inteiro Refinado de 32 bits
// Disciplina: Organização e Arquitetura de Computadores
// =============================================================
// Integra: fsm_controle + datapath_refinado
// Entrada:  A[31:0], B[31:0], start, clk, rst
// Saída:    produto[63:0], done
// =============================================================

module multiplicador_refinado (
    input  logic        clk,
    input  logic        rst,
    input  logic        start,
    input  logic [31:0] A,        // multiplicando
    input  logic [31:0] B,        // multiplicador
    output logic [63:0] produto,  // resultado de 64 bits
    output logic        done
);

    // Sinais internos entre FSM e Datapath
    logic init_regs;
    logic add_ctrl;
    logic shift_en;
    logic B_lsb;

    // ----------------------------------------------------------
    // Instância da FSM
    // ----------------------------------------------------------
    fsm_controle u_fsm (
        .clk       (clk),
        .rst       (rst),
        .start     (start),
        .B_lsb     (B_lsb),
        .init_regs (init_regs),
        .add_ctrl  (add_ctrl),
        .shift_en  (shift_en),
        .done      (done)
    );

    // ----------------------------------------------------------
    // Instância do Datapath
    // ----------------------------------------------------------
    datapath_refinado u_datapath (
        .clk       (clk),
        .rst       (rst),
        .init_regs (init_regs),
        .add_ctrl  (add_ctrl),
        .shift_en  (shift_en),
        .A         (A),
        .B_in      (B),
        .produto   (produto),
        .B_lsb     (B_lsb)
    );

endmodule
