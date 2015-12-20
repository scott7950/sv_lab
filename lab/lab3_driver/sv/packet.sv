`ifndef __PACKET_SV__
`define __PACKET_SV__

class packet;

string name;

typedef enum {GOOD_SOF_FLAG, BAD_SOF_FLAG} sof_flag_type_enum;
typedef enum {GOOD_PARITY, BAD_PARITY} parity_type_enum;
typedef enum {GOOD_EOF_FLAG, BAD_EOF_FLAG} eof_flag_type_enum;

rand sof_flag_type_enum sof_flag_type;
rand parity_type_enum parity_type;
rand eof_flag_type_enum eof_flag_type;
rand int length;

rand bit [7:0] sof_flag;
rand bit [7:0] payload [];
rand bit [7:0] parity;
rand bit [7:0] eof_flag;
rand int delay[];

constraint c_length {length >= 1; length <= 63;}
constraint c_payload {
    solve length before payload;
    payload.size() == length;
}
constraint c_sof_flag {
    sof_flag_type == GOOD_SOF_FLAG -> sof_flag == 8'h7e;
    sof_flag_type == BAD_SOF_FLAG -> sof_flag != 8'h7e;
}
constraint c_eof_flag {
    eof_flag_type == GOOD_EOF_FLAG -> eof_flag == 8'h7f;
    eof_flag_type == BAD_EOF_FLAG -> eof_flag != 8'h7f;
}

constraint c_delay_size {
    delay.size() == length + 3;
    foreach(delay[i]) {
        delay[i] inside {[0:1000000]};
    }
}

function new(string name = "packet");
    this.name = name;
endfunction

function void pack(ref byte tx_stream[] );
    bit [7:0] data[$];

    data.push_back(sof_flag);
    foreach(payload[i]) begin
        data.push_back(payload[i]);
    end
    data.push_back(parity);
    data.push_back(eof_flag);

    tx_stream = new[data.size()];
    foreach(data[i]) begin
        tx_stream[i] = data[i];
    end
endfunction

//function void bit_stuff();
//    bit [7:0] data[$];
//
//    foreach(payload[i]) begin
//    end
//endfunction

function void display(string prefix = "");
    $display("Packet %s:", prefix);
    $display("========================================================");
    $display("    sof_flag_type : %s", sof_flag_type.name());
    $display("    parity_type   : %s", parity_type.name());
    $display("    eof_flag_type : %s", eof_flag_type.name());

    $display("    length        : %d", length);
    $display("    sof_flag      : %h", sof_flag);
    foreach (payload[i]) begin
        $display("        payload[%3d] = %h", i, payload[i]);
    end
    $display("    parity   : %h", parity);
    $display("    eof_flag : %h", eof_flag);
    $display("========================================================");
endfunction

endclass

`endif

