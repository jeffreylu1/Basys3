//////////////////////////////////////////////////////////////////////////////////
// Module Name: segment_controller
// Target Devices: Basys 3
// Tool Versions: Vivado 2018.1
// Description: Display a 16 bit number as a hex value on the 7 segment display
//              of the Basys 3 prototype board
//////////////////////////////////////////////////////////////////////////////////
module segment_controller(
    clock,
    reset,
    displayed_number,
    en_seg_n,
    LED_out
);

//////////////////////////////////////////////////////////////////////////////////
// Port Declarations
//////////////////////////////////////////////////////////////////////////////////
input               clock;              // 100Mhz clock
input               reset;              // reset
input       [15:0]  displayed_number;   // Value to display on 7 segment display
output reg  [ 3:0]  en_seg_n;           // Enable segment (cathode active low)
output reg  [ 6:0]  LED_out;            // Cathode patterns

reg         [ 3:0]  led_disp;           //
reg         [19:0]  count;              //
reg         [ 1:0]  seg_sel;            //

//////////////////////////////////////////////////////////////////////////////////
// Seven Segment Display Logic
//////////////////////////////////////////////////////////////////////////////////

// Count to 2.5ms (250000 cycles) for each digit period with a refresh period of 10ms
// based on a 100MHz ref clock. See Basys 3 reference manual for timing diagram
always @(posedge clock or posedge reset) begin
    if(reset) begin
        count   <= 'b0;
        seg_sel <= 2'b00;
    end else begin
        if (count == 250000) begin
            seg_sel <=  seg_sel + 1;
            count   <= 1;
        end else begin
            seg_sel <= seg_sel;
            count   <= count + 1;
        end
    end
end

// LED Segment selector
always @(*) begin
    case(seg_sel)
    2'b00: begin
            en_seg_n <= 4'b0111;
            led_disp <= displayed_number[15:12];
    end
    2'b01: begin
            en_seg_n <= 4'b1011;
            led_disp <= displayed_number[11:8];
    end
    2'b10: begin
            en_seg_n <= 4'b1101;
            led_disp <= displayed_number[7:4];
    end
    2'b11: begin
            en_seg_n <= 4'b1110;
            led_disp <= displayed_number[3:0];
    end
    endcase
end

// Binary to Hex decoder
always @(*) begin
    case(led_disp)
        4'b0000: LED_out <= 7'b1000000; // "0"
        4'b0001: LED_out <= 7'b1111001; // "1"
        4'b0010: LED_out <= 7'b0100100; // "2"
        4'b0011: LED_out <= 7'b0110000; // "3"
        4'b0100: LED_out <= 7'b0011001; // "4"
        4'b0101: LED_out <= 7'b0010010; // "5"
        4'b0110: LED_out <= 7'b0000010; // "6"
        4'b0111: LED_out <= 7'b1111000; // "7"
        4'b1000: LED_out <= 7'b0000000; // "8"
        4'b1001: LED_out <= 7'b0010000; // "9"
        4'b1010: LED_out <= 7'b0001000; // "A"
        4'b1011: LED_out <= 7'b0000011; // "b"
        4'b1100: LED_out <= 7'b1000110; // "C"
        4'b1101: LED_out <= 7'b0100001; // "d"
        4'b1110: LED_out <= 7'b0000110; // "E"
        4'b1111: LED_out <= 7'b0001110; // "F"
        default: LED_out <= 7'b1000000; // "0"
    endcase
end

endmodule