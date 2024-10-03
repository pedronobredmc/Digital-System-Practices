library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fsm_mealy is
    generic(
        clock_frequencyHz:integer
    );
    Port (
        rst : in std_logic;
        clock : in std_logic;
        w : in std_logic;
        z : out std_logic
     );
end fsm_mealy;

architecture RTL of fsm_mealy is
    type estados is (A, B);
    signal atual, prox : estados;
begin
    process(clock, rst, w, atual, prox)
    begin
    atual<=prox;
        if(rst='1')then
            atual <= A;
            prox <= A;
            z<='0';
        elsif(clock'event and clock='1')then
            case atual is
                when A=>
                    if(w='1')then
                        prox<=B;
                    else
                        prox<=A;
                    end if;
                when B=>
                    if(w='1')then
                        prox<=B;
                    else
                        prox<=A;
                    end if;
            end case;
        end if;
        if(atual=B and w='1')then
            z <= w;  
        else 
            z<='0';
        end if;
    end process;
end RTL;
