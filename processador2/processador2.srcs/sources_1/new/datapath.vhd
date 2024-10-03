library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity datapath is
Generic (N:integer :=16); 
  Port ( clk            : in STD_LOGIC;
  	     rst            : in STD_LOGIC;         
         Rd_wr          : in std_logic :='0';         
         Rd_sel         : in std_logic_vector(2 downto 0);
         Rm_sel         : in std_logic_vector(2 downto 0);
         Rn_sel         : in std_logic_vector(2 downto 0);     
         ula_op         : in std_logic_vector(3 downto 0);
         z              : out std_logic;
         c              : out std_logic;
         IO_read        : in  std_logic_vector(n-1 downto 0);                 --IO para REGISTRADOR
         IO_write       : out std_logic_vector(n-1 downto 0);                 --RM ou IMED para IO
         io_read_set    : in std_logic;                                   --setar mux no RD
         io_write_set   : in std_logic;
         ram_din        : in std_logic_vector(N-1 downto 0);
         ram_dout       : out std_logic_vector(N-1 downto 0);
         ram_addr       : out std_logic_vector(N-1 downto 0);
         immediate      : in std_logic_vector(N-1 downto 0);
         RF_source      : in std_logic_vector(1 downto 0);
         RAM_sel        : in std_logic;
         sp_ld          : in std_logic;
         sp_sel         : in std_logic;
         ram_addsel     : in std_logic
  );
end datapath;

architecture Behavioral of datapath is

--Memória
signal s_mem_dout_to_RF_source: std_logic_vector(N-1 downto 0);
signal s_ram_addr: std_logic_vector(N-1 downto 0) := (others => '0');

--Register file
signal s_RF_din:  std_logic_vector(N-1 downto 0) := (others => '0');
signal s_muxrdin: std_logic_vector(N-1 downto 0) := (others => '0');
signal s_Rm_dout: std_logic_vector(N-1 downto 0);
signal s_Rn_dout: std_logic_vector(N-1 downto 0);


--ULA
signal s_sel_ula_B : std_logic;
signal s_ula_B : std_logic_vector(N-1 downto 0);
signal s_ula_Q_to_RF_source: std_logic_vector(N-1 downto 0);

--IO
signal s_io_read : std_logic_vector(N-1 downto 0) := (others => '0');

signal s_SP : std_logic_vector(N-1 downto 0);
signal s_SP1 : std_logic_vector(N-1 downto 0);
signal s_SPTORAM : std_logic_vector(N-1 downto 0);

begin

INC: entity work.constant_adder
         generic map(N=>16, VAL=>1)
         port map  (I0 => s_SP,
                    O0 => s_SP1);

PILHA: entity work.pilha
    generic map(N => 16)
    port map (
        clk => clk,
        rst => rst,
        sp_sel => sp_sel,
        sp_ld => sp_ld,
        SP => s_SP
    );

ULA: entity work.ula
     generic map(N => 16)
     port map( A => s_Rm_dout,
               B => s_ula_B,
               Q => s_ula_Q_to_RF_source,
               op => ula_op,
               z => z,
               c => c);


RF:entity work.register_file
   generic map(N => 16)
   port map( clk => clk,
             rst => rst, 
             Rd_din => s_muxrdin,
             Rd_sel => Rd_sel,
             Rd_wr => Rd_wr,
             Rm_dout => s_Rm_dout,
             Rm_sel => Rm_sel,
             Rn_dout => s_Rn_dout,
             Rn_sel => Rn_sel
            );               

RAM_Mux: entity work.mux_2x1 
    generic map (N => 16)
    port map ( sel => RAM_sel,
           I0  => s_Rn_dout,
           I1  => immediate,
           O0  => ram_dout);

ULAB_MUX: entity work.mux_2x1
    generic map (N => 16)
    port map (
        sel => s_sel_ula_B,
        I0  => s_Rn_dout,
        I1  => immediate,
        O0  => s_ula_B
    );

RD_MUX: entity work.mux_2x1
    generic map (N => 16)
    port map (
        sel => io_read_set,
        I0  => s_RF_din,
        I1  => s_io_read,
        O0  => s_muxrdin
    );

s_io_read <= X"00" & IO_read(7 downto 0);

IO_WRITE_MUX: entity work.mux_2x1
    generic map (N => 16)
    port map (
        sel => io_write_set,
        I0  => s_Rm_dout,
        I1  => immediate,
        O0  => IO_write
    );

Register_file:
with RF_source select
s_RF_din <= s_Rm_dout               when "00", --Rd = Rm
            s_mem_dout_to_RF_source when "01", --Rd = [Rm]
            immediate               when "10", --Rd = immediate 
            s_ula_Q_to_RF_source    when "11", --Rd = Rm op Rn
            s_RF_din                when others;

s_mem_dout_to_RF_source <= ram_din;

RAMADDRESS:
with ram_addsel select
s_ram_addr <= s_Rm_dout when '0',
              s_SPTORAM when '1',
              s_ram_addr when others;

ram_addr <= s_ram_addr;

s_sel_ula_B <= '1' when (ula_op = "1011" or ula_op = "1100") else '0';

PP1:
with sp_sel select
s_SPTORAM <= s_SP when '0',
             s_SP1 when '1',
             s_SPTORAM when others;

end Behavioral;