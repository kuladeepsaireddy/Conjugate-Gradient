`timescale 1ns / 1ps
`define i 1
`define N 2**`i

module cg_tb(
    );
	
reg tb_clk;
reg [(32*`N)-1:0]tb_A;
reg [(32*`N)-1:0]tb_b;	
reg tb_i_valid;
wire[(32*`N)-1:0] tb_final_solution;
reg [31:0] tb_epsilon;
wire o_ready;

initial
begin
  tb_clk = 1'b0;
  forever
  begin
      tb_clk = ~tb_clk;
		#5;
  end
end


initial
begin

@(posedge tb_clk);
if(o_ready)
begin
tb_A<='h3f8000000000000;
tb_b<='h4000000040000000;
tb_epsilon<='h3c23d70a;
tb_i_valid<=1;
end
#10
@(posedge tb_clk);
if(o_ready)
begin
tb_i_valid<=1;
tb_A<='h3f8000003f800000;
tb_b<='h4000000040000000;
tb_epsilon<='h3c23d70a;
end
#10
@(posedge tb_clk);
if(o_ready)
begin
tb_A<='h3f8000000000000;
tb_b<='h4000000040000000;
tb_epsilon<='h3c23d70a;
tb_i_valid<=1;
end
    
end
	
cg_top dut(	
.clk(tb_clk),
.b(tb_b),
.A(tb_A),
.i_valid(tb_i_valid),
.final_solution(tb_final_solution),
.o_ready(o_ready),
.epsilon(tb_epsilon)
 );
 
endmodule
