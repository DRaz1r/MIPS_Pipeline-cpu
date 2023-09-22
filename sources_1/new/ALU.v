`include "Header.vh"
module alu (
    input  [31:0]   A   ,
    input  [31:0]   B   ,
    input  [5 :0]   AluOP,
    output Zero,
    output [31:0]   F  
);

    wire [31:0]    a_add_b_result;
    wire [31:0]    a_sub_b_result;
    wire [31:0]    a_or_b_result;
    wire [31:0]    a_and_b_result;
    wire [31:0]    a_xor_b_result;
    wire [31:0]    a_slt_b_result;
    wire [31:0]    movz_result;
    wire [31:0]    b_sll_a_result;

    // 运算
    assign a_add_b_result = A + B;
    assign a_sub_b_result = A - B;
    assign a_or_b_result = A | B;
    assign a_and_b_result = A & B;
    assign a_xor_b_result = A ^ B;
    assign a_slt_b_result = (A < B) ? 32'b1 : 32'b0;
    assign movz_result = (B == 0) ? A : 32'b0;
    wire [4:0] shamt;
    assign shamt = A[4:0];
    assign b_sll_a_result = B << shamt;

    // 运算结果 依据操作码AluOP选择
    assign  F   =   ({32{AluOP == `ADD}}  & a_add_b_result)  |
                    ({32{AluOP == `SUB}}  & a_sub_b_result)  |
                    ({32{AluOP == `OR}}   & a_or_b_result)   |
                    ({32{AluOP == `AND}}  & a_and_b_result)  |
                    ({32{AluOP == `XOR}}  & a_xor_b_result)  |
                    ({32{AluOP == `SLT}}  & a_slt_b_result)  |
                    ({32{AluOP == `MOVZ}} & movz_result)     |
                    ({32{AluOP == `SLL}}  & b_sll_a_result)  |
                    0;
    assign Zero = (F == 0) ? 1 : 0;
endmodule