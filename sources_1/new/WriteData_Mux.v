`timescale 1ns / 1ps

module WriteData_Mux0(
    input [31:0] EX_Reg2,
    input [31:0] WB_ReadData,
    input WriteData_Sel_0,

    output reg [31:0] EX_WriteData
    );
    always @(*) begin
        case (WriteData_Sel_0) 
            1'b0: EX_WriteData = EX_Reg2;
            1'b1: EX_WriteData = WB_ReadData;
            default: EX_WriteData = EX_Reg2;
        endcase
    end
endmodule

module WriteData_Mux1(
    input [31:0] MEM_WriteData,
    input [31:0] WB_ReadData,
    input  WriteData_Sel_1,

    output reg [31:0] MEM_i_data
    );
    always @(*) begin
        case (WriteData_Sel_1) 
            1'b0: MEM_i_data = MEM_WriteData;
            1'b1: MEM_i_data = WB_ReadData;
            default: MEM_i_data = MEM_WriteData;
        endcase
    end
endmodule

