------------------------------------------------------------------------------------------------
--ALUNO:PEDRO NÓBREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand_teste is
    port (
        clock: in std_logic;
        a: in std_logic;
        b: in std_logic;
        x: out std_logic
);
end nand_teste;

architecture RTL6 of nand_teste is
begin
     process
        begin
        wait until clock'event and clock='1';
        if(a='1' and b='1')then
            x<='0';
        else
            x<='1';
        end if;
    end process;
end RTL6;
