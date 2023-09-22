`include "Header.vh"
module regfile(
    input clk,
    input [`REG_ADDR_WIDTH] raddr1,
    input [`REG_ADDR_WIDTH] raddr2,
    input we, // 写使能
    input [`REG_ADDR_WIDTH] waddr, // 写地址
    input [`REG_DATA_WIDTH] wdata, // 写数据
    output [`REG_DATA_WIDTH] rdata1,
    output [`REG_DATA_WIDTH] rdata2
    );
    // 数组表示寄存器堆
    reg [`REG_DATA_WIDTH] mips_regfile [`REG_NUM];
    
    initial begin
        $readmemh(`REG_PATH, mips_regfile);
    end

    // 读1
    assign rdata1 = (raddr1 != 0 && we && (waddr == raddr1)) ? wdata : mips_regfile[raddr1];
    // 读2
    assign rdata2 = (raddr2 != 0 && we && (waddr == raddr2)) ? wdata : mips_regfile[raddr2];
    // 写
    always @(posedge clk) begin
        if (we == 1'b1 && (waddr != 0))
            mips_regfile[waddr] <= wdata;    
        else 
            mips_regfile[waddr] <=  mips_regfile[waddr]; 
    end
endmodule
