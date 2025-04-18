`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 12:22:27 AM
// Design Name: 
// Module Name: tb_NTT
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


module tb_NTT;
    reg [31:0] x0, x1, x2, x3, w0, w1;
    wire [31:0] b0, b1, b2, b3;
    NTT uut(.x0(x0), .x1(x1), .x2(x2), .x3(x3), .w0(w0), .w1(w1), .b0(b0), .b1(b1), .b2(b2), .b3(b3));
    // 1 + 2x + 3x^2 + 4x^3
    // [0, 2, 3, 4]
    initial
        begin
            #1 x0 <= 1; x1 <= 2; x2 <= 3; x3 <= 4; w0 <= 1; w1 <= 3;
            #500 x0 <= 2; x1 <= 3; x2 <= 3; x3 <= 0; w0 <= 1; w1 <= 3;
            #250 x0 <= 0; x1 <= 2; x2 <= 3; x3 <= 4; w0 <= 1; w1 <= 2;
            #50 x0 <= 3; x1 <= 3; x2 <= 2; x3 <= 0; w0 <= 1; w1 <= 2;
        end
endmodule
