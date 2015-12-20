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
extern task reset();

endclass

function packet_driver::new(string name = "packet Driver", packet_tran_mbox in_box, virtual interface packet_if.master vif);
    this.name = name;
    this.in_box = in_box;
    this.vif = vif;
endfunction

task packet_driver::run();
    packet pkt;
    byte tx_stream[];

    vif.pkt_phase_value = -1;
    vif.uart_phase_value = -1;
    reset();

    fork
        forever begin
            in_box.get(pkt);
            pkt.display("packet_driver");

            pkt.pack(tx_stream);

            foreach(tx_stream[i]) begin
                if(i==0) begin
                    vif.pkt_phase_value = 0;
                end else if(i == tx_stream.size()-1) begin
                    vif.pkt_phase_value = 3;
                end else if(i == tx_stream.size()-2) begin
                    vif.pkt_phase_value = 2;
                end else begin
                    vif.pkt_phase_value = 1;
                end

                // start bit
                vif.uart_phase_value = 0;
                vif.tx = 1'b0;
                #104166ns;

                // each byte content
                vif.uart_phase_value = 1;
                foreach(tx_stream[i][j]) begin
                    vif.tx = tx_stream[i][j];
                    #104166ns;
                end

                // stop bit
                vif.uart_phase_value = 2;
                vif.tx = 1'b1;
                #104166ns;

                vif.uart_phase_value = -1;
                #(pkt.delay[i] * 1ns);
            end

            vif.pkt_phase_value = -1;

        end
    join_none
endtask

task packet_driver::reset();
    vif.tx = 1'b1;
    #(104166 * 10ns);
endtask

`endif

