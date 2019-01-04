class router_rd_agent extends uvm_agent;
`uvm_component_utils(router_rd_agent);
router_rd_seqr r_seqr;
router_rd_dr r_dr;
router_rd_mon r_mon;
router_rd_agent_config r_cfg;
extern function new(string name="R_AGENT",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

function router_rd_agent::new(string name="R_AGENT",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_rd_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_rd_agent_config)::get(this,"","rd_config",r_cfg))
		`uvm_fatal("R_AGENT","cannot get config data");
	super.build_phase(phase);
	r_mon=router_rd_mon::type_id::create("R_MON",this);
	if(r_cfg.is_active==UVM_ACTIVE)
		begin
		r_seqr=router_rd_seqr::type_id::create("R_SEQR",this);
		r_dr=router_rd_dr::type_id::create("R_DR",this);
		end
endfunction

function void router_rd_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	r_dr.seq_item_port.connect(r_seqr.seq_item_export);
endfunction

