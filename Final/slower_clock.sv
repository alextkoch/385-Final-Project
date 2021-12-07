module slower_clock( input logic Reset, Clk,
							output logic slower_Clk
);

logic [2:0] counter, count;

always_ff @ (posedge Reset or posedge Clk )
begin

	if (Reset) begin
		counter <= 3'b0;
		slower_Clk <= 1'b0;
	end
	else begin
	
		if (counter == 3'b111) begin
			slower_Clk <= 1'b1;
			counter <= 3'b0;
		end
		else begin
			slower_Clk <= 1'b0;
			counter <= counter + 3'b1;
		end
	end
end



endmodule