module top;

bit clk;
always #5 clk=~clk;
import router_pkg::*;
import uvm_pkg::*;

router_if in(clk);
router_if in0(clk);
router_if in1(clk);
router_if in2(clk);
router_top RTL (.data_in(in.data_in),.pkt_valid(in.pkt_valid),.clock(clk),.resetn(in.resetn),.err(in.err),.busy(in.busy),
		.read_enb_0(in0.read_enb),.data_out_0(in0.data_out),.vld_out_0(in0.vld_out),
		.read_enb_1(in1.read_enb),.data_out_1(in1.data_out),.vld_out_1(in1.vld_out),
		.read_enb_2(in2.read_enb),.data_out_2(in2.data_out),.vld_out_2(in2.vld_out));

initial
	begin
 		uvm_config_db#(virtual router_if) ::set(null,"*","vif",in);
		uvm_config_db#(virtual router_if) ::set(null,"*","vif[0]",in0);
		uvm_config_db#(virtual router_if) ::set(null,"*","vif[1]",in1);
		uvm_config_db#(virtual router_if) ::set(null,"*","vif[2]",in2);
		run_test("router_test_c1");
	end
endmodule
