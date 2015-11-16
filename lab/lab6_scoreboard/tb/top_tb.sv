`include "packet.sv"

program top_tb;

packet pkt;

initial begin
    pkt = new();
    if(!pkt.randomize()) begin
        $display("Randomize failed");
        $finish();
    end
    pkt.display();
end
endprogram

