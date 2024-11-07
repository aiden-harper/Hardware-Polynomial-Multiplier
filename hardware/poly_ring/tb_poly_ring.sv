`timescale 1ns/1ps

module tb_poly_ring;
    parameter integer N = 8;
    parameter integer Q = 13;

    reg [$clog2(Q)-1:0] a [N-1:0];
    reg [$clog2(Q)-1:0] b [N-1:0];
    reg [$clog2(Q)-1:0] c [N*2-2:0];
    reg [$clog2(Q)-1:0] result [N-1:0];

    convolve #(.N(N)) conv (
        .a(a),
        .b(b),
        .c(c)
    );
    
    negacyclic_conv #(.N(N)) deconv (
        .c(c),
        .remainder(result)
    );

    initial begin
        a = {8'd9, 8'd4, 8'd10, 8'd12, 8'd6, 8'd6, 8'd12, 8'd9};
        b = {8'd2, 8'd1, 8'd6, 8'd4, 8'd3, 8'd11, 8'd10, 8'd7};
    end
endmodule
