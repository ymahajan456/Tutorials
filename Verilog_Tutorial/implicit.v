module implicit();
reg clk,d,rst,pre;
wire q;

// Here second port is not connected
dff u0 ( q,,clk,d,rst,pre); 

endmodule

// D fli-flop
module dff (q, q_bar, clk, d, rst, pre);
input clk, d, rst, pre;
output q, q_bar;
reg q;

assign q_bar = ~q;

always @ (posedge clk)
if (rst == 1'b1) begin
  q <= 0;
end else if (pre == 1'b1) begin
  q <= 1;
end else begin
  q <= d;
end

endmodule
