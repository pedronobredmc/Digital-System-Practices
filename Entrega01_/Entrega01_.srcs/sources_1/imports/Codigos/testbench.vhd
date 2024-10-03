library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
port(
    clock: in std_logic;
    a: in std_logic;
    b: in std_logic;
    x_and: out std_logic;
    x_or: out std_logic;
    x_xor: out std_logic;
    x_inverter: out std_logic
    );
end testbench;

architecture Behavioral of testbench is
    component and_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            b: in std_logic;
            x: out std_logic
        );
   end component;
   component or_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            b: in std_logic;
            x: out std_logic
        );    
    end component;
    component xor_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            b: in std_logic;
            x: out std_logic
        );    
    end component;
    component inverter_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            x: out std_logic
        );    
    end component;
    component nor_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            b: in std_logic;
            x: out std_logic
        );    
    end component;
    component nand_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            b: in std_logic;
            x: out std_logic
        );    
    end component;
    component xnor_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            b: in std_logic;
            x: out std_logic
        );    
    end component;
    component latch_teste is
        port(
            clock: in std_logic;
            s: in std_logic;
            r: in std_logic;
            q: out std_logic
        );    
    end component;
    component flipflopD_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            x: out std_logic
        );   
    end component;
    component half_adder_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            b: in std_logic;
            s: out std_logic;
            c: out std_logic
        );
    end component;
    --signal clock: std_logic := '0';
    --signal a: std_logic;
    --signal b: std_logic;
    --signal x_and: std_logic;
    --signal x_or: std_logic;
    --signal x_xor: std_logic;
    --signal x_inverter: std_logic;
    signal x_nor:std_logic;
    signal x_nand:std_logic;
    signal x_xnor:std_logic;
    signal x_latch:std_logic := '0';
    signal x_flipflop:std_logic;
    signal s:std_logic;
    signal c:std_logic;
    constant clock_periodo:time:= 100 ns;
begin
    --clock<= not clock after clock_periodo/2;
    DUT1:and_teste port map(clock,a,b,x_and);
    DUT2:or_teste port map(clock,a,b,x_or);
    DUT3:xor_teste port map(clock,a,b,x_xor);
    DUT4:inverter_teste port map(clock,a,x_inverter);
    DUT5:nor_teste port map(clock,a,b,x_nor);
    DUT6:nand_teste port map(clock,a,b,x_nand);
    DUT7:xnor_teste port map(clock,a,b,x_xnor);
    DUT8:latch_teste port map(clock,a,b,x_latch);
    DUT9:flipflopD_teste port map(clock,a,x_flipflop);
    DUT10:half_adder_teste port map(clock,a,b,s,c);
    
    estimulos:process
    begin
        --teste1
        --a<='0';
        --b<='0';
        --wait for clock_periodo;
        --teste2
        --a<='0';
        --b<='1';
        --wait for clock_periodo;
        --teste3
        --a<='1';
        --b<='0';
        --wait for clock_periodo;
        --teste4
        --a<='1';
        --b<='1';
        --wait for clock_periodo;
    
    end process;
end Behavioral;










