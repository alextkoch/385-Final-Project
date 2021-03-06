
module finalproject (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;
	int tank1x, tank2x, tank1y, tank2y;
	int bul1x, bul2x, bul1y, bul2y;
	int change1, change2;
	logic win1, win2;
	logic hitted1, hitted2;
	logic pixel1, pixel2, pixel_bul, pixel_brk, pixel_bush, pixel_rck;
	logic [7:0] addr;
	logic [31:0] data;
	int dir1, dir2;
	logic reset2;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	final_proj_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );
	
	int map[300];

//0 = Nothing, it can be blank or store a bullet or store a tank!
//1 = Unbreakable borderwall
//2 = Destructable Wall
//3 = P1 Base
//4 = P2 Base
	logic slow_clk;
	
	vga_controller theVGA (.Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), .blank(blank), .sync(sync), .DrawX(drawxsig), .DrawY(drawysig));
	
	graphics drawing(.addr(addr), .data(data));
	
	slower_clock slowerClk(.Reset(Reset_h), .Clk(VGA_VS), .slower_Clk(slow_clk));
	
	cartographer theMap (.Reset(Reset_h), .Clk(slow_clk), .Reset2(reset2), .keycode(keycode), .win1(win1), .win2(win2), .map(map), .change1(change1), .change2(change2));
	
	tank	player1	(.player(1'b1), .Reset2(reset2), .dir(dir1), .map(map), .loss(win2), .win(win1), .change(change1), .Reset(Reset_h), .frame_clk(slow_clk), .keycode(keycode), .TankX(tank1x), .TankY(tank1y), .BulX(bul1x), .BulY(bul1y), .enemyX(tank2x), .enemyY(tank2y), .gotHit(hitted2), .hitted(hitted1));
	tank	player2	(.player(1'b0), .Reset2(reset2), .dir(dir2), .map(map), .loss(win1), .win(win2), .change(change2), .Reset(Reset_h), .frame_clk(slow_clk), .keycode(keycode), .TankX(tank2x), .TankY(tank2y), .BulX(bul2x), .BulY(bul2y), .enemyX(tank1x), .enemyY(tank1y), .gotHit(hitted1), .hitted(hitted2));
	
	pixel pixel_tank1(.bush(1'b0), .rck(1'b0), .bul(1'b0), .brk(1'b0), .dir(dir1), .DrawX(drawxsig[4:0]), .DrawY(drawysig[4:0]), .pixel(pixel1));
	pixel pixel_tank2(.bush(1'b0), .rck(1'b0), .bul(1'b0), .brk(1'b0), .dir(dir2), .DrawX(drawxsig[4:0]), .DrawY(drawysig[4:0]), .pixel(pixel2));
	pixel pixel_bullet(.bush(1'b0), .rck(1'b0), .bul(1'b1), .brk(1'b0), .dir(4), .DrawX(drawxsig[4:0]), .DrawY(drawysig[4:0]), .pixel(pixel_bul));
	pixel pixel_brick(.bush(1'b0), .rck(1'b0), .bul(1'b0), .brk(1'b1), .dir(5), .DrawX(drawxsig[4:0]), .DrawY(drawysig[4:0]), .pixel(pixel_brk));
	pixel pixel_bsh(.bush(1'b1), .rck(1'b0), .bul(1'b0), .brk(1'b0), .dir(5), .DrawX(drawxsig[4:0]), .DrawY(drawysig[4:0]), .pixel(pixel_bush));
	pixel pixel_rock(.bush(1'b0), .rck(1'b1), .bul(1'b0), .brk(1'b0), .dir(5), .DrawX(drawxsig[4:0]), .DrawY(drawysig[4:0]), .pixel(pixel_rck));
	
	color_mapper theColorMapper (.pixel1(pixel1), .pixel2(pixel2), .pixel_bush(pixel_bush), .pixel_rck(pixel_rck), .pixel_bul(pixel_bul), .pixel_brk(pixel_brk), .blank(!blank), .map(map), .TankOneX(tank1x), .TankOneY(tank1y), .TankTwoX(tank2x), .TankTwoY(tank2y), .BulOneX(bul1x), .BulOneY(bul1y), .BulTwoX(bul2x), .BulTwoY(bul2y), .DrawX(drawxsig), .DrawY(drawysig), .Red(Red), .Green(Green), .Blue(Blue));

endmodule
