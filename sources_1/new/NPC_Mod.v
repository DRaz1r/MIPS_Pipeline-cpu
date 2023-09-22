module NPC_Mod(
    input [31:0] PC,
    output [31:0] NPC
    );
    assign NPC = PC + 4; 
endmodule
