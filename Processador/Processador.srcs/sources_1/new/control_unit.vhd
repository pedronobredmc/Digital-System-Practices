library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
entity control_unit is
    generic(N:integer:= 16);
        Port (
            clock   : in std_logic;
            reset   : in std_logic;
            Ir_data : in std_logic_vector(N-1 downto 0);
            rom_en  : out std_logic;
            rom_addr: out std_logic_vector(N-1 downto 0);
            rom_dout: in std_logic_vector(N-1 downto 0);
            immed   : inout std_logic_vector(N-1 downto 0);
            ram_sel : out std_logic;
            ram_we  : out std_logic;
            rf_sel  : out std_logic_vector(1 downto 0);
            rd_sel  : out std_logic_vector(2 downto 0);
            rd_wr   : out std_logic;
            rm_sel  : inout std_logic_vector(2 downto 0);
            rn_sel  : out std_logic_vector(2 downto 0);
            carry   : in std_logic;
            zero    : in std_logic;
            IO_read : out std_logic_vector(N-1 downto 0); 
            IO_write: out std_logic_vector(N-1 downto 0);
            ula_op  : out std_logic_vector(3 downto 0)
        );
end control_unit;

architecture Behavioral of control_unit is
    --PC
    signal s_pc_clr: std_logic;
    signal s_pc_inc: std_logic;
    signal s_pc_q  : std_logic_vector(N-1 downto 0);
    signal s_pc_d  : std_logic_vector(N-1 downto 0);
    
    --IR
    signal s_ir_ld : std_logic;
    signal s_ir_d  : std_logic_vector(N-1 downto 0);
    signal s_ir_q  : std_logic_vector(N-1 downto 0);
    
    signal jump_en : std_logic;
    signal jump_op : std_logic_vector(1 downto 0);
    signal s_zero  : std_logic;
    signal s_carry : std_logic;
begin
    controlador: entity work.controller_fsm
        port map(
            clock   => clock,
            reset   => reset,
            IR_data => s_ir_d,
            IR_load => s_ir_ld,
            immed   => immed,
            Ram_sel => ram_sel,
            Ram_we  => ram_we,
            RF_sel  => rf_sel,
            Rd_sel  => rd_sel,
            Rd_wr   => rd_wr,
            Rm_sel  => rm_sel,
            Rn_sel  => rn_sel,
            ula_op  => ula_op,
            Rom_en  => rom_en,
            Pc_clr  => s_pc_clr,
            IO_read => IO_read,
            IO_write=> IO_write,
            Pc_inc  => s_pc_inc
        );
    
    IR: entity work.registrador
        generic map(N=>16)
        port map(
            clock   => clock,
            reset   => reset,
            ld      => s_ir_ld,
            d       => s_ir_d,
            q       => s_ir_q
        );
    PC: entity work.registrador
        generic map(N=>16)
        port map(
            clock   => clock,
            reset   => reset,
            ld      => s_ir_ld,
            d       => s_ir_d,
            q       => s_ir_q
        );
    INC: entity work.inc
         generic map(N=>16, VAL=>2)
         port map (
            Q       => s_pc_q,
            D       => s_pc_d
        );
                    
    s_ir_d <= rom_dout;
    rom_addr <= s_pc_d;
    
    s_PC_Q <= (s_PC_D + 2 + Immed) when (jump_en = '1' and jump_op = "00")                      else
    (s_PC_D + 2 + Immed) when (jump_en = '1' and jump_op = "01" and zero = '1' and carry = '0') else
    (s_PC_D + 2 + Immed) when (jump_en = '1' and jump_op = "10" and zero = '0' and carry = '1') else
    (s_PC_D + 2 + Immed) when (jump_en = '1' and jump_op = "11" and zero = '0' and carry = '0') else
                
    s_PC_D + 2 when jump_en = '0';
    
end Behavioral;
