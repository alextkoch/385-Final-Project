
module  tank ( input Reset, frame_clk, player,
					input [7:0] keycode,
	      input int old_map[300],
	      output int  TankX, TankY, BulX, BulY, change
			);

	int Tank_X_Pos, Tank_X_Motion, Tank_Y_Pos, Tank_Y_Motion, Tank_X_Pot, Tank_Y_Pot;
	int potX_tank, potY_tank;
	int nextTile_tank, valid_tank;
	
	int Bul_X_Pos, Bul_X_Motion, Bul_Y_Pos, Bul_Y_Motion, Bul_X_Pot, Bul_Y_Pot;
	int potX_bul, potY_bul;
	int nextTile_bul, valid_bul;
	
	int dir;
	
	logic is_bul, attempt;
		
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
						 
					8'h14 : begin // q, shoot bullet
					        	Tank_Y_Motion <= 0;
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
					8'h28 : begin // enter, shoot bullet
					        	Tank_Y_Motion <= 0;
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
			potX_tank <= Tank_X_Pos + Tank_X_Motion;
			potY_tank <= Tank_Y_Pos + Tank_Y_Motion;
				
			nextTile_tank <= potY_tank * 20 + potX_tank;
			
			valid_tank <= old_map[nextTile_tank];
				
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
						

	    if (is_bul) begin
	    	Bul_X_Motion <= Bul_X_Motion;
		Bul_Y_Motion <= Bul_Y_Motion;
		Bul_X_Pos <= Bul_X_Pos + Bul_X_Motion;
		Bul_Y_Pos <= Bul_Y_Pos + Bul_Y_Motion;
		is_bul <= 1;
	    end
	    else begin
		    
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
			    Bul_X_Pos <= Tank_X_Pos + Bul_X_Motion;
			    Bul_Y_Pos <= Tank_Y_Pos + Bul_Y_Motion;
			    is_bul <= 1;
		    end
		    else begin
			Bul_X_Motion <= Bul_X_Motion;
			Bul_Y_Motion <= Bul_Y_Motion;
			Bul_X_Pos <= Bul_X_Pos;
			Bul_Y_Pos <= Bul_Y_Pos;
			is_bul <= 0;
		    end
			    
		    
	    end
	
	// functionalities of bullet
	potX_bul <= Bul_X_Pos + Bul_X_Motion;
	potY_bul <= Bul_Y_Pos + Bul_Y_Motion;
				
	nextTile_bul <= potY_bul * 20 + potX_bul;
	valid_bul <= old_map[nextTile_bul];
	
	
			case (valid_bul)
				1 : begin // disappear if hits the wall
					Bul_Y_Pos <= -1;
					Bul_X_Pos <= -1;
					is_bul <= 0;
					change <= 0;
				    end
				
				2 : begin // destroy the brick
					Bul_Y_Pos <= -1;
					Bul_X_Pos <= -1;
					is_bul <= 0;
					change <= nextTile_bul;
				    end
				default : begin
					Bul_X_Pos <= Bul_X_Pos;
					Bul_Y_Pos <= Bul_Y_Pos;
					is_bul <= 1;
					change <= 0;
				          end
			endcase
    end
    end


    assign TankX = Tank_X_Pos;
    assign TankY = Tank_Y_Pos;
	
    assign BulX = Bul_X_Pos;
    assign BulY = Bul_Y_Pos;
	 
	 
	    
endmodule
