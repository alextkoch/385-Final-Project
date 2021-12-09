
module  tank ( input Reset, frame_clk, player,
					input [7:0] keycode,
	      input int map[300],
			input logic loss, gotHit,
			input int enemyX, enemyY,
	      output int  TankX, TankY, BulX, BulY,
			output int change,
			output logic win, hitted
			);

	int Tank_X_Pos, Tank_X_Motion, Tank_Y_Pos, Tank_Y_Motion, Tank_X_Pot, Tank_Y_Pot;
	int potX_tank, potY_tank;
	int nextTile_tank, valid_tank;
	
	int Bul_X_Pos, Bul_X_Motion, Bul_Y_Pos, Bul_Y_Motion, Bul_X_Pot, Bul_Y_Pot;
	int potX_bul, potY_bul;
	int nextTile_bul, valid_bul;
	
	int dir;
	
	logic won;
	
	logic is_bul, attempt;
	
	int whereHeAt;
	assign whereHeAt = enemyY * 20 + enemyX;
	
	parameter int Tank1_X_Int= 1;  // Leftmost position on the X axis upon reset (starting position essentially)
	parameter int Tank1_Y_Int= 13;       // Topmost point on the Y axis upon reset
	parameter int Tank2_X_Int= 18;  // Leftmost position on the X axis upon reset (starting position essentially)
	parameter int Tank2_Y_Int= 1;       // Topmost point on the Y axis upon reset
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_
        if (Reset)  // Asynchronous Reset
        begin 
		is_bul <= 0;
		dir <= 0;
		Bul_Y_Motion <= 0;
		Bul_X_Motion <= 0;
		won <= 1'b0;
		win <= 1'b0;
		if (player) //low means we're dealing with player 1
			begin
				Tank_Y_Motion <= 0;
				Tank_X_Motion <= 0;
				Tank_Y_Pos <= Tank1_Y_Int;
				Tank_X_Pos <= Tank1_X_Int;
				Bul_Y_Pos <= -1;
				Bul_X_Pos <= -1;
			end
			else
			begin
				Tank_Y_Motion <= 0;
				Tank_X_Motion <= 0;
				Tank_Y_Pos <= Tank2_Y_Int;
				Tank_X_Pos <= Tank2_X_Int;
				Bul_Y_Pos <= -1;
				Bul_X_Pos <= -1;
			end
			end
           
       else 
        	begin 				  
			if (loss) begin
				Tank_Y_Motion <= 0;
				Tank_X_Motion <= 0;
				Tank_Y_Pos <= -1;
				Tank_X_Pos <= -1;
				Bul_Y_Pos <= -1;
				Bul_X_Pos <= -1;
				win <= 1'b0;
			end
			else if (won) begin
				Tank_Y_Motion <= 0;
				Tank_X_Motion <= 0;
				Tank_Y_Pos <= 7;
				Tank_X_Pos <= 9;
				Bul_Y_Pos <= -1;
				Bul_X_Pos <= -1;
				win <= 1'b1;
				won <= 1'b0;
			end
			else if (gotHit) begin
				win <= 1'b0;
				Tank_Y_Motion <= 0;
				Tank_X_Motion <= 0;
				Bul_Y_Pos <= -1;
				Bul_X_Pos <= -1;
				won <= 1'b0;
				if (player) begin
					Tank_Y_Pos <= Tank1_Y_Int;
					Tank_X_Pos <= Tank1_X_Int;
					Bul_Y_Pos <= -1;
					Bul_X_Pos <= -1;
				end
				else begin
					Tank_Y_Motion <= 0;
					Tank_X_Motion <= 0;
					Tank_Y_Pos <= Tank2_Y_Int;
					Tank_X_Pos <= Tank2_X_Int;
					Bul_Y_Pos <= -1;
					Bul_X_Pos <= -1;
					end
			end
			else begin
				win <= 1'b0;
				if(player) //distinction here is important, player 1 uses WASD, player 2 used the arrow keys
				begin
					 case (keycode)
					8'h04 : begin

								Tank_X_Motion <= -1;//A
								Tank_Y_Motion<= 0;
								dir <= 1;
								attempt <= 0;
							  end
					        
					8'h07 : begin
								
					        	  Tank_X_Motion <= 1;//D
							  Tank_Y_Motion <= 0;
							  dir <= 3;
							  attempt <= 0;
							  end

							  
					8'h16 : begin

					        	  Tank_Y_Motion <= 1;//S
							  Tank_X_Motion <= 0;
							  dir <= 2;
							  attempt <= 0;
							 end
							  
					8'h1A : begin
					           	  Tank_Y_Motion <= -1;//W
							  Tank_X_Motion <= 0;
							  dir <= 0;
						   	  attempt <= 0;
							 end
						 
					8'h14 : begin
					        	Tank_Y_Motion <= 0;// q
							Tank_X_Motion <= 0;
							dir <= dir;
							attempt <= 1;
							
							end
					default: begin
							Tank_X_Motion <= 0;
							Tank_Y_Motion <= 0;
							dir <= dir;
							attempt <= 0;
						 end
					   endcase
				end
			else
				begin
					begin
					 case (keycode)
					8'h4F : begin

							Tank_X_Motion <= 1;//Right
							Tank_Y_Motion<= 0;
							dir <= 3;
							attempt <= 0;
							end
					        
					8'h50 : begin
								
					        	Tank_X_Motion <= -1;//Left
							Tank_Y_Motion <= 0;
							dir <= 1;
							attempt <= 0;
							end

							  
					8'h51 : begin

					        	Tank_Y_Motion <= 1;//Down
							Tank_X_Motion <= 0;
							dir <= 2;
							attempt <= 0;
							end
							  
					8'h52 : begin
					        	Tank_Y_Motion <= -1;//Up
							Tank_X_Motion <= 0;
							dir <= 0;
							attempt <= 0;
							end
					8'h28 : begin
					        	Tank_Y_Motion <= 0;// enter
							Tank_X_Motion <= 0;
							dir <= dir;
							attempt <= 1;
							
							end
					default: begin
							Tank_X_Motion <= 0;
							Tank_Y_Motion <= 0;
							dir <= dir;
							attempt <= 0;
						 end
					   endcase
				end
					
		end 			
			potX_tank = Tank_X_Pos + Tank_X_Motion;
			potY_tank = Tank_Y_Pos + Tank_Y_Motion;
				
			nextTile_tank = potY_tank * 20 + potX_tank;
			
			valid_tank = map[nextTile_tank];
				
					if(valid_tank == 0)
						begin
							Tank_X_Pos <= Tank_X_Pos + Tank_X_Motion;
							Tank_Y_Pos <= Tank_Y_Pos + Tank_Y_Motion;
						end
					else
						begin
							Tank_X_Pos <= Tank_X_Pos;
							Tank_Y_Pos <= Tank_Y_Pos;
						end
						

			end			

	    if (is_bul) begin
