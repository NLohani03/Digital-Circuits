--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------
entity Energy_Monitor is
   port (
			AGTB, AEQB, ALTB, vacation_mode, MC_test, window_open, door_open : in std_logic; 
			furnace, at_temp, AC, blower, window, door, vacation: out std_logic;
			run_n, increase, decrease   : out std_logic
        );
end Energy_Monitor;

-- *****************************************************************************
-- *  Architecture                                                             *
-- *****************************************************************************

architecture Energy_Monitoring_Controller of Energy_Monitor is

signal activate: std_logic;

-----------------------------------------------------------------------------------------------
begin

energymonitor1:

	process (AGTB, AEQB, ALTB, vacation_mode, MC_test, window_open, door_open) is 
	
	begin
		--- Ouputs expressed as correct boolean expressions with input operands and signals
	
		furnace <= ((AGTB) and (not MC_test) and (not window_open) and (not door_open)); 
		at_temp <= AEQB; 
		AC <= ((ALTB) and (not MC_test) and (not window_open) and (not door_open)); 
		blower <= ((AGTB or ALTB) and (not MC_test) and (not window_open) and (not door_open)); 
		window <= window_open; 
		door <= door_open; 
		vacation <= vacation_mode; 
		
		decrease <= ALTB; 
		increase <= AGTB;
		run_n <= ((AEQB) or (window_open) or (door_open) or (MC_test));
		
end process;

end architecture Energy_Monitoring_Controller; 
----------------------------------------------------------------
