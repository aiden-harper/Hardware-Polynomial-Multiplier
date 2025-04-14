`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:37:46 PM
// Design Name: 
// Module Name: INTT
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

// Inverse Number Theoretic Transfrom for Kyber version 3 based on bit reversed input, normal output Gentleman-Sande butterfly
// PARAMETERS - Q: Modulus, BITS: Bitwidth, N: Polynomial length, invN: Inverse of N    note: (invN*N)%Q=1
module INTT #(parameter Q = 3329, parameter BITS = 12, parameter N = 8, parameter invN = 2913)
            (input logic clk, reset, [BITS-1:0] fhat[0:N-1], psis[0:N/2-1],
             output logic [BITS-1:0] f[0:N-1]);
            // $clog2(N) = stages
            reg [$clog2(N):0] start;
            reg [$clog2(N):0] length;
            reg [BITS-1:0] inf[0:N-1];
            reg [$clog2(N)-1:0] omegaj;
            reg [$clog2(N)-1:0] j;
            
            always_ff @(posedge clk)
                begin
                if(reset)
                    begin
                    // reset so initialize inf register
                    inf <= fhat;
                    // length determines how far the inputs of the butterfly unit are from each other
                    length <= 1;
                    // start determines which groups are being processed
                    start <= 0;
                    j <= 0;
                    omegaj <= 0;
                    end
                else if(length <= N/2)
                    begin
                    // Gentleman-Sande butterfly
                    f[j] = (inf[j] + inf[j+length])%Q;
                    f[j+length] = ((inf[j]+(Q-inf[j+length]))*psis[omegaj])%Q;
                    if(length == N/2)
                        begin
                        f[j] = (f[j]*invN)%Q;
                        f[j+length] = (f[j+length]*invN)%Q;
                        end
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
                        length = length*2;
                        omegaj = 0;
                        inf = f;
                        end
                    end
                end
endmodule