//	    	Bul_X_Motion <= Bul_X_Motion;
//		Bul_Y_Motion <= Bul_Y_Motion;
//		Bul_X_Pos <= Bul_X_Pos + Bul_X_Motion;
//		Bul_Y_Pos <= Bul_Y_Pos + Bul_Y_Motion;
//		is_bul <= 1; working movement
			if ((Bul_Y_Pos * 20 + Bul_X_Pos) == whereHeAt) begin
						hitted <= 1'b1;
						change <= 0;
						Bul_X_Pos <= -1;
						Bul_Y_Pos <= -1;
						is_bul <= 0;
					end
					else begin
						hitted <= 1'b0;
						case (map[Bul_Y_Pos * 20 + Bul_X_Pos])
							0 : begin
									change <= 0;
									Bul_X_Motion <= Bul_X_Motion;
									Bul_Y_Motion <= Bul_Y_Motion;
									Bul_X_Pos <= Bul_X_Pos + Bul_X_Motion;
									Bul_Y_Pos <= Bul_Y_Pos + Bul_Y_Motion;
									is_bul <= 1;
								 end
							1 : begin
									change <= 0;
									Bul_X_Pos <= -1;
									Bul_Y_Pos <= -1;
									is_bul <= 0;
								 end
							2 : begin
									change <= Bul_Y_Pos * 20 + Bul_X_Pos;
									Bul_X_Pos <= -1;
									Bul_Y_Pos <= -1;
									is_bul <= 0;
								 end
							3 : begin
									Bul_X_Pos <= -1;
									Bul_Y_Pos <= -1;
									is_bul <= 0;
									if (!player)
										won <= 1'b1;
								 end
							4 : begin
									Bul_X_Pos <= -1;
									Bul_Y_Pos <= -1;
									is_bul <= 0;
									if (player)
										won <= 1'b1;
								 end	 
							default begin
									change <= 0;
									Bul_X_Pos <= -1;
									Bul_Y_Pos <= -1;
									is_bul <= 0;
									
								 end
							endcase
			end //end of if not at the enemy
	    end
	    else begin
			 hitted <= 1'b0;
		    change <= 0;
		    if (attempt) begin
			    case (dir)
				  0 :  begin Bul_X_Motion <= 0;
					     Bul_Y_Motion <= -1;
				       end
				    1 :  begin Bul_X_Motion <= -1;
					     Bul_Y_Motion <= 0;
				       end
				    2 :  begin Bul_X_Motion <= 0;
					     Bul_Y_Motion <= 1;
				       end
				    default :  begin Bul_X_Motion <= 1;
					     Bul_Y_Motion <= 0;
				       end
			    endcase
			    Bul_X_Pos <= Tank_X_Pos + Tank_X_Motion;
			    Bul_Y_Pos <= Tank_Y_Pos + Tank_Y_Motion;
			    is_bul <= 1;
				 attempt <= 0;
		    end
		    else begin
			Bul_X_Motion <= Bul_X_Motion;
			Bul_Y_Motion <= Bul_Y_Motion;
			Bul_X_Pos <= Bul_X_Pos;
			Bul_Y_Pos <= Bul_Y_Pos;
			is_bul <= 0;
		    end
			    
		    
	    end
	
    end
    end


	assign	TankX = Tank_X_Pos;
	assign	TankY = Tank_Y_Pos;

   
    
    assign BulX = Bul_X_Pos;
    assign BulY = Bul_Y_Pos;
	    
endmodule
