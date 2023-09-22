`define DATA_PATH "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/base_test/base_data_data"
`define INSTR_PATH "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/base_test/base_inst_data"
`define REG_PATH "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/base_test/base_reg_data"
`define TRACE_FILE_PATH "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/base_test/base_cpu_trace"
`define TEST_COUNT 20
`define TEST_FINAL_PC 32'h0000006c



`define REG_DATA_WIDTH 31:0
`define REG_NUM 31:0
`define REG_ADDR_WIDTH 4:0
`define REG_ADDR_BIT 5
`define REG_DATA_BIT 32

`define ADD         6'b100000 // A 加 B
`define SUB         6'b100010 // A 减 B  
`define OR          6'b100101 // F = A + B
`define AND         6'b100100 // F = AB
`define XOR         6'b100110 // 异或
`define SLT         6'b101010 // A < B
`define MOVZ        6'b001010 // 条件移动指令
`define SLL         6'b000000 // 移位指令

`define OPE             6'b000000 // 
`define SW              6'b101011 // 存数指令
`define LW              6'b100011 // 取数指令
`define BNE             6'b000101
`define J               6'b000010