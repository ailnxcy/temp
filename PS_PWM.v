
//`#start header` -- edit after this line, do not edit this line
// ========================================
//
// Copyright YOUR COMPANY, THE YEAR
// All Rights Reserved
// UNPUBLISHED, LICENSED SOFTWARE.
//
// CONFIDENTIAL AND PROPRIETARY INFORMATION
// WHICH IS THE PROPERTY OF your company.
//
// ========================================
`include "cypress.v"
//`#end` -- edit above this line, do not edit this line
// Generated on 11/08/2015 at 20:00
// Component: PS_PWM
module PS_PWM (
	output  Qa,
	output  Qb,
	input   Clock,
	input   FeedBack,
	input  [7:0] PWM,
	input   Trig
);

//`#start body` -- edit after this line, do not edit this line
    wire    q;
    wire    Q;
    wire    clock;
    wire    [7:0] alui;
    wire    [7:0] aluo;
    
    reg     mask;
    reg     fb;     //FeedBack edge detect
    reg     [2:0] cnt;
    reg     [1:0] state;
    
    assign Q = Trig & ~q;
    assign Qa = FeedBack & Q;
    assign Qb = ~FeedBack & Q;
    assign alui = mask ? aluo : 8'h00;
    
    initial mask <= 1;
    

    
    localparam COUNT_UP    = 2'd0;
    localparam RESET_PWM   = 2'd1;
    localparam CALC_PWM    = 2'd2;
    localparam RESET_COUNT = 2'd3;
    
    cy_psoc3_udb_clock_enable_v1_0 #(.sync_mode(`TRUE))
    ClockEnable (
        /* output */.clock_out(clock),
        /* input */ .clock_in(Clock),
        /* input */ .enable(1'b1)
    );
    
    always @(posedge clock)
    begin
        if(fb != FeedBack)
        begin
            fb <= FeedBack;
            if(Trig)
            begin
                if(state[0])
                begin
                    state <= COUNT_UP;
                end
                else
                begin
                    state <= RESET_PWM;
                end
            end
        end
        if(Trig)
        begin
            case(state)
            RESET_PWM:
            begin
                state <= CALC_PWM;
            end
            CALC_PWM:
            begin
                if(~cnt)
                begin
                    cnt <= cnt + 1;
                    if(PWM[cnt])
                    begin
                        mask <= 1;
                    end
                    else
                    begin
                        mask <= 0;
                    end
                end
                else
                begin
                    state <= RESET_PWM;
                    cnt <= 0;
                    mask <= 1;
                end
            end
            RESET_COUNT:
            begin
                state <= COUNT_UP;
            end
            default:
            begin
            end
            endcase
        end
        else
        begin
            state <= RESET_PWM;
        end
    end
    
//        Your code goes here

cy_psoc3_dp #(.d0_init(10), .d1_init(64), 
.cy_dpconfig(
{
    `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_A0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC__ALU, `CS_A1_SRC___D1,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM0:   init*/
    `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_A0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC__ALU, `CS_A1_SRC___D1,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM1:   init*/
    `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_A0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC__ALU, `CS_A1_SRC___D1,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM2:   init*/
    `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_A0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC__ALU, `CS_A1_SRC___D1,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM3:   init*/
    `CS_ALU_OP__INC, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGB, /*CFGRAM4:   count up*/
    `CS_ALU_OP__XOR, `CS_SRCA_A0, `CS_SRCB_A0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC__ALU,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM5:   reset pwm*/
    `CS_ALU_OP__ADD, `CS_SRCA_A0, `CS_SRCB_A1,
    `CS_SHFT_OP___SR, `CS_A0_SRC_NONE, `CS_A1_SRC__ALU,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM6:   calc pwm*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC___D0, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM7:   reset count*/
    8'hFF, 8'h00,  /*CFG9:   */
    8'hFF, 8'hFF,  /*CFG11-10:   */
    `SC_CMPB_A1_A0, `SC_CMPA_A0_A0, `SC_CI_B_ARITH,
    `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
    `SC_A_MASK_DSBL, `SC_DEF_SI_1, `SC_SI_B_DEFSI,
    `SC_SI_A_DEFSI, /*CFG13-12:   */
    `SC_A0_SRC_PIN, `SC_SHIFT_SL, 1'h0,
    1'h0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
    `SC_MSB_DSBL, `SC_MSB_BIT0, `SC_MSB_NOCHN,
    `SC_FB_NOCHN, `SC_CMP1_NOCHN,
    `SC_CMP0_NOCHN, /*CFG15-14:   */
    10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
    `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_DSBL,
    `SC_WRK16CAT_DSBL /*CFG17-16:   */
}
)) pspwm_datapath(
        /*  input                   */  .reset(1'b0),
        /*  input                   */  .clk(clock),
        /*  input   [02:00]         */  .cs_addr({Trig,state[1:0]}),
        /*  input                   */  .route_si(1'b0),
        /*  input                   */  .route_ci(1'b0),
        /*  input                   */  .f0_load(1'b0),
        /*  input                   */  .f1_load(1'b0),
        /*  input                   */  .d0_load(1'b0),
        /*  input                   */  .d1_load(1'b0),
        /*  output                  */  .ce0(),
        /*  output                  */  .cl0(),
        /*  output                  */  .z0(),
        /*  output                  */  .ff0(),
        /*  output                  */  .ce1(),
        /*  output                  */  .cl1(q),
        /*  output                  */  .z1(),
        /*  output                  */  .ff1(),
        /*  output                  */  .ov_msb(),
        /*  output                  */  .co_msb(),
        /*  output                  */  .cmsb(),
        /*  output                  */  .so(),
        /*  output                  */  .f0_bus_stat(),
        /*  output                  */  .f0_blk_stat(),
        /*  output                  */  .f1_bus_stat(),
        /*  output                  */  .f1_blk_stat(),
        
        /* input                    */  .ci(1'b0),     // Carry in from previous stage
        /* output                   */  .co(),         // Carry out to next stage
        /* input                    */  .sir(1'b0),    // Shift in from right side
        /* output                   */  .sor(),        // Shift out to right side
        /* input                    */  .sil(1'b0),    // Shift in from left side
        /* output                   */  .sol(),        // Shift out to left side
        /* input                    */  .msbi(1'b0),   // MSB chain in
        /* output                   */  .msbo(),       // MSB chain out
        /* input [01:00]            */  .cei(2'b0),    // Compare equal in from prev stage
        /* output [01:00]           */  .ceo(),        // Compare equal out to next stage
        /* input [01:00]            */  .cli(2'b0),    // Compare less than in from prv stage
        /* output [01:00]           */  .clo(),        // Compare less than out to next stage
        /* input [01:00]            */  .zi(2'b0),     // Zero detect in from previous stage
        /* output [01:00]           */  .zo(),         // Zero detect out to next stage
        /* input [01:00]            */  .fi(2'b0),     // 0xFF detect in from previous stage
        /* output [01:00]           */  .fo(),         // 0xFF detect out to next stage
        /* input [01:00]            */  .capi(2'b0),   // Software capture from previous stage
        /* output [01:00]           */  .capo(),       // Software capture to next stage
        /* input                    */  .cfbi(1'b0),   // CRC Feedback in from previous stage
        /* output                   */  .cfbo(),       // CRC Feedback out to next stage
        /* input [07:00]            */  .pi(alui),     // Parallel data port
        /* output [07:00]           */  .po(aluo)      // Parallel data port
);
//`#end` -- edit above this line, do not edit this line
endmodule
//`#start footer` -- edit after this line, do not edit this line
//`#end` -- edit above this line, do not edit this line


