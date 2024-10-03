library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity mux_4x1 is
    generic (N:integer:=16);
    Port ( I0  : in STD_LOGIC_VECTOR (N-1 downto 0);
           I1  : in STD_LOGIC_VECTOR (N-1 downto 0);
           I2  : in STD_LOGIC_VECTOR (N-1 downto 0);
           I3  : in STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           O0  : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end mux_4x1;

architecture Behavioral of mux_4x1 is    
begin
    O0 <= I0 when sel = "00" else
          I1 when sel = "01" else
          I2 when sel = "10" else
          I3 when sel = "11" else
          (others => '0');         
    
end Behavioral;
