`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:46:09 PM
// Design Name: 
// Module Name: tb_INTT
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


module tb_INTT;
    parameter BITS = 40, N = 8, Q = 3329, invN = 2913;
    reg [BITS-1:0] b[0:N-1], invPsis[0:N/2-1];
    wire [BITS-1:0] f[0:N-1];
    INTT uut(.fhat(b), .invPsis(invPsis), .f(f));
    initial
    begin
    #50 b[0] <= 36; b[1] <= 3325; b[2] <= 254; b[3] <= 3067; b[4] <= 427; b[5] <= 81; b[6] <= 3240; b[7] <= 2894; invPsis[0] <= 1; invPsis[1] <= 1729; invPsis[2] <= 2580; invPsis[3] <= 3289; 
    end
endmodule