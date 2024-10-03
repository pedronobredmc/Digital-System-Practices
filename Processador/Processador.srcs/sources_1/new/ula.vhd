library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;

entity ULA is
	generic(N:integer:=16);
    port(
    	resultado  : out std_logic_vector(N-1 downto 0);
    	op         : in std_logic_vector(3 downto 0);
        operA      : in std_logic_vector(N-1 downto 0);
        immed      : in std_logic_vector (N-1 downto 0);
        operB      : in std_logic_vector(N-1 downto 0);
        zero       : out std_logic;
        carry      : out std_logic
    );
    
end ULA;

architecture behavioral of ULA is
	signal result : std_logic_vector(N-1 downto 0);
	signal result_mul : std_logic_vector(2*N-1 downto 0);
    signal msb    : std_logic;
    signal lsb    : std_logic;
    
    begin
    
    msb <= operA(N-1);
    lsb <= operA(0);
    
    zero  <= '1' when (operA = operB) else '0';
    carry <= '1' when (operA < operB) else '0';
    result_mul <= operA * operB when op ="0110";
    result <= operA + operB when op = "0100" else
    operA or operB	        when op = "1000" else
    operA and operB	        when op = "0111" else
    operA - operB	        when op = "0101" else
    not (operA)             when op = "1001" else
    operA xor operB         when op="1010" else
    shr(operA, Immed)       when op = "1011"    else   
    shl(operA, Immed)       when op = "1100"    else
    lsb & operA(N-1 downto 1)   when op = "1101"    else
    operA(N-1-1 downto 0) & msb when op = "1110"    else
    (others => '0');
    zero <= '1' when result = "0";
    resultado<=result; 
end behavioral;