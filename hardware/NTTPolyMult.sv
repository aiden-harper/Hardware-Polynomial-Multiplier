`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 06:50:31 PM
// Design Name: 
// Module Name: NTTPolyMult
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

// NTTPolyMult takes two coeffecient representations of polynomials and twiddle factors (normal and inverse) as input and uses the 
// Kyber version 2 NTT to multiply them.
// PARAMETERS - Q: Modulus, BITS: Bitwidth, N: Polynomial length, invN: Inverse of N    note: (invN*N)%Q=1
module NTTPolyMult #(parameter Q = 7681, parameter BITS = 13, parameter N = 256, parameter invN = 7651)
            (input logic [BITS-1:0] a[0:N-1], b[0:N-1], psis[0:N-1], invPsis[0:N-1], output logic [BITS-1:0] c[0:N-1]);
            // Wires to connect between modules
            wire [BITS-1:0] ahat[0:N-1], bhat[0:N-1], chat[0:N-1];
            // Use NTT to find ahat = NTT(a)
            NTT #(.Q(Q), .BITS(BITS), .N(N)) NTTa(.f(a), .psis(psis), .fhat(ahat));
            // Use NTT to find bhat = NTT(b)
            NTT #(.Q(Q), .BITS(BITS), .N(N)) NTTb(.f(b), .psis(psis), .fhat(bhat));
            // Generate loop to pointwise multiply value representation polynomials
            generate
            for(genvar i = 0; i < N; i = i + 1)
                begin
                assign chat[i] = (ahat[i]*bhat[i])%Q;
                end
            endgenerate
            // Finally, use INTT to convert result back to time domain (c = INTT(chat))
            INTT #(.Q(Q), .BITS(BITS), .N(N), .invN(invN)) INTTc(.fhat(chat), .invPsis(invPsis), .f(c));
endmodule
