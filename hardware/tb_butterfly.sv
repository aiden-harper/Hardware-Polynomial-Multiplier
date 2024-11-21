`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 04:37:32 PM
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
    reg [31:0] in[0:1], w;
    wire [31:0] out[0:1];
    butterfly uut(.in(in), .w(w), .out(out));
    initial 
        begin
            #1 in[0] <= 1; in[1] <= 3; w <= 1;
            #1 in[0] <= 2; in[1] <= 4; w <= 1;
        end
endmodule
