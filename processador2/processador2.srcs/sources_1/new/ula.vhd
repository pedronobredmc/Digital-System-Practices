library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula is
  Generic (N:integer:=16);
  Port (A:in std_logic_vector(N-1 downto 0);
        B:in std_logic_vector(N-1 downto 0);
        Q:out std_logic_vector(N-1 downto 0);
        op:in std_logic_vector(3 downto 0);
        z: out std_logic := '0';
        c: out std_logic := '0'
        );
end ula;

architecture Behavioral of ula is

signal result: std_logic_vector(N-1 downto 0) := (others =>'0');
signal s_mul:  std_logic_vector(2*N-1 downto 0) := (others =>'0');


begin

with op select

result <= A + B   when "0100",
          A - B   when "0101",
          s_mul(N-1 downto 0)   when "0110",
          A and B   when "0111",
          A or B    when "1000",
          not A   when "1001",
          A xor B   when "1010",
          std_logic_vector(unsigned(A) srl to_integer(unsigned(B)))   when "1011",
          std_logic_vector(unsigned(A) sll to_integer(unsigned(B)))   when "1100",
          std_logic_vector(unsigned(A) ror 1)   when "1101",
          std_logic_vector(unsigned(A) rol 1)   when "1110",
          result  when others;

s_mul <= A * B;

Q <= result;

ZC:
  process (A,B, op)
  begin
    if (op = "0011") then
      if (A = B) then
        z <= '1';
        c <= '0';
      elsif (A < B) then 
        z <= '0';
        c <= '1';
      else
        z <= '0';
        c <= '0';
      end if;
    end if;
  end process;

end Behavioral;