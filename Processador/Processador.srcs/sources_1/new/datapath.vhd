library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
    Generic
    (
        N : integer := 16
    );
    Port
    (
        clock    : in  std_logic;                       -- clock
        reset    : in  std_logic;                       -- reset
        zero     : out std_logic;                       -- ZERO? flag
        carry    : out std_logic;                       -- CARRY flag
        RF_sel   : in  std_logic_vector(1 downto 0);    -- Register file Rd in selector
        Rd_sel   : in  std_logic_vector(2 downto 0);    -- Register Rd selector
        Rd_wr    : in  std_logic := '0';                -- Rd write
        Rm_sel   : in  std_logic_vector(2 downto 0);    -- Rm register selector
        Rn_sel   : in  std_logic_vector(2 downto 0);    -- Rn register selector
        Immed    : in  std_logic_vector(N-1 downto 0);  -- Immediate value
        ula_op   : in  std_logic_vector(3 downto 0);    -- ula operation
        RAM_sel  : in  std_logic;                       -- RAM din selector 
        RAM_din  : in  std_logic_vector(N-1 downto 0);  -- RAM D input
        RAM_dout : out std_logic_vector(N-1 downto 0);  -- RAM Q output
        pin_out  : in  std_logic_vector(N-1 downto 0);
        RAM_addr : out std_logic_vector(N-1 downto 0)   -- RAM address
    );
end datapath;

architecture Behavioral of datapath is
    -- signals to handle output and input volatile values
    signal Rd_signal        : std_logic_vector(N-1 downto 0);
    signal Rm_signal        : std_logic_vector(N-1 downto 0);
    signal Rn_signal        : std_logic_vector(N-1 downto 0);
    signal RAM_dout_signal  : std_logic_vector(N-1 downto 0);
    signal ula_out_signal   : std_logic_vector(N-1 downto 0);
    signal s_ir_ld: std_logic;
    signal s_ir_q: std_logic_vector(N-1 downto 0);

begin
    REGISTER_FILE : entity work.register_file
        Generic map
        (
            N => 16
        )
        Port map
        (
            clock       => clock,
            reset       => reset,
            Rd_sel      => Rd_sel,
            Rd_wr       => Rd_wr,
            Rm_sel      => Rm_sel,
            Rn_sel      => Rn_sel,
            Rd_din      => Rd_signal,
            Rm_dout     => Rm_signal,
            Rn_dout     => Rn_signal
        );
        
    ULA : entity work.ula
        Generic map
        (
            N => 16
        )
        Port map
        (
            operA     => Rm_signal,
            operB     => Rn_signal,
            zero      => zero,
            carry     => carry,
            Immed     => Immed,
            op        => ula_op,
            resultado => ula_out_signal
        );
    RAM_Mux: entity work.mux_2x1 
        generic map (N =>16)
        port map
        ( 
           sel => RAM_sel,
           I0  => ula_out_signal,
           I1  => immed,
           O0  => ram_dout
         );
         
    RF_MUX  : entity work.mux_4x1
        generic map(N=>16)
        port map
        (
           I0  => rm_signal,
           I1  => RAM_dout_signal,
           I2  => Immed,
           I3  => ula_out_signal,
           sel => rf_sel,
           O0  => rd_signal
        );
    IN_OUT: entity work.registrador
        Port map                       
        (                           
            clock => clock,        
            reset => reset,        
            ld    => s_ir_ld,      
            d     => pin_out,    
            q     => s_ir_q        
        );                            
    ram_dout_signal <= ram_din;
    ram_addr <= rm_signal;
end Behavioral;