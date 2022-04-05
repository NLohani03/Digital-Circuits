LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
	Clk			: in	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 
	leds			: out std_logic_vector(7 downto 0);

------------------------------------------------------------------	
--	xreg, yreg	: out std_logic_vector(3 downto 0);-- (for SIMULATION only)
--	xPOS, yPOS	: out std_logic_vector(3 downto 0);-- (for SIMULATION only)
------------------------------------------------------------------	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment display (for LogicalStep only)
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector (for LogicalStep only)
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector (for LogicalStep only)
	
	);
END LogicalStep_Lab4_top;

ARCHITECTURE Circuit OF LogicalStep_Lab4_top IS
------------------------------------------------------------------
-- Project Components Used
------------------------------------------------------------------- 
COMPONENT Clock_Source 	port (SIM_FLAG: in boolean;clk_input: in std_logic;clock_out: out std_logic);
END COMPONENT;
------------------------------------------------------------------
component SevenSegment
  port 
   (
      hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
      sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
end component SevenSegment;
--------------------------------------------------------------------
component segment7_mux 
  port 
   (
      clk       	: in  std_logic := '0';
		DIN2 			: in  std_logic_vector(6 downto 0);	
		DIN1 			: in  std_logic_vector(6 downto 0);
		DOUT			: out	std_logic_vector(6 downto 0);
		DIG2			: out	std_logic;
		DIG1			: out	std_logic
   );
end component segment7_mux;
------------------------------------------------------------------
component Bidir_shift_reg 
	port
	(
		clk 				: in std_logic := '0';
		reset 			: in std_logic := '0';
		clk_en 			: in std_logic := '0';	
		left0_right1 	: in std_logic := '0';
		reg_bits 		: out std_logic_vector( 3 downto 0)
	
	); 
end component Bidir_shift_reg; 
------------------------------------------------------------------
component Compx4 
	port
	(
			A, B : in std_logic_vector(3 downto 0); 
			AGTB_out, AEQB_out, ALTB_out : out std_logic 
	); 
end component Compx4; 
------------------------------------------------------------------
component XY_Motion
	port
	(
			clk_input, reset   																									: in std_logic;
			X_LT, X_EQ, X_GT, motion, Y_LT, Y_EQ, Y_GT, extender_out													: in std_logic;
			clk_en_X, up_down_X, error_led, capture_XY,clk_en_Y, up_down_Y, extender_en						: out std_logic
	
	); 
end component XY_Motion; 
------------------------------------------------------------------
component Extender 
	port 
	(
			clk_input, reset, extender, extender_en	  				: in std_logic;
			leds																	: in std_logic_vector (3 downto 0);
			clk_en, shift_leftright, grappler_en, extender_out 	: out std_logic	
	); 
end component Extender; 
------------------------------------------------------------------	
component Grappler 
	port
	(
			clk_input, reset, grappler_push, grappler_en  				: in std_logic;
			led																		: out std_logic
	);
end component Grappler; 
------------------------------------------------------------------
component U_D_Bin_Counter4bit 
	port 
	(
					clk 				: in std_logic := '0';
					reset 			: in std_logic := '0';
					clk_en 			: in std_logic := '0';	
					up1_down0 		: in std_logic := '0';
					counter_bits 	: out std_logic_vector( 3 downto 0)
			
	); 
end component U_D_Bin_Counter4bit;
------------------------------------------------------------------
component registerr 
	port(
	clk : in std_logic := '0';
	reset : in std_logic := '0';
	target : in std_logic_vector (3 downto 0);
	capture_XY : in std_logic := '0';
	position : out std_logic_vector (3 downto 0) 
); 

end component registerr; 
------------------------------------------------------------------
component Inverter 
 	port 
	(
			grappler, extender, motion, RESET										: in std_logic;
			grapplerout, extenderout, motionout, RESETout						: out std_logic
	);

end component Inverter;
------------------------------------------------------------------
constant SIM_FLAG : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board
------------------------------------------------------------------	
------------------------------------------------------------------	
-- All Signals
signal clk_in, clock	: std_logic;
signal RESET : std_logic; 


signal clk_en_fromext : std_logic; 
signal left_right 	 : std_logic; 
signal ext_pos 		 : std_logic_vector (3 downto 0); 

signal X_pos : std_logic_vector (3 downto 0); 
signal Y_pos : std_logic_vector (3 downto 0); 

signal decoderout0 : std_logic_vector (6 downto 0); 
signal decoderout1 : std_logic_vector (6 downto 0);

signal X_reg : std_logic_vector ( 3 downto 0); 
signal Y_reg : std_logic_vector ( 3 downto 0); 

signal X_GT	: std_logic;
signal X_EQ	: std_logic;
signal X_LT	: std_logic;

signal Y_GT	: std_logic;
signal Y_EQ	: std_logic;
signal Y_LT	: std_logic;

signal motion : std_logic; 
signal extender_out : std_logic;
signal extender_en : std_logic; 

signal clk_en_x : std_logic; 
signal up_down_x: std_logic; 

signal clk_en_y : std_logic; 
signal up_down_y : std_logic; 

signal error : std_logic; 
signal Capture_XY : std_logic;

signal extender_push : std_logic; 
signal grappler_push : std_logic;  

signal grappler_en :std_logic; 
signal grappler_on :std_logic; 

signal X_target : std_logic_vector (3 downto 0); 
signal Y_target :std_logic_vector (3 downto 0); 

begin
clk_in <= clk; 
leds(5 downto 2) <= ext_pos;
leds(1) <= grappler_on; 
leds(0) <= error;


X_target <= sw(7 downto 4); 
Y_target <= sw(3 downto 0); 
---comment for FPGA  
--xPOS <= X_pos; 
--yPOS <= Y_pos; 
----
--xreg <= X_reg; 
--yreg <= Y_reg; 
-- 
--------------------------------------------------------------
-----clock instance-------------------------------------------
Clock_Selector: Clock_source port map(SIM_FLAG, clk_in, clock);

----decoder----------------------------------------------------
decoder0: SevenSegment port map (X_pos, decoderout0); 
decoder1: SevenSegment port map (Y_pos, decoderout1);
 
--make changes to mux cause of the 2 before 1 thing
mux: segment7_mux port map (clk_in, decoderout1, decoderout0, seg7_data, seg7_char2, seg7_char1); 

---bidirectional shift----------------------------------------
bidi_shift: Bidir_shift_reg port map (clock, RESET, clk_en_fromext, left_right, ext_pos); 

---4bitcomparator----------------------------------------------
fourbit0: Compx4 port map (X_pos, X_reg, X_GT, X_EQ, X_LT);
fourbit1: Compx4 port map (Y_pos, Y_reg, Y_GT, Y_EQ,  Y_LT);

---------XY_motion----------------------------------------------
xy: XY_Motion port map (clock, RESET, X_LT, X_EQ, X_GT, motion, Y_LT, Y_EQ, Y_GT, extender_out,
								clk_en_x, up_down_x, error, Capture_XY, clk_en_y, up_down_y, extender_en);

----------Extender----------------------------------------------
ext: Extender port map (clock, RESET, extender_push, extender_en, ext_pos, clk_en_fromext, left_right, grappler_en, extender_out); 

--------Grappler-----------------------------------------------------
grap: Grappler port map (clock, RESET, grappler_push, grappler_en, grappler_on); 

--------up/down shift-------------------------------------------------
updown0: U_D_Bin_Counter4bit port map (clock, RESET, clk_en_x, up_down_x, X_pos);
updown1: U_D_Bin_Counter4bit port map (clock, RESET, clk_en_y, up_down_y, Y_pos);

---------Registers------------------------------------------------------
reg0: registerr port map(clock, RESET, X_target, Capture_XY, X_reg);
reg1: registerr port map(clock, RESET, Y_target, Capture_XY, Y_reg);

---------Inverter-------------------------------------------------------
inv: Inverter port map (pb_n(0), pb_n(1), pb_n(2), '1', grappler_push, extender_push, motion, RESET); 
							

end Circuit;
