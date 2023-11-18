## 2.1 Modules Explanation
* Adder.v
        
    Adder 模組接收 2 個 32-bit 輸入，src1_i 和 src2_i，並產生 1 個 32-bit 的輸出 adder_o。模組使用 assign 語句將 adder_o 設為 src1_i 和 src2_i 的總和。因此，Adder 模組實現了 32-bit 的加法功能。

* ALU_Control.v

    ALU_Control 模組讀取來自指令的 funct7 和 funct3 的部分以及 ALU 運算類型（ALUOp），並輸出 ALU 操作碼（op_o）。根據 ALUOp、funct7、funct3 的組合，模組使用一系列的 case 語句來確定 ALU 的實際操作。這個模組支援 I-type、R-type、lw/sw、和 beq 四種不同類型，並根據指令的不同選擇相應的 ALU 操作碼。由於 lw/sw 在 ALU 中是使用加法來確定 address，因此 ALU_Control 模組在 lw/sw 的情況下會將 ALU 操作碼設跟 add 和 addi 指令相同的 ALU 操作碼；而 beq 在 ALU 中是使用減法來確定 rs1 和 rs2 是否相等，因此 ALU_Control 模組在 beq 的情況下會將 ALU 操作碼設跟 sub 指令相同的 ALU 操作碼。

    |     op    | 指令類型  |
    | :---------: | :------: |
    |     000     |   and    |
    |     001     |   xor    |
    |     010     |   sll    |
    |     011     |   add、addi、 lw/sw|
    |     100     |   sub、beq    |
    |     101     |   mul    |
    |     111     |   srai   |

* ALU.v

    ALU 模組包含操作碼（op_i）、兩個操作數（src1_i 和 src2_i）作為輸入以及 ALU 結果（ALUResult_o）作為輸出。該模組根據操作碼的值執行不同的運算。例如，當操作碼為 3'b011 時，執行加法操作，將 src1_i 和 src2_i 相加，結果存儲在 ALUResult_o 中。

* Branch_Detection_Unit.v
    Branch_Detection_Unit 模組接收 2 個 32-bit 的輸入 src1_i 和 src2_i，以及 1 個 Branch_i 作為輸入，並輸出 1-bit 的 is_equal_o 和 flush_o。is_equal_o 信號用來判斷 src1_i 和 src2_i 是否相等，若相等則為 1，否則為 0。flush_o 信號則用來判斷現在是否是執行 branch 指令（beq）且 src1_i 和 src2_i 是否相等時，來確認是否應該執行分支。當是在執行 branch 指令時（Branch_i = 1）且 src1_i 和 src2_i 相等（is_equal_o = 0）則代表應該執行分支，此時 flush_o 信號為 1，反之則為 0。

* Control.v
        
    Control 模組接收 1-bit 的 NoOp 信號和 7-bit 的 opcode 信號作為輸入，並產生 8 個控制信號作為輸出。當 NoOp 信號為 1 時，表示是 No Operation，則所有控制信號皆設為零；反之，根據 opcode 的值進行不同的設定。

    8 個控制信號作用如下：

    * ALUOp_o：這是一個 2-bit 的信號，表示 ALU（算術邏輯單元）的操作類型。根據不同的指令類型，設定 ALUOp_o 的值。

        |   指令類型   |  ALUOp_o |
        | :---------: | :------: |
        |     I-type  |   00     |
        |     R-type  |   01     |
        |     lw/sw   |   10     |
        |     beq     |   11     |

    * ALUSrc_o：這是一個 1-bit 信號，指示 ALU 的輸入選擇。當 ALUSrc_o 為 1 時，表示 ALU 的輸入來自指令中的常數（immediate）；反之，則來自第二個來源（rs2）。

    * RegWrite_o：這是一個 1-bit 信號，表示是否對寄存器進行寫入。僅在 store 指令（sw）和 branch 指令（beq）時為 0。

    * MemtoReg_o：這是一個 1-bit 信號，表示是否將記憶體的值寫回寄存器。僅在 load 指令（lw）時為 1。

    * MemRead_o：這是一個 1-bit 信號，表示是否從記憶體中讀取數據。僅在 load 指令（lw）時為 1。

    * MemWrite_o：這是一個 1-bit 信號，表示是否將數據寫入記憶體。僅在 store 指令（sw）時為 1。

    * Branch_o：這是一個 1-bit 信號，表示當前指令是否是 branch 指令（beq）。僅在 branch 指令（beq）時為 1。

    根據指令的不同類型，Control 模組將這些控制信號設置為適當的值，以指導流水線中的各個模組執行正確的操作。

