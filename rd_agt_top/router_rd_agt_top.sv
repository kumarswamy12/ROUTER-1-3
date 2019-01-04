class router_rd_agt_top extends uvm_env;
`uvm_component_utils(router_rd_agt_top);

router_env_config cfg;
router_rd_agent_config r_cfg[];
router_rd_agent r_ag[];

extern function new(string name="R_AG_T",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function router_rd_agt_top::new(string name="R_AG_T",uvm_component parent);
	super.new(name,parent);
endfunction 

function void router_rd_agt_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("AGT_TOP","cannot get config data");
	r_cfg=new[cfg.no_of_clients];
	r_ag=new[cfg.no_of_clients];
	foreach(r_ag[i]) begin
	r_cfg[i]=cfg.r_cfg[i];
	r_ag[i]=router_rd_agent::type_id::create($sformatf("R_AGENT[%0d]",i),this);
	uvm_config_db#(router_rd_agent_config)::set(this,$sformatf("R_AGENT[%0d]*",i),"rd_config",r_cfg[i]);
	end
endfunction
