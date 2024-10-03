library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity SP is
    generic(N:integer:= 16);
    Port ( D : in STD_LOGIC_vector(N-1 downto 0) ;
           Q : out STD_LOGIC_vector(N-1 downto 0);
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           op : in STD_LOGIC_vector(1 downto 0));
end SP;

architecture Behavioral of SP is
begin
process(clk, rst, en)
    begin
        if(rst = '1')then
            Q <= (others => '0');
        elsif(rising_edge(clk)) then
            if(en = '1') then
              if(op = "01") then
                Q <= D + 1;
              elsif(op = "10") then
                Q <= D - 1;
              else
                Q <= D;
              end if;  
            end if;
        end if;
    end process;
end Behavioral;