
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity datapath_tb is

end datapath_tb;

architecture Behavioral of datapath_tb is

constant PERIOD : time := 10 ns;
constant N: integer:=16;

signal tb_clk : std_logic := '0'; -- deve ser inicializado
signal tb_rst : std_logic;

--pilha
signal s_sp_ld : std_logic := '0';
signal s_sp_sel : std_logic := '0';
signal s_ram_addsel : std_logic := '0';

--Register file (RF)         
signal s_Rd_wr:  std_logic :='0';         
signal s_Rd_sel: std_logic_vector(2 downto 0);
signal s_Rm_sel: std_logic_vector(2 downto 0);
signal s_Rn_sel: std_logic_vector(2 downto 0);
         
--ULA         
signal s_ula_op: std_logic_vector(3 downto 0);
signal s_z: std_logic;
signal s_c: std_logic;
         
--Memória
signal s_ram_dout: std_logic_vector(N-1 downto 0);
signal s_ram_din: std_logic_vector(N-1 downto 0);
signal s_ram_addr:std_logic_vector(N-1 downto 0);
signal s_ram_we: std_logic :='0';
         
--RF Source
signal s_immediate: std_logic_vector(N-1 downto 0);
signal s_RF_source: std_logic_vector(1 downto 0);

--Mux
signal s_RAM_sel: std_logic;

--IO
signal s_io_read : std_logic_vector(N-1 downto 0) := (others => '0');
signal s_io_write : std_logic_vector(N-1 downto 0) := (others => '0');
signal s_io_read_set : std_logic := '0';
signal s_io_write_set : std_logic := '0';
signal s_io_ld : std_logic := '0';
signal s_io_writeoutput : std_logic_vector(N-1 downto 0) := (others => '0');
signal s_io_readinput : std_logic_vector(N-1 downto 0) := (others => '0');

begin

DUT: entity work.datapath
     generic map(N => 16)
     port map ( clk => tb_clk,
  	            rst =>tb_rst, 
                Rd_wr => s_Rd_wr,        
                Rd_sel => s_Rd_sel,
                Rm_sel => s_Rm_sel,
                Rn_sel => s_Rn_sel,
                ula_op => s_ula_op,
                ram_din => s_ram_dout,
                ram_addr => s_ram_addr,
                ram_dout => s_ram_din,
                immediate => s_immediate,
                RF_source => s_RF_source,
                RAM_sel => s_RAM_sel,
                z => s_z,
                c => s_c,
                IO_read => s_io_read,
                IO_write => s_io_write,
                io_read_set => s_io_read_set,
                io_write_set => s_io_write_set,
                sp_ld => s_sp_ld,
                sp_sel => s_sp_sel,
                ram_addsel => s_ram_addsel
              );
                
RAM: entity work.ram
      port map(
               clk => tb_clk,
               address => s_ram_addr,
               din => s_ram_din,
               we => s_ram_we,
               dout => s_ram_dout
              );
                
IO: entity work.e_s
    generic map (n => 16)
    port map(
             IO_read => s_io_read,
             IO_write => s_io_writeoutput,
             IO_sysinput => s_io_write,
             IO_userinput => s_io_readinput,
             IO_ld => s_io_ld,
             clk => tb_clk
            );

clock:
  tb_clk <= not tb_clk after PERIOD/2; 
  
reset: 
  process
         begin
           tb_rst <= '1';
           wait for 2*PERIOD;
           tb_rst <= '0';
           wait;
         end process reset;
         
