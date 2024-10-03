    ------------------------------------------------------------------------------------------------
--ALUNO:PEDRO NÓBREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity and_teste is
    port(
        clock: in std_logic;
        a: in std_logic;
        b: in std_logic;
        x: out std_logic
    );
end and_teste;

architecture RTL1 of and_teste is
begin
    process
    begin
        wait until clock'event and clock='1';
        if(a='1' and b='1')then
            x<='1';
        else
            x<='0';
        end if;
    end process;
end RTL1;