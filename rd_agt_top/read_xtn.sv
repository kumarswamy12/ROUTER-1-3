class read_xtn extends uvm_sequence_item;
`uvm_object_utils(read_xtn);
bit [7:0]header;
bit [7:0]payload_data[];
bit [7:0]parity;
rand int xtn_delay;
constraint U{xtn_delay<30 && xtn_delay>0;}
function new(string name="read_xtn");
	super.new(name);
endfunction

 function void  do_print (uvm_printer printer);
    super.do_print(printer);

   
      printer.print_field( "header", 		this.header, 	    8,		 UVM_DEC		);
foreach(payload_data[i])
    printer.print_field( $sformatf("payload_data[%0d]",i), this.payload_data[i], 	    8,		 UVM_DEC		);
    printer.print_field( "parity", 		this.parity, 	    8,		 UVM_DEC		);
   	
   
   endfunction:do_print

endclass


