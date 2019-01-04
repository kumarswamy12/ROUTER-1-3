class router_env_config extends uvm_object;

`uvm_object_utils(router_env_config)

int no_of_sources;
int no_of_clients;
int has_scoreboard;
int has_virtual_sequencer;

router_wr_agent_config w_cfg[];
router_rd_agent_config r_cfg[];

extern function new(string name="ENV_CONFIG");

endclass

function router_env_config::new(string name="ENV_CONFIG");
	super.new(name);
endfunction
