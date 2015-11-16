`include "packet_generator.sv"
`include "packet_driver.sv"
`include "packet_if.svi"

program tb_top;

packet_generator pkt_gen;
packet_tran_mbox gen2drv_chan;
packet_driver    pkt_drv;

initial begin
    gen2drv_chan = new(1);
    pkt_gen = new("pkt_gen", gen2drv_chan);
    pkt_drv = new("pkt_gen", gen2drv_chan, hw_top.vif);

    pkt_gen.run_for_n_insts = 10;

    pkt_gen.run();
    pkt_drv.run();

    wait(pkt_gen.done);
    $finish();
end
endprogram

