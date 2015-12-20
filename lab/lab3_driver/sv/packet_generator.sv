`ifndef __PACKET_GENERATOR_SV__
`define __PACKET_GENERATOR_SV__

`include "packet.sv"
`include "packet_define.sv"

class packet_generator;

string name;
packet_tran_mbox out_chan;
int run_for_n_insts = 0;
packet pkt;
event done;

extern function new(string name = "Packet Generator", packet_tran_mbox out_chan);
extern task run();

endclass

function packet_generator::new(string name = "Packet Generator", packet_tran_mbox out_chan);
    this.name = name;
    this.out_chan = out_chan;
endfunction

task packet_generator::run();
    packet pkt_cp;
    pkt = new("pkt");

    fork
        begin
            for(int i=0; i<run_for_n_insts; i++) begin
                if(!pkt.randomize()) begin
                    $display("Error to randomize pkt");
                    $finish();
                end

                pkt_cp = new pkt;

                pkt_cp.display("packet_generator");

                out_chan.put(pkt_cp);
            end
            ->done;
        end
    join_none
endtask

`endif

