`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 01:55:11 PM
// Design Name: 
// Module Name: tb_butterfly
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


module tb_butterfly;
    reg [31:0] x0, x1, w;
    wire [31:0] a0, a1;
    butterfly uut(.x0(x0), .x1(x1), .w(w), .a0(a0), .a1(a1));
    initial 
        begin
            #1 x0 <= 1; x1 <= 3; w <= 1;
            #1 x0 <= 2; x1 <= 4; w <= 3;
        end
endmodule
