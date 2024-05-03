module perceptron
import rv32i_types::*;
(
    input   logic                     clk,
    input   logic                     rst,
    // At Instq
    input   logic [31:0]              branch_pc,                  // Lower bits of branch address; comes from Instq
    input   logic                     is_branch,                  // Indicates a branch instruction; Comes from Instq
    // On Commit
    input   logic                     branch_taken,               // Actual branch outcome (taken/not taken); Comes from ROB
    input   logic                     committing_br,              // Branch Commit Occured
    input   logic   [31:0]            comitting_br_pc,

    // Prediction output
    output  logic                     prediction                   // Prediction
);

    // Global History Register, Perceptron Table
    logic [GHR_WIDTH-1:0] ghr;
    logic [WEIGHTS_WIDTH-1:0] pTable [P_TABLE_SIZE][WEIGHTS_WIDTH];

    logic   [GHR_WIDTH-1:0]     pt_index;
    logic                       prediction2;
    logic   [WEIGHTS_WIDTH-1:0]               sum;
    logic   [WEIGHTS_WIDTH-1:0]              sum1;

    // Indexing/Reading into Perceptron Table
    always_comb begin
        pt_index = '0;
        prediction = '0;
        prediction2 = '0;
        sum = '0;
        sum1 = '0;
        // Reading from Instq
        if (is_branch) begin
            sum = sum + pTable[branch_pc[7:0]][0];
            for (int i = 1; i < WEIGHTS_WIDTH; i++) begin
                if (ghr[i])
                    sum = sum + pTable[branch_pc[7:0]][i];
                else
                    sum = sum - pTable[branch_pc[7:0]][i];
            end
            if (sum > 8'b1000)
                prediction = 1'b1;
        end
        // Reading to prepare for Write in ROB
        if (committing_br) begin
            sum1 = sum1 + pTable[comitting_br_pc[7:0]][0];
            for (int i = 1; i < WEIGHTS_WIDTH; i++) begin
                if (ghr[i])
                    sum1 = sum1 + pTable[comitting_br_pc[7:0]][i];
                else
                    sum1 = sum1 - pTable[comitting_br_pc[7:0]][i];
            end
            if (sum1 > 8'b1000)
                prediction2 = 1'b1;
        end
    end

    // Modifying BHT
    always_ff @(posedge clk) begin
        if (rst) begin
            ghr <= '0;
            for (int i = 0; i < P_TABLE_SIZE; i++) begin
                for (int j = 0; j < WEIGHTS_WIDTH; j++) begin
                    // Initialize Weights to all 0's
                    pTable[i][j] <= 8'b00000000; 
                end
            end
        end else begin
            // Instruction Commited is a branch
            if (committing_br) begin
                ghr <= {ghr[GHR_WIDTH-2:0], branch_taken};
                if (branch_taken != prediction2) begin
                    for (int i = 0; i < WEIGHTS_WIDTH; i++) begin
                        if (branch_taken == ghr[i]) pTable[comitting_br_pc[7:0]][i] <= pTable[comitting_br_pc[7:0]][i] + 1'b1;
                        else pTable[comitting_br_pc[7:0]][i] <= pTable[comitting_br_pc[7:0]][i] - 1'b1;
                    end
                end
            end
        end
    end

endmodule

