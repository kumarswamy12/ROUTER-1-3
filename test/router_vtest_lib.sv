class router_test extends uvm_test;
`uvm_component_utils(router_test)
router_env_config cfg;
router_wr_agent_config w_cfg[];
router_rd_agent_config r_cfg[];
int no_of_sources=1;
int no_of_clients=3;
int has_scoreboard=1;
int has_virtual_sequencer=1;
router_tb env;

extern function new(string name="TEST",uvm_component parent);
extern function void build_phase(uvm_phase phase);
//extern task run_phase(uvm_phase);

endclass

function router_test:: new(string name="TEST",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test:: build_phase(uvm_phase phase);
	r_cfg=new[no_of_clients];
	w_cfg=new[no_of_sources];
	cfg=router_env_config::type_id::create("ENV_CONFIG");
	cfg.r_cfg=new[no_of_clients];
	cfg.w_cfg=new[no_of_sources];
	foreach(w_cfg[i])
	begin
		w_cfg[i]=router_wr_agent_config::type_id::create($sformatf("WR_AGENT_CONFIG[%0d]",i));
		if(!uvm_config_db #(virtual router_if)::get(this,"","vif",w_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");
		w_cfg[i].is_active=UVM_ACTIVE;
		cfg.w_cfg[i]=w_cfg[i];
	end
	foreach(r_cfg[i])
	begin
		r_cfg[i]=router_rd_agent_config::type_id::create($sformatf("RD_AGENT_CONFIG[%0d]",i));
		if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("vif[%0d]",i),r_cfg[i].vif))
			`uvm_fatal("TEST","cannot get config data");
		r_cfg[i].is_active=UVM_ACTIVE;
		cfg.r_cfg[i]=r_cfg[i];
	end
	cfg.no_of_sources=no_of_sources;
	cfg.no_of_clients=no_of_clients;
	cfg.has_scoreboard=has_scoreboard;
	cfg.has_virtual_sequencer=has_virtual_sequencer;
	uvm_config_db#(router_env_config) ::set(this,"*","env_config",cfg);
	super.build_phase(phase);
	env=router_tb::type_id::create("ENV",this);
endfunction

class router_test_c1 extends router_test;
`uvm_component_utils(router_test_c1)
router_virtual_sequence_c1 v_seq;

extern function new(string name="TEST",uvm_component parent);
extern function void build_phase(uvm_phase);
extern task run_phase(uvm_phase);

endclass

function router_test_c1:: new(string name="TEST",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test_c1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction		

task router_test_c1::run_phase(uvm_phase phase);
	v_seq=router_virtual_sequence_c1::type_id::create("V_SEQ");
	phase.raise_objection(this);
	v_seq.start(env.v_seqr);
	phase.drop_objection(this);
endtask

