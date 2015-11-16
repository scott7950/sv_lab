`ifndef __PACKET_DRIVER_SV__
`define __PACKET_DRIVER_SV__

`include "packet.sv"
`include "packet_define.sv"
`include "packet_if.svi"

class packet_driver;

string name;
packet_tran_mbox in_box;
virtual interface packet_if.master vif;

extern function new(string name = "packet Driver", packet_tran_mbox in_box, virtual interface packet_if.master vif);
extern task run();

endclass

function packet_driver::new(string name = "packet Driver", packet_tran_mbox in_box, virtual interface packet_if.master vif);
    this.name = name;
    this.in_box = in_box;
    this.vif = vif;
endfunction

task packet_driver::run();
    packet pkt;

    fork
        forever begin
            vif.cb.dout_valid <= 1'b0;
            in_box.get(pkt);
            pkt.display();

            @(vif.cb);
            vif.cb.dout <= pkt.sof_flag;
            vif.cb.dout_valid <= 1'b1;

            foreach (pkt.payload[i]) begin
                @(vif.cb);
                vif.cb.dout <= pkt.payload[i];
            end

            @(vif.cb);
            vif.cb.dout <= pkt.parity;

            @(vif.cb);
            vif.cb.dout <= pkt.eof_flag;
        end
    join_none
endtask

`endif


