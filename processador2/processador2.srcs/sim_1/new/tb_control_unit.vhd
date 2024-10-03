library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_control_unit is
end tb_control_unit;

architecture Behavioral of tb_control_unit is


 constant period : time := 10 ns;
 signal tb_clk : std_logic := '1'; -- deve ser inicializado
 signal tb_rst : std_logic;
 signal s_rom_addr :  std_logic_vector(15 downto 0);
 signal s_rom_data : std_logic_vector(15 downto 0);
 signal s_rom_en : std_logic;
 signal s_Immed : std_logic_vector(15 downto 0) := (others => '0');
 signal s_RAM_sel : std_logic := '0';
 signal s_RAM_we : std_logic := '0';
 signal s_ram_addsel : std_logic := '0';
 signal s_RF_sel : std_logic_vector(1 downto 0) := (others => '0');
 signal s_Rd_sel : std_logic_vector(2 downto 0) := (others => '0');
 signal s_Rd_wr : std_logic := '0'; 
 signal s_Rm_sel : std_logic_vector(2 downto 0) := (others => '0');
 signal s_Rn_sel : std_logic_vector(2 downto 0) := (others => '0');
 signal s_Ula_Op : std_logic_vector(3 downto 0) := (others => '0');
 signal s_io_read_set : std_logic := '0';
 signal s_io_write_set : std_logic := '0';
 signal s_io_ld : std_logic := '0';
 signal s_z : std_logic := '0';
 signal s_c : std_logic := '0';
 signal s_sp_sel : std_logic := '0';
 signal s_sp_ld : std_logic := '0';


begin
--altere as instruções na rom, coloque as que voce quer testar, exemplo quando for tal instrução se z = 1 e c = 0 jump etc

DUT: entity work.control_unit
     generic map (N =>16)
     port map 
     ( 
       clk => tb_clk,
       reset => tb_rst,
       ROM_en => s_rom_en,
       ROM_addr => s_rom_addr,
       IR_data =>s_rom_data,
       Immed => s_immed,
       RAM_sel => s_ram_sel,
       RAM_we => s_ram_we,
       ram_addsel => s_ram_addsel,
       RF_sel => s_rf_sel,
       Rd_sel => s_rd_sel,
       Rd_wr => s_rd_wr,
       Rm_sel => s_rm_sel,
       Rn_sel => s_rn_sel,
       Ula_Op => s_Ula_Op,
       io_read_set => s_io_read_set,
       io_write_set => s_io_write_set,
       io_ld => s_io_ld,
       z => s_z,
       c => s_c,
       sp_sel => s_sp_sel,
       sp_ld => s_sp_ld
       );
       
ROM: entity work.rom
            generic map(data_width => 16, addr_width => 16)
            port map(
            clk => tb_clk,
            address => s_rom_addr,
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