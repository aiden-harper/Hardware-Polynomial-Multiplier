`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 04:47:23 PM
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

// Forward Number Theoretic Transfrom for Kyber version 3 based on normal input, bit reversed output Cooley-Tukey butterfly
// PARAMETERS - Q: Modulus, BITS: Bitwidth, N: Polynomial length
module NTT #(parameter Q = 3329, parameter BITS = 12, parameter N = 256)
            (input logic clk, reset, [BITS-1:0] f[0:N-1], psis[0:N/2-1],
             output logic [BITS-1:0] fhat[0:N-1]);
            // $clog2(N) = stages
            reg [$clog2(N):0] start;
            reg [$clog2(N)-1:0] length;
            reg [BITS-1:0] inf[0:N-1];
            reg [$clog2(N)-1:0] omegaj;
            reg [$clog2(N)-1:0] j;
            
            always_ff @(posedge clk)
                begin
                if(reset)
                    begin
                    // reset so initialize inf register
                    inf <= f;
                    // length determines how far the inputs of the butterfly unit are from each other
                    length <= N/2;
                    // start determines which groups are being processed
                    start <= 0;
                    j <= 0;
                    omegaj <= 0;
                    end
                else if(length >= 1)
                    begin
                    // Cooley-Tukey butterfly
                    fhat[j] = (inf[j] + psis[omegaj]*inf[j+length])%Q;
                    fhat[j+length] = (inf[j] + (Q-psis[omegaj])*inf[j+length])%Q;
                    j = j + 1;
                    if(j >= start + length) 
                        begin
                        start = start + length*2;
                        omegaj = omegaj + 1;
                        j = start;
                        end
                    if(start >= N)
                        begin
                        start = 0;
                        j = 0;
                        length = length/2;
                        omegaj = 0;
                        inf = fhat;
                        end
                    end
                end
endmodule