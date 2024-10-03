library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity cpu is
    generic (N:integer:=16);
    Port ( clock        : in std_logic;
           reset        : in std_logic                    
         );  
end cpu;
architecture Behavioral of cpu is
          signal s_rd_wr      :  std_logic:='0';                   
          signal s_rd         :  std_logic_vector(N-1 downto 0);       
          signal s_rm         :  std_logic_vector(N-1 downto 0);       
          signal s_rn         :  std_logic_vector(N-1 downto 0);       
          signal s_rd_sel     :  std_logic_vector(2 downto 0);    
          signal s_rm_sel     :  std_logic_vector(2 downto 0);    
          signal s_rn_sel     :  std_logic_vector(2 downto 0);    
          signal s_rom_en     :  std_logic:='0';                  
          signal s_pc_q       :  std_logic_vector(N-1 downto 0);    
          signal s_ir_d       :  std_logic_vector(N-1 downto 0);   
          signal s_ir_ld      :  std_logic;                        
          signal s_ir_q       :  std_logic_vector(N-1 downto 0);   
          signal s_ram_d      :  std_logic_vector(N-1 downto 0);   
          signal s_ram_q      :  std_logic_vector(N-1 downto 0);   
          signal s_ram_addr   :  std_logic_vector(N-1 downto 0);
          signal s_ram_we     :  std_logic;                       
          signal s_stack_en     :  std_logic;                      
          signal s_stack_op     :  std_logic_vector(1 downto 0);                                          
          signal s_ula_op     :  std_logic_vector(3 downto 0);    
          signal s_zero       :  std_logic;                         
          signal s_carry      :  std_logic;                        
          signal s_immed      :  std_logic_vector(N-1 downto 0);   
          signal s_rf_sel     :  std_logic_vector(1 downto 0);    
          signal s_pin_out    :  std_logic_vector(N-1 downto 0); 
          signal s_ram_sel    :  std_logic;
begin
    control_Unit:
    entity work.control_unit
    generic map(N=>16)
        port map(
            clock => clock,
            reset => reset,
            ir_data => s_ir_d,
            rom_en=>s_rom_en,
            rom_addr=>s_pc_q,
            rom_dout=>s_ir_d,
            immed=>s_immed,
            ram_sel=>s_ram_sel,
            ram_we=>s_ram_we,
            rf_sel=>s_rf_sel,
            rd_sel=>s_rd_sel,
            rd_wr=>s_rd_wr,
            rm_sel=>s_rm_sel,
            rn_sel=>s_rn_sel,
            zero => s_zero,
            IO_read  => s_pin_out,
            carry => s_carry,
            ula_op=>s_ula_op
        );
    datapath_0:
    entity work.datapath
     generic map(N=>16)
        Port map(
            clock    => clock,
            reset    => reset,
            zero     => s_zero,
            carry    => s_carry,
            RF_sel   => s_rf_sel,
            Rd_sel   => s_rd_sel,
            Rd_wr    => s_rd_wr,
            Rm_sel   => s_rm_sel,
            Rn_sel   => s_rn_sel,
            Immed    => s_immed,
            ula_op   => s_ula_op,
            pin_out => s_pin_out,
            RAM_sel  => s_ram_sel,
            RAM_din  => s_ram_d,
            RAM_dout => s_ram_q,
            RAM_addr => s_ram_addr
            );
    ROM : entity work.rom                       -- ROM instantiate
        Port map
        (
            clk=> clock,
            en   => s_rom_en,
            addr => s_ir_d,
            dout => s_pc_q
        );

    RAM : entity work.ram                       -- RAM instantiate
        Port map
       (
            clk    => clock,
            we       => s_ram_we,
            stack_en => s_stack_en,
            stack_op => s_stack_op,
            din      => s_ram_d,
            addr     => s_ram_addr,
            dout     => s_ram_q
        );
end Behavioral;