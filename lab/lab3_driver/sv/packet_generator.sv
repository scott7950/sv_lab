`ifndef __PACKET_GENERATOR_SV__
`define __PACKET_GENERATOR_SV__

`include "packet.sv"
`include "packet_define.sv"

class packet_generator;

string name;
packet_tran_mbox out_box;
int run_for_n_insts = 0;
packet pkt;
event done;

extern function new(string name = "Packet Generator", packet_tran_mbox out_box);
extern task run();

endclass

function packet_generator::new(string name = "Packet Generator", packet_tran_mbox out_box);
    this.name = name;
    this.out_box = out_box;
endfunction

task packet_generator::run();
    pkt = new("pkt");
    fork
        begin
            for(int i=0; i<run_for_n_insts; i++) begin
                packet pkt_cp = new pkt;

                if(!pkt_cp.randomize()) begin
                    $display("Error to randomize pkt_cp");
                    $finish();
                end

                pkt_cp.display("packet_generator");

                out_box.put(pkt_cp);
            end
            ->done;
        end
    join_none
endtask

`endif

