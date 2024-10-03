------------------------------------------------------------------------------------------------
--ALUNO:PEDRO NÓBREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder_teste is
     Port (
        clock: in std_logic;
        a: in std_logic;
        b: in std_logic;
        s: out std_logic;
        c: out std_logic
     );
end half_adder_teste;

architecture RTL10 of half_adder_teste is
begin
    process
    begin
        wait until clock'event and clock='1';
        s <=a xor b;
        c <=a and b;        
    end process;

end RTL10;
