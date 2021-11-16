//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------
//32x32 Sprites
//20x15 Boxes - This means a 300 size array (299:0) to store the coords of boxes/tank
//640x480 Dispaly

module  color_mapper ( input        [9:0] TankOneX, TankOneY, TankTwoX, TankTwoY, DrawX, DrawY, 
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on;
	  
    int DistOneX, DistOneY;
    int DistTwoX, DistTwoY;
	 assign DistOneX = DrawX - TankOneX;
    	 assign DistOneY = DrawY - TankOneY;
	
	 assign DistTwoX = DrawX - TankTwoX;
    	 assign DistTwoY = DrawY - TankTwoY;
	  
    always_comb
    begin:Ball_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'h55;
            Blue = 8'h00;
        end       
        else 
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h7f - DrawX[9:3];
        end      
    end 
    
endmodule
