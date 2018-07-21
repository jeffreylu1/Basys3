`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: top
// Target Devices: Basys 3 (Artix 7 XC7A35T-ICPG236C)
// Tool Versions: Vivado 2018.1
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////
module top(
    clock,
    reset,
    sw,
    led,
    seg,
    en_seg_n
);

//////////////////////////////////////////////////////////////////////////////////
// Parameter Declarations
//////////////////////////////////////////////////////////////////////////////////
localparam  [7:0]   baudrate = 87;  // 115 200 baudrate for UART RX/TX

//////////////////////////////////////////////////////////////////////////////////
// Port Declarations
//////////////////////////////////////////////////////////////////////////////////
input               clock;          // Clock at 100MHz
input               reset;          // Reset
input       [15:0]  sw;             // Switches
output      [15:0]  led;            // LEDs
output      [ 6:0]  seg;            // 7 segment LED display
output      [ 3:0]  en_seg_n;       // Enable segment (cathode active low)

//////////////////////////////////////////////////////////////////////////////////
// Port Declarations
//////////////////////////////////////////////////////////////////////////////////
reg         [15:0]  debug;

assign led = 16'b0;
/*
// Instantiate modules
uart_rx uart_rx_inst(
    .i_Clock            (clock),
    .i_Rx_Serial        (),
    .o_Rx_DV            (),
    .o_Rx_Byte          ()
);

uart_tx uart_tx_inst(
    .i_Clock            (clock),
    .i_Tx_DV            (),
    .i_Tx_Byte          (),
    .o_Tx_Active        (),
    .o_Tx_Serial        (),
    .o_Tx_Done          ()
);
*/
segment_controller segment_controller_isnt(
    .clock              (clock),
    .reset              (reset),
    .displayed_number   (sw),
    .en_seg_n           (en_seg_n),
    .LED_out            (seg)
);
endmodule