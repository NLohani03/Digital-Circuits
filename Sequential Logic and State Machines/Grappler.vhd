

--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------

entity Grappler is 
		port (
					clk_input, reset, grappler_push, grappler_en  				: in std_logic;
					led																		: out std_logic  
			
			); 
end entity;


architecture sm of Grappler is
 
  
 type state_names is (closed, openn, opening, closing);   		-- list all the STATE_NAMES values
 signal current_state, next_state	:  state_names;     	-- signals of type STATE_NAMES

begin
---------------------------------------------------------------------
--State Machine
---------------------------------------------------------------------

-- Register_Logic Process:

Register_Section: process (clk_input, reset, next_state)  -- this process synchronizes the activity to a clock
begin
	if (reset = '1') then
		current_state <= closed;
	elsif(rising_edge(clk_input)) then
		current_state <= next_State;
	end if;
end process;

--Transition_Logic Process: 
Transtion_Section : process (grappler_push, grappler_en, current_state) 	
begin
	case current_state is 
		
			when closed => 	
									if ( grappler_push = '1' and grappler_en = '1') then
										next_state <= opening; 
									else
										next_state <= closed; 
									end if;
			
			when opening => 	 
									if (grappler_push = '0') then 
										next_state <= openn; 
									else
										next_state <= opening; 
									end if; 
			
			when openn =>   
									if ( grappler_push = '1' and grappler_en = '1') then 
										next_state <= closing; 
									else
										next_state <= openn; 
									end if; 
		
			when closing => 	
									if (grappler_push = '0') then
										next_state <= closed;
									else
										next_state <= closing; 
									end if; 
			
			
	end case;
end process;

--Decoder_Logic Process: 
Decoder_Section: process (current_state)
begin
	case current_state is 
			when closed =>
									led <= '0';
			when opening => 
									led <= '0'; 
			when openn => 		
									led <= '1'; 
			when closing => 	 
									led <= '1'; 
	end case; 
end process; 

end architecture sm; 
