library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity controller_FSM is
Generic (N:Integer:=16);
Port ( clk     : in std_logic;                        
       reset   : in std_logic;                        
       PC_clr  : out std_logic;                       
       PC_inc  : out std_logic;                       
       PC_set  : out std_logic;                       
       ROM_en  : out std_logic :='0';                 
       IR_ld   : out std_logic;                       
       IR_data : in std_logic_vector (N-1 downto 0);  
       immed   : out std_logic_vector (N-1 downto 0); 
       
       io_read_set  : out std_logic := '0';                     
       io_write_set : out std_logic := '0';                     
       io_ld        : out std_logic := '0';                     

       RAM_sel :out std_logic;                        
       RAM_we  :out std_logic:='0';                   
       
       RF_sel  : out std_logic_vector (1 downto 0);   
       Rd_sel  : out std_logic_vector (2 downto 0);    
       Rd_wr   : out std_logic := '0';                  
       Rm_sel  : out std_logic_vector (2 downto 0);   
       Rn_sel  : out std_logic_vector (2 downto 0);   
       ula_op  : out std_logic_vector (3 downto 0);   
       z : in std_logic;
       c : in std_logic;

       sp_sel : out std_logic;
       sp_ld  : out std_logic;
       ram_addsel : out std_logic
       );    

end controller_FSM;

architecture Behavioral of controller_FSM is

type state_type is (init,fetch,decode,
                   exec_nop, exec_halt, exec_mov, exec_load, exec_store, exec_ula, exec_desvio, exec_e_s, exec_pilha);


signal current_s,next_s: state_type;  

signal instruction : std_logic_vector (N-1 downto 0);


begin

process (clk,reset)
begin
 if (reset='1') then
  current_s <= init;  
elsif (rising_edge(clk)) then
  current_s <= next_s;   
end if;
end process;

