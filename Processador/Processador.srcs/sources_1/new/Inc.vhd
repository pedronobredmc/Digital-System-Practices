library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
entity inc is
    generic(
        N:integer:=16;
        val:integer:=2    
    );
    Port (
        Q: in std_logic_vector(N-1 downto 0);
        D: out std_logic_vector(N-1 downto 0)
    );
end inc;

architecture Behavioral of inc is
begin
    D<= Q + val;

end Behavioral;
