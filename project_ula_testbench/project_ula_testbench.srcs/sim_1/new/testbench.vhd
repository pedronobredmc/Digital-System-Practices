
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity testbench is
end testbench;

architecture Behavioral of testbench is
constant PERIOD : time := 10 ns;
constant N: integer:=8;

signal tb_clk : std_logic := '0'; -- deve ser inicializado
signal tb_rst : std_logic;
signal s_A: std_logic_vector(N-1 downto 0);
signal s_B: std_logic_vector(N-1 downto 0);
signal s_Q: std_logic_vector(N-1 downto 0);
signal s_op: std_logic_vector(3 downto 0);

begin

DUT: entity work.ula
     generic map(N => 8)
     port map( operA =>s_A,
               operB =>s_B,
               resultado =>s_Q,
               op =>s_op);

clock:
tb_clk <= not tb_clk after PERIOD/2; 

reset:
process
begin
     tb_rst <= '1';
     wait for PERIOD;
     tb_rst <= '0';
     wait;
end process;
       
test:
process
begin
  wait until tb_rst='0';
  wait for PERIOD/2;
  s_A <= X"05";
  s_B <= X"03";
  
      s_op <= "0000"; 
      wait for PERIOD;
      s_op <= "0001"; 
      wait for PERIOD;
      s_op <= "0010"; 
      wait for PERIOD;
      s_op <= "0011"; 
      wait for PERIOD;
      s_op <= "0100"; 
      wait for PERIOD;
      s_op <= "0101"; 
      wait for PERIOD;
      
end process;  

end Behavioral;
