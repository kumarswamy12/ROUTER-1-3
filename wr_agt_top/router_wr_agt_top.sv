class router_wr_agt_top extends uvm_env;
`uvm_component_utils(router_wr_agt_top);

router_env_config cfg;
router_wr_agent_config w_cfg[];
router_wr_agent w_ag[];

extern function new(string name="W_AG_T",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function router_wr_agt_top::new(string name="W_AG_T",uvm_component parent);
	super.new(name,parent);
endfunction 

function void router_wr_agt_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("AGT_TOP","cannot get config data");
	w_cfg=new[cfg.no_of_sources];
	w_ag=new[cfg.no_of_sources];
	foreach(w_ag[i]) begin
	w_cfg[i]=router_wr_agent_config::type_id::create($sformatf("W_AGENT_CFG[%0d]",i));
	w_cfg[i]=cfg.w_cfg[i];
	w_ag[i]=router_wr_agent::type_id::create($sformatf("W_AGENT[%0d]",i),this);
	uvm_config_db#(router_wr_agent_config)::set(this,$sformatf("W_AGENT[%0d]*",i),"wr_config",cfg.w_cfg[i]);
	end
endfunction
