`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/17 01:45:00
// Design Name: 
// Module Name: NTTPolyMult
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: NTTPolyMult computes c = INTT(NTT(a)*NTT(b)) for CRYSTALS-Kyber v3,
// integrating Dadda multiplier (dadda_mult) for all modular multiplications.
// PARAMETERS - Q: Modulus, BITS: Bitwidth, N: Polynomial length, invN: Inverse of N (invN*N % Q == 1)
//////////////////////////////////////////////////////////////////////////////////

module NTTPolyMult #(
    parameter Q    = 3329,
    parameter BITS = 12,
    parameter N    = 256,
    parameter invN = 3316
)(
    input  logic                 clk,
    input  logic                 resetA,
    input  logic                 resetB,
    input  logic                 resetIntt,
    input  logic                 process,
    input  logic                 serialIn,
    input  logic                 serialOut,
    input  logic [BITS-1:0]      serialF  [0:7],
    input  logic [BITS-1:0]      serialPsis[0:7],
    output logic [BITS-1:0]      serialC  [0:7]
);

    // Full arrays for NTT/INTT
    reg  [BITS-1:0] outf   [0:N-1];
    reg  [BITS-1:0] ahat   [0:N-1];
    reg  [BITS-1:0] chat   [0:N-1];
    reg  [BITS-1:0] f      [0:N-1];
    reg  [BITS-1:0] psis   [0:N/2-1];
    reg  [BITS-1:0] c      [0:N-1];

    // Serial counters
    reg [$clog2(N)-1:0] inCounter      = 0;
    reg [$clog2(N)-1:0] outCounter     = 0;
    reg [$clog2(N)-1:0] processCounter = 0;

    // NTT reset control
    reg resetNTT = 0;

    // Wires for Dadda-based pointwise multiplication
    wire [BITS-1:0] chat_wire [0:N-1];
    genvar k;
    generate
        for (k = 0; k < N; k = k + 1) begin: CHAT_MUL
            dadda_mult #(
                .WIDTH(BITS),
                .Q(Q)
            ) chat_mul (
                .a(ahat[k]),
                .b(outf[k]),
                .product_mod_q(chat_wire[k])
            );
        end
    endgenerate

    // Sequential logic
    always_ff @(posedge clk) begin
        if (serialIn) begin
            // Gather 8 terms into f and psis
            for (int j = 0; j < 8; j = j + 1) begin
                f[inCounter*8 + j]    = serialF[j];
                psis[inCounter*8 + j] = serialPsis[j];
            end
            inCounter = inCounter + 1;
        end else if (serialOut && outCounter < N/8) begin
            // Output 8 terms from c
            for (int j = 0; j < 8; j = j + 1)
                serialC[j] = c[outCounter*8 + j];
            outCounter = outCounter + 1;
        end else if (resetA) begin
            // Begin NTT for polynomial a
            resetNTT  = 1;
            inCounter = 0;
        end else if (resetB) begin
            // Save NTT(a) and begin NTT for b
            ahat      = outf;
            resetNTT  = 1;
            inCounter = 0;
        end else if (process && (processCounter < N)) begin
            // Pointwise multiply using Dadda multiplier
            chat[processCounter] = chat_wire[processCounter];
            processCounter = processCounter + 1;
            resetNTT      = 0;
        end else begin
            resetNTT = 0;
        end
    end

    // Instantiate NTT and INTT modules
    NTT  #(.Q(Q),    .BITS(BITS), .N(N))    NTTa (.clk(clk), .reset(resetNTT),  .f(f),    .psis(psis), .fhat(outf));
    INTT #(.Q(Q),    .BITS(BITS), .N(N),     .invN(invN)) INTTc(.clk(clk), .reset(resetIntt), .fhat(chat), .psis(psis), .f(c));

    // Serialize c back to serialC is handled in sequential block
endmodule
