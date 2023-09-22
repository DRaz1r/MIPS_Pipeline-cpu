/* Select Test ID
    0 : Base Test
    1 : Add  Test 1
    2 : Add  Test 2
*/
`define TEST_SELECT 2


`define SELECT_DATA_PATH(sel) \
    (sel == 0) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/base_test/base_data_data" : \
    (sel == 1) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/add_test1/additional_data_data1" : \
    (sel == 2) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/add_test2/additional_data_data2" : \
    ""
`define DATA_PATH `SELECT_DATA_PATH(`TEST_SELECT)



`define SELECT_INSTR_PATH(sel) \
    (sel == 0) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/base_test/base_inst_data" : \
    (sel == 1) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/add_test1/additional_inst_data1" : \
    (sel == 2) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/add_test2/additional_inst_data2" : \
    ""

`define INSTR_PATH `SELECT_INSTR_PATH(`TEST_SELECT)



`define SELECT_REG_PATH(sel) \
    (sel == 0) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/base_test/base_reg_data" : \
    (sel == 1) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/add_test1/additional_reg_data1" : \
    (sel == 2) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/add_test2/additional_reg_data2" : \
    ""

`define REG_PATH `SELECT_REG_PATH(`TEST_SELECT)


`define SELECT_TRACE_FILE_PATH(sel) \
    (sel == 0) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/base_test/base_cpu_trace" : \
    (sel == 1) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/add_test1/additional_cpu_trace1" : \
    (sel == 2) ? "H:/Xilinx/testdocument/Pipeline_cpu/lab1_env/add_test2/additional_cpu_trace2" : \
    ""

`define TRACE_FILE_PATH `SELECT_TRACE_FILE_PATH(`TEST_SELECT)

`define TEST_COUNT 30
`define TEST_FINAL_PC 32'h00000074

// 下列注释代码仿真错误
// 一开始就会莫名PASS，或者一直不PASS，打印值是对的

// `define SELECT_TEST_COUNT(sel) \
//     (sel == 0) ?  20 : \
//     (sel == 1) ?  36 : \
//     (sel == 2) ?  30 : \
//     1

// `define TEST_COUNT `SELECT_TEST_COUNT(`TEST_SELECT)

// `define SELECT_TEST_FINAL_PC(sel) \
//     (sel == 0) ?  32'h0000006c : \
//     (sel == 1) ?  32'h00000098 : \
//     (sel == 2) ?  32'h00000074 : \
//     1

// `define TEST_FINAL_PC `SELECT_TEST_FINAL_PC(`TEST_SELECT)





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