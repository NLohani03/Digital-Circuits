--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
library work;
---------------------------------------------------------------------------------
entity Inverter is
 	port (
			grappler, extender, motion, RESET										: in std_logic;
			grapplerout, extenderout, motionout, RESETout						: out std_logic
			);

end entity Inverter;
---------------------------------------------------------------------------------
architecture inverter_logic of Inverter is
 
begin

--- Ouputs with correct boolean equations using input operands

grapplerout <= not grappler;
extenderout <= not extender;
motionout <= not motion;
RESETout <= not RESET;
				 
end architecture inverter_logic;
 
 