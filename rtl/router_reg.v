module router_reg(input clock,resetn,pkt_valid,input[7:0]data_in,input fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,output reg err,parity_done,low_packet_valid,output reg [7:0]dout);

reg [7:0]header_byte,fifo_byte,internal_parity,parity_reg;

always@(posedge clock)
 begin
  parity_done<=0;
  if(ld_state&&~fifo_full&&~pkt_valid&&resetn&&~detect_add)
    parity_done<=1;
  else if(laf_state&&low_packet_valid&&~parity_done&&resetn&&~detect_add)
    parity_done<=1;
 end

always@(posedge clock)
 begin
  low_packet_valid<=0;
  if(ld_state&&~pkt_valid&&~rst_int_reg&&resetn)
   low_packet_valid<=1;
 end

always@(posedge clock)
 begin
  if(~resetn)
   dout<=0;
  else
   begin
    dout<=8'bz;
     if(detect_add&&data_in[1:0]!=3)
       header_byte<=data_in;
     else if(lfd_state)
       dout<=header_byte;
     else if(ld_state&&~fifo_full)
       dout<=data_in;
     else if(ld_state&&fifo_full)
       fifo_byte<=data_in;
     else if(laf_state)
       dout<=fifo_byte;
   end
 end

always@(posedge clock)
 begin
    if(resetn)
    begin
     if(detect_add)
      internal_parity<=0;
     else if(lfd_state)
       internal_parity<=internal_parity ^ header_byte;
     else if(ld_state&&~full_state&&pkt_valid)
       internal_parity<=internal_parity ^ data_in;
    end
  end

always@(posedge clock)
 begin
   parity_reg<=0;
   if(((~fifo_full && ~pkt_valid)||(~parity_done && low_packet_valid))&&resetn)
    parity_reg<=data_in;
 end

always@(posedge clock)
 begin
  err<=0;
 if(resetn)
  begin
    if(detect_add)
     err<=0;
    else if(parity_done)
     begin
      if(internal_parity!=parity_reg)
         err<=1;
     end
 end
 end

endmodule

        
    
                   
