//32x32 Sprites
//20x15 Boxes - This means a 300 size array (299:0) to store the coords of boxes/tank
//640x480 Dispaly

module  color_mapper ( input        [9:0] DrawX, DrawY,
		      input	    int TankOneX, TankOneY, TankTwoX, TankTwoY, BulOneX, BulOneY, BulTwoX, BulTwoY,
		      input	    int map[300],
		       input		  blank,
                       output logic [7:0]  Red, Green, Blue );
    
    logic tankOne, tankTwo, bulOne, bulTwo;
	
    int ourTile;
	assign ourTile = (DrawY[9:5] * 20 + DrawX[9:5]);
	  
    int DistOneX, DistOneY;
    int DistTwoX, DistTwoY;
	 assign DistOneX = DrawX - TankOneX;
    	 assign DistOneY = DrawY - TankOneY;
	
	 assign DistTwoX = DrawX - TankTwoX;
    	 assign DistTwoY = DrawY - TankTwoY;
	  
    always_comb
    begin
	    if ( (TankOneX == DrawX[9:5]) && (TankOneY == DrawY[9:5]) ) 
            tankOne = 1'b1;
        else 
            tankOne = 1'b0;
     end 
	
    always_comb
    begin
	    if ( (TankTwoX == DrawX[9:5]) && (TankTwoY == DrawY[9:5]) ) 
            tankTwo = 1'b1;
        else 
            tankTwo = 1'b0;
     end 
    
    always_comb
    begin
	    if ( (BulOneX == DrawX[9:5]) && (BulOneY == DrawY[9:5]) ) 
            bulOne = 1'b1;
        else 
            bulOne = 1'b0;
     end
	
    always_comb
    begin
	    if ( (BulTwoX == DrawX[9:5]) && (BulTwoY == DrawY[9:5]) ) 
            bulTwo = 1'b1;
        else 
            bulTwo = 1'b0;
     end
	
	
	
	
    always_comb
    begin:RGB_Display
	    if (blank)
	begin
	    Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
	end
	else if (bulOne == 1'b1)
	begin
	    Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
		end
	else if (bulTwo == 1'b1)
	begin
	    Red = 8'hff;
            Green = 8'h00;
            Blue = 8'h00;
		end
	    else if (map[ourTile] == 1)
	begin
	    Red = 8'h50;
            Green = 8'h50;
            Blue = 8'h50;
	end
	    else if (map[ourTile] == 2)
	begin
	    Red = 8'h96;
            Green = 8'h4B;
            Blue = 8'h00;
	end
	    else if (map[ourTile] == 3)
	begin
	    Red = 8'hFF;
            Green = 8'hD7;
            Blue = 8'h00;
	end
	    else if (map[ourTile] == 4)
	begin
	    Red = 8'hFF;
            Green = 8'hD7;
            Blue = 8'h00;
	end
	    else if ((tankOne == 1'b1)) 
        begin 
            Red = 8'h00;
            Green = 8'h55;
            Blue = 8'h00;
        end
	    else if ((tankTwo == 1'b1))
	begin 
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h55;
	end
	    
        else 
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00;
        end      
    end 
    
endmodule
