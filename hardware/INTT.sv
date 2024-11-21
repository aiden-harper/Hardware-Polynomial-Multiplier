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


module INTT #(parameter Q = 7681, parameter BITS = 13, parameter N = 8, parameter invN = 6721)
            (input logic [BITS-1:0] fhat[0:N-1], invPsis[0:N-1], output logic [BITS-1:0] f[0:N-1]);
            wire [BITS-1:0] outf[0:$clog2(N)][0:N-1];
            assign outf[$clog2(N)] = fhat;
            generate
            for(genvar stage = $clog2(N)-1; stage >= 0; stage = stage-1)
                begin
                //(N/(2**(stage+1))) = length
                for(genvar start = 0; start < N; start = start + 2*(N/(2**(stage+1))))
                    begin
                    for(genvar j = start; j < start+(N/(2**(stage+1))); j = j + 1)
                        begin
                        GSbutterfly #(.BITS(BITS), .Q(Q))butterfly(
                                    .in0(outf[stage+1][j]),
                                    .in1(outf[stage+1][j+(N/(2**(stage+1)))]),
                                    .out0(outf[stage][j]),
                                    .out1(outf[stage][j+(N/(2**(stage+1)))]),
                                    .w(invPsis[2**stage+start/(2*N/(2**(stage+1)))]));
                        end
                    end
                end
            for(genvar i = 0; i < N; i = i + 1)
                begin
                assign f[i] = (outf[0][i]*invN)%Q;
                end
            endgenerate
endmodule