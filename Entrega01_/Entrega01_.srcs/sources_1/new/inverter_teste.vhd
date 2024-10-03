------------------------------------------------------------------------------------------------
--ALUNO:PEDRO NÓBREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity inverter_teste is
    port(
    clock: in std_logic;
        a: in std_logic;
        x: out std_logic
    );
end inverter_teste;

architecture RTL4 of inverter_teste is
begin
    process
        begin
        wait until clock'event and clock='1';
        if(a='1')then
            x<='0';
        else
            x<='1';
        end if;
    end process;
end RTL4;