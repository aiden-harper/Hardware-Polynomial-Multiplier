module negacyclic_conv #(parameter integer N = 8, parameter Q = 13)
                 (input wire [$clog2(Q)-1:0] c [N*2-2:0],
                  output reg [$clog2(Q)-1:0] remainder [N-1:0]);
    integer i;

    reg [$clog2(Q)-1:0] poly [N*2-2:0];
    
    always @* begin
        for (i = 0; i < N*2-1; i = i + 1) begin
            poly[i] = c[i];
        end

        for (i = N; i < N*2-1; i = i + 1) begin
            poly[i - N] = (poly[i - N] - poly[i] + Q) % Q;
            poly[i] = 0;
        end

        for (i = 0; i < N; i = i + 1) begin
            remainder[i] = poly[i];
        end
    end
endmodule