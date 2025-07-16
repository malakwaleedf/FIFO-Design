module fifo_memory_tb;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 512;
parameter ADDRESS_SIZE = 9;
reg [FIFO_WIDTH-1 : 0] din_a;
reg wen_a, ren_b, clk_a, clk_b, rst;
wire [FIFO_WIDTH-1 : 0] dout_b;
wire full, empty;

fifo_memory dut (din_a, wen_a, ren_b, clk_a, clk_b, rst, dout_b, full, empty);

initial begin
    clk_a = 1;
    clk_b = 1;
    forever begin
        #3 clk_a = ~clk_a;
        #5 clk_b = ~clk_b;
    end
end

initial begin
    rst = 1;
    din_a = 0;
    wen_a = 0;
    ren_b = 0;
    @(negedge clk_a);
    rst = 0;
    //test write
    repeat(200) begin
        wen_a = $random();
        din_a = $random();
        @(negedge clk_a);
    end
    wen_a = 0;
    //test read
    repeat(200) begin
        ren_b = $random();
        @(negedge clk_b);
    end
    //test read and write
    wen_a = 1;
    ren_b = 1;
    repeat(1000) begin
        din_a = $random();
        wen_a = $random();
        @(negedge clk_a);
        ren_b = $random();
        @(negedge clk_b);
    end
    $writememh("mem.dat", dut.mem);
    $stop();
end

initial begin
    $monitor("din_a= %H, wen_a= %b, ren_b = %b, dout_b= %H, full= %b, empty= %b", din_a, wen_a, ren_b, dout_b, full, empty);
end
endmodule