--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
library work;
-----------------------------------------------------------------------------------
entity MUX is
 	port (
			desired_temp, vacation_temp 				: in std_logic_vector(3 downto 0);
			vacation_mode 									: in std_logic; 
			mux_temp				 							: out std_logic_vector(3 downto 0)
			);

end entity MUX;
-----------------------------------------------------------------------------------

architecture mux_logic of MUX is
 
begin
 
--for the multiplexing of two mux input busses
with vacation_mode select 
mux_temp <= desired_temp when '0', 
			   vacation_temp when '1'; 
				
end architecture mux_logic;
 
 