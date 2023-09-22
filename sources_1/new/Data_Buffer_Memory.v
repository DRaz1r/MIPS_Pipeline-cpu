`include "Header.vh"
module Data_Buffer_Memory(
    input[31:0] i_data,
    input[31:0] addr,
    input we,
    input clk,
    output [31:0] o_data    
    );
    reg [31:0] data_memory [255:0];
    initial begin
        $readmemh(`DATA_PATH, data_memory);
    end
    wire [31:0] addr_byte;
    assign addr_byte = addr >> 2;
    always @(posedge clk)begin
        if(we)
            data_memory[addr_byte] <= i_data; //sw
        else
            data_memory[addr_byte] <= data_memory[addr_byte];
    end
    
    assign o_data = data_memory[addr_byte]; //lw
endmodule