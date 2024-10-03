library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity driver_testbench is
         --Port ();
end driver_testbench;

architecture Behavioral of driver_testbench is
    constant N:integer:=8;
    signal tb_clk :std_logic:='0';
    signal tb_rst :std_logic;
    signal sdata_en :std_logic;
    signal sdata_in: std_logic_vector(N-1 downto 0);
    signal sdata_out: std_logic_vector(N-1 downto 0);
    
    constant periodo: time := 100 ns;
begin    
    DUT: entity work.driver
        Port map( 
        clk=>tb_clk, 
        rst=>tb_rst,
        data_en=>'1',
        driver_in=>sdata_in,
        driver_out=>sdata_out
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
        wait until tb_rst='0';
        
        sdata_in<=X"01";
        wait for periodo;
        
        sdata_in<=X"03";
        wait for periodo;
        
        sdata_in<=X"05";
        wait for periodo;
        
        sdata_in<=X"07";
        wait;
   end process;
end Behavioral;
