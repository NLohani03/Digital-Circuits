----XY_Motion

--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------

entity XY_Motion is 
		port (
					clk_input, reset   																									: in std_logic;
					X_LT, X_EQ, X_GT, motion, Y_LT, Y_EQ, Y_GT, extender_out													: in std_logic;
					clk_en_X, up_down_X, error_led, capture_XY,clk_en_Y, up_down_Y, extender_en						: out std_logic 
					
					
			); 
end entity;

architecture sm of XY_Motion is
 
  
 type state_names is (initial, button_down, moving, error);   -- list all the STATE_NAMES values

 
 signal current_state, next_state	:  state_names;     	-- signals of type STATE_NAMES


---------------------------------------------------------------------
--State Machine
---------------------------------------------------------------------
begin
-- Register_Logic Process:

Register_Section: process (clk_input, reset, next_state)  -- this process synchronizes the activity to a clock
begin
	if (reset = '1') then
		current_state <= initial;
	elsif(rising_edge(clk_input)) then
		current_state <= next_State;
	end if;
end process;


--Transition_Logic Process: 
Transtion_Section : process (current_state, X_LT, X_EQ, X_GT, motion, Y_LT, Y_EQ, Y_GT, extender_out ) 	
begin
	case current_state is 
	
		
									
			when initial =>
									if (motion = '1' and extender_out = '1') then 
										next_state <= error; 
									
									elsif( motion = '1') then 
										next_state <= button_down; 
										
									else
									 next_state <= initial; 
									 
									end if;
									
			when error =>
									if (extender_out = '0') then 
										next_state <= initial; 
									else 
										next_state <= error; 
									end if; 					
			
			
			when button_down =>
									if (motion = '0') then 
										next_state <= moving; 
									else 
										next_state <= button_down; 
									end if; 
				
			
			when moving => 
									if (X_EQ = '1' and Y_EQ = '1') then
										next_state <= initial; 
									else 
										next_state <= moving; 
									end if; 
									
			
	
									
	end case;
end process;


--Decoder_Logic Process: 
Decoder_Section: process (current_state, X_LT, X_EQ, X_GT, motion, Y_LT, Y_EQ, Y_GT, extender_out, clk_input)
begin
	case current_state is 

								when initial =>
														extender_en <= X_EQ and Y_EQ;
														clk_en_x <= '0'; 
														clk_en_y <= '0';
														capture_XY <= '0';
														error_led <= '0'; 
												 
								when error =>
														error_led <= clk_input; 	
														
								when button_down =>
													
														capture_XY <= '1';
														
								when moving =>
														clk_en_x <= X_LT or X_GT; 
														clk_en_y <= Y_LT or Y_GT; 
														extender_en <= '0'; 
														capture_XY <= '0'; 
----														up_down_x <= X_LT;
----														up_down_y <= Y_LT; 
														
													----for the x motion
														if (X_LT = '1') then 
															up_down_x <= '1'; ---x coordinate is less than target so must bring it up
														
														elsif (X_EQ = '1') then 
															clk_en_x <= '0'; -- x is t target so we can disable the counter 
														
														elsif (X_GT = '1') then
															up_down_x <= '0'; -- x is higher than target, so we must bring it down
														
														end if;
														
														
														--for the y motion, bring it down if the y coordinate is too high and up if too low and disbale counter if at target
														if (Y_LT = '1') then
															up_down_y <= '1'; 
															
														elsif (Y_EQ = '1') then 
															clk_en_y <= '0'; 
															 
															
														elsif (Y_GT = '1') then
															up_down_y <= '0'; 
															
														end if; 
														
			
	end case; 
end process; 

end architecture sm; 
