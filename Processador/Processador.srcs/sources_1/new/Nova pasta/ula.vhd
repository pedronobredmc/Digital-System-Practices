library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity ula is
    generic (N:integer:=32);
    Port (
        DataRP1 : in std_logic_vector(N-1 downto 0); 
        uins : in std_logic_vector(3 downto 0);
        Op2: in std_logic_vector(N-1 downto 0);
        --OP : in std_logic_vector(3 downto 0);
        Zero: out std_logic;
        Q : out std_logic_vector(N-1 downto 0)
    );
end ula;

architecture Behavioral of ula is
    signal resultado: std_logic_vector(N-1 downto 0);
    --signal mul: std_logic_vector(2*N-1 downto 0);
begin
    resultado <= DataRP1 + Op2 when uins="0100" else
        DataRP1-Op2 when uins="0101" else
        --mul(n-1 downto 0) when op="0110" else
        DataRP1 and Op2 when uins="0111" else
        DataRP1 or Op2 when uins="1000" else
        not(DataRP1) and Op2 when uins="1001" else
        DataRP1 xor Op2 when uins="1010" else
        resultado;
        
        --mul<=A*B;
        Q<=resultado;
    
end Behavioral;
