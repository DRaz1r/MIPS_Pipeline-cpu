`timescale 1ns / 1ps

`include "Header.vh"
module Instr_Buffer_Memory(
    input[31:0] PC,
    output[31:0] instruction
    );
    reg [31:0] inst_memory[255:0];
    initial begin
          $readmemh(`INSTR_PATH, inst_memory);//读取指令文件到inst_data
    end
    assign instruction = inst_memory[PC >> 2];
endmodule
