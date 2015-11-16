`include "packet_if.svi"

module hw_top;

reg clk;
reg rst_n;

packet_if vif(clk, rst_n);

initial begin
    rst_n = 1'b1;
    #10;
    rst_n = 1'b0;
    #10;
    rst_n = 1'b1;
end

initial begin
    clk = 1'b0;
    forever #5 clk =~ clk;
end

endmodule

