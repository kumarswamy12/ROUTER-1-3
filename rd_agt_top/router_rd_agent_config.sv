class router_rd_agent_config extends uvm_object;

`uvm_object_utils(router_rd_agent_config)
uvm_active_passive_enum is_active=UVM_ACTIVE;
virtual router_if vif;

extern function new(string name="RD_AGENT_CONFIG");

endclass

function router_rd_agent_config::new(string name="RD_AGENT_CONFIG");
	super.new(name);
endfunction
