library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ram_testbench is
    generic(N : integer := 16);
--  Port ( );
end ram_testbench;

architecture Behavioral of ram_testbench is
  signal din       : std_logic_vector(N-1 downto 0);
  signal addr      : std_logic_vector(N-1 downto 0);
  signal dout      : std_logic_vector(N-1 downto 0) := (others => '0');
  signal we        : std_logic := '0';                     
  signal clk       : std_logic := '0';
  signal stack_en  : std_logic;
  signal stack_op  : std_logic_vector(1 downto 0);                      
begin
    ram_teste: 
    entity work.ram         
           port map(
               din  => din ,
               addr => addr,
               dout => dout,
               we   => we  ,
               stack_en => stack_en,
               stack_op => stack_op,
               clk  => clk 
           ); 
           
     clk <= not clk after 100 ns;
     
     estimulos: process
     begin 
        we <= '0';
        din <= x"0000";
        addr <= x"0000";
        
        wait for 100 ns;
        
        we <= '1';
        din <= x"0C20";
        addr <= x"0001";
        
        wait for 200 ns;
        
        we <= '0';
        addr <= x"0001";
        
        wait for 200 ns;
        
        we   <= '1';
        din  <= x"A42B";
        addr <= x"0020";
        
        wait for 200 ns;
        
        we <= '0';
        addr <= x"0020";
        
        wait for 200 ns;        
     end process;      
end Behavioral;