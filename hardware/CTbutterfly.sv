`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 04:34:06 PM
// Design Name: 
// Module Name: butterfly
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Cooley-Tukey butterfly unit
// PARAMETERS - Q: Modulus, BITS: Bitwidth
module CTbutterfly #(parameter BITS = 13, parameter Q = 7681)
                (input logic [BITS-1:0] in0, in1, w, output logic [BITS-1:0] out0, out1);
        // u = in0, v = in1
        // out0 = (u + w*v)%q
        assign out0 = (in0 + w*in1)%Q;
        // out1 = (u - w*v)%q      (note: -w = Q-w due to the ring)
        assign out1 = (in0 + (Q-w)*in1)%Q;
endmodule
