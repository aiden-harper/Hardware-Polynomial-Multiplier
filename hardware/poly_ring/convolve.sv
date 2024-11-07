module convolve #(parameter integer N = 8, parameter Q = 13)
                 (input wire [$clog2(Q)-1:0] a [N-1:0],
                  input wire [$clog2(Q)-1:0] b [N-1:0],
                  output reg [$clog2(Q)-1:0] c [N*2-2:0]);
    
    integer i;
    integer j;
        
    always @* begin
        for (i = 0; i < N*2-1; i = i + 1) begin
            c[i] = 0;
            for (j = 0; j < N; j = j + 1) begin
                if (i-j >= 0 && i-j < N) begin
                    c[i] = (c[i] + a[j] * b[i-j]) % Q;
                end
            end
        end
    end
endmodule