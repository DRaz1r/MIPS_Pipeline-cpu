module WriteData_Mux(
    input [31:0] EX_Reg2,
    input [31:0] WriteBackData,
    input [31:0] MEM_ReadData,
    input [1:0] WriteData_Sel,

    output reg [31:0] EX_WriteData
    );
    always @(*) begin
        case (WriteData_Sel) 
            2'b10: EX_WriteData = WriteBackData;
            2'b01: EX_WriteData = MEM_ReadData;
            2'b00: EX_WriteData = EX_Reg2;
            default: EX_WriteData = EX_Reg2;
        endcase
    end
endmodule
