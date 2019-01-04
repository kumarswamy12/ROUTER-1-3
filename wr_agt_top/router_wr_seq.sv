class router_wr_seq extends uvm_sequence #(write_xtn);
`uvm_object_utils(router_wr_seq);
extern function new(string name="W_SEQ");
endclass

function router_wr_seq::new(string name="W_SEQ");
	super.new(name);
endfunction


class router_wr_seq_c1 extends router_wr_seq;
`uvm_object_utils(router_wr_seq_c1);
extern function new(string name="W_SEQ_c1");
extern task body;
endclass

function router_wr_seq_c1::new(string name ="W_SEQ_c1");
	super.new(name);
endfunction



task router_wr_seq_c1::body;
	req=write_xtn::type_id::create("W_REQ");
	start_item(req);
	assert(req.randomize with {header[7:2]==10;});
	finish_item(req);
endtask
