------------------------------------------------------------------------------------------------
--ALUNO:PEDRO NÓBREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
port(
--------------------------COMENTADO PARA TESTAR NA PLACA----------------------------------------
    --x_and: out std_logic; Comentado para testar na placa
    --x_or: out std_logic;  Comentado para testar na placa
    --x_xor: out std_logic; Comentado para testar na placa
    --x_inverter: out std_logic; Comentado para testar na placa
    --x_flipflop: out std_logic;
------------------------------------------------------------------------------------------------  
    clock: in std_logic := '0';
    a: in std_logic;
    b: in std_logic;
    x_teste: out std_logic;
    --x_latch: out std_logic;
    switch_0: in std_logic;
    switch_1: in std_logic;
    switch_2: in std_logic;
    switch_3: in std_logic
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
            q: out std_logic;
            qbar: out std_logic
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
    component driver_teste is
        port(
            clock: in std_logic;
            a: in std_logic;
            x: out std_logic 
        );
    end component;
    
--------------------------COMENTADO PARA TESTAR NA PLACA----------------------------------------
    --signal clock: std_logic := '0';
    --signal a: std_logic;
    --signal b: std_logic;
    --constant clock_periodo:time:= 100 ns;
------------------------------------------------------------------------------------------------  

    signal x_and: std_logic;
    signal x_or: std_logic;
    signal x_xor: std_logic;
    signal x_inverter: std_logic;
    signal x_nor:std_logic;
    signal x_nand:std_logic;
    signal x_flipflop:std_logic;
    signal x_xnor:std_logic;
    signal x_nao_latch:std_logic := '0';
    signal x_driver:std_logic;
    signal x_latch:std_logic := '0';
    signal s:std_logic;
    signal c:std_logic;
begin
    --clock<= not clock after clock_periodo/2;  Comentado para testar na placa
    DUT1:and_teste port map(clock,a,b,x_and);
    DUT2:or_teste port map(clock,a,b,x_or);
    DUT3:xor_teste port map(clock,a,b,x_xor);
    DUT4:inverter_teste port map(clock,a,x_inverter);
    DUT5:nor_teste port map(clock,a,b,x_nor);
    DUT6:nand_teste port map(clock,a,b,x_nand);
    DUT7:xnor_teste port map(clock,a,b,x_xnor);
    DUT8:latch_teste port map(clock,a,b,x_latch,x_nao_latch);
    DUT9:flipflopD_teste port map(clock,a,x_flipflop);
    DUT10:half_adder_teste port map(clock,a,b,s,c);
    DUT11:driver_teste port map(clock,a,x_driver);
    
    estimulos:process
    variable tmp: std_logic;
    begin
        if(switch_0 ='1' and (a='1' and b='1'))then
            tmp:='1';
        elsif(switch_1 ='1' and (a='1' or b='1'))then
            tmp:='1';
        elsif(switch_2 ='1' and ((a='1' and b='0') or (a='0' and b='1')))then
            tmp:='1';
        elsif(switch_3 ='1' and a='0')then
            tmp:='1';
        else
            tmp:='0';
        end if;
        x_teste<=tmp;
        
 ---------------------COMENTADO PARA TESTAR NA PLACA--------------------------------------------  
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
------------------------------------------------------------------------------------------------  
    end process;
end Behavioral;