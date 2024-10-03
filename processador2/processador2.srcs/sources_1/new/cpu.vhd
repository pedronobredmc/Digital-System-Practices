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
          signal s_stack_sel  :  std_logic;                      
          signal s_stack_ld   :  std_logic;                                          
          signal s_ula_op     :  std_logic_vector(3 downto 0);    
          signal s_zero       :  std_logic;                         
          signal s_carry      :  std_logic;                        
          signal s_immed      :  std_logic_vector(N-1 downto 0);   
          signal s_rf_sel     :  std_logic_vector(1 downto 0);    
          signal s_pin_out    :  std_logic_vector(N-1 downto 0); 
          signal s_ram_sel    :  std_logic;
          signal s_ram_add_sel:  std_logic;
          signal s_rom_addr   :  std_logic_vector(N-1 downto 0);
          signal s_rom_q      :  std_logic_vector(N-1 downto 0);
          signal s_IO_read    :  std_logic_vector(n-1 downto 0);
          signal s_IO_write   :  std_logic_vector(n-1 downto 0);
          signal s_IO_sysinput:  std_logic_vector(n-1 downto 0);
          signal s_IO_userinput: std_logic_vector(n-1 downto 0);
          signal s_IO_ld	  : std_logic;
          signal s_IO_read_set: std_logic;
          signal s_IO_write_set: std_logic;
begin
    control_Unit:
    entity work.control_unit
    generic map(N=>16)
        port map(
            clk         =>   clock,
            reset       =>   reset,
            ROM_en      =>   s_rom_en,
            ROM_addr    =>   s_rom_addr,
            IR_data     =>   s_ir_d,
            Immed       =>   s_immed,
            RAM_sel     =>   s_ram_sel,
            RAM_we      =>   s_ram_we,
            ram_addsel  =>   s_ram_add_sel,
            RF_sel      =>   s_rf_sel,
            Rd_sel      =>   s_rd_sel,
            Rd_wr       =>   s_rd_wr,
            Rm_sel      =>   s_rm_sel,
            Rn_sel      =>   s_rn_sel,
            Ula_Op      =>   s_ula_op,
            io_read_set =>   s_IO_read_set,
            io_write_set=>   s_IO_write_set,
            io_ld       =>   s_io_ld,
            z           =>   s_zero,
            c           =>   s_carry,
            sp_sel      =>   s_stack_sel,
            sp_ld       =>   s_stack_ld
        );
    datapath_0:
    entity work.datapath
     generic map(N=>16)
        Port map(
            clk         => clock,
            rst         => reset,
            Rd_wr       => s_rd_wr,
            Rd_sel      => s_rd_sel,
            Rm_sel      => s_rm_sel,
            Rn_sel      => s_rn_sel,
            ula_op      => s_ula_op,
            z           => s_zero,
            c           => s_carry,
            IO_read     => s_io_read,
            IO_write    => s_io_write,
            io_read_set => s_IO_read_set,
            io_write_set=> s_IO_write_set,
            ram_din     => s_ram_d,
            ram_dout    => s_ram_q,
            ram_addr    => s_ram_addr,
            immediate   => s_immed,
            RF_source   => s_rf_sel,
            RAM_sel     => s_ram_sel,
            sp_ld       => s_stack_ld,
            sp_sel      => s_stack_sel,
            ram_addsel  => s_ram_add_sel
            );
    ROM : entity work.rom                       -- ROM instantiate
        Port map
        (
        clk     => clock,   
        address => s_rom_addr,
        en      => s_rom_en,
        dout    => s_rom_q
        );

    RAM : entity work.ram                       -- RAM instantiate
        Port map
       (
        clk     => clock,
        address => s_ram_addr,
        din     => s_ram_d,
        we      => s_ram_we,
        dout    => s_ram_q
        );
        
    IN_OUT : entity work.e_s
        Port map
        (
        IO_read     => s_io_read,
        IO_write    => s_io_write,
        IO_sysinput => s_io_sysinput,
        IO_userinput=> s_io_userinput,
        IO_ld	    => s_io_ld,
        clk			=> clock
        );
end Behavioral;