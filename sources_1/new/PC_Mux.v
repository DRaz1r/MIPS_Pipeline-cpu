module PC_Mux(
    input [31:0] NPC,
    input [31:0] J_PC,
    input [31:0] Branch_PC,
    input Jump,
    input Branch,
    output reg [31:0] PC_Result
    );
    always @(*) begin
        case ({Jump, Branch})
            2'b00: PC_Result = NPC;
            2'b01: PC_Result = Branch_PC;
            2'b10: PC_Result = J_PC;
            default: PC_Result = NPC;
        endcase
    end
endmodule
