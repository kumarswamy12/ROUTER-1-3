module router_fifo (input clock,resetn,soft_reset,write_enb,read_enb,lfd_state,input [7:0]data_in,output full,empty,output reg [7:0]data_out);
reg [8:0]mem[15:0];
reg [4:0]wr_ptr,rd_ptr;
reg [5:0]counter;
reg lfd_temp;
integer i;

always@(posedge clock)
 begin
   lfd_temp<=lfd_state;
 end
 
always@(posedge clock)
 begin
  if(!resetn)
   begin
    for(i=0;i<16;i=i+1)
     mem[i]<=0;
   end
  else if(soft_reset)
   begin
    for(i=0;i<16;i=i+1)
     mem[i]<=0;
    end
  else
   begin
    if(write_enb&&~full)
     {mem[wr_ptr[3:0]][8], mem[wr_ptr[3:0]][7:0]}<={lfd_temp,data_in};
    end
 end

always@(posedge clock)
  begin
    if(!resetn)
     begin
      data_out<=0;
     end
    else if(soft_reset)
      data_out <= 8'bz;
  else
    begin
     if((counter==0)&& data_out!=0)
      data_out<=8'bz;

     else if(read_enb&&~empty)
      data_out<=mem[rd_ptr];
    end
end

always@(posedge clock)
 begin
  if(!resetn)
   begin
    wr_ptr<=0;
    rd_ptr<=0;
   end
  else
   begin
    //wr_ptr[3:0]<=0;
  //  rd_ptr[3:0]<=0;
      if(read_enb&&~empty)
        rd_ptr<=rd_ptr+1;
      if(write_enb&&~full)
        wr_ptr<=wr_ptr+1;
         end
 end
always@(posedge clock)
 begin
   if(mem[rd_ptr][8]&&read_enb&&~empty)
     counter<=mem[rd_ptr][7:2]+1;
   else if(read_enb&&~empty&&counter!=0)
     counter<=counter-1;
		
 end

assign full=((wr_ptr[4]!=rd_ptr[4])&&(wr_ptr[3:0]==rd_ptr[3:0]));

assign empty=(wr_ptr==rd_ptr);

endmodule

  
