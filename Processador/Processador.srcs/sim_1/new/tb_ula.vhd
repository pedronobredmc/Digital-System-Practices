library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ula is
    generic(N : integer := 16);
--  Port ( );
end tb_ula;

architecture Behavioral of tb_ula is
  signal resultado  : std_logic_vector(N-1 downto 0);
  signal op         : std_logic_vector(3 downto 0);
  signal operA      : std_logic_vector(N-1 downto 0);                     
  signal operB      : std_logic_vector(N-1 downto 0);
  signal immed      : std_logic_vector(N-1 downto 0);
  signal zero       : std_logic;
  signal carry      : std_logic;
  constant clock_period :time := 100 ns;                     
begin
    ula_teste: 
    entity work.ula
           generic map(N => N)          
           port map(
           
               resultado => resultado,
                op       => op,
                operA    => operA,
                operB    => operB,
                immed    => immed,
                zero     => zero,
                carry    => carry
                
           ); 
           
     --clk <= not clk after 100 ns;
     
     estimulos: process
     begin 
        operA <= x"0001";
        operB <= x"0001";
        wait for clock_period;
    
        op <=  "0000";
        wait for clock_period;
        op <=  "0100" ;
        wait for clock_period;
        op <=  "0101" ;
        wait for clock_period;
        op <=  "0110";
        wait for clock_period;   
        op <=  "0111";
        wait for clock_period;
        op <=  "1000";
        wait for clock_period;
        op <=  "1001";
        wait for clock_period;
        op <=  "1010";
        wait for clock_period;
        op <=  "1011";
        wait for clock_period;
        op <=  "1100";
        wait for clock_period;
        op <=  "1101";
        wait for clock_period;
        op <=  "1110";
        wait for clock_period;   
     end process;      
end Behavioral;