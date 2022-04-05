--Author: Group 3, Nandita Lohani, Puneet Bhullar
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------
entity Compx1 is
   port (
				A, B : in std_logic; 
				AgreatB, AequalB, AlessB : out std_logic       
        );
end Compx1;

-- *****************************************************************************
-- *  Architecture                                                             *
-- *****************************************************************************

architecture Single_Bit_Comparator of Compx1 is

begin

-- boolean logic applied to each output with input operands

AgreatB <= A and (not B); 
AequalB <=  A xnor B;
AlessB  <=  (not A) and B;
										 
end architecture Single_Bit_Comparator; 
----------------------------------------------------------------