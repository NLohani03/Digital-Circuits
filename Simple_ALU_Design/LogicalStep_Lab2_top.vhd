--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity LogicalStep_Lab2_top is port (
	pb					: in	std_logic_vector(6 downto 0); 	-- push buttons used for data input selection/operation control
 	sw   				: in  std_logic_vector(15 downto 0); 	-- The switch inputs used for data inputs
   leds				: out std_logic_vector(5 downto 0) 		--  leds for outputs
	
); 
end LogicalStep_Lab2_top;

architecture Circuit of LogicalStep_Lab2_top is

-- Components to be Used ---
------------------------------------------------------------------- 
component hex_mux
 	port (
			hex_num3, hex_num2, hex_num1, hex_num0 : in std_logic_vector(3 downto 0);
			mux_select 										: in std_logic_vector(1 downto 0); 
			hex_out 											: out std_logic_vector(3 downto 0)
			);

end component;

component logic_proc
 	port (
			logic_in0,logic_in1 				: in std_logic_vector(3 downto 0);
			logic_select 						: in std_logic_vector(1 downto 0); 
			logic_out				 			: out std_logic_vector(3 downto 0)
			);
			
end component;

component full_adder_4bit 
 	port (
			cin						: in std_logic;
			hex_val_A, hex_val_B	: in std_logic_vector(3 downto 0);
			hex_sum 					: out std_logic_vector(3 downto 0);
		   carry_out				: out std_logic
			);

end component;


component mux_out 
 	port (
			mux_num0, mux_num1 				: in std_logic_vector(4 downto 0);
			muxout_select 						: in std_logic; 
			mux_out				 				: out std_logic_vector(4 downto 0)
			);

end component;
-- 
------------ Signals --------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- groups of logic signals with each group defined as std_logic_vector(MSB downto LSB)
	signal hex_A, hex_B, hex_C, hex_D															: std_logic_vector(3 downto 0);

--- some selector nets;
	signal hex_mux_sel0, hex_mux_sel1, logic_proc_sel										: std_logic_vector(1 downto 0);
	signal hex_mux_out0, hex_mux_out1, logic_proc_out, adder_bit_out 					: std_logic_vector (3 downto 0); 
	
--- some concatenation nets
	signal muxout_in0, muxout_in1																	: std_logic_vector(4 downto 0); 
	
	signal muxout_sel																					: std_logic;
	signal carry_out 																					: std_logic; 
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
begin

-- assign (connect) one end of each input group (bus) to sepecific switch inputs
hex_A <= sw(3 downto 0);
hex_B <= sw(7 downto 4);
hex_C <= sw(11 downto 8);
hex_D <= sw(15 downto 12);


-- assign 4 of the pb inputs to drive mux selection port
hex_mux_sel0 	<= pb(1 downto 0);
hex_mux_sel1 	<= pb(3 downto 2); 
logic_proc_sel <= pb(5 downto 4);
muxout_sel 		<= pb(6);

--combine singles through concatenation for the mux_out multiplexer inputs 
muxout_in0 		<= '0' & logic_proc_out; 
muxout_in1 		<= carry_out & adder_bit_out; 
----------------------------------------------------------------------------
----------------------------------------------------------------------------
--instances for hex_mux, logic processor, full adder 4 bit and mux_out component
inst0: hex_mux port map (hex_A, hex_B, hex_C, hex_D, hex_mux_sel0, hex_mux_out0); 
inst1: hex_mux port map (hex_A, hex_B, hex_C, hex_D, hex_mux_sel1, hex_mux_out1); 

inst2: logic_proc port map (hex_mux_out0, hex_mux_out1, logic_proc_sel, logic_proc_out);
inst3: full_adder_4bit port map ('0', hex_mux_out0, hex_mux_out1, adder_bit_out, carry_out);

inst4: mux_out port map (muxout_in0, muxout_in1, muxout_sel, leds(4 downto 0)); 
leds(5) <= pb(6);


end Circuit;

