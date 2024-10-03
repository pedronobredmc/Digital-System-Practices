------------------------------------------------------------------------------------------------
--ALUNO:PEDRO NÓBREGA DAMACENA
--MATRICULA:536543
--ENTREGA 01
------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity latch_teste is
PORT(
    clock: in std_logic;
    s: in std_logic;
    r: in std_logic;
    q: out std_logic;
    qbar: out std_logic
    );
end latch_teste;
 
Architecture RTL8 of latch_teste is
begin
process
variable tmp: std_logic;
begin
    wait until clock'event and clock='1';
    if(s='0' and r='0')then
        tmp:=tmp;
    elsif(s='1' and r='1')then
        tmp:='Z';
    elsif(s='0' and r='1')then
        tmp:='0';
    else
        tmp:='1';
    end if;
    q <= tmp;
    qbar <= not tmp;
end Process;
end rTL8;
