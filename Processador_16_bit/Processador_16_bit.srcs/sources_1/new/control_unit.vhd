library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity control_unit is
  generic(N : integer := 16);
  Port
    (
       ROM_en   : out std_logic;
       clk      : in std_logic;
       rst      : in std_logic;
       Immed    : inout std_logic_vector(N-1 downto 0);
       RAM_sel  : out std_logic;
       RAM_we   : out std_logic;
       RF_sel   : out std_logic_vector(1 downto 0);
       Rd_sel   : out std_logic_vector(2 downto 0);
       Rd_wr    : out std_logic;
       Rm_sel   : out std_logic_vector(2 downto 0);
       Rn_sel   : out std_logic_vector(2 downto 0);
       ula_op   : out std_logic_vector(3 downto 0);
       ROM_dout : in  std_logic_vector(N-1 downto 0);
       ROM_addr : out std_logic_vector(N-1 downto 0);
       Z        : in std_logic;
       C        : in std_logic;
       stack_en : out std_logic;                  
       stack_op : out std_logic_vector(1 downto 0);
       immed_en : inout std_logic;
       IO_en    : out std_logic;
       IO_sel   : out std_logic     
    );
end control_unit;

architecture Behavioral of control_unit is
        signal PC_clr, PC_inc : std_logic;
        signal IR_data, IR_IN  : std_logic_vector(N-1 downto 0);
        signal IR_load  : std_logic;
        signal PC_D, PC_Q, aux : std_logic_vector(N-1 downto 0) := (others => '0');
        signal PC_Mux: std_logic_vector(8 downto 0);
        signal Flags_D: std_logic_vector(1 downto 0) := Z & C; 
        signal Flags_DATA: std_logic_vector(1 downto 0);
        signal Flags_LOAD: std_logic;
begin

    FSM: entity work.fsm
            generic map(N => N)
            port map(
              PC_clr => PC_clr ,
              PC_inc => PC_inc ,
              ROM_en => ROM_en ,
              clk    => clk    ,
              rst    => rst    ,
              IR_load=> IR_load,
              IR_data=> IR_data,
              Immed  => Immed  ,
              RAM_sel=> RAM_sel,
              RAM_we => RAM_we ,
              RF_sel => RF_sel ,
              Rd_sel => Rd_sel ,
              Rd_wr  => Rd_wr  ,
              Rm_sel => Rm_sel ,
              Rn_sel => Rn_sel ,
              ula_op => ula_op,
              Flags_DATA => Flags_DATA,
              Flags_LOAD => Flags_LOAD,
              Immed_en => Immed_en,
              stack_en => stack_en,
              stack_op => stack_op,
              IO_en    => IO_en,
              IO_sel   => IO_sel 
            );
            
    IR: entity work.registrador
                generic map(N => N)
                port map(
                    D     => IR_IN,
                    ld    => IR_load,
                    clk   => clk,          
                    rst   => rst,
                    Q     => IR_data
                );
                
    PC: entity work.registrador
                generic map(N => N)
                port map(
                    D    => PC_D,
                    ld   => PC_inc,
                    clk  => clk,
                    rst  => PC_clr,
                    Q    => PC_Q
                );
    
    Flags: entity work.registrador
            generic map (N => 2)
            port map(
                    D   => Flags_D,
                    ld  => Flags_LOAD,
                    clk => clk,
                    rst => rst,
                    Q   => Flags_DATA
                    );                
    PC_Mux <= Immed(8 downto 0) when Immed_en = '1' else "000000010";
    Flags_D <= Z & C;
    PC_D <= PC_Q + PC_mux;
    ROM_addr <= PC_Q;      
    IR_IN <= ROM_Dout;                           
end Behavioral;
