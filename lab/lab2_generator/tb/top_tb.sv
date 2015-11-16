`include "packet_generator.sv"

program top_tb;

packet_generator pkt_gen;
packet_tran_mbox gen2drv_chan;

initial begin
    pkt_gen = new("pkt_gen", gen2drv_chan);
    pkt_gen.run_for_n_insts = 10;
    pkt_gen.run();
    wait(pkt_gen.done);
    $finish();
end
endprogram

