class router_wr_agent extends uvm_agent;
`uvm_component_utils(router_wr_agent);
uvm_sequencer#(write_xtn) w_seqr;
router_wr_dr w_dr;
router_wr_mon w_mon;
router_wr_agent_config w_cfg;i
extern function new(string name="W_AGENT",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function router_wr_agent::new(string name="W_AGENT",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_wr_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_wr_agent_config)::get(this,"","wr_config",w_cfg))
		`uvm_fatal("W_AGENT","cannot get config data");
	super.build_phase(phase);
	w_mon=router_wr_mon::type_id::create("W_MON",this);
	if(w_cfg.is_active==UVM_ACTIVE)
		begin
		w_seqr=uvm_sequencer#(write_xtn)::type_id::create("W_SEQR",this);
		w_dr=router_wr_dr::type_id::create("W_DR",this);
		end
endfunction

function void router_wr_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	w_dr.seq_item_port.connect(w_seqr.seq_item_export);
endfunction
task router_wr_agent::run_phase(uvm_phase phase);
uvm_top.print_topology;
endtask
