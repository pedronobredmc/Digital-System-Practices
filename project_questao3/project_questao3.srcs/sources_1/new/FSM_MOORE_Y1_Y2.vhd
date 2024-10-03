library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fsm_moore_y1_y2 is
generic(
    clock_frequencyHz:integer
);
  Port (
    rst   : in std_logic;
    clock : in std_logic;    
    w     : in std_logic;
    y1    : out std_logic;
    y2    : out std_logic;
    R1_in : out std_logic;
    R1_out: out std_logic;
    R2_in : out std_logic;
    R2_out: out std_logic;
    R3_in : out std_logic;
    R3_out: out std_logic;
    Done  : out std_logic
  );
end fsm_moore_y1_y2;

architecture RTL of fsm_moore_y1_y2 is
    type estados is (A, B, C);
    signal y : estados;
begin
    process(w,rst,clock)
    begin
        if(rst = '1')then
            y<=A;
            y1<='0';
            y2<='0';
            R1_in<='0';
            R1_out<='0';
            R2_in<='0';
            R2_out<='0';
            R3_in<='0';
            R3_out<='0';
            Done<='0';
        elsif(clock'event and clock='1')then
            case y is
                when A =>
                    if(w = '0')then
                        y <= A;
                        y1<='0';
                        y2<='0';
                        R1_in<='0';
                        R1_out<='0';
                        R2_in<='0';
                        R2_out<='0';
                        R3_in<='0';
                        R3_out<='0';
                        Done<='0';
                    else
                        y <= B;
                        y1<='0';
                        y2<='1';
                        R1_in<='0';
                        R1_out<='0';
                        R2_in<='0';
                        R2_out<='1';
                        R3_in<='1';
                        R3_out<='0';
                        Done<='0';
                    end if;
                when B =>
                    if(w = '0')then
                        y <= C;
                        y1<='1';
                        y2<='0';
                        R1_in<='0';
                        R1_out<='1';
                        R2_in<='1';
                        R2_out<='0';
                        R3_in<='0';
                        R3_out<='0';
                        Done<='0';
                    else
                        y <= C;
                        y1<='1';
                        y2<='0';
                        R1_in<='0';
                        R1_out<='1';
                        R2_in<='1';
                        R2_out<='0';
                        R3_in<='0';
                        R3_out<='0';
                        Done<='0';
                    end if;
                when C =>
                    if(w = '0')then
                        y <= A;
                        y1<='0';
                        y2<='0';
                        R1_in<='1';
                        R1_out<='0';
                        R2_in<='0';
                        R2_out<='0';
                        R3_in<='0';
                        R3_out<='1';
                        Done<='1';
                    else
                        y <= A;
                        y1<='0';
                        y2<='0';
                        R1_in<='1';
                        R1_out<='0';
                        R2_in<='0';
                        R2_out<='0';
                        R3_in<='0';
                        R3_out<='1';
                        Done<='1';
                    end if;
            end case;
        end if;
    end process;
end RTL;
