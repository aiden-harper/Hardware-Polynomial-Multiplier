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

// parameters: Q = modulo number, BITS = # bits for inputs/outputs
module CTbutterfly #(parameter BITS = 12, parameter Q = 3329)
                (input logic [BITS-1:0] in0, in1, w, output logic [BITS-1:0] out0, out1);
        // assign even output to even input plus twiddle factor times odd input all mod Q
        assign out0 = (in0 + w*in1)%Q;
        // assign odd output to even input minus twiddle factor times odd input all mod Q
        assign out1 = (in0 + (Q-w)*in1)%Q;
endmodule
