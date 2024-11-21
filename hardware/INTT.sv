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

// Inverse Number Theoretic Transfrom for Kyber version 2 based on bit reversed input, normal output Gentleman-Sande butterfly
// PARAMETERS - Q: Modulus, BITS: Bitwidth, N: Polynomial length, invN: Inverse of N    note: (invN*N)%Q=1
module INTT #(parameter Q = 7681, parameter BITS = 13, parameter N = 256, parameter invN = 256)
            (input logic [BITS-1:0] fhat[0:N-1], invPsis[0:N-1], output logic [BITS-1:0] f[0:N-1]);
            // outf wires connect between the butterfly stages
            // $clog2(N) = stages
            wire [BITS-1:0] outf[0:$clog2(N)][0:N-1];
            // Assign the last outf to input polynomial fhat
            assign outf[$clog2(N)] = fhat;
            // Itteratively generate the INTT
            generate
            // Loop over each stage in reverse order
            for(genvar stage = $clog2(N)-1; stage >= 0; stage = stage-1)
                begin
                //(N/(2**(stage+1))) = length (distance between even and odd inputs for the butterflies, depends on grouping)
                // start represents the beginning of butterfly group (start = start + 2*length)
                // Loop over each butterfly grouping
                for(genvar start = 0; start < N; start = start + 2*(N/(2**(stage+1))))
                    begin
                    // Loop over inputs for current butterfly grouping (j is current input index)
                    for(genvar j = start; j < start+(N/(2**(stage+1))); j = j + 1)
                        begin
                        // Cooley-Tukey butterfly with inputs/outputs j (even) and j+length (odd)
                        // The input invPsis are preprocessed in the correct complicated order
                        // start/(2*N/(2**(stage+1))) = start/2*length (this counts which butterfly group is being processed)
                        GSbutterfly #(.BITS(BITS), .Q(Q))butterfly(
                                    .in0(outf[stage+1][j]),
                                    .in1(outf[stage+1][j+(N/(2**(stage+1)))]),
                                    .out0(outf[stage][j]),
                                    .out1(outf[stage][j+(N/(2**(stage+1)))]),
                                    .w(invPsis[2**stage+start/(2*N/(2**(stage+1)))]));
                        end
                    end
                end
            // Finally, scale the last round of outputs based on the inverse of N and assign to output polynomial f
            for(genvar i = 0; i < N; i = i + 1)
                begin
                assign f[i] = (outf[0][i]*invN)%Q;
                end
            endgenerate
endmodule