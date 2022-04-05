--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------------------------
entity Bidir_shift_reg is 
		port (
					clk 				: in std_logic := '0';
					reset 			: in std_logic := '0';
					clk_en 			: in std_logic := '0';	
					left0_right1 	: in std_logic := '0';
					reg_bits 		: out std_logic_vector( 3 downto 0)
			
			); 
end entity;

architecture one of Bidir_shift_reg is 

signal sreg : std_logic_vector(3 downto 0); 

begin 

process(clk, reset, clk_en, left0_right1) is 
begin
	if (reset = '1') then 
				sreg <= "0000"; 
				
	elsif (rising_edge(clk) and (clk_en = '1')) then
			
			if (left0_right1 = '1') then --if right shift is on 
				
				sreg (3 downto 0) <= '1' & sreg (3 downto 1);  -- right bit shifts
				
			elsif (left0_right1 = '0') then
			
				sreg (3 downto 0) <= sreg(2 downto 0) & '0'; -- left bit shifts 
				
			end if; 
			
	end if; 
	reg_bits <= sreg;
	
end process;
  
end architecture one; 