process (current_s, instruction)
begin

  case current_s is
    when init =>
      --saídas 
      PC_clr <= '1';
      PC_inc <= '0';
      PC_set <= '0';
      ROM_en <= '0';
      IR_ld <= '0';
      immed <= X"0000";
      RAM_sel <= '0';
      RAM_we  <= '0';
      RF_sel <= "00";
      Rd_sel <= "000";
      Rd_wr  <= '0';
      Rm_sel <= "000";
      Rn_sel <= "000";
      ula_op <= "0000";
      io_read_set  <= '0';
      io_write_set <= '0';
      io_ld <= '0';
      sp_sel <= '0';
      sp_ld <= '0';
      ram_addsel <= '0';
      
      --lógica de transição
      next_s <= fetch;

    when fetch =>
      --saídas
      PC_clr   <= '0';
      PC_inc   <= '1';
      PC_set   <= '0';
      ROM_en   <= '1';
      IR_ld    <= '1';
      immed <= X"0000";
      RAM_sel <= '0';
      RAM_we  <= '0';
      RF_sel <= "00";
      Rd_sel <= "000";
      Rd_wr  <= '0';
      Rm_sel <= "000";
      Rn_sel <= "000";
      ula_op <= "0000";
      io_read_set  <= '0';
      io_write_set <= '0';
      io_ld <= '0';
      sp_sel <= '0';
      sp_ld <= '0';
      ram_addsel <= '0';
      


      next_s   <= decode;
     
    when decode =>
      --saídas   
      PC_clr   <= '0';
      PC_inc   <= '0';
      PC_set   <= '0';
      ROM_en   <= '0';
      IR_ld    <= '0';
      immed <= X"0000";
      RAM_sel <= '0';
      RAM_we  <= '0';
      RF_sel <= "00";
      Rd_sel <= "000";
      Rd_wr  <= '0';
      Rm_sel <= "000";
      Rn_sel <= "000";
      ula_op <= "0000";
      io_read_set  <= '0';
      io_write_set <= '0';
      io_ld <= '0';
      sp_sel <= '0';
      sp_ld <= '0';
      ram_addsel <= '0';
      
      --lógica de transição
      if (instruction(15 downto 0) = "0000000000000000") then
        next_s   <= exec_nop;
      elsif (instruction(15 downto 0) = "1111111111111111") then
        next_s   <= exec_halt;
      elsif (instruction(15 downto 12) = "0001") then
        next_s   <= exec_mov;
      elsif (instruction(15 downto 12) = "0010") then
        next_s   <= exec_store;
      elsif (instruction(15 downto 12) = "0011") then
        next_s   <= exec_load;
      elsif (instruction(15 downto 12) = "0100") then
        next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "0101") then
        next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "0110") then
        next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "0111") then
        next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "1000") then
        next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "1001") then
        next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "1010") then
         next_s   <= exec_ula;
      elsif (instruction(15 downto 11) = "00000" and instruction(1 downto 0) = "11") then
         next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "1011") then
         next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "1100") then
         next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "1101") then
         next_s   <= exec_ula;
      elsif (instruction(15 downto 12) = "1110") then
         next_s   <= exec_ula;
      elsif (instruction(15 downto 11) = "00001") then
         next_s   <= exec_desvio;
      elsif (instruction(15 downto 12) = "1111" and instruction(1 downto 0) = "01") then
         next_s   <= exec_e_s;
      elsif (instruction(15 downto 11) = "11110" and instruction(1 downto 0) = "10") then
         next_s   <= exec_e_s;
      elsif (instruction(15 downto 11) = "11111" and instruction(7 downto 5) = "000") then
         next_s   <= exec_e_s;
      elsif (instruction(15 downto 11) = "00000" and instruction(1 downto 0) = "01") then
         next_s   <= exec_pilha;
      elsif (instruction(15 downto 11) = "00000" and instruction(1 downto 0) = "10") then
         next_s   <= exec_pilha;
      else
        next_s   <= exec_nop;    
      end if;
            
      
    when exec_nop =>
      next_s <= fetch;
       
    when exec_halt =>
      next_s <= exec_halt;
      
    -- Rd = Rm ou Rd = #Im  
    when exec_mov =>
      --saídas   
      immed <= X"00" & instruction(7 downto 0); -- se instruction(11) = 1 / RF_sel = 10b rd = #im
      Rm_sel <= instruction(7 downto 5);        -- se instruction(11) = 0 / RF_sel = 00b rd = rm
      Rd_sel <= instruction(10 downto 8);
      RF_sel <= instruction(11) & '0';
      Rd_wr  <= '1';
      --lógica de transição
      next_s <= fetch;
  
    -- [Rm] = Rn ou [Rm] = #Im
    when exec_store =>
      --saídas
      immed <= X"00" & instruction(10 downto 8) & instruction(4 downto 0); -- se instruction(11) = 1 / RAM_sel = 1
      Rn_sel <= instruction(4 downto 2);                                   -- se instruction(11) = 0 / RAM_sel = 0
      Rm_sel <= instruction(7 downto 5);
      RAM_sel <= instruction(11);
      RAM_we  <= '1'; 
      --lógica de transição
      next_s <= fetch;
    
    -- Rd = [Rm]  
    when exec_load =>
    --saídas
    Rd_sel <= instruction(10 downto 8);
    Rm_sel <= instruction(7 downto 5);
    RF_sel <= "01";
    Rd_wr  <= '1';
    --lógica de transição
    next_s <= fetch;
    
    -- Rd = Rm op Rn
    when exec_ula =>
    --saídas
    if (instruction(15 downto 11) = "00000" and instruction(1 downto 0) = "11") then
        ula_op <= "0011";
    else
        ula_op <= instruction(15 downto 12);
    end if;   
    Rd_sel <= instruction(10 downto 8);
    Rm_sel <= instruction(7 downto 5);
    Rn_sel <= instruction(4 downto 2);
    RF_sel <= "11";
    Rd_wr  <= '1';
    immed  <= "00000000000" & instruction(4 downto 0);
    --lógica de transição
    next_s <= fetch;
    
    when exec_desvio =>
    if (instruction(1 downto 0) = "00") then
      PC_set <= '1';
      PC_inc <= '1';
    elsif (instruction(1 downto 0) = "01" and z = '1' and c = '0') then
      PC_set <= '1';
      PC_inc <= '1';
    elsif (instruction(1 downto 0) = "10" and z = '0' and c = '1') then
      PC_set <= '1';
      PC_inc <= '1';
    elsif (instruction(1 downto 0) = "11" and z = '0' and c = '0') then
      PC_set <= '1';
      PC_inc <= '1';
    end if;

    immed <= "0000000" & instruction(10 downto 2);

    next_s <= fetch;

    when exec_e_s =>

    if (instruction(15 downto 12) = "1111" and instruction(1 downto 0) = "01") then
      Rd_sel <= instruction(10 downto 8);
      Rd_wr <= '1';
      io_read_set <= '1';
    elsif (instruction(15 downto 11) = "11110" and instruction(1 downto 0) = "10") then
      --DO RM SELECT
      Rm_sel <= instruction(7 downto 5);
      io_write_set <= '0';
      io_ld <= '1';
      io_read_set  <= '0';
    elsif (instruction(15 downto 11) = "11111" and instruction(7 downto 5) = "000") then
      immed <= X"00" & instruction(10 downto 8) & instruction(4 downto 0);
      io_write_set <= '1';
      io_ld <= '1';
      io_read_set <= '0';
    end if;

    next_s <= fetch;

    when exec_pilha =>

    if (instruction(15 downto 11) = "00000" and instruction(1 downto 0) = "01") then
      sp_ld <= '1';
      sp_sel <= '0';
      Rn_sel <= instruction(4 downto 2);
      ram_we <= '1';
      RAM_sel <= '0';
      ram_addsel <= '1';
    elsif (instruction(15 downto 11) = "00000" and instruction(1 downto 0) = "10") then
      sp_ld <= '1';
      sp_sel <= '1';
      rd_sel <= instruction(10 downto 8);
      rd_wr  <= '1';
      RF_sel <= "01";
      ram_addsel <= '1';
    end if;

  end case;
end process;

instruction <= IR_data;

end Behavioral;
