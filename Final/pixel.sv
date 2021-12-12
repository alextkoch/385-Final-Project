module pixel (
							input logic [4:0] DrawX,
							input logic [4:0] DrawY,
							input int dir,
							input logic bul, brk, bush, rck,
							output logic pixel );

	logic [7:0] addr;
	logic [31:0] data;


	always_comb begin
		if (bul)
			addr = 8'd128 + DrawY;
		else if (brk)
			addr = 8'd160 + DrawY;
		else if (bush)
			addr = 8'd192 + DrawY;
		else if (rck)
			addr = 8'd224 + DrawY;	
		else if (dir == 0)
			addr = 5'b0 + DrawY;
		else if (dir == 1)
			addr = 8'd32 + DrawY;
		else if (dir == 2)
			addr = 8'd64 + DrawY;
		else
			addr = 8'd96 + DrawY;
	end
	
	graphics tank1test(.addr(addr), .data(data));
	
	assign pixel = data[5'b11111 - DrawX[4:0]];


	
endmodule 
