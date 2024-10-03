library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Registrador is
    generic (N:integer:=32);
    Port (
        clock : std_logic; 
        reset : std_logic;
        ce : in std_logic;
        d : in std_logic_vector(N-1 downto 0);
        q : out std_logic_vector(N-1 downto 0)
  );
end Registrador;

architecture Behavioral of Registrador is
   
begin
    process(clock)
    begin
        if(reset='1')then
        q<=(others=>'0');
        elsif(clock'event and clock='1')then
            if(ce='1')then
                q<=d;
            end if;
        end if;
    end process;

end Behavioral;