* Forwarding_Unit.v

    Forwarding_Unit 模組的作用是處理 data forwarding 的邏輯，以解 data hazard 的問題。此模組接收來自 MEM 和 WB 階段的控制信號（RegWrite）和要寫回寄存器中的數據地址以及 ID/EX pipeline 的寄存器的來源寄存器號碼（rs1、rs2），並生成兩個輸出信號 ForwardA_o 和 ForwardB_o，這兩個信號用於指示應該選擇甚麼值傳入給 ALU。

    Forwarding_Unit 模組的運作邏輯是透過一系列條件判斷來確定是否有必要進行 data forwarding。具體來說：

    * 對於 ForwardA_o，首先檢查 EX 階段是否有寫入記憶體（EX_MEM_RegWrite_i = 1），並且目標寄存器不是 0（EX_MEM_RDaddr_i != 0），同時目標寄存器地址等於取指令階段的第一個來源寄存器地址（ID_EX_RS1addr_i）。如果這些條件滿足，則將 ForwardA_o 設置為 2'b10，表示需進行 MEM 階段到 EX 階段的 data forwarding，將此時 MEM 階段中的 ALUResult 作為此時 EX 階段中 ALU 計算的第一個來源。

    * 如果上述條件不滿足，則進一步檢查 MEM 階段是否有需要將資料寫回寄存器（MEM_WB_RegWrite_i = 1），目標寄存器不是零（MEM_WB_RDaddr_i != 0），並且不同於 EX 階段的 RegWrite，同時目標寄存器地址等於 EX 階段的第一個來源寄存器地址（ID_EX_RS1addr_i）。如果這些條件滿足，則 ForwardA_o 設置為 2'b01，表示需進行 WB 階段到 EX 階段的 data forwarding，將此時 WB 階段中的 MUXResult 作為此時 EX 階段中 ALU 計算的第一個來源。

    * 如果以上條件都不滿足，則將 ForwardA_o 設置為 2'b00，表示不進行 data forwarding。

    對於 ForwardB_o 的判斷過程類似，只是將相應的信號和地址應用於第二個來源寄存器。這樣，Forwarding_Unit 模組確保在 data hazard 的情況下，系統能夠正確地執行指令。

* Hazard_Detection_Unit.v

    Hazard_Detection_Unit 模組包主要用於檢測 pipeline 中的 load use data hazard。以下是該模組的解釋：

    Hazard_Detection_Unit 模組讀取重設信號（rst_i）、兩個來源寄存器的地址（RS1addr_i 和 RS2addr_i）、執行階段的目的寄存器地址（ID_EX_RDaddr_i）以及執行階段的記憶體讀取控制信號（ID_EX_MemRead_i）作為輸入。它產生三個輸出信號：NoOp_o、Stall_o 和 PCWrite_o。

    模組使用條件語句來定義輸出信號。如果重設信號（rst_i）設為 0，模組將產生預設值，即 NoOp_o 為 0、Stall_o 為 0、PCWrite_o 為 1。這表示在重設時，模組不會引發任何操作的中斷，並允許 PC 的寫入。

    如果 ID_EX_MemRead_i 為 1，且 RS1 或 RS2 的地址等於 ID_EX_RDaddr_i，這表示有 load use data hazard 產生，則 pipeline 需產生 Stall（Stall_o = 1）並且不執行任何操作（NoOp_o = 1），同時禁止 PC 的寫入（PCWrite_o = 0）。

    如果以上條件都不滿足，模組將生成默認值，確保 NoOp_o 為 0、Stall_o 為 0，並允許 PC 的寫入（PCWrite_o 為 1）。這表示在這種情況下，流水線不受阻塞，並且可以正常執行操作。

