package router_pkg;

import uvm_pkg::*;
	`include "uvm_macros.svh"
//`include "tb_defs.sv"
`include "write_xtn.sv"
`include "router_wr_agent_config.sv"
`include "router_rd_agent_config.sv"
`include "router_env_config.sv"
`include "router_wr_drv.sv"
`include "router_wr_mon.sv"
`include "router_wr_seqr.sv"
`include "router_wr_agent.sv"
`include "router_wr_agt_top.sv"
`include "router_wr_seq.sv"

`include "read_xtn.sv"
`include "router_rd_mon.sv"
`include "router_rd_seqr.sv"
`include "router_rd_seq.sv"
`include "router_rd_drv.sv"
`include "router_rd_agent.sv"
`include "router_rd_agt_top.sv"

`include "router_virtual_sequencer.sv"
`include "router_virtual_sequence.sv"
`include "router_scoreboard.sv"

`include "router_tb.sv"


`include "router_vtest_lib.sv"
endpackage
