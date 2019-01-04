class router_scoreboard extends uvm_scoreboard;
`uvm_component_utils(router_scoreboard);

uvm_tlm_analysis_fifo#(write_xtn) af_w;
uvm_tlm_analysis_fifo#(read_xtn) af_r[];
router_env_config cfg;
write_xtn xtn;
read_xtn xtn2,xtn3,xtn1;
extern function new(string name="SCOREBOARD",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase);
extern task check_(read_xtn rd);
endclass

function router_scoreboard::new(string name="SCOREBOARD",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","env_config",cfg))
		`uvm_fatal("SB","cannot get config data");
	af_r=new[cfg.no_of_clients];
	af_w=new("AF_W",this);
	foreach(af_r[i])
		af_r[i]=new($sformatf("af_r[%0d]",i),this);
	super.build_phase(phase);
endfunction

task router_scoreboard::run_phase(uvm_phase);
	fork
		forever begin
			af_w.get(xtn);
			end
		forever begin
			fork:A
			begin af_r[0].get(xtn1);
				check_(xtn1);
			end
			begin af_r[1].get(xtn2);
				check_(xtn2);
			end
			begin af_r[2].get(xtn3);
				check_(xtn3);
			end
			join_any
			disable A;
			end
	join
endtask

task router_scoreboard::check_(read_xtn rd);
	if(rd.header==xtn.header)
	begin
	foreach(rd.payload_data[i])
		if(rd.payload_data[i]!=xtn.payload_data[i])
		begin 
		$display("----------------------------------WRONG DATA-------------------------------");
		return;
		end
	end
	else
	begin  $display("---------------------------HEADER MISMATCH------------------------------------");
	return;
	end
	if(rd.parity==xtn.parity)
	$display("----------------------------------GOOD PACKET-------------------------------------------");
	else
	$display("------------------------------------BAD PACKET------------------------------------------");
endtask
