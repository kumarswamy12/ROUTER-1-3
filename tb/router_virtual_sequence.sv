class router_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
`uvm_object_utils(router_virtual_sequence);
router_virtual_sequencer v_seqr;
router_wr_seqr w_seqr[];
router_rd_seqr r_seqr[];
router_env_config cfg;

extern function new(string name="V_SEQ");
extern task body;
endclass

function router_virtual_sequence::new(string name="V_SEQ");
	super.new(name);
endfunction

task router_virtual_sequence::body;
	if(!uvm_config_db#(router_env_config) ::get(null,get_full_name(),"env_config",cfg))
		`uvm_fatal("V_SEQ","cannot get cfg");
	$cast(v_seqr,m_sequencer);
	w_seqr=new[cfg.no_of_sources];
	r_seqr=new[cfg.no_of_clients];
	foreach(w_seqr[i])
		w_seqr[i]=v_seqr.w_seqr[i];
	foreach(r_seqr[i])
		r_seqr[i]=v_seqr.r_seqr[i];
endtask

class router_virtual_sequence_c1 extends router_virtual_sequence;
`uvm_object_utils(router_virtual_sequence_c1);
router_wr_seq_c1 w_seq; 
router_rd_seq_c1 r_seq[];

extern function new(string name="V_SEQ_c1");
extern task body;

endclass

function router_virtual_sequence_c1::new(string name="V_SEQ_c1");
	super.new(name);
endfunction

task router_virtual_sequence_c1::body;
	super.body;
	w_seq=router_wr_seq_c1::type_id::create("W_SEQ");
	r_seq=new[cfg.no_of_clients];
	foreach(r_seq[i])
	r_seq[i]=router_rd_seq_c1::type_id::create($sformatf("RESQ[%0d]",i));
	fork:a
		begin
		foreach(w_seqr[i])
		w_seq.start(w_seqr[i]);
		end
		begin
		fork:b
		r_seq[0].start(r_seqr[0]);
		r_seq[1].start(r_seqr[1]);
		r_seq[2].start(r_seqr[2]);
		join_any
		disable b;
		end
	join
endtask

