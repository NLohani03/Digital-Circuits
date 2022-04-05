--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
library work;

entity mux_out is
 	port (
			mux_num0, mux_num1 				: in std_logic_vector(4 downto 0);
			muxout_select 						: in std_logic; 
			mux_out				 				: out std_logic_vector(4 downto 0)
			);

end entity mux_out;

architecture muxout_logic of mux_out is
 
begin
 
--for the multiplexing of two mux input busses
with muxout_select select 
mux_out <= mux_num0 when '0', 
			  mux_num1 when '1'; 
				
end architecture muxout_logic;
 
 