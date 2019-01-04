class router_rd_mon extends uvm_monitor;
`uvm_component_utils(router_rd_mon);
virtual router_if.R_MON_MP vif;
router_rd_agent_config r_cfg;
uvm_analysis_port #(read_xtn) ap_r;
read_xtn xtn;
extern function new(string name="R_MON",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase);
extern task collect_data;
endclass

function router_rd_mon::new(string name="R_MON",uvm_component parent);
	super.new(name,parent);
	ap_r=new("AP_R",this);
endfunction

function void router_rd_mon::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_rd_agent_config)::get(this,"","rd_config",r_cfg))
		`uvm_fatal("R_MON","cannot get config data");
$display("%p",r_cfg);
	super.build_phase(phase);
endfunction

function void router_rd_mon::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=r_cfg.vif;
endfunction

task router_rd_mon::run_phase(uvm_phase);
	forever
		collect_data;
endtask

task router_rd_mon::collect_data;
	xtn=read_xtn::type_id::create("XTN");
	
	wait(vif.r_mon_cb.read_enb)
	@(vif.r_mon_cb);
	xtn.header=vif.r_mon_cb.data_out;
	xtn.payload_data=new[xtn.header[7:2]];
	for(int i=0;i<xtn.header[7:2];i++)
		begin
				@(vif.r_mon_cb);
				xtn.payload_data[i]=vif.r_mon_cb.data_out;
		end
	@(vif.r_mon_cb);
	xtn.parity=vif.r_mon_cb.data_out;
	xtn.print;
	@(vif.r_mon_cb);
	ap_r.write(xtn);
endtask
	
