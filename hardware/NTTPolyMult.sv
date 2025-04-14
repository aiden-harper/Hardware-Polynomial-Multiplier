`timescale 1ns / 1ps
// NTTPolyMult computes c = INTT(NTT(a)*NTT(b)) for use with CRYSTALS-Kyber version 3. It is also configurable to work with different parameters.
// PARAMETERS - Q: Modulus, BITS: Bitwidth, N: Polynomial length, invN: Inverse of N    note: (invN*N)%Q=1
// Default parameters are from Kyber version 3 #(parameter Q = 3329, parameter BITS = 12, parameter N = 256, parameter invN = 3316)
// I/O - clk: universal clock, resetA: reset signal for polynomial a, resetB: reset signal for polynomial b, resetIntt: reset signal for INTT,
//       process: pointwise multiplication wait signal, serialIn: serial input wait signal, serialOut: serial output wait signal,
//       serialF: serialized input polynomial (input/output polynomials are processed 8 terms at a time), serialPsis: serialized twiddle factors,
//       serialC: serialized output polynomial
module NTTPolyMult 
            #(parameter Q = 3329, parameter BITS = 12, parameter N = 256, parameter invN = 3316)
            (input logic clk, resetA, resetB, resetIntt, process, serialIn, serialOut, [BITS-1:0] serialF[0:7], serialPsis[0:7],
             output logic [BITS-1:0] serialC[0:7]);
            // outf: output of NTT module, ahat: NTT(a), chat: (NTT(a)*NTT(b)), f: entire input polynomial, psis: twiddle factors, c: entire output polynomial
            reg [BITS-1:0] outf[0:N-1], ahat[0:N-1], chat[0:N-1], f[0:N-1], psis[0:N/2-1], c[0:N-1];
            // inCounter/outCounter: tracks where serialized input/output goes into full array, processCounter: tracks pointwise multiplication steps
            reg [$clog2(N)-1:0] inCounter = 0;
            reg [$clog2(N)-1:0] outCounter = 0;
            reg [$clog2(N)-1:0] processCounter = 0;
            // reset signal for NTT activated by resetA and resetB
            reg resetNTT = 0;
            // sequential logic
            always_ff @(posedge clk)
                begin
                if(serialIn)
                    begin
                    // gather 8 terms at a time into arrays f and psis
                    for(int j = 0; j < 8; j = j + 1)
                        begin
                        f[inCounter*8+j] = serialF[j];
                        psis[inCounter*8+j] = serialPsis[j];
                        end
                    inCounter = inCounter + 1;
                    end
                else if(serialOut && outCounter < N/8)
                    begin
                    // gather 8 terms at a time into output array serialC
                    for(int j = 0; j < 8; j = j + 1) serialC[j] = c[outCounter*8+j];
                    outCounter = outCounter + 1;
                    end
                else if(resetA)
                    begin
                    // reset NTT module to take in polynomial a arguments
                    resetNTT = 1;
                    inCounter = 0;
                    end
                else if(resetB)
                    begin
                    // store NTT(a) into ahat
                    ahat = outf;
                    // reset NTT module to take in polynomial a arguments
                    resetNTT = 1;
                    inCounter = 0;
                    end
                else if(process && (processCounter < N))
                    begin
                    // calculate pointwise multiplication chat = NTT(a)*NTT(b)      (outf contains bhat at this point)
                    chat[processCounter] = (ahat[processCounter]*outf[processCounter])%Q;
                    processCounter = processCounter + 1;
                    resetNTT = 0;
                    end
                else resetNTT = 0;
                end
            // NTT module copmutes NTT(f) using twiddle factors psis
            NTT #(.Q(Q), .BITS(BITS), .N(N)) NTTa(.f(f), .psis(psis), .fhat(outf), .clk(clk), .reset(resetNTT));
            // NTT module copmutes INTT(fhat) using inverse twiddle factors psis
            INTT #(.Q(Q), .BITS(BITS), .N(N), .invN(invN)) INTTc(.fhat(chat), .psis(psis), .f(c), .clk(clk), .reset(resetIntt));
endmodule
