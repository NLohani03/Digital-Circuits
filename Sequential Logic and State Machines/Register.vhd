----Register

--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------
entity registerr is port(
	clk : in std_logic := '0';
	reset : in std_logic := '0';
	target : in std_logic_vector (3 downto 0);
	capture_XY : in std_logic := '0';
	position : out std_logic_vector (3 downto 0) 
); 

end entity; 

architecture arch of registerr is 
begin 

registerr1:
process (clk, reset, capture_XY) is 
begin
		if (capture_XY = '1') then 
			position <= target; 
			
		elsif (reset = '1') then 
			position <= "0000"; 

		end if;

end process; 

end architecture arch; 
