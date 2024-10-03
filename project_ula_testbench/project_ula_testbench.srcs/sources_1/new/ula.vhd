library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ULA is
	generic(N:integer:=8);
    port(
    	resultado: out std_logic_vector(N-1 downto 0);
    	op: in std_logic_vector(3 downto 0);
        operA: in std_logic_vector(N-1 downto 0);
        operB: in std_logic_vector(N-1 downto 0)
        --cin: in std_logic_vector
    );
    
end ULA;

architecture behavioral of ULA is
	signal result: std_logic_vector(N-1 downto 0);
    
    begin
    result <= operA + operB when op = "0000" else
    operA or operB	when op = "0001" else
    operA and operB	when op = "0010" else
    operA - operB	when op = "0011" else
    not (operA) and operB when op = "0100" else
    conv_std_logic_vector(conv_integer(operA * operB), 8) when op = "0101" else
    result;
    
resultado <= result;
end behavioral;