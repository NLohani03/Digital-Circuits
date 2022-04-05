--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
library work;
---------------------------------------------------------------------------------
entity Inverter is
 	port (
			pb_n0, pb_n1, pb_n2, pb_n3										: in std_logic;
			pb_n0out, pb_n1out, pb_n2out, pb_n3out						: out std_logic
			);

end entity Inverter;
---------------------------------------------------------------------------------
architecture inverter_logic of Inverter is
 
begin

--- Ouputs with correct boolean equations using input operands

pb_n0out <= not pb_n0;
pb_n1out <= not pb_n1;
pb_n2out <= not pb_n2;
pb_n3out <= not pb_n3;
				 
end architecture inverter_logic;
 
 