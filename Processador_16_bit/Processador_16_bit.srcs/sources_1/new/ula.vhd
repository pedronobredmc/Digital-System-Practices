library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

entity ULA is
    generic(N : integer := 16);
    Port ( 
           A     :  in std_logic_vector(N-1 downto 0);
           B     :  in std_logic_vector(N-1 downto 0);
           op    :  in std_logic_vector(3 downto 0);
           Q     :  out std_logic_vector(N-1 downto 0);
           Immed :  in std_logic_vector(4 downto 0);
           Z     :  out std_logic;
           C     :  out std_logic 
           );
end ULA;

architecture Behavioral of ULA is
    signal mux_result: std_logic_vector(2*N - 1 downto 0);
begin
    mux_result <= A * B;
    Z <= '1' when (A = B) else '0';
    C <= '1' when (A < B) else '0';
    process(op)
    begin
        case(op) is
            when "0100" => Q <= A + B;
            when "0101" => Q <= A - B;
            when "0110" => Q <= mux_result(N-1 downto 0);
            when "0111" => Q <= A and B;
            when "1000" => Q <= A or B;
            when "1001" => Q <= not A;
            when "1010" => Q <= A xor B;
            when "1011" => Q <= shr(A, immed);
            when "1100" => Q <= shl(A, Immed);
            when "1101" => Q <= A(0) & A(N-1 downto 1);
            when "1110" => Q <= A(N-2 downto 0) & A(N-1);
            when others => Q <= (others => '0');
        end case;
    end process;

end Behavioral;
