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


module GSbutterfly #(parameter BITS = 12, parameter Q = 3329)
                (input logic [BITS-1:0] in0, in1, w, output logic [BITS-1:0] out0, out1);
        // assign even output to even input plus twiddle factor times odd input all mod Q
        assign out0 = (in0 + in1)%Q;
        // assign odd output to even input minus twiddle factor times odd input all mod Q
        assign out1 = ((in0 + (Q-in1))*w)%Q;
endmodule
