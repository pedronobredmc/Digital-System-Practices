library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity tb_datapath is

end tb_datapath;

architecture Behavioral of tb_datapath is

constant PERIOD : time := 10 ns;
constant N: integer:=16;

signal tb_clk : std_logic := '0'; -- deve ser inicializado
signal tb_rst : std_logic;

--Register file (RF)         
signal s_Rd_wr:  std_logic :='0';         
signal s_Rd_sel: std_logic_vector(2 downto 0);
signal s_Rm_sel: std_logic_vector(2 downto 0);
signal s_Rn_sel: std_logic_vector(2 downto 0);
signal s_Rm_dout: std_logic_vector(N-1 downto 0);
signal s_Rn_dout: std_logic_vector(N-1 downto 0);
         
--ULA         
signal s_ula_op: std_logic_vector(3 downto 0);
         
--Memória
signal s_din: std_logic_vector(N-1 downto 0);
signal s_mem_din: std_logic_vector(N-1 downto 0);
signal s_mem_addr:std_logic_vector(N-1 downto 0);
signal s_we: std_logic :='0';
signal s_stack_en:std_logic;
signal s_stack_op:std_logic_vector(1 downto 0);
        
--RF Source
signal s_immediate: std_logic_vector(N-1 downto 0);
signal s_RF_source: std_logic_vector(1 downto 0);

--Mux
signal s_RAM_sel: std_logic;

signal s_pin_out: std_logic_vector(N-1 downto 0);

begin
DUT: entity work.datapath
     generic map(N => 16)
     port map ( clock => tb_clk,
  	            reset => tb_rst, 
                Rd_wr => s_Rd_wr,        
                Rd_sel => s_Rd_sel,
                Rm_sel => s_Rm_sel,
                Rn_sel => s_Rn_sel,
                ula_op => s_ula_op,
                ram_din => s_din,
                ram_addr => s_rm_dout,
                ram_dout => s_rn_dout,
                immed => s_immediate,
                RF_sel => s_RF_source,
                pin_out => s_pin_out,
                RAM_sel => s_RAM_sel);
                
RAM: entity work.ram
     generic map(data_width => 16, addr_width => 16)
     port map(
                clk => tb_clk,
                addr => s_mem_addr,
                din => s_mem_din,
                we => s_we,
                stack_en => s_stack_en,
                stack_op => s_stack_op,
                dout => s_din);
                
  
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
  s_ula_op <="0101";
  s_immediate <= (others => 'Z');
  wait for PERIOD;
  
  -- str [R1],R2 --> [Rm] = Rn 
  s_Rd_wr <='0';
  s_we <='1';
  s_Rm_sel <= "001";
  s_Rn_sel <="010";
  wait for PERIOD;
  
  -- str [R0],R3 --> [Rm] = Rn 
  s_Rd_wr <='0';
  s_we <='1';
  s_Rm_sel <= "000";
  s_Rn_sel <="011";
  wait for PERIOD;
    
  
  -- ldr R6,[R0] --> Rd = [Rm] 
  s_Rd_wr <='1';
  s_RF_source <= "01";
  s_we <='0';
  s_Rd_sel <= "110";
  s_Rm_sel <="000";
  wait for PERIOD;    
  
  -- ldr R7,[R1] --> Rd = [Rm] 
  s_Rd_wr <='1';
  s_RF_source <= "01";
  s_we <='0';
  s_Rd_sel <= "111";
  s_Rm_sel <="001";
  wait for PERIOD;

   
  
  
  s_Rd_sel <= (others => 'Z');
  s_Rd_wr <='0';
 
 for i in 0 to 7 loop
     s_rm_sel <= conv_std_logic_vector(i, 3);
     wait for PERIOD;
 end loop; 
               
end process;



--por enquanto o endereço vem sempre de Rm
s_mem_din <= s_rn_dout;
s_mem_addr <= s_rm_dout;                            

end Behavioral;
