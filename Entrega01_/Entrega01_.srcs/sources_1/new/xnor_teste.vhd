------------------------------------------------------------------------------------------------
--ALUNO:PEDRO NÓBREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xnor_teste is
    port (
        clock: in std_logic;
        a: in std_logic;
        b: in std_logic;
        x: out std_logic
    );
end xnor_teste;

architecture RTL7 of xnor_teste is
begin
    process
        begin
        wait until clock'event and clock='1';
        if((a='1' and b='1') or (a='0' and b='0'))then
            x<='1';
        else
            x<='0';
        end if;
    end process;
end RTL7;
