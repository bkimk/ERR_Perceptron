module shift_add_multiplier
import rv32i_types::*;
#(
    parameter int OPERAND_WIDTH = 32
)
(
    input logic clk,
    input logic rst,
    // Start must be reset after the done flag is set before another multiplication can execute
    input logic start,

    // Use this input to select what type of multiplication you are performing
    // 0 = Multiply two unsigned numbers
    // 1 = Multiply two signed numbers
    // 2 = Multiply a signed number and unsigned number
    //      a = signed
    //      b = unsigned
    input logic [1:0] mul_type,

    input logic [OPERAND_WIDTH-1:0] a,
    input logic [OPERAND_WIDTH-1:0] b,

    input logic [4:0] arch_reg, 
    input logic [PR_WIDTH-1:0] phys_reg, 
    input logic [ROB_WIDTH-1:0] rob, 
    input logic cdb_mul_ack, 
    input logic branch,         // TODO: flush FU with this branch signal

    // output logic [2*OPERAND_WIDTH-1:0] p,
    output cdb_t mul_cdb_output, 
    output logic done
);

    // Constants for multiplication case readability
    `define UNSIGNED_UNSIGNED_MUL 2'b11
    `define SIGNED_SIGNED_MUL     2'b00
    `define SIGNED_UNSIGNED_MUL   2'b10

    enum int unsigned {IDLE, SHIFT, ADD, DONE} curr_state, next_state;
    localparam int OP_WIDTH_LOG = $clog2(OPERAND_WIDTH);
    logic [OP_WIDTH_LOG-1:0] counter;
    logic [OPERAND_WIDTH-1:0] b_reg;
    logic [2*OPERAND_WIDTH-1:0] accumulator, a_reg; // a_reg needs to be 2 times wide since it is shifted left
    logic neg_result;

    logic   [2*OPERAND_WIDTH-1:0]   p;
    logic                           local_cdb_valid;
    logic   [ROB_WIDTH-1:0]         local_rob;
    logic   [4:0]                   local_arch_reg;
    logic   [PR_WIDTH-1:0]          local_phys_reg;
    logic   [31:0]                  local_op1;
    logic   [31:0]                  local_op2;

    always_comb
    begin : state_transition
        next_state = curr_state;
        unique case (curr_state)
            IDLE:    next_state = start ? ADD : IDLE;
            ADD:     next_state = SHIFT;
            SHIFT:   next_state = ({27'b0, counter} == OPERAND_WIDTH-1'b1) ? DONE : ADD;
            DONE:    next_state = ((start == 0) && cdb_mul_ack) ? IDLE : DONE;
            // SHIFT:   next_state = (counter == (OP_WIDTH_LOG)'(OPERAND_WIDTH-1)) ? DONE : ADD;
            // DONE:    next_state = start ? DONE : IDLE;
            default: next_state = curr_state;
        endcase
    end : state_transition

    always_comb
    begin : state_outputs
        p = '0;
        done = '0;
        mul_cdb_output.cdb_valid = '0;
        mul_cdb_output.rob = '0;
        mul_cdb_output.arch_reg = '0;
        mul_cdb_output.phys_reg = '0;
        mul_cdb_output.data = '0;
        mul_cdb_output.ps1_rdata = '0;
        mul_cdb_output.ps2_rdata = '0;
        mul_cdb_output.is_store = '0;
        mul_cdb_output.is_branch = '0;
        mul_cdb_output.is_jalr = '0;
        mul_cdb_output.branch_imm = '0;
        mul_cdb_output.mem_addr = '0;
        mul_cdb_output.mem_wdata = '0;
        mul_cdb_output.mem_rdata = '0;
        mul_cdb_output.mem_rmask = '0;
        mul_cdb_output.mem_wmask = '0;
        unique case (curr_state)
            DONE:
            begin
                unique case (mul_type)
                    `UNSIGNED_UNSIGNED_MUL: p = accumulator[2*OPERAND_WIDTH-1:0];
                    `SIGNED_SIGNED_MUL,
                    `SIGNED_UNSIGNED_MUL: p = neg_result ? (~accumulator[2*OPERAND_WIDTH-1-1:0])+1'b1 : accumulator;
                    default: ;
                endcase
                if ( cdb_mul_ack ) begin
                    done = 1'b1;
                    mul_cdb_output.cdb_valid = local_cdb_valid;
                    mul_cdb_output.rob = local_rob;
                    mul_cdb_output.arch_reg = local_arch_reg;
                    mul_cdb_output.phys_reg = local_phys_reg;
                    mul_cdb_output.data = p;
                    mul_cdb_output.ps1_rdata = local_op1;
                    mul_cdb_output.ps2_rdata = local_op2;
                end
            end
            IDLE: 
            begin
                if ( start ) done = 1'b0;
                else done = 1'b1;
            end
            default: ;
        endcase
    end : state_outputs

    always_ff @ (posedge clk)
    begin
        if (rst || branch)
        begin
            curr_state <= IDLE;
            a_reg <= '0;
            b_reg <= '0;
            accumulator <= '0;
            counter <= '0;
            neg_result <= '0;

            local_cdb_valid <= '0;
            local_rob <= '0;
            local_arch_reg <= '0;
            local_phys_reg <= '0;
            local_op1 <= '0;
            local_op2 <= '0;
        end

        else
        begin
            curr_state <= next_state;
            unique case (curr_state)
                IDLE:
                begin
                    if (start)
                    begin
                        accumulator <= '0;
                        unique case (mul_type)
                            `UNSIGNED_UNSIGNED_MUL:
                            begin
                                neg_result <= '0;   // Not used in case of unsigned mul, but just cuz . . .
                                a_reg <= {{OPERAND_WIDTH{1'b0}}, a};
                                b_reg <= b;
                            end
                            `SIGNED_SIGNED_MUL:
                            begin
                                // A -*+ or +*- results in a negative number unless the "positive" number is 0
                                neg_result <= (a[OPERAND_WIDTH-1] ^ b[OPERAND_WIDTH-1]) && ((a != '0) && (b != '0));
                                // If operands negative, make positive
                                a_reg <= (a[OPERAND_WIDTH-1]) ? {OPERAND_WIDTH*{1'b0}, (~a + 1'b1)} : a;
                                b_reg <= (b[OPERAND_WIDTH-1]) ? {(~b + 1'b1)} : b;
                            end
                            `SIGNED_UNSIGNED_MUL:
                            begin
                                neg_result <= a[OPERAND_WIDTH-1];
                                a_reg <= (a[OPERAND_WIDTH-1]) ? {OPERAND_WIDTH*{1'b0}, (~a + 1'b1)} : a;
                                b_reg <= b;
                            end
                            default:;
                        endcase

                        local_cdb_valid <= start;
                        local_rob <= rob;
                        local_arch_reg <= arch_reg;
                        local_phys_reg <= phys_reg;
                        local_op1 <= a;
                        local_op2 <= b;

                    end
                end
                ADD:
                begin
                    if (b_reg[0]) accumulator <= accumulator + a_reg;

                    local_cdb_valid <= local_cdb_valid;
                    local_rob <= local_rob;
                    local_arch_reg <= local_arch_reg;
                    local_phys_reg <= local_phys_reg;
                    local_op1 <= local_op1;
                    local_op2 <= local_op2;

                end
                SHIFT:
                begin
                    a_reg <= a_reg<<1;
                    b_reg <= b_reg>>1;
                    counter <= counter + 1'b1;

                    local_cdb_valid <= local_cdb_valid;
                    local_rob <= local_rob;
                    local_arch_reg <= local_arch_reg;
                    local_phys_reg <= local_phys_reg;
                    local_op1 <= local_op1;
                    local_op2 <= local_op2;

                end
                DONE: 
                begin
                    counter <= '0;
                    local_cdb_valid <= local_cdb_valid;
                    local_rob <= local_rob;
                    local_arch_reg <= local_arch_reg;
                    local_phys_reg <= local_phys_reg;
                    local_op1 <= local_op1;
                    local_op2 <= local_op2;
                end
                default: ;
            endcase
        end
    end

endmodule
