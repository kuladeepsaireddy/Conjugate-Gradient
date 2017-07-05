`timescale 1ns / 1ps

`define i 1
`define N 2**`i
module cg_top(
input wire clk,
input wire [(32*`N)-1:0] b,
input wire [(32*`N)-1:0] A,
input wire i_valid,
output reg [(32*`N)-1:0] final_solution,
output o_ready,
input wire [31:0] epsilon
 );
	
reg [(32*`N)-1:0] r;
reg [(32*`N)-1:0]d;
reg [(32*`N)-1:0]q;	
reg [(32*`N)-1:0]x;
reg [31:0] delta_0;	
reg [31:0] delta_new;	
integer i=0;
reg[31:0] beta;

reg [3:0] sel_1;
reg [3:0] sel_2;


 
//assign vect_A=(sel_1=='h0) ? dout:(sel_1=='h1)? r:(sel_1=='h2)? b:d;
//assign vect_B=(sel_2=='h0) ? q:(sel_2=='h1)? r:(sel_2=='h2)? b:d;
integer count =0;
reg rd_en;
wire [63:0]dout;
wire full;
wire empty;

reg [(32*`N)-1:0]vect_A;
reg [(32*`N)-1:0]vect_B;
//wire [(32*`N)-1:0]vect_A=(sel_1=='h0) ? dout:(sel_1=='h1)? r:(sel_1=='h2)? b:d;
//wire [(32*`N)-1:0]vect_B =(sel_2=='h0) ? q:(sel_2=='h1)? r:(sel_2=='h2)? b:d;
wire [31:0]main_o_data;
reg main_i_valid_1;
reg main_i_valid_2;
wire main_o_ready_1;
wire main_o_ready_2;
wire o_valid_result;
reg i_ready_result;

reg [(32*`N)-1:0]i_vect_1_sub;
reg [(32*`N)-1:0]i_vect_2_sub;
reg i_valid_vect_2_sub;
reg i_valid_vect_1_sub;
wire [(32*`N)-1:0] o_data_sub;
reg i_ready_sub;
wire o_valid_sub;
wire o_ready_1_sub;
wire o_ready_2_sub;

reg [(32*`N)-1:0] i_vect_1_add;
reg [(32*`N)-1:0] i_vect_2_add;
reg i_valid_vect_1_add;
reg i_valid_vect_2_add;
wire [(32*`N)-1:0] o_data_add;
reg i_ready_add;
wire o_valid_add;
wire o_ready_1_add;
wire o_ready_2_add;


reg [(32*`N)-1:0] i_vect_1_add_2;
reg [(32*`N)-1:0] i_vect_2_add_2;
reg i_valid_vect_1_add_2;
reg i_valid_vect_2_add_2;
wire [(32*`N)-1:0] o_data_add_2;
reg i_ready_add_2;
wire o_valid_add_2;
wire o_ready_1_add_2;
wire o_ready_2_add_2;

reg [31:0] i_data_1_division; 
reg [31:0] i_data_2_division; 
wire [31:0] o_data_division; 
reg i_valid_1_division; 
reg i_valid_2_division;
wire o_ready_1_division;
wire o_ready_2_division;
wire o_valid_result_division;
reg i_ready_result_division;

reg [31:0] i_data_1_division_2; 
reg [31:0] i_data_2_division_2; 
wire [31:0] o_data_division_2; 
reg i_valid_1_division_2; 
reg i_valid_2_division_2;
wire o_ready_1_division_2;
wire o_ready_2_division_2;
wire o_valid_result_division_2;
reg i_ready_result_division_2;

reg [(32*`N)-1:0] i_data_vect_mult_1;
reg [31:0] i_data_scalar_mult_1;
reg 	i_valid_vect_mult_1;
reg i_valid_scalar_mult_1;
wire [(32*`N)-1:0] o_data_mult_1;
reg i_ready_mult_1;
wire o_valid_mult_1;
wire o_ready_1_mult_1;
wire o_ready_2_mult_1;


reg [(32*`N)-1:0] i_data_vect_mult_2;
reg [31:0] i_data_scalar_mult_2;
reg 	i_valid_vect_mult_2;
reg i_valid_scalar_mult_2;
wire [(32*`N)-1:0] o_data_mult_2;
reg i_ready_mult_2;
wire o_valid_mult_2;
wire o_ready_1_mult_2;
wire o_ready_2_mult_2;

reg [(32*`N)-1:0] i_data_vect_mult_3;
reg [31:0] i_data_scalar_mult_3;
reg 	i_valid_vect_mult_3;
reg i_valid_scalar_mult_3;
wire [(32*`N)-1:0] o_data_mult_3;
reg i_ready_mult_3;
wire o_valid_mult_3;
wire o_ready_1_mult_3;
wire o_ready_2_mult_3;

wire s_axis_a_tready;
wire s_axis_b_tready;
wire m_axis_result_tvalid;
wire m_axis_a_tready;
wire [31:0] m_axis_result_tdata;
wire s_axis_b_tready_2;
wire m_axis_result_tvalid_2;
wire [31:0] tolerance;

/*
initial 
  begin	
  
    d<=b;
	r<=b;
	sel_1<='h2;
	sel_2<='h2;
	
	//vect_A<=r;
	//vect_B<=r;
	main_i_valid_1<=1'b1;
	main_i_valid_2<=1'b1;
	i_ready_result<=1'b1;
	if(o_valid_result)
	 begin
	  delta_0<=main_o_data;
	 end
	delta_new<=delta_0;
	
  end
 */
always@(posedge clk)
 begin
  if(sel_1=='h0)
   begin 
     vect_A<=dout;
	 rd_en<=1'b1;
   end
  else if(sel_1=='h1)
   begin
     vect_A<=r;

   end
  else if(sel_1=='h2)
    begin
     vect_A<=b;
    end
  else if(sel_1=='h3)
    begin
     vect_A<=d;
    end	
 end
 
always@(posedge clk)
  begin
  if(sel_2=='h0)
   begin 
     vect_B<=q;
   end
  else if(sel_2=='h1)
   begin
     vect_B<=r;
   end
  else if(sel_2=='h2)
    begin
     vect_B<=b;
    end
  else if(sel_2=='h3)
    begin
     vect_B<=d;
    end	
 end 
  
 reg count_1;
 initial
 begin
  count_1<=0;
 end
 
 always@(posedge clk)
 begin
 if(count_1==0)
   begin
    d<=b;
	r<=b;
	sel_1<='h1;
	sel_2<='h1;
	 if(main_o_ready_1& main_o_ready_2)
	  begin
	    main_i_valid_1<=1'b1;
		main_i_valid_2<=1'b1;
		
		if(o_valid_result)
			begin
            i_ready_result<=1'b1;			
			delta_0<=main_o_data;
			end
		delta_new<=delta_0;
		count_1<=1;
	  end
   end
if(delta_new< tolerance & count_1==1 )
 begin
   if(count<`N & main_o_ready_1& main_o_ready_2 )
    begin
     sel_1<=0;
	 //rd_en<=1'b1;
     sel_2<=3;
     main_i_valid_1<=fifo_o_valid;
     main_i_valid_2<=1'b1;
     count<=count+1;
     i_ready_result<=1'b1;	 
    end 
	
	
   if(o_valid_result&i<`N)
      begin
       q[32*i+:32]<=main_o_data;
       i<=i+1;
      end
	  
	  
   if(i==`N)
      begin
       sel_1<=3;
	   sel_2<=0;
	   main_i_valid_1<=1'b1;
       main_i_valid_2<=1'b1;
	   i_ready_result<=1'b1;
	    if(o_valid_result&o_ready_1_division&o_ready_2_division)
	     begin
	      i_data_1_division<=delta_new;
	      i_data_2_division<=main_o_data;
	      i_valid_1_division<=1'b1;
	      i_valid_2_division<=1'b1;
		  i_ready_result_division<=1'b1;
	      i='hZ;
	    end
   end
   
   
   if(o_valid_result_division &o_ready_1_mult_1&o_ready_2_mult_1&o_ready_1_mult_2&o_ready_2_mult_2)
    begin
	   i_data_vect_mult_1<=d;
	   i_data_scalar_mult_1<=o_data_division;
	   i_valid_scalar_mult_1<=1'b1;
	   i_valid_vect_mult_1<=1'b1;
	   i_ready_mult_1<=1'b1;
	   i_data_vect_mult_2<=q;
	   i_data_scalar_mult_2<=o_data_division;
	   i_valid_scalar_mult_2<=1'b1;
	   i_valid_vect_mult_2<=1'b1;
	   i_ready_mult_2<=1'b1;
	 end
	 
	 
	if(o_valid_mult_1&o_ready_1_add&o_ready_1_add)
	  begin
        i_vect_1_add <=x;
		i_vect_2_add<=o_data_mult_1;
		i_valid_vect_1_add<=1'b1;
		i_valid_vect_2_add<=1'b1;
		i_ready_add<=1'b1;
	  end
	  
	  
	 if(o_valid_mult_2&o_ready_1_sub&o_ready_2_sub)
	  begin
	   i_vect_1_sub<=r;
	   i_vect_2_sub<=o_data_mult_2;
	   i_valid_vect_2_sub <=1'b1;
	   i_valid_vect_1_sub <=1'b1;
	   i_ready_sub<=1'b1;
	  end
	  
	  
	 if(o_valid_add)
	  begin
	   x<=o_data_add;
	  end
	  
	 if(o_valid_sub&main_o_ready_1&main_o_ready_2)
	  begin
	   r<=o_data_sub;
	   delta_0<=delta_new;
	   //vect_A<=r;
	   //vect_B<=r;
	   sel_1<='h1;
	   sel_2<='h1;
	   main_i_valid_1<=1'b1;
	   main_i_valid_2<=1'b1;
	   i_ready_result<=1'b1;
	  end
	  
	  
	 if(o_valid_result& i=='hz)
	  begin
	   delta_new<=main_o_data;
	   i=0;
	   
	  end
	  
	  
	 if(o_ready_1_division_2&o_ready_2_division_2)
	  begin
	    i_data_1_division_2<=delta_new;
		i_data_2_division_2<=delta_0;
		i_valid_1_division_2<=1'b1;
		i_valid_2_division_2<=1'b1;
		i_ready_result_division_2<=1'b1;
	  end
	  
	  
	 if(o_valid_result_division_2&o_ready_1_mult_3&o_ready_2_mult_3)
	  begin
	    beta<=o_data_division_2;
		i_data_vect_mult_3<=d;
		i_data_scalar_mult_3<=beta;
		i_valid_vect_mult_3<=1'b1;
		i_valid_scalar_mult_3<=1'b1;
		i_ready_mult_3<=1'b1;
	  end
	  
	  
	 if(o_valid_mult_3)
	  begin
	    i_vect_1_add_2<=r;
		i_vect_2_add_2<=o_data_mult_3;
		i_valid_vect_1_add_2<=1'b1;
		i_valid_vect_2_add_2<=1'b1;
		i_ready_add_2<=1'b1;
	  end
	  
	  
	 if(o_valid_add_2)
	  begin
        d<=o_data_add_2;
        count<=0;;		
	  end
	  
 end
////
	else
	  begin
       final_solution<=x;
	   count_1<=0;
      end

end

vector_by_vector vect_by_vect_inst(
  .clk(clk),
  .vect_A(vect_A),
  .vect_B(vect_B),
  .main_o_data(main_o_data),
  .main_i_valid_1(main_i_valid_1),
  .main_i_valid_2(main_i_valid_2),
  .main_o_ready_1(main_o_ready_1),
  .main_o_ready_2(main_o_ready_2),
  .o_valid_result(o_valid_result),
  .i_ready_result(i_ready_result)
    
    );  

cg_vector_subtractor  sub_instnce(    
    .clk(clk),
    .i_data_vect_1(i_vect_1_sub),
    .i_valid_vect_2(i_valid_vect_2_sub),
    .i_valid_vect_1(i_valid_vect_1_sub),
    
    .i_data_vect_2(i_vect_2_sub),    
    .o_data(o_data_sub),
    .i_ready(i_ready_sub),
    .o_valid(o_valid_sub),
    .o_ready_1(o_ready_1_sub),
    .o_ready_2(o_ready_2_sub)        
      );
	


 cg_vector_adder adder_instnce(
.clk(clk),
.i_data_vect_1(i_vect_1_add),
.i_valid_vect_1(i_valid_vect_1_add),
.i_valid_vect_2(i_valid_vect_2_add),

.i_data_vect_2(i_vect_2_add),    
.o_data(o_data_add),
.i_ready(i_ready_add),
.o_valid(o_valid_add),
.o_ready_1(o_ready_1_add),
.o_ready_2(o_ready_2_add)    

);	

 

 cg_vector_adder adder_instnce_2(
.clk(clk),
.i_data_vect_1(i_vect_1_add_2),
.i_valid_vect_1(i_valid_vect_1_add_2),
.i_valid_vect_2(i_valid_vect_2_add_2),

.i_data_vect_2(i_vect_2_add_2),    
.o_data(o_data_add_2),
.i_ready(i_ready_add_2),
.o_valid(o_valid_add_2),
.o_ready_1(o_ready_1_add_2),
.o_ready_2(o_ready_2_add_2)    

);  



 cg_scalar_division division_instnce(
.clk(clk),
.i_data_1(i_data_1_division),
.i_data_2(i_data_2_division),
.i_valid_1(i_valid_1_division),
.i_valid_2(i_valid_2_division),
.o_ready_1(o_ready_1_division),
.o_ready_2(o_ready_2_division),
.o_data(o_data_division),
.o_valid_result(o_valid_result_division),
.i_ready_result(i_ready_result_division)
    );



	
 cg_scalar_division division_instnce_2(
.clk(clk),
.i_data_1(i_data_1_division_2),
.i_data_2(i_data_2_division_2),
.i_valid_1(i_valid_1_division_2),
.i_valid_2(i_valid_2_division_2),
.o_ready_1(o_ready_1_division_2),
.o_ready_2(o_ready_2_division_2),
.o_data(o_data_division_2),
.o_valid_result(o_valid_result_division_2),
.i_ready_result(i_ready_result_division_2)
    );	



cg_scalar_mult scalar_mult_instnce_1(
.clk(clk),
.i_data_vect(i_data_vect_mult_1),
.i_valid_vect(i_valid_vect_mult_1),
.i_valid_scalar(i_valid_scalar_mult_1),

.i_data_scalar(i_data_scalar_mult_1),    
.o_data(o_data_mult_1),
.i_ready(i_ready_mult_1),
.o_valid(o_valid_mult_1),
.o_ready_1(o_ready_1_mult_1),
.o_ready_2(o_ready_2_mult_1)    

);



cg_scalar_mult scalar_mult_instnce_2(
.clk(clk),
.i_data_vect(i_data_vect_mult_2),
.i_valid_vect(i_valid_vect_mult_2),
.i_valid_scalar(i_valid_scalar_mult_2),

.i_data_scalar(i_data_scalar_mult_2),    
.o_data(o_data_mult_2),
.i_ready(i_ready_mult_2),
.o_valid(o_valid_mult_2),
.o_ready_1(o_ready_1_mult_2),
.o_ready_2(o_ready_2_mult_2)    

);


cg_scalar_mult scalar_mult_instnce_3(
.clk(clk),
.i_data_vect(i_data_vect_mult_3),
.i_valid_vect(i_valid_vect_mult_3),
.i_valid_scalar(i_valid_scalar_mult_3),

.i_data_scalar(i_data_scalar_mult_3),    
.o_data(o_data_mult_3),
.i_ready(i_ready_mult_3),
.o_valid(o_valid_mult_3),
.o_ready_1(o_ready_1_mult_3),
.o_ready_2(o_ready_2_mult_3)    

);

//wire [1023:0] b;
//wire i_valid;


/*
fifo_matrix_A matrix_fifo (
  .clk(clk),      // input wire clk
  .rst(1'b0),      // input wire rst
  .din(A),      // input wire [63 : 0] din
  .wr_en(i_valid),  // input wire wr_en
  .rd_en(rd_en),  // input wire rd_en
  .dout(dout),    // output wire [63 : 0] dout
  .full(full),    // output wire full
  .empty(empty)  // output wire empty
);
*/
wire fifo_o_valid;
fifo_matrix_A matrix_fifo (
  .s_aclk(clk),                // input wire s_aclk
  .s_aresetn(1'b1),          // input wire s_aresetn
  .s_axis_tvalid(i_valid),  // input wire s_axis_tvalid
  .s_axis_tready(o_ready),  // output wire s_axis_tready
  .s_axis_tdata(A),    // input wire [63 : 0] s_axis_tdata
  .m_axis_tvalid(fifo_o_valid),  // output wire m_axis_tvalid
  .m_axis_tready(rd_en),  // input wire m_axis_tready
  .m_axis_tdata(dout)    // output wire [63 : 0] m_axis_tdata
);

ephsilon_mult square_eph(
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
  .s_axis_a_tdata(epsilon),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
  .s_axis_b_tdata(epsilon),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(m_axis_a_tready),  // input wire m_axis_result_tready
  .m_axis_result_tdata(m_axis_result_tdata)    // output wire [31 : 0] m_axis_result_tdata
	  );
ephsilon_mult mult_eph(
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(m_axis_result_tvalid),            // input wire s_axis_a_tvalid
  .s_axis_a_tready(m_axis_a_tready),            // output wire s_axis_a_tready
  .s_axis_a_tdata(m_axis_result_tdata),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
  .s_axis_b_tready(s_axis_b_tready_2),            // output wire s_axis_b_tready
  .s_axis_b_tdata(delta_0),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(m_axis_result_tvalid_2),  // output wire m_axis_result_tvalid
  .m_axis_result_tready(1'b1),  // input wire m_axis_result_tready
  .m_axis_result_tdata(tolerance)    // output wire [31 : 0] m_axis_result_tdata
	  );
endmodule
