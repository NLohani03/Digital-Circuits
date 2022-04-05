--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------
entity Compx4 is
   port (
				A, B : in std_logic_vector(3 downto 0); 
				AGTB_out, AEQB_out, ALTB_out : out std_logic 
        );
end Compx4;
                                                           
-- *****************************************************************************
architecture Four_Bit_Comparator of Compx4 is

component Compx1 
	port ( 
			A, B : in std_logic; 
			AgreatB, AequalB, AlessB : out std_logic  
			);
end component;

----------------------------------------------------------------
signal AGTB, AEQB, ALTB : std_logic_vector (3 downto 0);  
begin

-- Outputs expressed as boolean equations of operand inputs

AGTB_out <=	((AGTB(3)) or
				 (AEQB(3) and AGTB(2)) or
				 (AEQB(3) and AEQB(2) and AGTB(1)) or
				 (AEQB(3) and AEQB(2) and AEQB(1) and AGTB(0))
			);

AEQB_out <= (AEQB(3) and AEQB(2) and AEQB(1) and AEQB(0)); 


ALTB_out <= ((ALTB(3)) or
				 (AEQB(3) and ALTB(2)) or 
				 (AEQB(3) and AEQB(2) and ALTB(1)) or 
				 (AEQB(3) and AEQB(2) and AEQB(1) and ALTB(0))
		  ); 
		
------instantiation of four single bit comparators-----------------------------

inst1: Compx1 port map (A(3), B(3), AGTB(3), AEQB(3), ALTB(3));
inst2: Compx1 port map (A(2), B(2), AGTB(2), AEQB(2), ALTB(2));
inst3: Compx1 port map (A(1), B(1), AGTB(1), AEQB(1), ALTB(1));
inst4: Compx1 port map (A(0), B(0), AGTB(0), AEQB(0), ALTB(0));
										 
end architecture Four_Bit_Comparator; 
----------------------------------------------------------------
