//-------------------------------------------------------------------------
//    This is built off of the ball.sv from lab 6 (very loosely!)
//
//		Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  tank ( input Reset, frame_clk, player,
					input [7:0] keycode,
	      input int map[300],
	      output [9:0]  TankX, TankY);
    
	logic [9:0] Tank_X_Pos, Tank_X_Motion, Tank_Y_Pos, Tank_Y_Motion;
	 
	int nextTile;
	//Psuedo Middle of the Bottom of the Screen (easy w)
	parameter [9:0] Tank1_X_Int= 32;  // Leftmost position on the X axis upon reset (starting position essentially)
	parameter [9:0] Tank1_Y_Int= 416;       // Topmost point on the Y axis upon reset
	parameter [9:0] Tank2_X_Int= 576;  // Leftmost position on the X axis upon reset (starting position essentially)
	parameter [9:0] Tank2_Y_Int= 32;       // Topmost point on the Y axis upon reset
	
	parameter [9:0] Tank_X_Step=1;      // Step size on the X axis 
	parameter [9:0] Tank_Y_Step=1;      // Step size on the Y axis 
			//This step size thing is VERY subject to change, I don't like it at all. Hard to gage w/o movement
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_
        if (Reset)  // Asynchronous Reset
        begin 
		if (player) //low means we're dealing with player 1
			begin
				Tank_Y_Motion <= 10'd0;
				Tank_X_Motion <= 10'd0;
				Tank_Y_Pos <= Tank1_Y_Int;
				Tank_X_Pos <= Tank1_X_Int;
			end
		else
			begin
				Tank_Y_Motion <= 10'd0;
				Tank_X_Motion <= 10'd0;
				Tank_Y_Pos <= Tank2_Y_Int;
				Tank_X_Pos <= Tank2_X_Int;
			end
        end
           
        else 
        	begin 				  
			
			if(player) //distinction here is important, player 1 uses WASD, player 2 used the arrow keys
				begin
					 case (keycode)
					8'h04 : begin

								Tank_X_Motion <= -32;//A
								Tank_Y_Motion<= 0;
							  end
					        
					8'h07 : begin
								
					        	  Tank_X_Motion <= 32;//D
							  Tank_Y_Motion <= 0;
							  end

							  
					8'h16 : begin

					        Tank_Y_Motion <= 32;//S
							  Tank_X_Motion <= 0;
							 end
							  
					8'h1A : begin
					        Tank_Y_Motion <= -32;//W
							  Tank_X_Motion <= 0;
							 end	  
					default: begin
							Tank_X_Motion <= 0;
							Tank_Y_Motion <= 0;
						 end
					   endcase
				end
			else
				begin
					begin
					 case (keycode)
					8'h4F : begin

								Tank_X_Motion <= -32;//Right
								Tank_Y_Motion<= 0;
							  end
					        
					8'h50 : begin
								
					        	  Tank_X_Motion <= 32;//Left
							  Tank_Y_Motion <= 0;
							  end

							  
					8'h51 : begin

					        Tank_Y_Motion <= 32;//Down
							  Tank_X_Motion <= 0;
							 end
							  
					8'h52 : begin
					        Tank_Y_Motion <= -32;//Up
							  Tank_X_Motion <= 0;
							 end	  
					default: begin
							Tank_X_Motion <= 0;
							Tank_Y_Motion <= 0;
						 end
					   endcase
				end
					Tank_Y_Pos <= (Tank_Y_Pos + Tank_Y_Motion);
					Tank_X_Pos <= (Tank_X_Pos + Tank_X_Motion);
					int nextTile <= map[Tank_Y_Pos[9:5] * 20 + Tank_X_Pos[9:5]];
					
					if(nextTile == 0)
						begin
							TankX <= Tank_X_Pos;
							TankY <= Tank_Y_Pos;
						end
					else
						begin
							TankX <= Tank_X_Pos - Tank_X_Motion;
							TankY <= Tank_Y_Pos - Tank_Y_Motion;
						end
		end  
    end
    end 

endmodule
