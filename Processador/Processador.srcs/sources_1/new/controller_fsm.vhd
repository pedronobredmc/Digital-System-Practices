library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_fsm is
    generic (N:integer:=16);
    Port (
        clock : in STD_LOGIC;
        reset : in STD_LOGIC;
        IR_data: in std_logic_vector(N-1 downto 0);
        IR_load:out std_logic;
        immed:out std_logic_vector (N-1 downto 0);
        Ram_sel: out std_logic;
        Ram_we: out std_logic;
        RF_sel: out std_logic_vector (1 downto 0);
        Rd_sel: out std_logic_vector (2 downto 0);
        Rd_wr: out std_logic;
        Rm_sel: inout std_logic_vector (2 downto 0);
        Rn_sel: out std_logic_vector (2 downto 0);
        ula_op: out std_logic_vector (3 downto 0);
        Rom_en: out std_logic;
        Pc_clr: out std_logic;
        IO_read: out std_logic_vector(N-1 downto 0);
        IO_write: out std_logic_vector(N-1 downto 0);
        Pc_inc: out std_logic
    );
end controller_fsm;

    architecture Behavioral of controller_fsm is
    
    type state_type is (init, fetch, decode, exec_nop, exec_halt, exec_move, exec_load, exec_store, exec_ula, exec_in, exec_out_reg,exec_out_im);
    signal estado_atual, prox_estado: state_type;
    signal instruction: std_logic_vector(N-1 downto 0);
    
begin
    process(clock, reset)
    begin
        if(reset = '1')then
            estado_atual<=init;
        elsif(clock'event and clock='1')then
            estado_atual <= prox_estado;
        end if;
    end process;
    
    process(estado_atual, instruction)
    begin
        case estado_atual is
                when init =>
                    --Saídas 
                    PC_clr <= '1';
                    PC_inc <= '0';
                    ROM_en <= '0';
                    IR_load <= '0';
                    immed <= X"0000";
                    RAM_sel <= '0';
                    RAM_we  <= '0';
                    RF_sel <= "00";
                    Rd_sel <= "000";
                    Rd_wr  <= '0';
                    Rm_sel <= "000";
                    Rn_sel <= "000";
                    ula_op <= "0000";
                    --Avança estado
                    prox_estado <= fetch;
                when fetch =>
                    --Saídas 
                    PC_clr <= '0';
                    PC_inc <= '1';
                    ROM_en <= '1';
                    IR_load <= '1';
                    immed <= X"0000";
                    RAM_sel <= '0';
                    RAM_we  <= '0';
                    RF_sel <= "00";
                    Rd_sel <= "000";
                    Rd_wr  <= '0';
                    Rm_sel <= "000";
                    Rn_sel <= "000";
                    ula_op <= "0000";
                    --Avança estado
                    prox_estado <= decode;
                when decode =>
                    --Saídas 
                    PC_clr <= '0';
                    PC_inc <= '0';
                    ROM_en <= '0';
                    IR_load <= '0';
                    immed <= X"0000";
                    RAM_sel <= '0';
                    RAM_we  <= '0';
                    RF_sel <= "00";
                    Rd_sel <= "000";
                    Rd_wr  <= '0';
                    Rm_sel <= "000";
                    Rn_sel <= "000";
                    ula_op <= "0000";
                    --Avança estado
                    if(instruction(N-1 downto 0)="0000000000000000")then
                        prox_estado <= exec_nop;
                    elsif(instruction(N-1 downto 0)="1111111111111111")then
                        prox_estado <= exec_halt;
                    elsif(instruction(N-1 downto 0)="0001")then
                        prox_estado <= exec_move;
                    elsif(instruction(N-1 downto 0)="0010")then
                        prox_estado <= exec_store;
                    elsif(instruction(N-1 downto 0)="0011")then
                        prox_estado <= exec_load;
                    elsif (instruction(15 downto 9) = "1111000") then
                        prox_estado   <= exec_in;           -- IN
                    elsif (instruction(15 downto 9) = "1111001") then
                        prox_estado   <= exec_out_reg;      -- OUT Rm
                    elsif (instruction(15 downto 8) = "111101") then
                        prox_estado   <= exec_out_im;       -- Detecta a instrução OUT #Im
                    else
                    prox_estado <= exec_ula;
                    end if;
                when exec_nop =>
                    --Avança estado
                    prox_estado <= fetch;
                when exec_halt =>
                    --Avança estado
                    prox_estado <= exec_halt;
                when exec_move =>
                    --Fazer saídas
                    if(instruction(11)='0')then
                        rm_sel <= instruction(7 downto 5);
                        rf_sel <= "00";
                    else
                        immed <= X"000" & instruction(10 downto 7);
                        rf_sel <= "10";
                    end if;
                    rd_sel <= instruction(10 downto 8);
                    rd_wr <= '1';
                    --Avança estado
                    prox_estado <= fetch;
                when exec_load =>
                    --Fazer saídas
                    rd_sel <= instruction(10 downto 8);
                    rm_sel <= instruction (7 downto 5);
                    rf_sel <= "00";
                    rd_wr <= '1';
                    --Avança estado
                    prox_estado <= fetch;
                when exec_store =>
                    --Fazer saídas
                     if(instruction(11)='0')then
                        rn_sel <= instruction(4 downto 2);
                        ram_sel <= '0';
                    else
                        immed <= X"00" & instruction(10 downto 8) and instruction(4 downto 0);
                        ram_sel <= '1';
                    end if;
                    rm_sel <= instruction (7 downto 5);
                    ram_we <= '1';
                    --Avança estado
                    prox_estado <= fetch;
                when exec_ula =>
                    --Fazer saídas
                    ula_op <= instruction(15 downto 12);
                    rd_sel <= instruction(10 downto 8);
                    rm_sel <= instruction(7 downto 5);
                    rn_sel <= instruction(4 downto 2);
                    rf_sel <= "11";
                    rd_wr <= '1';
                    --Avança estado
                    prox_estado <= fetch;
                when exec_in => 
                  Rd_sel <= instruction(10 downto 8);  
                  RF_sel <= "01";                      
                  Rd_wr  <= '1';                       
                  prox_estado <= fetch;
            
                when exec_out_reg =>
                  IO_write <= (others => '0');
                  IO_write(2 downto 0) <= Rm_sel;               
                  prox_estado <= fetch;
                  
                when exec_out_im =>
                  IO_write(7 downto 0) <= instruction(7 downto 0);
                  prox_estado <= fetch;
            end case;
    end process;
    instruction <= IR_data;
end Behavioral;
