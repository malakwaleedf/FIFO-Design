module fifo_memory (din_a, wen_a, ren_b, clk_a, clk_b, rst, dout_b, full, empty);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 512;
parameter ADDRESS_SIZE = 9;
input [FIFO_WIDTH-1 : 0] din_a;
input wen_a, ren_b, clk_a, clk_b, rst;
output reg [FIFO_WIDTH-1 : 0] dout_b;
output full, empty;

reg [FIFO_WIDTH-1 : 0] mem [FIFO_DEPTH-1 : 0];
reg [ADDRESS_SIZE : 0] wrt_ptr, rd_ptr;
wire [ADDRESS_SIZE : 0] wrt_ptr_sync, rd_ptr_sync;

gray_encoded_sync #(.WIDTH(ADDRESS_SIZE + 1)) rd_ptr_synchronizer (rst, clk_b, clk_a, rd_ptr, rd_ptr_sync); //at a
gray_encoded_sync #(.WIDTH(ADDRESS_SIZE + 1)) wrt_ptr_synchronizer (rst, clk_a, clk_b, wrt_ptr, wrt_ptr_sync); //at b

always @(posedge clk_a) begin
    if (rst) begin
        wrt_ptr <= 0;
    end
    else begin
        if(wen_a && !full) begin
            mem[wrt_ptr[ADDRESS_SIZE-1 : 0]] <= din_a;
            wrt_ptr = wrt_ptr + 1;
        end
    end
end

always @(posedge clk_b) begin
    if(rst) begin
        rd_ptr <= 0;
        dout_b <= 0;
    end
    else begin
        if(ren_b && !empty) begin
            dout_b <= mem[rd_ptr[ADDRESS_SIZE-1 : 0]];
            rd_ptr = rd_ptr + 1;
        end
    end
end

assign full = ((wrt_ptr[ADDRESS_SIZE] != rd_ptr_sync[ADDRESS_SIZE]) && (wrt_ptr[ADDRESS_SIZE-1 : 0] == rd_ptr_sync[ADDRESS_SIZE-1 : 0]))? 1 : 0;
assign empty = (wrt_ptr_sync == rd_ptr)? 1 : 0;
    
endmodule