`timescale 1ns / 1ps

module WriteData_Mux(
    input [31:0] EX_Reg2,
    input [31:0] WB_ReadData,
    input [1:0] WriteData_Sel,

    output reg [31:0] EX_WriteData
    );
    always @(*) begin
        case (WriteData_Sel) 
            2'b10: EX_WriteData = EX_Reg2;
            2'b01: EX_WriteData = WB_ReadData;
            default: EX_WriteData = EX_Reg2;
        endcase
    end
endmodule
