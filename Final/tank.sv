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


module  tank ( input Reset, frame_clk,
					input [7:0] keycode,
	      output [9:0]  TankX, TankX);
    
	logic [9:0] Tank_X_Pos, Tank_X_Motion, Tank_Y_Pos, Tank_Y_Motion;
	 
	//Psuedo Middle of the Bottom of the Screen (easy w)
	parameter [9:0] Tank_X_Int= 350;  // Leftmost position on the X axis upon reset (starting position essentially)
	parameter [9:0] Tank_Y_Int= 500;       // Topmost point on the Y axis upon reset
	parameter [9:0] Tank_X_Step=1;      // Step size on the X axis 
	parameter [9:0] Tank_Y_Step=1;      // Step size on the Y axis 
			//This step size thing is VERY subject to change, I don't like it at all. Hard to gage w/o movement
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_
        if (Reset)  // Asynchronous Reset
        begin 
            			Tank_Y_Motion <= 10'd0;
				Tank_X_Motion <= 10'd0;
				Tank_Y_Pos <= Tank_Y_Int;
				Tank_X_Pos <= Tank_X_Int;
        end
           
//         else 
//         begin 
// 				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
// 					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  
// 				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
// 					  Ball_Y_Motion <= Ball_Y_Step;
					  
// 				  else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
// 					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  
// 				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
// 					  Ball_X_Motion <= Ball_X_Step;
					  
// 				 else 
// 					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 
// 				 case (keycode)
// 					8'h04 : begin

// 								Ball_X_Motion <= -1;//A
// 								Ball_Y_Motion<= 0;
// 							  end
					        
// 					8'h07 : begin
								
// 					        Ball_X_Motion <= 1;//D
// 							  Ball_Y_Motion <= 0;
// 							  end

							  
// 					8'h16 : begin

// 					        Ball_Y_Motion <= 1;//S
// 							  Ball_X_Motion <= 0;
// 							 end
							  
// 					8'h1A : begin
// 					        Ball_Y_Motion <= -1;//W
// 							  Ball_X_Motion <= 0;
// 							 end	  
// 					default: ;
// 			   endcase
				 
// 				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
// 				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);

// 		end  
    end
       
    assign TankX = Tank_X_Pos;
   
    assign TankY = Tank_Y_Pos;   

endmodule
