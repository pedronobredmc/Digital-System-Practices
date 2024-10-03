library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
   -- Port ();
end testbench;

architecture Behavioral of testbench is
    component fsm_moore is
        port(
        rst:in std_logic;
        clock:in std_logic:='0';    
        w:in std_logic;
        z:out std_logic  
        );
    end component;
    signal rst,w:std_logic:='0';
    signal clock:std_logic:='1';
    signal z:std_logic;
    constant clock_frequencyHz:integer:=100;
    constant clock_periodo:time:=50 ns;
begin
    DUT:entity work.fsm_moore(RTL)
    generic map(clock_frequencyHz => clock_frequencyHz)
    port map(rst,clock,w,z);
    clock<=not clock after clock_periodo/2;
    process
    begin
        -- w = 0 1 0 1 1 0 1 1 1 0 1
        -- z = 0 0 0 0 0 1 0 0 1 1 0
            rst<='1'; 
             wait for clock_periodo;
            rst<='0';
             wait for clock_periodo;
            w<='0';
             wait for clock_periodo;
            w<='1';
             wait for clock_periodo;
            w<='0';
             wait for clock_periodo;
            w<='1';
             wait for clock_periodo;
            w<='1';
             wait for clock_periodo;
            w<='0';
             wait for clock_periodo;
            w<='1';
             wait for clock_periodo;
            w<='1';
             wait for clock_periodo;
            w<='1';
             wait for clock_periodo;
            w<='0';
             wait for clock_periodo;
            w<='1';
             wait for clock_periodo;
            rst<='1';
             wait for clock_periodo;
    end process;
end Behavioral;
