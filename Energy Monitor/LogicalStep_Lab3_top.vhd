--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
	--HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 
component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;
------------------------------------------------------------------	
component Tester port (
		MC_TESTMODE				: in  std_logic;
		I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
		input1					: in  std_logic_vector(3 downto 0);
		input2					: in  std_logic_vector(3 downto 0);
		TEST_PASS  				: out	std_logic							 
		); 
	end component;
------------------------------------------------------------------	
component HVAC 	port (
		HVAC_SIM					: in boolean;
		clk						: in std_logic; 
		run_n		   			: in std_logic;
		increase, decrease	: in std_logic;
		temp						: out std_logic_vector (3 downto 0)
		);
	end component;
------------------------------------------------------------------
component Compx4 port ( 
			A, B : in std_logic_vector(3 downto 0); 
			AGTB_out, AEQB_out, ALTB_out : out std_logic    
			);
end component;
-----------------------------------------------------------------------------------
component MUX port (
			vacation_mode 									: in std_logic; 
			desired_temp, vacation_temp 				: in std_logic_vector(3 downto 0);
			mux_temp				 							: out std_logic_vector(3 downto 0)
			);

end component;
-------------------------------------------------------------------------------
component Inverter port (
			pb_n0, pb_n1, pb_n2, pb_n3										: in std_logic;
			pb_n0out, pb_n1out, pb_n2out, pb_n3out						: out std_logic
			);

end component;
-------------------------------------------------------------------------------------------
component Energy_Monitor port (
			AGTB, AEQB, ALTB, vacation_mode, MC_test, window_open, door_open : in std_logic; 
			furnace, at_temp, AC, blower, window, door, vacation: out std_logic;
			run_n, increase, decrease   : out std_logic
        );
end component;

------------------------------------------------------------------	
constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board
------------------------------------------------------------------	

-- global clock
signal clk_in									: std_logic;
signal mux_temp, current_temp 			: std_logic_vector(3 downto 0);
signal mt_7seg, ct_7seg						: std_logic_vector(6 downto 0);


--additional signals-------------------------------------------------------------------------
signal desired_temp 														: std_logic_vector (3 downto 0); 
signal vacation_temp 													: std_logic_vector (3 downto 0); 
signal vacation_mode, MC_test_mode_signal, window_open, door_open	: std_logic;
signal AGTB_signal, AEQB_signal, ALTB_signal	    				: std_logic;
signal MC_test_pass														: std_logic; 
signal decrease, increase, run_n 									: std_logic; 

------------------------------------------------------------------- 
begin -- Here the circuit begins
clk_in <= clkin_50;	--hook up the clock input

-- temp inputs hook-up to internal busses.
desired_temp <= sw(3 downto 0);
vacation_temp <= sw(7 downto 4);

----------------------------------------------------------------------------
--instantiation of all components with the appropriate singls and outputs
----------------------------------------------------------------------------
inst1: sevensegment port map (mux_temp, mt_7seg);
inst2: sevensegment port map (current_temp, ct_7seg);

inst3: segment7_mux port map (clk_in, mt_7seg, ct_7seg, seg7_data, seg7_char2, seg7_char1);	
inst4: Tester port map(MC_test_mode_signal, AEQB_signal, AGTB_signal, ALTB_signal, desired_temp, current_temp,leds(6)); 


inst5: HVAC port map (HVAC_SIM, clk_in, run_n, increase, decrease, current_temp ); 
inst6: Compx4 port map (mux_temp, current_temp, AGTB_signal, AEQB_signal, ALTB_signal); 

inst7: MUX port map (vacation_mode, desired_temp, vacation_temp, mux_temp);

inst8: Inverter port map(pb_n(0), pb_n(1), pb_n(2), pb_n(3), door_open, window_open, MC_test_mode_signal, vacation_mode); 
	 
inst9: Energy_Monitor port map (AGTB_signal, AEQB_signal, ALTB_signal, vacation_mode, MC_test_mode_signal, window_open, door_open, 
											leds(0), leds(1),leds(2),leds(3),leds(4),leds(5),leds(7), run_n, increase, decrease);

------------------------------------------------------------------
--HVAC_temp <= current_temp;  -- used for simulations only. Comment out for FPGA download compiles.	
------------------------------------------------------------------
end design;



