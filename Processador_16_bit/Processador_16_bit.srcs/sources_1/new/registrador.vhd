library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registrador is
    generic( N: integer := 16); 
    Port (  D   : in std_logic_vector(N-1 downto 0);
            ld  : in std_logic;
            clk : in STD_LOGIC;
            rst : in std_logic;
            Q   : out std_logic_vector(N-1 downto 0)
            );
end registrador;

architecture Behavioral of registrador is
    signal reg : std_logic_vector(N-1 downto 0);
begin
    process(clk, rst, ld)
    begin
        if(rst = '1')then
            reg <= (others => '0');
        elsif(rising_edge(clk)) then
            if(ld = '1') then
                reg <= D;
            end if;
        end if;
    end process;
    Q <= reg;
end Behavioral;
