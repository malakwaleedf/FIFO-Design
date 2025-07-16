module gray_encoded_sync (rst, clk_tx, clk_rx, tx_data, rx_data);
parameter WIDTH = 8;
parameter RSTTYPE = "SYNC"; //or ASYNC
input rst, clk_tx, clk_rx;
input [WIDTH-1 : 0] tx_data;
output [WIDTH-1 : 0] rx_data;

wire [WIDTH-1 : 0] tx_data_gray, rx_data_gray;
reg [WIDTH-1 : 0] tx_data_gray_reg;

binary_to_gray #(.n(WIDTH)) bin2gray (tx_data, tx_data_gray);
dff_sync_2 #(.WIDTH(WIDTH), .RSTTYPE(RSTTYPE)) dff_sync (clk_rx, rst, tx_data_gray_reg, rx_data_gray);
gray_to_binary #(.n(WIDTH)) gray2bin (rx_data_gray, rx_data);

generate
    if(RSTTYPE == "SYNC") begin
        always @(posedge clk_tx) begin
            if(rst)
                tx_data_gray_reg <= 0;
            else
                tx_data_gray_reg <= tx_data_gray;
        end
    end
    else if(RSTTYPE == "ASYNC") begin
        always @(posedge clk_tx or posedge rst) begin
            if(rst)
                tx_data_gray_reg <= 0;
            else
                tx_data_gray_reg <= tx_data_gray;
        end
    end
endgenerate

endmodule