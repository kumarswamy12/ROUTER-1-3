class router_rd_seq  extends uvm_sequence #(read_xtn);
`uvm_object_utils(router_rd_seq);
extern function new(string name="R_SEQ");
extern task body;
endclass

function router_rd_seq::new(string name="R_SEQ_c1");
	super.new(name);
endfunction

class router_rd_seq_c1  extends uvm_sequence #(read_xtn);
`uvm_object_utils(router_rd_seq_c1);
extern function new(string name="R_SEQ_c1");
extern task body;
endclass

function router_rd_seq_c1::new(string name="R_SEQ_c1");
	super.new(name);
endfunction


task router_rd_seq_c1::body;
	req=read_xtn::type_id::create("R_REQ_c1");
	start_item(req);
	assert(req.randomize);
	finish_item(req);
endtask
