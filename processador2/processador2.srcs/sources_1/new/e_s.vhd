library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity e_s is
	generic (n : integer := 16);
	port (
		IO_read  	: out std_logic_vector(n-1 downto 0) := (others => '0');
		IO_write    : out std_logic_vector(n-1 downto 0) := (others => '0');
		IO_sysinput : in  std_logic_vector(n-1 downto 0);
		IO_userinput: in  std_logic_vector(n-1 downto 0);
		IO_ld	 	: in  std_logic := '0';
		clk			: in  std_logic := '0'
	);
end entity e_s;
architecture behav of e_s is
begin
	process(IO_sysinput, IO_ld, clk)
	begin
		if (rising_edge(clk)) then
			if (IO_ld = '1') then
				IO_write <= IO_sysinput;
			end if;
		end if;
	end process;
	IO_read <= IO_userinput;
end architecture behav;