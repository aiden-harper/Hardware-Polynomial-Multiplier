`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 05:00:38 PM
// Design Name: 
// Module Name: tb_NTT
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


module tb_NTT;
    parameter BITS = 40, N = 8, Q = 3329;
    reg [BITS-1:0] f[0:N-1], psis[0:N/2-1];
    wire [BITS-1:0] fhat[0:N-1];
    NTT uut(.f(a), .psis(psis[0:N/2-1]), .fhat(fhat));
    initial
    begin
    #50 a[0] <= 1; a[1] <= 2; a[2] <= 3; a[3] <= 4; a[4] <= 5; a[5] <= 6; a[6] <= 7; a[7] <= 8; psis[0] <= 1; psis[1] <= 1600; psis[2] <= 40; psis[3] <= 749;
    end
endmodule
