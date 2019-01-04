module router_top( input [7:0]data_in,input pkt_valid,clock,resetn,read_enb_0,read_enb_1,read_enb_2,output [7:0]data_out_0,data_out_1,data_out_2,output vld_out_0,vld_out_1,vld_out_2,err,busy);

wire fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,parity_done,low_packet_valid,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,soft_reset_0,soft_reset_1,soft_reset_2;  

wire [7:0]dout;

wire [2:0]write_enb;

router_reg REGISTER (clock,resetn,pkt_valid,data_in,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,err,parity_done,low_packet_valid,dout);

router_sync SYNCHRONIZER (clock,resetn,data_in[1:0],detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,write_enb, fifo_full, vld_out_0,vld_out_1,vld_out_2, soft_reset_0,soft_reset_1,soft_reset_2 );

router_fsm FSM(clock,resetn,pkt_valid,data_in[1:0], fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid, write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);


router_fifo FIFO1(clock,resetn,soft_reset_0,write_enb[0],read_enb_0,lfd_state,dout,full_0,empty_0,data_out_0);

router_fifo FIFO2(clock,resetn,soft_reset_1,write_enb[1],read_enb_1,lfd_state,dout,full_1,empty_1,data_out_1);

router_fifo FIFO3(clock,resetn,soft_reset_2,write_enb[2],read_enb_2,lfd_state,dout,full_2,empty_2,data_out_2);


endmodule


