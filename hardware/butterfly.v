`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 01:51:25 PM
// Design Name: 
// Module Name: butterfly
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


module butterfly #(
    parameter integer BITS = 32,
    parameter integer Q    = 5
)(
    input  wire [BITS-1:0] x0,
    input  wire [BITS-1:0] x1,
    input  wire [BITS-1:0] w,
    output reg  [BITS-1:0] a0,
    output reg  [BITS-1:0] a1
);

    
    wire [BITS-1:0] prod0;
    wire [BITS-1:0] prod1;
    // inverted weight = Q - w
    wire [BITS-1:0] w_inv;
    assign w_inv = Q - w;

    
    dadda_mult #(
        .WIDTH(BITS),
        .Q(Q)
    ) mul0 (
        .a(w),
        .b(x1),
        .product_mod_q(prod0)
    );

    dadda_mult #(
        .WIDTH(BITS),
        .Q(Q)
    ) mul1 (
        .a(w_inv),
        .b(x1),
        .product_mod_q(prod1)
    );

    
    always @* begin
        a0 <= (x0 + prod0) % Q;
        a1 <= (x0 + prod1) % Q;
    end

endmodule

