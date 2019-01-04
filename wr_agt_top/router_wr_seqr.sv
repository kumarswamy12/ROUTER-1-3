class router_wr_seqr extends uvm_sequencer #(write_xtn);
`uvm_component_utils(router_wr_seqr);
extern function new(string name="W_SEQR",uvm_component parent);
endclass

function router_wr_seqr::new(string name="W_SEQR",uvm_component parent);
	super.new(name,parent);
endfunction
