module binary_to_gray (bin, gray);
    parameter n = 4;
    input [n-1 : 0] bin;
    output [n-1 : 0] gray;

    genvar i;

    generate
        for(i = n-2; i >= 0; i = i - 1) 
            assign gray[i] = bin[i+1] ^ bin[i];
    endgenerate

    
    assign gray[n-1] = bin [n-1];

endmodule

module gray_to_binary (gray, bin);
    parameter n = 4;
    input [n-1 : 0] gray;
    output [n-1 : 0] bin;

    genvar i;

    generate
        for(i = n-2; i >= 0; i = i - 1) 
            assign bin[i] = bin[i+1] ^ gray[i];
    endgenerate

    assign bin[n-1] = gray[n-1];
    
endmodule