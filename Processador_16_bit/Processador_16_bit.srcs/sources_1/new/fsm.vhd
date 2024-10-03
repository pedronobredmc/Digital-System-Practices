library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    generic(N : integer := 16);
    Port ( 
       PC_clr   : out std_logic;
       PC_inc   : out std_logic;
       ROM_en   : out std_logic;
       clk      : in std_logic;
       rst      : in std_logic;
       IR_load  : out std_logic;
       IR_data  : in  std_logic_vector(N-1 downto 0);
       immed    : inout std_logic_vector(N-1 downto 0);
       RAM_sel  : out std_logic;
       RAM_we   : out std_logic;
       RF_sel   : out std_logic_vector(1 downto 0);
       Rd_sel   : out std_logic_vector(2 downto 0);
       Rd_wr    : out std_logic;
       Rm_sel   : out std_logic_vector(2 downto 0);
       Rn_sel   : out std_logic_vector(2 downto 0);
       ula_op   : out std_logic_vector(3 downto 0);
       Flags_data:in std_logic_vector(1 downto 0);
       Flags_load:out std_logic; 
       Immed_en : out std_logic := '0';
       IO_en    : out std_logic := '0';
       IO_sel   : out std_logic := '0';
       stack_en : out std_logic;                  
       stack_op : out std_logic_vector(1 downto 0)
    ); 
end fsm;

architecture Behavioral of fsm is
    type estados is (init, fetch, decode, exec_nop, exec_halt, exec_mov, exec_load, exec_store, exec_ula, exec_stack, exec_jmp, exec_IO);
    signal next_state : estados;
    signal present_state: estados;
