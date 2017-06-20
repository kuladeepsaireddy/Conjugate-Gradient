`timescale 1ns/1ps
`define N 8
module cg_tb(
);
reg tb_clk;
reg [32*`N:0] tb_vect_a;
reg [32*`N:0] tb_vect_b;
wire [32:0] tb_main_o_data;
reg tb_i_valid;


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
 tb_clk<=1'b0;
 tb_i_valid<=1'b0;
 #5
 @(posedge tb_clk);
 tb_vect_a<=32*`N'h1;
 tb_vect_b<= 32*`N'h2;
 tb_i_valid<=1'b1;
 
end
vector_by_vector my_tb(
.clk(tb_clk),
.vect_A(tb_vect_a),
.vect_B(tb_vect_b),
.main_o_data(tb_main_o_data),
.i_valid(tb_i_valid)
);

endmodule 