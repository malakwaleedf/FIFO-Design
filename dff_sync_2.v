module dff_sync_2 (clk, rst, in, out);
parameter WIDTH = 1;
parameter RSTTYPE = "SYNC"; //or ASYNC
input clk, rst;
input [WIDTH-1 : 0] in;
output reg [WIDTH-1 : 0] out;

reg [WIDTH-1 : 0] q;

generate
    if(RSTTYPE == "SYNC") begin
        always @(posedge clk) begin
            if(rst) begin
                q <= 0;
                out <= 0;
            end
            else begin
                q <= in;
                out <= q;
            end
        end
    end
    else if(RSTTYPE == "ASYNC") begin
        always @(posedge clk or posedge rst) begin
            if(rst) begin
                q <= 0;
                out <= 0;
            end
            else begin
                q <= in;
                out <= q;
            end
        end
    end
endgenerate

endmodule