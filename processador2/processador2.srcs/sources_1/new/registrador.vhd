
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registrador is
	generic (N : integer := 16);
	port(
		clk : in STD_LOGIC;
		ld : in STD_LOGIC;
		rst: in STD_LOGIC;
		d : in STD_LOGIC_VECTOR(N-1 downto 0);
		q : out STD_LOGIC_VECTOR(N-1 downto 0)
		);
end registrador;
 
architecture Behavioral of registrador is
begin
 
	process(clk)
	begin
		if rising_edge(clk) then
			if rst='1' then
				q<=(others=>'0');
			else
				if ld='1' then
					q<=d;
				end if;
			end if;
		end if;			
	end process;
 
 
end Behavioral;
