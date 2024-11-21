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
    parameter BITS = 13, N = 8, Q = 7681, invN = 6721;
    reg [BITS-1:0] f[0:N-1], psis[0:N-1];
    wire [BITS-1:0] fhat[0:N-1];
    INTT uut(.fhat(f), .invPsis(psis), .f(fhat));
    initial
    begin
    // input: 2182x^0 + 5766x^1 + 4218x^2 + 4669x^3 + 2324x^4 + 6216x^5 + 1179x^6 + 4178x^7
	#50 f[0] <= 2182; f[1] <= 5766; f[2] <= 4218; f[3] <= 4669; f[4] <= 2324; f[5] <= 6216; f[6] <= 1179; f[7] <= 4178; psis[0] <= 1; psis[1] <= 3383; psis[2] <= 1925; psis[3] <= 6468; psis[4] <= 583; psis[5] <= 5953; psis[6] <= 849; psis[7] <= 7154;
	end
endmodule