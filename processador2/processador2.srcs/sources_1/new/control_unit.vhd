library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_unit is
Generic (N:integer := 16);
Port ( clk              : in std_logic;
       reset            : in std_logic;
       ROM_en           : out std_logic :='0';                 -- l� mem�ria de programa
       ROM_addr         : out std_logic_vector(N-1 downto 0); -- Endere�o da mem�ria de programa
       IR_data          : in std_logic_vector (N-1 downto 0);  -- instru��o
       Immed            : out std_logic_vector (N-1 downto 0); --valor imediato
       RAM_sel          :out std_logic;                        -- seleciona fonte de dados da RAM
       RAM_we           :out std_logic:='0';
       ram_addsel       : out std_logic := '0';                   -- habilita escrita na RAM
       RF_sel           : out std_logic_vector (1 downto 0);   -- seleciona fonte de dados do RF
       Rd_sel           : out std_logic_vector (2 downto 0);   -- seleciona Rd  
       Rd_wr            : out std_logic :='0';                 -- habilita escrita em Rd  
       Rm_sel           : out std_logic_vector (2 downto 0);   -- seleciona Rm
       Rn_sel           : out std_logic_vector (2 downto 0);   -- seleciona Rn
       Ula_Op           : out std_logic_vector (3 downto 0);    -- seleciona opera��o da ULA
       io_read_set      : out std_logic := '0';                     --setar mux no RD
       io_write_set     : out std_logic := '0';                     --setar mux na saida de io
       io_ld            : out std_logic := '0';                     --permite escrita
       z                : in std_logic;
       c                : in std_logic;
       sp_sel           : out std_logic;
       sp_ld            : out std_logic
      );

end control_unit;

architecture Behavioral of control_unit is

-- PC
signal s_pc_clr  : std_logic;
signal s_pc_din :std_logic_vector(N-1 downto 0);
signal s_pc_dout :std_logic_vector(N-1 downto 0);
signal s_pc_inc  : std_logic;
signal s_pc_set  : std_logic;
signal s_pc_cadder : std_logic_vector(N-1 downto 0);
signal s_pc_wimed : std_logic_vector(N-1 downto 0);

-- IR
signal s_ir_ld   : std_logic;
signal s_ir_din : std_logic_vector (N-1 downto 0);
signal s_ir_dout : std_logic_vector (N-1 downto 0);
            
-- IMMEDIATE
signal s_immed : std_logic_vector(N-1 downto 0); 

begin

controlador: entity work.controller_FSM
       port map ( clk => clk,
                  reset => reset, 
                  PC_clr => s_pc_clr,
                  PC_inc => s_pc_inc,
                  PC_set => s_pc_set,
                  ROM_en => ROM_en,
                  IR_ld => s_ir_ld,
                  IR_data => s_ir_dout,
                  immed => s_immed,
                  RAM_sel => RAM_sel,
                  RAM_we => RAM_we,
                  RF_sel => RF_sel,
                  Rd_sel => Rd_sel,  
                  Rd_wr  => Rd_wr,
                  Rm_sel => Rm_sel,
                  Rn_sel => Rn_sel,
                  ula_op => Ula_Op,
                  z => z,
                  c => c,
                  io_read_set => io_read_set,
                  io_write_set => io_write_set,
                  io_ld => io_ld,
                  sp_sel => sp_sel,
                  sp_ld => sp_ld,
                  ram_addsel => ram_addsel
                  );

IR: entity work.registrador 
    generic map (N=>16) 
    port map(clk=>clk,
             rst=>reset,
             ld=>s_ir_ld,
             d=>s_ir_din,
             q=>s_ir_dout);

PC: entity work.registrador 
    generic map (N=>16) 
    port map(clk=>clk,
             ld=>s_pc_inc,
             rst=>s_pc_clr,
             d=>s_pc_din,
             q=>s_pc_dout);

MUXPCIMED: entity work.mux_2x1
    generic map (N => 16)
    port map (
        sel => s_pc_set,
        I0  => s_pc_cadder,
        I1  => s_pc_wimed,
        O0  => s_pc_din
    );

INC_PC: entity work.constant_adder
         generic map(N=>16, VAL=>1)
         port map  (I0 => s_pc_dout,
                    O0 => s_pc_cadder);
                
             
s_pc_wimed <= s_pc_dout + s_immed;
s_ir_din <= IR_data;
ROM_addr <= s_pc_dout;

Immed <= s_immed;
  
end Behavioral;