library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Register_File is
    generic (N:integer:=32);
    Port (
        clock : in std_logic; 
        reset : std_logic;
        AdRP1, AdRP2, AdWP : in std_logic_vector(4 downto 0);
        DataWP : in std_logic_vector(N-1 downto 0);
        DataRP1, DataRP2 : out std_logic_vector(N-1 downto 0);
        --rd_sel : in std_logic_vector(2 downto 0); 
        --rd_wr : in std_logic;
        ce : in std_logic
        --rm_sel : in std_logic_vector(2 downto 0);
        --rn_sel : in std_logic_vector(2 downto 0);
        --rd: in std_logic_vector(N-1 downto 0);
        --Rm: out std_logic_vector(N-1 downto 0);
        --rn: out std_logic_vector(N-1 downto 0)
  );
end Register_File;

architecture Behavioral of Register_File is
    type banco_registradores is array(0 to 31) of std_logic_vector (N-1 downto 0);
    signal Reg: banco_registradores;
    signal wreg: std_logic_vector (N-1 downto 0);
begin
    gx:for i in 0 to 31 generate
        --ld_reg(i)<='1' when rd_sel=i and rd_wr='1' else '0';
        wreg(i)<='1' when i /=0 and AdWP =i and ce='1' else '0';     
        REG_X: entity work.registrador
        generic map(N=>N)
        port map(
            clock => clock,
            reset => reset,
            ce => wreg(i),
            D => DataWP,
            Q => reg(i)
        );
    end generate;
    
    DataRP1<=reg(conv_integer (AdRP1));
    
    DataRP2<=reg(conv_integer (AdRP2));

end Behavioral;
