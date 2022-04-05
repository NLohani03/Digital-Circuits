--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------

entity Extender is 
		port (
					clk_input, reset, extender, extender_en	  				: in std_logic;
					leds																	: in std_logic_vector (3 downto 0);
					clk_en, shift_leftright, grappler_en, extender_out 	: out std_logic
			
			); 
end entity;


architecture sm of Extender is
 
  
 type state_names is (extending, fully_extended, extender_pause, retracter_pause, retracting, fully_retracted);   -- list all the STATE_NAMES values

 
 signal current_state, next_state	:  state_names;     	-- signals of type STATE_NAMES

begin
---------------------------------------------------------------------
--State Machine
---------------------------------------------------------------------

-- Register_Logic Process:

Register_Section: process (clk_input, reset, next_state)  -- this process synchronizes the activity to a clock
begin
	if (reset = '1') then
		current_state <= fullY_retracted;
	elsif(rising_edge(clk_input)) then
		current_state <= next_State;
	end if;
end process;	


-- Transition_Logic Process: 
Transition_Section: process (extender, extender_en, leds, current_state) 

begin 
	case current_state is 
			
			
			when fully_retracted =>
									if ( extender = '1' and extender_en = '1') then 
										next_state <= extender_pause; 
									else 
										next_state <= fully_retracted; 
									end if;
			
			when extender_pause =>
									 if(extender = '0') then 
										next_state <= extending;
									else 
										next_state <= extender_pause; 
									end if; 
										
			when extending => 
									if (leds = "1111") then 
										next_state <= fully_extended; 
									else 
										next_state <= extending; 
									end if;
		
										
			when fully_extended =>
									if (extender = '1' and extender_en = '1') then
										next_state <= retracter_pause; 
									else 
										next_state <= fully_extended; 
									end if; 
			
			when retracter_pause =>
									 if(extender = '0') then 
										next_state <= retracting;
									else 
										next_state <= retracter_pause;
									end if;
									
			when retracting => 
									if (leds = "0000") then
										next_state <= fully_retracted; 
									else 
										next_state <= retracting; 
									end if;
			

									
	end case; 
end process; 
								

-- Decoder_Logic Process:
Decoder_Section: process (current_state) 

begin 
	case current_state is 
			
			when fully_retracted =>	--when its fully retracted, nothing should be on
											clk_en <= '0';
											shift_leftright <= '0';
											grappler_en <= '0';
											extender_out <= '0';
										
			when extender_pause =>	--when its paused, nothing should be on
											clk_en <= '0';
											shift_leftright <= '0';
											grappler_en <= '0';
											extender_out <= '0';
																		
											
			when extending =>			--when its extending, everything except the grappler should be on
											clk_en <= '1';
											shift_leftright <= '1';
											grappler_en <= '0';
											extender_out <= '1';
	
			
											
			when fully_extended =>	--when its fully retracted, nothing should be on
											clk_en <= '0';
											shift_leftright <= '0';
											grappler_en <= '1';
											extender_out <= '1';
										
									
			when retracter_pause =>	--when its fully extended, the extender should be out and the grappler should be on
											clk_en <= '0';
											shift_leftright <= '0';
											grappler_en <= '1';
											extender_out <= '1';
		
			when retracting =>		--when its retracting, grappler and left and right shift should be off
											clk_en <= '1';
											shift_leftright <= '0';
											grappler_en <= '0';
											extender_out <= '1'; 
			when others =>
											grappler_en <= '0';  
			
			
						
			
	end case; 
end process; 

end sm; 
 