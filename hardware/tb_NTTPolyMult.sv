`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 07:05:59 PM
// Design Name: 
// Module Name: tb_NTTPolyMult
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


module tb_NTTPolyMult;
    parameter BITS = 40, N = 8, Q = 3329, invN = 2913;
    //parameter BITS = 13, N = 256, Q = 7681, invN = 7651;
    reg [BITS-1:0] a[0:N-1], b[0:N-1], psis[0:N/2-1], invPsis[0:N/2-1];
    wire [BITS-1:0] c[0:N-1];
    NTTPolyMult #(.Q(Q), .BITS(BITS), .N(N), .invN(invN))
                uut(.a(a), .b(b), .psis(psis), .invPsis(invPsis), .c(c));
    initial
    begin
    #50 a[0] <= 1; a[1] <= 2; a[2] <= 3; a[3] <= 4; a[4] <= 5; a[5] <= 6; a[6] <= 7; a[7] <= 8; psis[0] <= 1; psis[1] <= 1600; psis[2] <= 40; psis[3] <= 749; b[0] <= 1; b[1] <= 2; b[2] <= 3; b[3] <= 4; b[4] <= 5; b[5] <= 6; b[6] <= 7; b[7] <= 8; invPsis[0] <= 1; invPsis[1] <= 1729; invPsis[2] <= 2580; invPsis[3] <= 3289; 
    end
endmodule
