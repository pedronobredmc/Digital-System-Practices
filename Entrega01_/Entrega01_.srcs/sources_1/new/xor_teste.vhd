------------------------------------------------------------------------------------------------
--ALUNO:PEDRO N�BREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity xor_teste is
    port(
    clock: in std_logic;
        a: in std_logic;
        b: in std_logic;
        x: out std_logic
    );
end xor_teste;

architecture RTL3 of xor_teste is
begin
    process
        begin
        wait until clock'event and clock='1';
        if((a='1' and b='1') or (a='0' and b='0'))then
            x<='0';
        else
            x<='1';
        end if;
    end process;
end RTL3;