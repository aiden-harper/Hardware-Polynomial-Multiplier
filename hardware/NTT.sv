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
// Forward Number Theoretic Transform for Kyber version 3 based on normal input, bit-reversed output Cooley-Tukey butterfly
// This version integrates the Dadda multiplier (dadda_mult) for efficient modular multiplications.
// Dependencies: dadda_mult
//
// Revision:
// Revision 0.02 - Integrated Dadda multiplier
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module NTT #(
    parameter Q    = 3329,
    parameter BITS = 12,
    parameter N    = 256
)(
    input  logic                 clk,
    input  logic                 reset,
    input  logic [BITS-1:0]      f    [0:N-1],
    input  logic [BITS-1:0]      psis [0:N/2-1],
    output logic [BITS-1:0]      fhat [0:N-1]
);

    // State and index registers
    reg [$clog2(N):0]           start;
    reg [$clog2(N)-1:0]         length;
    reg [BITS-1:0]              inf   [0:N-1];
    reg [$clog2(N)-1:0]         omegaj;
    reg [$clog2(N)-1:0]         j;

    // Wires for Dadda multiplier outputs
    logic [BITS-1:0]            prod_psis_inf;
    logic [BITS-1:0]            prod_inv_psis_inf;
    logic [BITS-1:0]            inv_psi;

    // Compute inverse psi factor
    assign inv_psi = Q - psis[omegaj];

    // Instantiate Dadda multipliers for modular multiplication
    dadda_mult #(
        .WIDTH(BITS),
        .Q(Q)
    ) dadda0 (
        .a(inf[j + length]),
        .b(psis[omegaj]),
        .product_mod_q(prod_psis_inf)
    );

    dadda_mult #(
        .WIDTH(BITS),
        .Q(Q)
    ) dadda1 (
        .a(inf[j + length]),
        .b(inv_psi),
        .product_mod_q(prod_inv_psis_inf)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            // Initialize registers on reset
            inf    <= f;
            length <= N/2;
            start  <= 0;
            j      <= 0;
            omegaj <= 0;
        end else if (length >= 1) begin
            // Cooley-Tukey butterfly using Dadda multiplier outputs
            fhat[j]         = (inf[j] + prod_psis_inf) % Q;
            fhat[j + length] = (inf[j] + prod_inv_psis_inf) % Q;

            // Increment index
            j = j + 1;
            if (j >= start + length) begin
                start  = start + length*2;
                omegaj = omegaj + 1;
                j      = start;
            end

            // Move to next stage when group done
            if (start >= N) begin
                start  = 0;
                j      = 0;
                length = length / 2;
                omegaj = 0;
                inf    = fhat;
            end
        end
    end

endmodule
