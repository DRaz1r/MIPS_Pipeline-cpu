module ID_EX_Reg(
    input clk,
    input stall,
    input reset_n,

    input [31:0]ID_Instr, // signal for debug
    output reg [31:0] EX_Instr,

    input ID_RegWrite,
    input ID_MemToReg,
    input ID_MemWrite,
    input [5:0] ID_AluOP,
    input ID_Branch,
    input ID_AluSrcB,
    input ID_AluSrcA,
    input ID_Jump,
    input [31:0] ID_Imm,
    input [31:0] ID_Reg1,
    input [31:0] ID_Reg2,
    input [4:0] ID_WriteReg,
    input [25:0] ID_instr_index,
    input [31:0] ID_NPC,

    // For Instr SLL: shamt
    input [4:0] ID_shamt,
    output reg [4:0] EX_shamt, 

    // rs,rt,rd
    input [4:0] ID_rs,
    input [4:0] ID_rt,
    input [4:0] ID_rd,
    output reg [4:0] EX_rs,
    output reg [4:0] EX_rt,
    output reg [4:0] EX_rd,
    //

    input [31:0] ID_PC,
    output reg [31:0] EX_PC,

    output reg EX_RegWrite,
    output reg EX_MemToReg,
    output reg EX_MemWrite,
    output reg [5:0] EX_AluOP,
    output reg EX_Branch,
    output reg EX_AluSrcB,
    output reg EX_AluSrcA,
    output reg EX_Jump,
    output reg [31:0] EX_Imm,
    output reg [31:0] EX_Reg1,
    output reg [31:0] EX_Reg2,
    output reg [4:0] EX_WriteReg,
    output reg [25:0] EX_instr_index,
    output reg [31:0] EX_NPC
    );

    always @(posedge clk) begin
        if (!reset_n) begin
            EX_RegWrite <= 0;
            EX_MemToReg <= 0;
            EX_MemWrite <= 0;
            EX_AluOP <= 0;
            EX_Branch <= 0;
            EX_AluSrcB <= 0;
            EX_AluSrcA <= 0;
            EX_Jump <= 0;
            EX_Imm <= 0;

            EX_WriteReg <= 0;
            EX_instr_index <= 0;

            //rs rt rd
            EX_rs <= 0;
            EX_rt <= 0;
            EX_rd <= 0;

            //Instr
            EX_Instr <= 0;
        end
        else begin
            if (stall) begin
                EX_RegWrite <= 0;
                EX_MemToReg <= 0;
                EX_MemWrite <= 0;
                EX_AluOP <= 0;
                EX_Branch <= 0;
                EX_AluSrcB <= 0;
                EX_AluSrcA <= 0;
                EX_Jump <= 0;

                EX_Instr <= EX_Instr;
                EX_PC <= EX_PC;
                EX_NPC <= EX_NPC;

            end
            else begin
                EX_RegWrite <= ID_RegWrite;
                EX_MemToReg <= ID_MemToReg;
                EX_MemWrite <= ID_MemWrite;
                EX_AluOP <= ID_AluOP;
                EX_Branch <= ID_Branch;
                EX_AluSrcB <= ID_AluSrcB;
                EX_AluSrcA <= ID_AluSrcA;
                EX_Jump <= ID_Jump;
                EX_Imm <= ID_Imm;
                EX_Reg1 <= ID_Reg1;
                EX_Reg2 <= ID_Reg2;
                EX_WriteReg <= ID_WriteReg;
                EX_instr_index <= ID_instr_index;
                EX_NPC <= ID_NPC;

                // rs rt rd
                EX_rs <= ID_rs;
                EX_rt <= ID_rt;
                EX_rd <= ID_rd;

                // Instr
                EX_Instr <= ID_Instr;

                // PC
                EX_PC <= ID_PC;

                // shamt
                EX_shamt <= ID_shamt; // Unsigned Extend
            end
        end
    end
endmodule
