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
// Inverse Number Theoretic Transform for Kyber version 3 based on bit-reversed input,
// normal output Gentleman-Sande butterfly, integrating Dadda multiplier for modular
// multiplications.
// Dependencies: dadda_mult
//
// Revision:
// Revision 0.02 - Integrated Dadda multiplier
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module INTT #(
    parameter Q     = 3329,
    parameter BITS  = 12,
    parameter N     = 8,
    parameter invN  = 2913    // invN*N % Q == 1
)(
    input  logic                 clk,
    input  logic                 reset,
    input  logic [BITS-1:0]      fhat [0:N-1],
    input  logic [BITS-1:0]      psis [0:N/2-1],
    output logic [BITS-1:0]      f    [0:N-1]
);

    // State and index registers
    reg [$clog2(N):0]            start;
    reg [$clog2(N):0]            length;
    reg [BITS-1:0]               inf    [0:N-1];
    reg [$clog2(N)-1:0]          omegaj;
    reg [$clog2(N)-1:0]          j;

    // Intermediate signals for Dadda multiplications
    logic [BITS-1:0]             sum_bs;         // sum for f[j]
    logic [BITS-1:0]             diff_bs;        // input to butterfly multiply
    logic [BITS-1:0]             prod_bs;        // butterfly multiply output
    logic [BITS-1:0]             prod_invN_j;    // invN * f[j]
    logic [BITS-1:0]             prod_invN_jl;   // invN * f[j+length]

    // Compute combinational values
    assign sum_bs  = (inf[j] + inf[j+length]) % Q;
    assign diff_bs = (inf[j] + (Q - inf[j+length])) % Q;

    // Instantiate Dadda multipliers
    // Butterfly multiplication: diff_bs * psis[omegaj]
    dadda_mult #(
        .WIDTH(BITS),
        .Q(Q)
    ) bs_mul (
        .a(diff_bs),
        .b(psis[omegaj]),
        .product_mod_q(prod_bs)
    );

    // invN multipliers
    dadda_mult #(
        .WIDTH(BITS),
        .Q(Q)
    ) invN_mul_j (
        .a(sum_bs),
        .b(invN),
        .product_mod_q(prod_invN_j)
    );

    dadda_mult #(
        .WIDTH(BITS),
        .Q(Q)
    ) invN_mul_jl (
        .a(prod_bs),
        .b(invN),
        .product_mod_q(prod_invN_jl)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            // Initialize on reset
            inf    <= fhat;
            length <= 1;
            start  <= 0;
            j      <= 0;
            omegaj <= 0;
        end else if (length <= N/2) begin
            // Gentleman-Sande butterfly with modular multiplication
            f[j]          = sum_bs;
            f[j+length]   = prod_bs;

            // Apply invN scaling at the final stage
            if (length == N/2) begin
                f[j]        = prod_invN_j;
                f[j+length] = prod_invN_jl;
            end

            // Update indices
            j = j + 1;
            if (j >= start + length) begin
                start  = start + length*2;
                omegaj = omegaj + 1;
                j      = start;
            end

            // Move to next stage
            if (start >= N) begin
                start  = 0;
                j      = 0;
                length = length * 2;
                omegaj = 0;
                inf    = f;
            end
        end
    end

endmodule