* Imm_Gen.v

    Imm_Gen 模組是一個產生常數（Immediate）的模組。它接收 32-bit 的指令（instr_i）作為輸入並生成一個 32-bit 的常數（imm_o）。根據不同的指令的 opcode（操作碼）（instr_i[6:0]），模組從指令不同的位元產生該指令要用的常數。具體來說：

    如果 opcode 是 7'b0100011，代表這是一條 store 指令（sw），那麼模組會將 imm_o 設置為 {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]}}。這將從 instr_i 中取得相應的位元組成常數，並使用 instr_i[31] 來填充最高位元（sign extend）。

    如果 opcode 是 7'b1100011，代表這是一條 branch equal 指令（beq），那麼模組會將 imm_o 設置為 {{20{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]}}。同樣地，這將從 instr_i 中取得相應的位元組成常數，並使用 instr_i[31] 來填充最高位元（sign extend）。

    對於其他操作碼，模組會將 imm_o 設置為 {{20{instr_i[31]}}, instr_i[31:20]}}。這是處理其他指令的默認情況。

* MUX32_Forwarding.v

    MUX32_Forwarding 模組包含 4 個輸入：2-bit 的 sel（選擇位元）、32-bit 的 src1_i、32-bit 的 src2_i、32-bit 的 src3_i，以及一個輸出 32-bit 的 mux_o。用來處理 data forwarding 時選擇的數據。

    選擇位元 sel 用來指示要選擇的輸入數據。根據不同的 sel 值，模組會選擇其中一個輸入作為輸出。

    * 當 sel = 00 時，mux_o 的輸出是 src1_i。
    * 當 sel = 01 時，mux_o 的輸出是 src2_i。
    * 當 sel 不是上述情況時，mux_o 的輸出是 src3_i。

* MUX32.v
    
    MUX32_Forwarding 模組包含 3 個輸入：1-bit 的 sel（選擇位元）、32-bit 的 src1_i、32-bit 的 src2_i 以及一個輸出 32-bit 的 mux_o。

    選擇位元 sel 用來指示要選擇的輸入數據。根據不同的 sel 值，模組會選擇其中一個輸入作為輸出。

    * 當 sel = 0 時，mux_o 的輸出是 src1_i。
    * 當 sel = 1 時，mux_o 的輸出是 src2_i。

* CPU.v

    將所有 module 依照作業給的 datapath 串接起來。首先將 PC 的輸出分別傳給 Adder 和 Instruction_Memory，前者將 PC 的輸出加上常數 4，來指向下一個指令的位址；後者透過 PC 的輸出，找到對應位址的指令，並且將指令輸出。將 Instruction_Memory 的輸出分別拆解並傳給 Control、Registers、Sign_Extend 以及 ALU_Control。Control 依照輸入的 opcode 輸出對應的 control signal 給 Registers、MUX_ALUSrc 以及 ALU_Control。Registers 依照輸入的 register 編號，輸出 rs1 和 rs2 的值，並確認寫入的 register 編號。Sign_Extend 則是將輸入的 12-bit 數字 sign extend 成 32-bit 並輸出。而 Registers 的 rs2 和 Sign_Extend 輸出的值會經過 MUX_ALUSrc，並透過 Control 輸出的 control signal (ALU_src) 來決定要取哪個值輸出。再來 ALU 則會將 Registers 的 rs1 和 MUX_ALUSrc 的輸出進行運算，透過 ALU_Control 的輸出 (ALU_control) 來決定進行甚什運算。最後將 ALU 的輸出根據 Control 輸出的 control signal (RegWrite) 寫回 Registers。 

## 2.2. Difficulties Encountered and Solutions in This Lab


## 2.3 Development Environment
* OS: WSL2 (Windows Subsystem for Linux version 2), Linux distro: Ubuntu 22.04.5 LTS
* compiler: iverilog version 11.0
* IDE: Visual Studio Code