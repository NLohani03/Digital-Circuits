--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------------------------
entity U_D_Bin_Counter4bit is 
		port (
					clk 				: in std_logic := '0';
					reset 			: in std_logic := '0';
					clk_en 			: in std_logic := '0';	
					up1_down0 		: in std_logic := '0';
					counter_bits 	: out std_logic_vector( 3 downto 0)
			
			); 
end entity;

architecture one of U_D_Bin_Counter4bit is 

signal ud_bin_counter : unsigned(3 downto 0); 

begin 

process(clk, reset, clk_en, up1_down0) is 
begin
	if (reset = '1') then 
				ud_bin_counter <= "0000"; 
				
	elsif (rising_edge(clk)) then
			
			if ((up1_down0 = '1') and (clk_en = '1')) then 
				ud_bin_counter <= (ud_bin_counter + 1); 
			
			elsif ((up1_down0 = '0') and (clk_en = '1')) then
				ud_bin_counter <= (ud_bin_counter - 1); 
				
			end if; 
			
	end if;

end process; 

	
counter_bits <= std_logic_vector(ud_bin_counter);
	
end one; 