library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity ram is
  generic(N : integer := 16);
  Port (
        din     :  in std_logic_vector(N-1 downto 0);
        addr    :  in std_logic_vector(N-1 downto 0);
        dout    :  out std_logic_vector(N-1 downto 0);  
        we      :  in std_logic;
        clk     :  in std_logic
   );
end ram;

architecture Behavioral of ram is   
    type memory is array(0 to (2**N - 1)) of std_logic_vector(N-1 downto 0);
    signal ram_memory : memory := (others => (others => '0'));

begin
    process(clk)
    begin
    
    if(rising_edge(clk) or clk = '1')then
        if(we = '1') then
            ram_memory(conv_integer(addr)) <= din;
        end if;
    end if;   
    end process;
    
   dout <= ram_memory(conv_integer(addr));

end Behavioral;
