library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity mux_2x1 is
    generic (N:integer:=16);
    Port ( I0: in std_logic_vector (N-1 downto 0);
    I1: in std_logic_vector (N-1 downto 0);
    sel: in std_logic; 
    O0: out std_logic_vector (N-1 downto 0)
    );
end mux_2x1;
architecture Behavioral of mux_2x1 is   
begin
   with sel select
   O0 <= I1 when '1',
         I0 when others; 
end Behavioral;
