library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_testbench is
    generic(N : integer := 16);
--  Port ( );
end rom_testbench;

architecture Behavioral of rom_testbench is
  signal addr  : std_logic_vector(N-1 downto 0);
  signal dout  : std_logic_vector(N-1 downto 0) := (others => '0');
  signal en    : std_logic;                     
  signal clk   : std_logic := '0';                      
begin
    rom_teste: 
    entity work.rom
           generic map(N => N)          
           port map(
               addr => addr,
               dout => dout,
               en   => en  ,
               clk  => clk 
           ); 
           
     clk <= not clk after 100 ns;
     
     estimulos: process
     begin 
        en <= '0';
        wait for 100 ns;
        
        en <= '1';
        
        wait for 200 ns;
        
        addr <= x"0000";
        wait for 200 ns;
        
        addr <= x"0002";
        wait for 200 ns;
        
        addr <= x"0004";
        wait for 200 ns;
        
        addr <= x"0006";
        wait for 200 ns;
        
        addr <= x"0008";
        wait for 200 ns; 
        
        addr <= x"0010";
        wait for 200 ns; 
        
        addr <= x"0000";
        wait for 200 ns;          
        
        addr <= x"0000";
     end process;      
end Behavioral;