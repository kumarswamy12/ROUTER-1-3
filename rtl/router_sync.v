module router_sync (input clock,resetn,input [1:0]data_in,input detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,output reg [2:0]write_enb,output reg fifo_full,output vld_out_0,vld_out_1,vld_out_2,output reg soft_reset_0,soft_reset_1,soft_reset_2 );

reg [4:0]counter_0,counter_1,counter_2;
reg [1:0]addr;

always@(posedge clock)
 begin
  if(detect_add)
    addr<=data_in;
 end

always@(*)
 begin
 if(~resetn)
  fifo_full=0;
 else
  begin
	  fifo_full=0;
    case(addr)
     2'b00: fifo_full=full_0;
     2'b01: fifo_full=full_1;
     2'b10: fifo_full=full_2;
    endcase 
  end
 end

assign vld_out_0= ~empty_0;

assign vld_out_1= ~empty_1;

assign vld_out_2= ~empty_2;

always@(*)
 begin
 if(~resetn)
  write_enb=0;
 else
  begin
  write_enb =3'b0;
  if(write_enb_reg)
   begin  
    case(addr)
     2'b00: write_enb=3'b001;
     2'b01: write_enb=3'b010;
     2'b10: write_enb=3'b100;
    endcase
   end
 end
end  

always@(posedge clock)
 begin
  counter_0<=0;
  soft_reset_0<=0;
  if(counter_0==29)
   begin
    counter_0<=0;
    soft_reset_0<=1;
   end
  else if(~read_enb_0&&vld_out_0&&~soft_reset_0)
    counter_0<=counter_0+1;
  else if(read_enb_0&&vld_out_0)
    counter_0<=0;
 end

always@(posedge clock)
 begin
 counter_1<=0;
 soft_reset_1<=0;
  if(counter_1==29)
   begin
    counter_1<=0;
    soft_reset_1<=1;
   end
  else if(~read_enb_1&&vld_out_1&&~soft_reset_1)
    counter_1<=counter_1+1;
  else if(read_enb_1&&vld_out_1)
    counter_1<=0;
 end

always@(posedge clock)
 begin
  counter_2<=0;
  soft_reset_2<=0;
  if(counter_2==29)
   begin
    counter_2<=0;
    soft_reset_2<=1;
   end
  else if(~read_enb_2&&vld_out_2&&~soft_reset_2)
    counter_2<=counter_2+1;
  else if(read_enb_2&&vld_out_2)
    counter_2<=0;
 end

endmodule




  
    
    
