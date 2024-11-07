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

// BITS = $ceil($clog2(Q))
// STAGES = $clog2(N)
// parameters: Q = modulo number, BITS = # bits for inputs/outputs, N = order of polynomial plus one, STAGES = # stages of butterflies
module NTT #(parameter Q = 17, parameter BITS = 16, parameter N = 256, parameter STAGES = 8)
            (input logic [BITS-1:0] in[0:N-1], w[0:STAGES-1][0:N/2-1], output logic [BITS-1:0] out[0:N-1]);
    // genvars for for generate loops below
    genvar stage, fly, counter, recursion, i, j, a, b, x, y;
    // temp wires to connect between stages
    wire [BITS-1:0] tempin[0:STAGES-1][0:N-1], tempout[0:STAGES-1][0:N-1];
    generate
    // reorder input
    for(i = 0; i < N; i = i + 1)
        begin
        // convert and assign counter i to correct bitwidth binary bits
        // also create reversed bits (stib) of same bitwidth
        logic [STAGES-1:0] bits = i, stib;
        // loop over each bit and assign reversed bits accordingly
        for(j = 0; j < STAGES; j = j + 1) assign stib[j] = bits[STAGES-j-1];
        // reassign inputs to temp wire
        assign tempin[0][i] = in[stib];
        end
    // loop over each butterfly stage
    for(stage = 0; stage < STAGES; stage = stage + 1)
        begin
        // loop for each individual butterfly
        for(fly = 0; fly < N/2; fly = fly + 1)
            begin
            // create instance of butterfly module
            butterfly #(.BITS(BITS), .Q(Q))butterfly(
                        .in0(tempin[stage][2*fly]),
                        .in1(tempin[stage][2*fly+1]),
                        .out0(tempout[stage][2*fly]),
                        .out1(tempout[stage][2*fly+1]),
                        .w(w[stage][fly]));
            end
         // reindex outputs
         // loop over each recursion
         for(recursion = 0; recursion < N/(2**(stage+2)); recursion = recursion + 1)
            begin
            //loop over each input for each recursion
            for(a = 0; a < (2**(stage+2)); a = a + 1)
                begin
                // convert and assign counter a to correct bitwidth binary bits
                // also create reversed bits (stib) of same bitwidth
                logic [stage+1:0] bits = a, stib;
                // loop over each bit and assign reversed bits accordingly
                for(b = 0; b < stage+2; b = b + 1) assign stib[b] = bits[stage+1-b];
                // reassign inputs to temp wire
                assign tempin[stage+1][a+recursion*(2**(stage+2))] = tempout[stage][stib+recursion*(2**(stage+2))];
                end
            end
        end
        endgenerate
        // assign the final output to the sorted output of the last stage (which is the last tempin)
        // reorder output
        for(x = 0; x < N; x = x + 1)
            begin
            // convert and assign counter i to correct bitwidth binary bits
            // also create reversed bits (stib) of same bitwidth
            logic [STAGES-1:0] bits = x, stib;
            // loop over each bit and assign reversed bits accordingly
            for(y = 0; y < STAGES; y = y + 1) assign stib[y] = bits[STAGES-y-1];
            // reassign inputs to temp wire
            assign out[x] = tempout[STAGES-1][stib];
            end
endmodule