class write_xtn extends uvm_sequence_item;
`uvm_object_utils(write_xtn);
rand bit[7:0]header;
rand bit[7:0]payload_data[];
bit [7:0] parity;

constraint O{payload_data.size ==header[7:2];}
constraint Y{header[1:0]!=3;}

extern function new(string name = "write_xtn");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function void do_print(uvm_printer printer);
extern function void post_randomize();
endclass:write_xtn


	function write_xtn::new(string name = "write_xtn");
		super.new(name);
	endfunction:new

  function void write_xtn::do_copy (uvm_object rhs);
    write_xtn rhs_;

    if(!$cast(rhs_,rhs)) begin
    `uvm_fatal("do_copy","cast of the rhs object failed")
    end
    super.do_copy(rhs);
    header= rhs_.header;
    foreach(payload_data[i])	
    payload_data[i]= rhs_.payload_data[i];
    parity= rhs_.parity;
    
  endfunction:do_copy

  function bit  write_xtn::do_compare (uvm_object rhs,uvm_comparer comparer);
    write_xtn rhs_;

    if(!$cast(rhs_,rhs)) begin
    `uvm_fatal("do_compare","cast of the rhs object failed")
    return 0;
    end

    return super.do_compare(rhs,comparer) &&
    header== rhs_.header &&
    parity== rhs_.parity;

 endfunction:do_compare 
   function void  write_xtn::do_print (uvm_printer printer);
    
   
      printer.print_field( "header", 		this.header, 	    8,		 UVM_BIN		);
foreach(payload_data[i])
    printer.print_field( $sformatf("payload_data[%0d]",i), this.payload_data[i], 	    8,		 UVM_DEC		);
    printer.print_field( "parity", 		this.parity, 	    8,		 UVM_DEC		);
   	
   
   endfunction:do_print
    
function void write_xtn::post_randomize();
	parity=header;
	foreach(payload_data[i])
		begin
		parity=payload_data[i]^parity;
		end
endfunction

