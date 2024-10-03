library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_testbench is
    generic(N : integer := 16);
--  Port ( );
end cpu_testbench;

architecture Behavioral of cpu_testbench is
    signal clk, rst : std_logic := '0';               
    constant clk_period : time := 100 ns;
begin
    DUT: entity work.cpu
            generic map(N => N)
            port map(
                clock       => clk,
                reset       => rst);
            
    clk <= not clk after clk_period/2;
    
    estimulos: process
    begin
    
    rst <= '1';
    wait for clk_period/4;
 
    rst <= '0';
    wait for 60 * clk_period;
    end process;    
end Behavioral;