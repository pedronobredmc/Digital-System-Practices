library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Register_File is
    generic (N:integer:=16);
    Port (
        clock : in std_logic; 
        reset : std_logic;
        
        rd_din: in std_logic_vector(N-1 downto 0);
        rd_sel : in std_logic_vector(2 downto 0); 
        rd_wr : in std_logic:='0';
        
        rm_sel : in std_logic_vector(2 downto 0);
        Rm_dout: out std_logic_vector(N-1 downto 0);
        
        rn_sel : in std_logic_vector(2 downto 0);
        rn_dout: out std_logic_vector(N-1 downto 0)
  );
end Register_File;

architecture Behavioral of Register_File is
    type banco_registradores is array(0 to 15) of std_logic_vector (N-1 downto 0);
    signal Reg: banco_registradores;
    signal wreg: std_logic_vector (N-1 downto 0);
begin
    R:for i in 0 to 7 generate
        wreg(i)<='1' when rd_sel=i and rd_wr='1' else '0';    
        REG_X: entity work.registrador
        generic map(N=>N)
        port map(
            clock => clock,
            reset => reset,
            ld => wreg(i),
            D => rd_din,
            Q => reg(i)
        );
        
  -- Seleção de Rm
  with Rm_sel select
       Rm_dout <= reg(0) when "111",
                  reg(1) when "110",
                  reg(2) when "101",
                  reg(3) when "100",        
                  reg(4) when "011",
                  reg(5) when "010",
                  reg(6) when "001",
                  reg(7) when others;
                  
  -- Seleção de Rn                
  with Rn_sel select
       Rn_dout <= reg(0) when "111",
                  reg(1) when "110",
                  reg(2) when "101",
                  reg(3) when "100",        
                  reg(4) when "011",
                  reg(5) when "010",
                  reg(6) when "001",
                  reg(7) when others;
                  
  -- Seleção de Rd
  wreg(0) <= Rd_wr when Rd_sel = "000" else '0';
  wreg(1) <= Rd_wr when Rd_sel = "001" else '0';
  wreg(2) <= Rd_wr when Rd_sel = "010" else '0';
  wreg(3) <= Rd_wr when Rd_sel = "011" else '0';
  wreg(4) <= Rd_wr when Rd_sel = "100" else '0';
  wreg(5) <= Rd_wr when Rd_sel = "101" else '0';
  wreg(6) <= Rd_wr when Rd_sel = "110" else '0';
  wreg(7) <= Rd_wr when Rd_sel = "111" else '0';        
end generate;

end Behavioral;