test:
process
begin
 wait until tb_rst='0';
           
 wait for PERIOD;
 
 -- mov R2,#0x22 --> Rd = immed
 s_Rd_wr <='1';
 s_RF_source <= "10";
 s_immediate <= X"0022";
 s_Rd_sel <= "010";
 wait for PERIOD;
 
 -- mov R3,#0x33 --> Rd = immed
 s_Rd_wr <='1';
 s_RF_source <= "10";
 s_immediate <= X"0033";
 s_Rd_sel <= "011";
 wait for PERIOD;
 
 -- mov R1,R2 --> Rd = Rm
  s_Rd_wr <='1';
  s_RF_source <= "00";
  s_Rd_sel <= "001";
  s_Rm_sel <="010";
  s_immediate <= (others => 'Z');
  wait for PERIOD;
  
  -- add R5,R2,R3 --> Rd = Rm + Rn
  s_Rd_wr <='1';
  s_RF_source <= "11";
  s_Rd_sel <= "101";
  s_Rm_sel <="010";
  s_Rn_sel <="011";
  s_ula_op <="0100";
  s_immediate <= (others => 'Z');
  wait for PERIOD;
  
  -- str [R1],R2 --> [Rm] = Rn 
  s_Rd_wr <='0';
  s_ram_sel <= '0';
  s_ram_we <='1';
  s_Rm_sel <= "001";
  s_Rn_sel <="010";
  wait for PERIOD;
  
  -- str [R0],R3 --> [Rm] = Rn 
  s_Rd_wr <='0';
  s_ram_we <='1';
  s_Rm_sel <= "000";
  s_Rn_sel <="011";
  wait for PERIOD;
    
  
  -- ldr R6,[R0] --> Rd = [Rm] 
  s_Rd_wr <='1';
  s_RF_source <= "01";
  s_ram_we <='0';
  s_Rd_sel <= "110";
  s_Rm_sel <="000";
  wait for PERIOD;    
  
  -- ldr R7,[R1] --> Rd = [Rm] 
  s_Rd_wr <='1';
  s_RF_source <= "01";
  s_ram_we <='0';
  s_Rd_sel <= "111";
  s_Rm_sel <="001";
  wait for PERIOD;

  -- CMP R1,R2 --> z = 1 e c = 0 {R1 = 34 e R2 = 34}
  s_Rd_wr <='0';
  s_RF_source <= "00";
  s_ram_we <='0';
  s_Rd_sel <= "000";
  s_Rm_sel <="001";
  s_Rn_sel <="010";
  s_ula_op <= "0011";
  wait for PERIOD;

  -- CMP R1,R2 --> z = 0 e c = 1 {R1 = 34 e R3 = 51}
  s_Rd_wr <='0';
  s_RF_source <= "00";
  s_ram_we <='0';
  s_Rd_sel <= "000";
  s_Rm_sel <="001";
  s_Rn_sel <="011";
  s_ula_op <= "0011";
  wait for PERIOD;

  -- SHR R4,R1,#1 --> R4 = R1 >> #1
  s_Rd_wr <='1';
  s_RF_source <= "11";
  s_ram_we <='0';
  s_Rd_sel <= "100";
  s_Rm_sel <="001";
  s_Rn_sel <="000";
  s_immediate <= "0000000000000001";
  s_ula_op <= "1011";
  wait for PERIOD;

  -- ROR R4,R4 --> R4 = R4 >> 1 e MSB(R4) = LSB(R4)
  s_Rd_wr <='1';
  s_RF_source <= "11";
  s_ram_we <='0';
  s_Rd_sel <= "100";
  s_Rm_sel <="100";
  s_Rn_sel <="000";
  s_immediate <= (others => 'Z');
  s_ula_op <= "1101";
  wait for PERIOD;
  
  -- IN R4 --> R4 = IO_Read(7...0)
  s_Rd_wr <='1';
  s_RF_source <= "00";
  s_ram_we <='0';
  s_Rd_sel <= "100";
  s_Rm_sel <="000";
  s_Rn_sel <="000";
  s_io_read_set <= '1';
  s_io_readinput <= "0000000000000001";
  s_immediate <= (others => 'Z');
  s_ula_op <= "0000";
  wait for PERIOD;

  -- OUT R4 --> IO_WRITE = R4
  s_Rd_wr <='0';
  s_RF_source <= "00";
  s_ram_we <='0';
  s_Rd_sel <= "000";
  s_Rm_sel <="100";
  s_Rn_sel <="000";
  s_io_read_set <= '0';
  s_io_write_set <= '0';
  s_io_ld <= '1';
  s_io_readinput <= "0000000000000000";
  s_immediate <= (others => 'Z');
  s_ula_op <= "0000";
  wait for PERIOD;

  -- OUT #Imed --> IO_WRITE = #0002
  s_Rd_wr <='0';
  s_RF_source <= "00";
  s_ram_we <='0';
  s_Rd_sel <= "000";
  s_Rm_sel <="000";
  s_Rn_sel <="000";
  s_io_read_set <= '0';
  s_io_write_set <= '1';
  s_io_ld <= '1';
  s_io_readinput <= "0000000000000000";
  s_immediate <= X"0002";
  s_ula_op <= "0000";
  wait for PERIOD;

-- PSH Rn --> [SP] = R7; SP--        //TOP DA PILHA = 65535 ou X"FFFF"
  s_Rd_wr <='0';
  s_RF_source <= "00";
  s_ram_we <='1';
  s_ram_sel <= '0';
  s_ram_addsel <= '1';
  s_sp_ld <= '1';
  s_sp_sel <= '0';
  s_Rd_sel <= "000";
  s_Rm_sel <="000";
  s_Rn_sel <="111";
  s_io_read_set <= '0';
  s_io_write_set <= '0';
  s_io_ld <= '0';
  s_io_readinput <= "0000000000000000";
  s_immediate <= (others => 'Z');
  s_ula_op <= "0000";
  wait for PERIOD;

  -- POP Rd --> R4 = [SP]; SP++        //TOP DA PILHA = 65535 ou X"FFFF"
  s_Rd_wr <='1';
  s_RF_source <= "01";
  s_ram_we <='0';
  s_ram_sel <= '0';
  s_ram_addsel <= '1';
  s_sp_ld <= '1';
  s_sp_sel <= '1';
  s_Rd_sel <= "100";
  s_Rm_sel <="000";
  s_Rn_sel <="000";
  s_io_read_set <= '0';
  s_io_write_set <= '0';
  s_io_ld <= '0';
  s_io_readinput <= "0000000000000000";
  s_immediate <= (others => 'Z');
  s_ula_op <= "0000";
  wait for PERIOD;

end process;


end Behavioral;
