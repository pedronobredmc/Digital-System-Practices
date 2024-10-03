library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

entity driver is
    Port ( 
        clk: in std_logic;
        rst: in std_logic;
        driver_in: in std_logic_vector(7 downto 0);
        driver_out: out std_logic_vector(7 downto 0);
        data_en: in std_logic
    );
end driver;

architecture Behavioral of driver is
begin
    process(clk)
    begin
        if(rst='1')then
        driver_out<=(others=>'0');
        elsif(clk'event and clk='1')then
            if(data_en='1')then
                driver_out<=driver_in;
            else
                driver_out<=(others=>'Z');
            end if;
        end if;
    end process;


end Behavioral;
