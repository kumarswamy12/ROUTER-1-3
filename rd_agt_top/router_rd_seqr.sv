class router_rd_seqr extends uvm_sequencer #(read_xtn);
`uvm_component_utils(router_rd_seqr);
extern function new(string name="R_SEQR",uvm_component parent);
endclass

function router_rd_seqr::new(string name="R_SEQR",uvm_component parent);
	super.new(name,parent);
endfunction