begin
   process(clk, rst)
   begin
        if(rst ='1') then
            present_state <= init;
        elsif(rising_edge(clk)) then
            present_state <= next_state;
        end if;
   end process;
   
   process(present_state, IR_data)
   begin
        case(present_state) is
            when init   => next_state <= fetch;
            when fetch  => next_state <= decode;
            when decode => 
                if(IR_data = x"0000") then
                    next_state <= exec_nop;
                elsif(IR_data = x"FFFF") then
                    next_state <= exec_halt;
                elsif(IR_data(15 downto 11) = "00000" and (IR_data(1 downto 0) = "01" or IR_data(1 downto 0) = "10")) then     
                     next_state <= exec_stack;
                elsif(IR_data(15 downto 12) = "0000" and IR_data(11) = '1') then
                     next_state <= exec_jmp;   
                elsif(IR_data(15 downto 12) = "0001") then
                    next_state <= exec_mov;
                elsif(IR_data(15 downto 12) = "0010") then
                    next_state <= exec_store;
                elsif(IR_data(15 downto 12) = "0011") then
                    next_state <= exec_load;
                elsif(IR_data(15 downto 12) = "0000" and IR_data(1 downto 0) = "11") or -- CMP
                      IR_data(15 downto 12) = "0100"                                 or     -- ADD
                      IR_data(15 downto 12) = "0101"                                 or     -- SUB
                      IR_data(15 downto 12) = "0110"                                 or     -- MUL
                      IR_data(15 downto 12) = "0111"                                 or     -- AND
                      IR_data(15 downto 12) = "1000"                                 or     -- ORR
                      IR_data(15 downto 12) = "1001"                                 or     -- NOT
                      IR_data(15 downto 12) = "1010"                                 or     -- XOR
                      IR_data(15 downto 12) = "1011"                                 or     -- SHR
                      IR_data(15 downto 12) = "1100"                                 or     -- SHL
                      IR_data(15 downto 12) = "1101"                                 or     -- ROR
                      IR_data(15 downto 12) = "1110"                                 then   -- ROL
                   
                    next_state <= exec_ula; 
                elsif(IR_data(15 downto 12) = "1111") then    
                    next_state <= exec_IO;
                elsif(IR_data(15 downto 11) = "00000" and (IR_data(1 downto 0) = "01" or IR_data(1 downto 0) = "10")) then
                    next_state <= exec_stack;
                else
                    next_state <= exec_nop;                                  
                end if;
            when exec_nop   => next_state <= fetch;
            when exec_halt  => next_state <= exec_halt;
            when exec_mov   => next_state <= fetch;
            when exec_load  => next_state <= fetch;
            when exec_store => next_state <= fetch;
            when exec_ula   => next_state <= fetch;
            when exec_stack => next_state <= fetch;
            when exec_jmp   => next_state <= fetch;
            when exec_IO    => next_state <= fetch;
        end case;   
   end process;
   
   process(present_state, IR_data)
   begin
        case(present_state) is
            when init   =>
                PC_clr    <= '1';
                PC_inc    <= '0';
                ROM_en    <= '1';
                IR_load   <= '0';
                RAM_sel   <= '0';
                RAM_we    <= '0';
                
                Rm_sel    <= "000";
                Rn_sel    <= "000";
                ula_op    <= "0000";
                Flags_load <= '0';
                Rd_sel    <= "000";
                Rd_wr     <= '0';  
                RF_sel    <= "00";
                
                Immed_en <= '1';                
                immed     <= x"FFF0";
                stack_en <= '1';
                stack_op <= "00";
                
            when fetch  =>
                PC_clr    <= '0';
                PC_inc    <= '1';
                ROM_en    <= '1';
                IR_load   <= '1';
                immed     <= x"0000";
                RAM_sel   <= '0';
                RAM_we    <= '1';
                RF_sel    <= "00";
                Rd_wr     <= '0';
                ula_op    <= "0000"; 
                Flags_LOAD <= '0';
                stack_en <= '0';
                Immed_en <= '0';
            when decode => 
                Immed_en <= '0';
                PC_inc    <= '0';
                ROM_en    <= '0';
                IR_load   <= '0';
                Rd_sel <= IR_data(10 downto 8);
                Rm_sel <= IR_data(7 downto 5);
                Rn_sel <= IR_data(4 downto 2);    
            when exec_mov   => 
                Rd_wr <= '1';
                Ram_we <= '1';
                if(IR_data(11) = '1') then
                    Immed  <= x"00" & IR_data(7 downto 0);
                    RF_sel <= "10";
                else
                    RF_sel <= "00";
                end if;
            when exec_store  =>  
                 Ram_we <= '1';
                 if(IR_data(11) = '1') then
                    Immed  <= x"00" & IR_data(10 downto 8) & IR_data(4 downto 0);
                    Ram_sel <= '1';
                else
                    Ram_sel <= '0';
                end if;
            when exec_load => 
                Rf_sel <= "01";
                Rd_wr  <= '1';    
                RAM_we <= '1';
            when exec_ula   => 
                Rf_sel <= "11";
                Rd_wr  <= '1';
                ula_op <= IR_data(15 downto 12);
                if(IR_data(15 downto 12) = "0000") then
                    Flags_LOAD <= '1';
                else
                    Flags_LOAD <= '0';
                end if;
            when exec_jmp =>
                Immed <= "0000000" & IR_data(10 downto 2);
                if( (IR_data(1 downto 0) = "00") or
                    (IR_data(1 downto 0) = "01" and Flags_DATA = "10") or
                    (IR_data(1 downto 0) = "10" and Flags_DATA = "01") or
                    (IR_data(1 downto 0) = "11" and Flags_DATA = "00")) then
                    Immed_en <= '1';
                    Rom_en <= '1';
                    PC_inc <= '1';
                end if;
            when exec_IO =>
                IO_sel <= '1';
                IO_en  <= '1';
                if(IR_data(11) = '0' and IR_data(1 downto 0) = "10") then     --Out Rn
                  Immed_en <= '0';
                  Rm_sel <= IR_data(7 downto 5);
                elsif(IR_data(11) = '1' and IR_data(7 downto 5) = "000") then --Out Immed
                  Immed_en <= '1';
                  Immed <= x"00" & IR_data(10 downto 8) & IR_data(4 downto 0);  
                else                                                           --In
                  Rd_sel <= IR_data(10 downto 8);
                  RF_sel <= "10";
                  Immed_en <= '0';
                end if;
            when exec_stack =>
                Rn_sel <= IR_data(4 downto 2);
                stack_en <= '1';
                immed_en <= '0';
                if(IR_DATA(1 downto 0) = "01") then
                    stack_op <= "01";
                elsif(IR_DATA(1 downto 0) = "10") then
                    stack_op <= "10";
                    Rd_sel <= IR_data(10 downto 8);
                    Rd_wr <= '1';
                    Rf_sel <= "01";
                else
                    stack_op <= "00";
                end if;
            when others =>
        end case;   
   end process;

end Behavioral;
