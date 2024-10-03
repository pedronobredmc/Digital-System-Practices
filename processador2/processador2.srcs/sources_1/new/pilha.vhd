library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity pilha is
	generic (N : integer := 16);
	port(
		clk    : in  STD_LOGIC;
		sp_sel : in std_logic;
		sp_ld : in  STD_LOGIC;
		rst    : in  STD_LOGIC;
		SP 	   : out STD_LOGIC_VECTOR(N-1 downto 0) := "1111111111111111" --topo da pilha!
		);
end pilha;
 
architecture Behavioral of pilha is

signal s_SP : std_logic_vector(n-1 downto 0) := "1111111111111111";

begin
	process(clk, sp_sel)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				s_SP <= "1111111111111111";
			elsif (sp_ld = '1' and sp_sel = '0') then
				s_SP <= s_SP - 1;
			elsif (sp_ld = '1' and sp_sel = '1') then
				s_SP <= s_SP + 1;
			end if;
		end if;			
	end process;
 
SP <= s_SP;

end Behavioral;
