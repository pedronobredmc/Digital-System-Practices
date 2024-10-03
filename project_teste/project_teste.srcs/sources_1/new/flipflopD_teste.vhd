------------------------------------------------------------------------------------------------
--ALUNO:PEDRO NÓBREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipflopD_teste is
    Port (
        clock: in std_logic;
        a: in std_logic;
        x: out std_logic;
        xbar : out std_logic
    );
end flipflopD_teste;

architecture RTL9 of flipflopD_teste is
begin
process
variable tmp: std_logic;
begin
    if rising_edge(clock)then
        if(a='0')then
            tmp:='0';
        else
            tmp:='1';
        end if;
    end if;
    if falling_edge(clock)then
        if(a='1')then
            tmp:=tmp;
        else
            tmp:=tmp;
        end if;
    end if;
    x <= tmp;
    xbar <= not tmp;
end Process;
end RTL9;
