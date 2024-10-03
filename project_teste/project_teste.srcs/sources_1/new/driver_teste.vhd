------------------------------------------------------------------------------------------------
--ALUNO:PEDRO NÓBREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity driver_teste is
    Port (
        clock: in std_logic; 
        a : in std_logic;
        x : out std_logic
    );
end driver_teste;

architecture RTL11 of driver_teste is

begin
process
    begin
        wait until clock'event and clock='1';
        x<=a;
end process;


end RTL11;
