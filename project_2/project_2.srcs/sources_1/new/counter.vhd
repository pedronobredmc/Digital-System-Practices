library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
entity counter is
      Port (
        clk: in std_logic;
        rst: in std_logic;
        cnt_in: in std_logic_vector(4 downto 0);
        cnt_out: out std_logic_vector(4 downto 0);
        enab: in std_logic;
        load: in std_logic
      );
end counter;
architecture Behavioral of counter is
    signal s_cnt_out: std_logic_vector(4 downto 0);
begin      
    process(clk)
    begin
        if(rst='1')then
        s_cnt_out<=(others=>'0');
        elsif(clk'event and clk='0' and load='1')then
            s_cnt_out<=cnt_in;
        elsif(clk'event and clk='0' and enab ='1')then
            s_cnt_out <= (s_cnt_out + "1");
        end if;
        cnt_out<=s_cnt_out;
    end process;

end Behavioral;
