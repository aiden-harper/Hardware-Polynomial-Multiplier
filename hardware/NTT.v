`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 12:12:50 AM
// Design Name: 
// Module Name: NTT
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


module NTT #(parameter integer BITS = 32, parameter Q = 5)
            (input wire [BITS-1:0] x0, x1, x2, x3, w0, w1, output wire [BITS-1:0] b0, b1, b2, b3);
            wire [BITS-1:0] a0, a1, a2, a3;
            // stage 1 butterflies
            butterfly fly1(.x0(x0), .x1(x2), .a0(a0), .a1(a1), .w(w0));
            butterfly fly2(.x0(x1), .x1(x3), .a0(a2), .a1(a3), .w(w0));
            
            // stage 2 butterflies
            butterfly fly3(.x0(a0), .x1(a2), .a0(b0), .a1(b2), .w(w0));
            butterfly fly4(.x0(a1), .x1(a3), .a0(b1), .a1(b3), .w(w1));
    
endmodule
