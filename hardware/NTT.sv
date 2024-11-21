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

// Forward Number Theoretic Transfrom for Kyber version 2 based on normal input, bit reversed output Cooley-Tukey butterfly
module NTT #(parameter Q = 7681, parameter BITS = 13, parameter N = 256)
            (input logic [BITS-1:0] f[0:N-1], psis[0:N-1], output logic [BITS-1:0] fhat[0:N-1]);
            // outf wires connect between the butterfly stages
            // $clog2(N) = stages
            wire [BITS-1:0] outf[0:$clog2(N)][0:N-1];
            // Assign the first outf to input polynomial f
            assign outf[0] = f;
            // Itteratively generate the NTT
            generate
            // Loop over each stage
            for(genvar stage = 0; stage < $clog2(N); stage = stage+1)
                begin
                //(N/(2**(stage+1))) = length (distance between even and odd inputs for the butterflies)
                // start represents the beginning of butterfly group (start = start + 2*length)
                for(genvar start = 0; start < N; start = start + 2*(N/(2**(stage+1))))
                    begin
                    for(genvar j = start; j < start+(N/(2**(stage+1))); j = j + 1)
                        begin
                        CTbutterfly #(.BITS(BITS), .Q(Q))butterfly(
                                    .in0(outf[stage][j]),
                                    .in1(outf[stage][j+(N/(2**(stage+1)))]),
                                    .out0(outf[stage+1][j]),
                                    .out1(outf[stage+1][j+(N/(2**(stage+1)))]),
                                    .w(psis[2**stage+start/(2*N/(2**(stage+1)))]));
                        end
                    end
                end
            endgenerate
            assign fhat = outf[$clog2(N)];
endmodule