library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_tb is
         --Port ();
end counter_tb;

architecture Behavioral of counter_tb is
    signal tb_clk :std_logic:='0';
    signal tb_rst :std_logic;
    signal sdata_en :std_logic;
    signal sdata_in: std_logic_vector(4 downto 0);
    signal sdata_out: std_logic_vector(4 downto 0);
    signal sload:std_logic;
    
    constant periodo: time := 100 ns;
begin    
    DUT: entity work.counter
        Port map( 
        clk=>tb_clk,
        rst=>tb_rst,
        cnt_in=>sdata_in,
        cnt_out=>sdata_out,
        enab=>sdata_en,
        load=>sload
    );
    
   tb_clk<= not tb_clk after periodo/2;
   
   process
   begin
        tb_rst<='1';
        wait for 2*periodo;
        tb_rst<='0';
        wait;
   end process;
   
   teste:process
   begin
        -- Initialize inputs
        tb_rst <= '1';
        wait for periodo;
        tb_rst <= '0';
        wait for periodo;

        -- Test load functionality
        sload <= '1';
        sdata_in <= "00011"; -- Load value 3
        wait for periodo;
        sload <= '0';

        -- Enable counting
        sdata_en <= '1';
        wait for 5 * periodo;

        -- Disable counting
        sdata_en <= '0';
        wait for 3 * periodo;

        -- Test reset functionality
        tb_rst <= '1';
        wait for periodo;
        tb_rst <= '0';

        wait for 10 * periodo;
        
        -- Finish simulation
        wait;
        
   end process;
end Behavioral;
