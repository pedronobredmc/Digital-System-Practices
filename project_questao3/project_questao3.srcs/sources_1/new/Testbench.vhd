library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
   -- Port ();
end testbench;

architecture Behavioral of testbench is
    component fsm_moore_y1_y2 is
        port(
        rst   :in std_logic;
        clock :in std_logic:='0';    
        w     : in std_logic;
        y1    : out std_logic;
        y2    : out std_logic;
        R1_in : out std_logic;
        R1_out: out std_logic;
        R2_in : out std_logic;
        R2_out: out std_logic;
        R3_in : out std_logic;
        R3_out: out std_logic;
        Done  : out std_logic
        );
    end component;
    signal rst,w:std_logic:='0';
    signal clock:std_logic:='1';
    signal y1:std_logic:='0';
    signal y2:std_logic:='0';
    signal R1_in:std_logic:='0';
    signal R1_out:std_logic:='0'; 
    signal R2_in:std_logic:='0';
    signal R2_out:std_logic:='0'; 
    signal R3_in:std_logic:='0';
    signal R3_out:std_logic:='0';
    signal Done:std_logic:='0';
    constant clock_frequencyHz:integer:=100;
    constant clock_periodo:time:=50 ns;
begin
    DUT:entity work.fsm_moore_y1_y2(RTL)
    generic map(clock_frequencyHz => clock_frequencyHz)
    port map(rst,clock,w,y1,y2,R1_in,R1_out,R2_in,R2_out,R3_in,R3_out,Done);
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
    end process;
end Behavioral;
