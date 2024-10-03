library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_control_unit is
end tb_control_unit;

architecture Behavioral of tb_control_unit is


 constant period : time := 10 ns;
 signal tb_clk      : std_logic := '1'; -- deve ser inicializado
 signal tb_rst      : std_logic;
 signal s_rom_addr  : std_logic_vector(15 downto 0);
 signal s_rom_data  : std_logic_vector(15 downto 0);
 signal s_rom_en    : std_logic;
 signal s_carry     : std_logic;
 signal s_zero     : std_logic;


begin


DUT: entity work.control_unit
     generic map (N =>16)
     port map ( 
       clock    => tb_clk,
       reset    => tb_rst,
       ROM_en   => s_rom_en,
       ROM_addr => s_rom_addr,
       carry    => s_carry,
       zero     => s_zero,
       rom_dout => s_rom_data);
       
ROM: entity work.rom
            generic map(data_width => 16, addr_width => 16)
            port map(
            clk => tb_clk,
            addr => s_rom_addr,
            en => s_rom_en,
            dout => s_rom_data);       
       
clock:
tb_clk <= not tb_clk after period/2;

reset: 
process
       begin
         tb_rst <= '1';
         wait for 2*period;
         tb_rst <= '0';
         wait;
       end process reset;   


end Behavioral;
