class router_rd_dr extends uvm_driver #(read_xtn);
`uvm_component_utils(router_rd_dr);

virtual router_if.R_DR_MP vif;
router_rd_agent_config r_cfg;

extern function new(string name="R_DR",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase);
extern task drive(read_xtn xtn);
endclass

function router_rd_dr::new(string name="R_DR",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_rd_dr::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_rd_agent_config)::get(this,"","rd_config",r_cfg))
		`uvm_fatal("R_DR","cannot get config data");
	super.build_phase(phase);
endfunction

function void router_rd_dr::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=r_cfg.vif;
endfunction

task router_rd_dr::run_phase(uvm_phase);
	forever
		begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done;
		end
endtask

task router_rd_dr::drive(read_xtn xtn);

@(vif.r_dr_cb);
	wait(vif.r_dr_cb.vld_out)
	//repeat(xtn.xtn_delay)
	@(vif.r_dr_cb);
	vif.r_dr_cb.read_enb<=1;
	
	wait(~vif.r_dr_cb.vld_out)
	@(vif.r_dr_cb);
	vif.r_dr_cb.read_enb<=0;
endtask
