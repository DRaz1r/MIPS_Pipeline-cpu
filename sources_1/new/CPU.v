module CPU (
    input            clk             ,  // clock, 100MHz
    input            reset_n          ,  // active low

    // debug signals
    output [31:0]    debug_wb_pc     ,  // 当前正在执行指令的PC
    output           debug_wb_rf_wen ,  // 当前通用寄存器组的写使能信号
    output [4 :0]    debug_wb_rf_addr,  // 当前通用寄存器组写回的寄存器编号
    output [31:0]    debug_wb_rf_wdata  // 当前指令需要写回的数据
);

/*
    提供的3个测试样例，均无跳转和分支指令
*/
    wire stall, flush;
    // flush sig needs to be completed
    wire [31:0] NPC, Branch_PC, J_PC, PC, PC_Result; // PC mod

    wire [31:0] IF_Instr, ID_Instr, EX_Instr, MEM_Instr, WB_Instr; // Instruction for debug
    wire [31:0] IF_PC, ID_PC, EX_PC, MEM_PC, WB_PC; // PC for debug


    // ID Stage
    wire ID_RegWrite, ID_MemToReg, ID_MemWrite, ID_Branch, ID_AluSrcB, ID_AluSrcA, ID_Jump;
    wire [5:0] ID_AluOP; 
    wire [31:0] ID_Imm, ID_Reg1, ID_Reg2, ID_NPC;
    wire [25:0] ID_instr_index;
    wire [4:0] ID_rs, ID_rt, ID_rd;
    wire [4:0] ID_WriteReg;
    wire [15:0] offset;
    wire [4:0] ID_shamt; assign ID_shamt = ID_Instr[10:6]; // SLL rd, rt, shamt
    
    // EX Stage
    wire [4:0] EX_rs, EX_rt, EX_rd;
    wire EX_RegWrite, EX_MemToReg, EX_MemWrite, EX_Branch, EX_AluSrcB, EX_AluSrcA, EX_Jump;
    wire [5:0] EX_AluOP;
    wire [31:0] EX_Imm, EX_Reg1, EX_Reg2;
    wire [4:0] EX_WriteReg;
    wire [25:0] EX_instr_index;
    wire [31:0] EX_WriteData, EX_AluResult;
    wire [31:0] EX_NPC;
    wire [4:0] EX_shamt;


    // MEM Stage
    wire [4:0] MEM_rd, MEM_rt;
    wire MEM_RegWrite, MEM_MemToReg, MEM_MemWrite;
    wire [4:0] MEM_WriteReg;
    wire [31:0] MEM_WriteData, MEM_AluResult;
    wire [31:0] MEM_ReadData;

    // WB Stage
    wire [4:0] WB_rd, WB_rt;
    wire WB_RegWrite, WB_MemToReg, WB_MemWrite;
    wire [4:0] WB_WriteReg;
    wire [31:0] WB_AluResult;
    wire [31:0] WB_ReadData;
    wire [31:0] WriteBackData;

    // Forwardinng Unit
    wire [1:0] AluSrcA_Sel, AluSrcB_Sel;
    wire [1:0] WriteData_Sel;

    // CU
    wire RegDst;

    // ALU
    wire Zero;
    wire [31:0] SrcA, SrcB;

    // Branch
    wire Branch;
    assign Branch = Zero & EX_Branch; // AND-Gate
    

    assign debug_wb_pc = WB_PC;
    assign debug_wb_rf_wen = WB_RegWrite;
    assign debug_wb_rf_addr = WB_WriteReg;
    assign debug_wb_rf_wdata = WriteBackData;
    
    PC_Mux  PC_Mux_u (
        .NPC                     ( NPC         ),
        .J_PC                    ( J_PC        ),
        .Branch_PC               ( Branch_PC   ),
        .Jump                    ( Jump        ),
        .Branch                  ( Branch      ),

        .PC_Result               ( PC_Result   )
    );

    PC_Mod  PC_Mod_u (
        .clk                     ( clk         ),
        .reset_n                 ( reset_n     ),
        .stall                   ( stall       ),
        .PC_Result               ( PC_Result   ),

        .PC                      ( PC          ) 
    );

    Instr_Buffer_Memory  Instr_Buffer_Memory_u (
        .PC                      ( PC            ),

        .instruction             ( IF_Instr      )
    );

    NPC_Mod  NPC_Mod_u (
        .PC                      ( PC    ),

        .NPC                     ( NPC   )
    );

    assign IF_NPC = NPC; // NPC in IF stage
    assign IF_PC = PC;   // PC in IF stage
    IF_ID_Reg  u_IF_ID_Reg (
        .IF_Instr                ( IF_Instr   ),
        .clk                     ( clk        ),
        .reset_n                 ( reset_n    ),
        .stall                   ( stall      ),
        .IF_NPC                  ( IF_NPC     ),
        .IF_PC                   ( IF_PC      ),

        .ID_NPC                  ( ID_NPC     ),
        .ID_PC                   ( ID_PC      ),
        .ID_Instr                ( ID_Instr   )
        );

    CU  CU_u (
        .OP                      ( ID_Instr[31:26] ),
        .func                    ( ID_Instr[5:0]   ),

        .RegWrite                ( ID_RegWrite   ),
        .MemToReg                ( ID_MemToReg   ),
        .MemWrite                ( ID_MemWrite   ),
        .AluOP                   ( ID_AluOP      ),
        .Branch                  ( ID_Branch     ),
        .AluSrcB                 ( ID_AluSrcB    ),
        .AluSrcA                 ( ID_AluSrcA    ),
        .Jump                    ( ID_Jump       ),
        .RegDst                  ( RegDst        )
    );

    assign ID_rs = ID_Instr[25:21];
    assign ID_rt = ID_Instr[20:16];
    assign ID_rd = ID_Instr[15:11];
    regfile regfile_u(
        .clk    (clk),
        .raddr1 (ID_rs),
        .raddr2 (ID_rt),
        .we     (WB_RegWrite), 
        .waddr  (WB_WriteReg),
        .wdata  (WriteBackData), 
        .rdata1 (ID_Reg1),
        .rdata2 (ID_Reg2)
    );

    WriteReg_Mux  WriteReg_Mux_u (
        .rt                      ( ID_rt        ),
        .rd                      ( ID_rd        ),
        .RegDst                  ( RegDst       ),

        .ID_WriteReg             ( ID_WriteReg  )
    );

    assign offset = ID_Instr[15:0];
    SigExt  SigExt_u (
        .offset                  ( offset   ),

        .Imm                     ( ID_Imm   ) 
    );

    ID_EX_Reg  ID_EX_Reg_u (
        .clk                     ( clk              ),
        .stall                   ( stall            ),
        .reset_n                 ( reset_n          ),
        .ID_Instr                ( ID_Instr         ),
        .ID_RegWrite             ( ID_RegWrite      ),
        .ID_MemToReg             ( ID_MemToReg      ),
        .ID_MemWrite             ( ID_MemWrite      ),
        .ID_AluOP                ( ID_AluOP         ),
        .ID_Branch               ( ID_Branch        ),
        .ID_AluSrcB              ( ID_AluSrcB       ),
        .ID_Jump                 ( ID_Jump          ),
        .ID_Imm                  ( ID_Imm           ),
        .ID_Reg1                 ( ID_Reg1          ),
        .ID_Reg2                 ( ID_Reg2          ),
        .ID_WriteReg             ( ID_WriteReg      ),
        .ID_instr_index          ( ID_instr_index   ),
        .ID_NPC                  ( ID_NPC           ),
        .ID_PC                   ( ID_PC            ),
        .ID_rs                   ( ID_rs            ),
        .ID_rt                   ( ID_rt            ),
        .ID_rd                   ( ID_rd            ),
        .ID_shamt                ( ID_shamt         ),
        .ID_AluSrcA              ( ID_AluSrcA       ),

        .EX_Instr                ( EX_Instr         ),
        .EX_rs                   ( EX_rs            ),
        .EX_rt                   ( EX_rt            ),
        .EX_rd                   ( EX_rd            ),
        .EX_RegWrite             ( EX_RegWrite      ),
        .EX_MemToReg             ( EX_MemToReg      ),
        .EX_MemWrite             ( EX_MemWrite      ),
        .EX_AluOP                ( EX_AluOP         ),
        .EX_Branch               ( EX_Branch        ),
        .EX_AluSrcB              ( EX_AluSrcB       ),
        .EX_Jump                 ( EX_Jump          ),
        .EX_Imm                  ( EX_Imm           ),
        .EX_Reg1                 ( EX_Reg1          ),
        .EX_Reg2                 ( EX_Reg2          ),
        .EX_WriteReg             ( EX_WriteReg      ),
        .EX_instr_index          ( EX_instr_index   ),
        .EX_NPC                  ( EX_NPC           ),
        .EX_PC                   ( EX_PC            ),
        .EX_shamt                ( EX_shamt         ),
        .EX_AluSrcA              ( EX_AluSrcA       )
    );

    J_Mod  J_Mod_u (
        .instr_index             ( EX_instr_index   ),
        .NPC                     ( EX_NPC           ),

        .J_PC                    ( J_PC          )
    ); 

    
    Branch_Mod  Branch_Mod_u (
        .Imm                     ( EX_Imm         ),
        .NPC                     ( EX_NPC         ),

        .Branch_PC               ( Branch_PC   )
    );

    AluSrcA_Mux  AluSrcA_Mux_u (
        .EX_Reg1                 ( EX_Reg1         ),
        .MEM_AluResult           ( MEM_AluResult   ),
        .WriteBackData           ( WriteBackData   ),
        .AluSrcA_Sel             ( AluSrcA_Sel     ),
        .EX_AluSrcA              ( EX_AluSrcA      ),
        .EX_shamt                ( EX_shamt        ),

        .SrcA                    ( SrcA            )
    );

    AluSrcB_Mux  AluSrcB_Mux_u (
        .AluSrcB_Sel             ( AluSrcB_Sel     ),
        .EX_AluSrcB              ( EX_AluSrcB      ),
        .EX_Reg2                 ( EX_Reg2         ),
        .EX_Imm                  ( EX_Imm          ),
        .WriteBackData           ( WriteBackData   ),
        .MEM_AluResult           ( MEM_AluResult   ),

        .SrcB                    ( SrcB            )
    );

    WriteData_Mux  u_WriteData_Mux (
        .EX_Reg2                 ( EX_Reg2         ),
        .WriteBackData           ( WriteBackData   ),
        .MEM_ReadData            ( MEM_ReadData   ),
        .WriteData_Sel           ( WriteData_Sel   ),

        .EX_WriteData            ( EX_WriteData    )
    );

    alu  alu_u (
        .A                       ( SrcA         ),
        .B                       ( SrcB         ),
        .AluOP                   ( EX_AluOP     ),

        .Zero                    ( Zero         ),
        .F                       ( EX_AluResult )
    );

    EX_MEM_Reg  EX_MEM_Reg_u (
        .clk                     ( clk             ),
        .reset_n                 ( reset_n         ),
        .EX_Instr                ( EX_Instr        ),
        .EX_RegWrite             ( EX_RegWrite     ),
        .EX_MemToReg             ( EX_MemToReg     ),
        .EX_MemWrite             ( EX_MemWrite     ),
        .EX_WriteReg             ( EX_WriteReg     ),
        .EX_WriteData            ( EX_WriteData    ),
        .EX_AluResult            ( EX_AluResult    ),
        .EX_rd                   ( EX_rd           ),
        .EX_rt                   ( EX_rt           ),
        .EX_PC                   ( EX_PC           ),
        .EX_AluOP                ( EX_AluOP        ),
        .Zero                    ( Zero            ), 

        .MEM_PC                  ( MEM_PC          ),
        .MEM_Instr               ( MEM_Instr       ),
        .MEM_rt                  ( MEM_rt          ),
        .MEM_rd                  ( MEM_rd          ),
        .MEM_RegWrite            ( MEM_RegWrite    ),
        .MEM_MemToReg            ( MEM_MemToReg    ),
        .MEM_MemWrite            ( MEM_MemWrite    ),
        .MEM_WriteReg            ( MEM_WriteReg    ),
        .MEM_WriteData           ( MEM_WriteData   ),
        .MEM_AluResult           ( MEM_AluResult   )
    );
   
   Data_Buffer_Memory  Data_Buffer_Memory_u (
        .i_data                  ( MEM_WriteData ),
        .addr                    ( MEM_AluResult ),
        .we                      ( MEM_MemWrite  ),
        .clk                     ( clk      ),

        .o_data                  ( MEM_ReadData  )
    );

    MEM_WB_Reg  MEM_WB_Reg_u (
        .clk                     ( clk             ),
        .reset_n                 ( reset_n         ),
        .MEM_Instr               ( MEM_Instr       ),
        .MEM_RegWrite            ( MEM_RegWrite    ),
        .MEM_MemToReg            ( MEM_MemToReg    ),
        .MEM_MemWrite            ( MEM_MemWrite    ),
        .MEM_WriteReg            ( MEM_WriteReg    ),
        .MEM_AluResult           ( MEM_AluResult   ),
        .MEM_ReadData            ( MEM_ReadData    ),
        .MEM_rd                  ( MEM_rd          ),
        .MEM_rt                  ( MEM_rt          ),
        .MEM_PC                  ( MEM_PC          ),

        .WB_PC                   ( WB_PC           ),
        .WB_Instr                ( WB_Instr        ),
        .WB_rd                   ( WB_rd           ),
        .WB_rt                   ( WB_rt           ),
        .WB_RegWrite             ( WB_RegWrite     ),
        .WB_MemToReg             ( WB_MemToReg     ),
        .WB_MemWrite             ( WB_MemWrite     ),
        .WB_WriteReg             ( WB_WriteReg     ),
        .WB_AluResult            ( WB_AluResult    ),
        .WB_ReadData             ( WB_ReadData     )
    );

    WB_Mux  WB_Mux_u (
        .WB_AluResult            ( WB_AluResult    ),
        .WB_ReadData             ( WB_ReadData     ),
        .WB_MemToReg             ( WB_MemToReg     ),

        .WriteBackData           ( WriteBackData   )
    );

    HazardUnit  HazardUnit_u (
        .EX_MemToReg             ( EX_MemToReg   ),
        .EX_rt                   ( EX_rt         ),
        .ID_rs                   ( ID_rs         ),
        .ID_rt                   ( ID_rt         ),
        .EX_Jump                 ( EX_Jump       ),
        .EX_Branch               ( EX_Branch     ),
        .Zero                    ( Zero          ),
        .ID_MemWrite             ( ID_MemWrite   ),

        .stall                   ( stall         ),
        .flush                   ( flush         )
    );

    ForwardUnit  u_ForwardUnit (
        .EX_rs                   ( EX_rs          ),
        .EX_rt                   ( EX_rt          ),
        .EX_rd                   ( EX_rd          ),
        .EX_MemWrite             ( EX_MemWrite    ),
        .MEM_rd                  ( MEM_rd         ),
        .MEM_rt                  ( MEM_rt         ),
        .MEM_RegWrite            ( MEM_RegWrite   ),
        .MEM_MemToReg            ( MEM_MemToReg   ),
        .MEM_MemWrite            ( MEM_MemWrite   ),
        .WB_rd                   ( WB_rd          ),
        .WB_rt                   ( WB_rt          ),
        .WB_RegWrite             ( WB_RegWrite    ),
        .WB_MemToReg             ( WB_MemToReg    ),
        

        .AluSrcA_Sel             ( AluSrcA_Sel    ),
        .AluSrcB_Sel             ( AluSrcB_Sel    ),
        .WriteData_Sel           ( WriteData_Sel )
    );
endmodule