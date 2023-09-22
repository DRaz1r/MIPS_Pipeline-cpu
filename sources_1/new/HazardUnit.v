
`timescale 1ns / 1ps

module HazardUnit(
    input EX_MemToReg,
    input [4:0] EX_rt,
    input [4:0] ID_rs,
    input [4:0] ID_rt,

    input EX_Jump,
    input EX_Branch,
    input Zero,
    output stall,
    output flush
    );                                                              
    // load-use Hazard
    // Attention: Save after Load need to be stalled 
    assign stall = ( (EX_MemToReg ) && ((EX_rt == ID_rs) || (EX_rt == ID_rt)) ) | 0;
    
    assign flush = (EX_Jump && ((Zero == 0) && EX_Branch)) | 0;
    // Jump Hazard & Branch Hazard
    
endmodule
