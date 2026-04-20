`include "src/button.sv"
`include "src/decoder.sv"
module top (
    /** Input Ports */
    input wire clk,
    input wire rst,
    input wire[1:0] bt,
    input wire dip,

    /** Output Ports */
    output logic[1:0] led,
    output logic[6:0] seg7,
    output logic dot
);

/** Logic */

logic[3:0] duty_cycle;
logic[3:0] display;
button u_bt(
    .clk(clk),
    .rst(rst),
    .bt(bt),
    .dip(dip),
    .led(led),
    .duty_cycle(duty_cycle),
    .dot(dot),
    .seg7(display)
);

decoder u_decoder(
    .bcd(display),
    .seg7(seg7)
);

endmodule