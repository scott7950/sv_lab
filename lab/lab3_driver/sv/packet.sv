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

rand logic [7:0] sof_flag;
rand logic [7:0] payload [];
rand logic [7:0] parity;
rand logic [7:0] eof_flag;

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

function new(string name = "packet");
    this.name = name;
endfunction

function void display(string prefix = "");
    $display("Packet %s:", prefix);
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
endfunction

endclass

`endif

