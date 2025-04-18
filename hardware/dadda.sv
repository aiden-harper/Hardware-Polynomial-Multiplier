`timescale 1ns / 1ps
module dadda_mult #
(
    parameter WIDTH = 12,
    parameter Q     = 3329
)
(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] product_mod_q
);
    logic [2*WIDTH-1:0] partials [0:WIDTH-1];
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign partials[i] = b[i] ? (a << i) : '0;
        end
    endgenerate

    logic [2*WIDTH-1:0] sum   [0:WIDTH-2];
    logic [2*WIDTH-1:0] carry [0:WIDTH-2];

    assign sum[0]   = partials[0] ^ partials[1];
    assign carry[0] = (partials[0] & partials[1]) << 1;

    genvar j;
    generate
        for (j = 1; j < WIDTH-1; j = j + 1) begin : REDUCE
            assign sum[j]   = sum[j-1] ^ partials[j+1] ^ carry[j-1];
            assign carry[j] = ((sum[j-1] & partials[j+1])
                             | (sum[j-1] & carry[j-1])
                             | (partials[j+1] & carry[j-1]))
                             << 1;
        end
    endgenerate

    logic [2*WIDTH-1:0] full_product;
    assign full_product = sum[WIDTH-2] + carry[WIDTH-2];

    assign product_mod_q = full_product % Q;
endmodule
