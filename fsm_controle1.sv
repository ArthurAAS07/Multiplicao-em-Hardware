// =============================================================
// FSM — Unidade de Controle do Multiplicador Refinado 32 bits
// Disciplina: Organização e Arquitetura de Computadores
// =============================================================
// Máquina de Moore: saídas dependem apenas do estado atual
// Estados: IDLE -> INIT -> STEP (x32) -> DONE -> IDLE
// =============================================================

module fsm_controle (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic B_lsb,        // B[0] vindo do datapath
    // Sinais de controle para o datapath
    output logic init_regs,
    output logic add_ctrl,
    output logic shift_en,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE = 2'b00,
        INIT = 2'b01,
        STEP = 2'b10,
        DONE = 2'b11
    } estado_t;

    estado_t estado_atual, proximo_estado;
    logic [4:0] count;   // 5 bits — conta de 0 a 31

    // ----------------------------------------------------------
    // Registrador de estado e contador
    // ----------------------------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            estado_atual <= IDLE;
            count        <= 5'b0;
        end else begin
            estado_atual <= proximo_estado;
            if (estado_atual == INIT)
                count <= 5'b0;
            else if (estado_atual == STEP && count < 5'd31)
                count <= count + 5'b1;
        end
    end

    // ----------------------------------------------------------
    // Lógica de próximo estado
    // ----------------------------------------------------------
    always_comb begin
        proximo_estado = estado_atual;
        case (estado_atual)
            IDLE: if (start)           proximo_estado = INIT;
            INIT:                      proximo_estado = STEP;
            STEP: if (count == 5'd31)  proximo_estado = DONE;
                  else                 proximo_estado = STEP;
            DONE:                      proximo_estado = IDLE;
            default:                   proximo_estado = IDLE;
        endcase
    end

    // ----------------------------------------------------------
    // Saídas (Moore — função apenas do estado atual)
    // ----------------------------------------------------------
    always_comb begin
        init_regs = 1'b0;
        add_ctrl  = 1'b0;
        shift_en  = 1'b0;
        done      = 1'b0;
        case (estado_atual)
            INIT: init_regs = 1'b1;
            STEP: begin
                add_ctrl = B_lsb;  // soma A somente se B[0] = 1
                shift_en = 1'b1;
            end
            DONE: done = 1'b1;
            default: ;
        endcase
    end

endmodule
