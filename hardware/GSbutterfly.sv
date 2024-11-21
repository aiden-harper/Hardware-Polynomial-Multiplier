`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:38:33 PM
// Design Name: 
// Module Name: GSbutterfly
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

// Gentleman-Sande butterfly unit
// PARAMETERS - Q: Modulus, BITS: Bitwidth
module GSbutterfly #(parameter BITS = 13, parameter Q = 7681)
                (input logic [BITS-1:0] in0, in1, w, output logic [BITS-1:0] out0, out1);
        // u = in0, v = in1
        // out0 = (u + v)%q
        assign out0 = (in0 + in1)%Q;
        // out1 = ((u - v)*w)%q     (note: -v = Q-v due to the ring)
        assign out1 = ((in0 + (Q-in1))*w)%Q;
endmodule
