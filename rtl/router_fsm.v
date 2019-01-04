module router_fsm (input clock,resetn,pkt_valid,input [1:0]data_in,input fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid,output write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);

reg [7:0]state,next_state;

parameter DECODE_ADDRESS  =  8'b00000001,
          LOAD_FIRST_DATA =  8'b00000010,
          LOAD_DATA       =  8'b00000100,
          LOAD_PARITY     =  8'b00001000,
          FIFO_FULL_STATE =  8'b00010000,
          LOAD_AFTER_FULL =  8'b00100000,
          WAIT_TILL_EMPTY =  8'b01000000,
          CHECK_PARITY_ERROR=8'b10000000;
always@(posedge clock)
 begin
  if(~resetn)
    state<=DECODE_ADDRESS;
  else if((soft_reset_0 && (data_in==2'd0))||(soft_reset_1 && (data_in==2'd1))||(soft_reset_2 && (data_in==2'd2)))
    state<=DECODE_ADDRESS;
  else
    state<=next_state;
 end

always@(*)
 begin
  next_state=DECODE_ADDRESS;
  case(state)
     DECODE_ADDRESS : begin
                       if((pkt_valid & (data_in[1:0]==0)& ~fifo_empty_0)|(pkt_valid & (data_in[1:0]==1)& ~fifo_empty_1)|(pkt_valid & (data_in[1:0]==2)& ~fifo_empty_2))
                            next_state=WAIT_TILL_EMPTY;
                       else if ((pkt_valid & (data_in[1:0]==0)& fifo_empty_0)|(pkt_valid & (data_in[1:0]==1)& fifo_empty_1)|(pkt_valid & (data_in[1:0]==2)& fifo_empty_2))
                            next_state=LOAD_FIRST_DATA;
                      end
     LOAD_FIRST_DATA: next_state=LOAD_DATA;
     LOAD_DATA      : begin
                       next_state=LOAD_DATA;
                       if(~fifo_full&&~pkt_valid)
                            next_state=	LOAD_PARITY;
                       else if(fifo_full)
                            next_state=FIFO_FULL_STATE;
                      end
     LOAD_PARITY    : next_state=CHECK_PARITY_ERROR; 
     FIFO_FULL_STATE: begin
                       next_state=FIFO_FULL_STATE;
                       if(~fifo_full)
                            next_state=LOAD_AFTER_FULL;
                      end
     LOAD_AFTER_FULL: begin
                       next_state=LOAD_AFTER_FULL;
                       if(parity_done)
                            next_state=DECODE_ADDRESS;
                       else
                          begin
                            if(low_packet_valid)
                               next_state=LOAD_PARITY;
                            else
                               next_state=LOAD_DATA;
                          end
                      end
     WAIT_TILL_EMPTY: begin
                       next_state=WAIT_TILL_EMPTY;
                       if(~fifo_empty_0 | ~fifo_empty_1 | ~fifo_empty_2)
                            next_state=	WAIT_TILL_EMPTY;
                       else if (fifo_empty_0 | fifo_empty_1 | fifo_empty_2)
                            next_state= LOAD_FIRST_DATA;
                      end
     CHECK_PARITY_ERROR : begin
                            next_state=CHECK_PARITY_ERROR;
                             if(~fifo_full)
                                 next_state= DECODE_ADDRESS;
                             else if(fifo_full)
                                 next_state=FIFO_FULL_STATE;
                          end
   endcase
 end

assign write_enb_reg= (state==LOAD_DATA)|| (state==LOAD_PARITY)|| (state==LOAD_AFTER_FULL);

assign detect_add= (state==DECODE_ADDRESS);

assign ld_state= (state==LOAD_DATA);

assign laf_state= (state==LOAD_AFTER_FULL);

assign lfd_state= (state==LOAD_FIRST_DATA);

assign full_state= (state==FIFO_FULL_STATE);

assign rst_int_reg= (state==CHECK_PARITY_ERROR);

assign busy=(state==LOAD_FIRST_DATA)|| (state==LOAD_PARITY)|| (state==FIFO_FULL_STATE)||(state==LOAD_AFTER_FULL)||(state==WAIT_TILL_EMPTY)||(state==CHECK_PARITY_ERROR);


endmodule


