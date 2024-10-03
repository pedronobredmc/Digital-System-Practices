library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity datapath is
    generic (N : integer := 16);
    Port ( 
            RAM_dout  : in std_logic_vector(N-1 downto 0);
            ROM_dout  : in std_logic_vector(N-1 downto 0);
            Immed     : in std_logic_vector(N-1 downto 0);
            Rf_sel    : in std_logic_vector(1 downto 0);
            Rd_sel    : in std_logic_vector(2 downto 0);
            Rd_wr     : in std_logic;
            Rm_sel    : in std_logic_vector(2 downto 0);    
            Rn_sel    : in std_logic_vector(2 downto 0);
            ula_op    : in std_logic_vector(3 downto 0);
            RAM_addr  : out std_logic_vector(N-1 downto 0);
            RAM_din   : out std_logic_vector(N-1 downto 0);
            RAM_sel   : in std_logic;
            clk       : in std_logic;
            rst       : in std_logic;
            Z         : inout std_logic;
            C         : inout std_logic;
            stack_en  : in std_logic;
            stack_op  : in std_logic_vector(1 downto 0);
            immed_en  : in std_logic;
            IO_dout   : in std_logic_vector(N-1 downto 0);
            IO_en     : in std_logic;
            IO_sel    : in std_logic
            );
end datapath;

architecture Behavioral of datapath is
    signal Rm_s, Rn_s, Q_s, Rd_s, D_sp, Q_sp: std_logic_vector(N-1 downto 0);
begin
    RAM_addr <= Rm_s when stack_en = '0' else
                Q_SP - 1 when stack_op = "10" else
                Q_SP;
    RAM_din <= Rn_s when RAM_sel = '0' and (ROM_dout(15 downto 11) = "00100" or ROM_dout(15 downto 11) = "00000") else
               Immed when ROM_dout(15 downto 11) = "00101";
    Rd_s <= Rm_s     when Rf_sel = "00" else
            RAM_dout when Rf_sel = "01" and IO_sel = '0' else
            IO_dout  when Rf_sel = "01" and IO_sel = '1' else    
            Immed    when Rf_sel = "10" else
            Q_s ;
                                    
    D_SP <= Immed when immed_en = '1' else
            Q_SP;                                
                                      
    ULA: entity work.ULA
            generic map (N => N)
            port map(
                A   => Rm_s,  
                B   => Rn_s,  
                op  => ula_op,
                Q   => Q_s,
                Immed => Immed(4 downto 0),
                Z   => Z,
                C   => C
            );
    
    Register_file: entity work.register_file
                    generic map(N => N)
                    port map(
                        Rd     => Rd_s,
                        Rm     => Rm_s,
                        Rn     => Rn_s,
                        Rd_sel => Rd_sel,
                        Rm_sel => Rm_sel,
                        Rn_sel => Rn_sel,
                        Rd_wr  => Rd_wr,
                        clk    => clk,
                        rst    => rst             
                    );   
     SP:entity work.SP
                    generic map(N => N)
                    port map(
                         D   => D_sp,
                         Q   => Q_sp,
                         rst => rst,
                         clk => clk,
                         en  => stack_en,
                         op  => stack_op
                    );                

end Behavioral;
