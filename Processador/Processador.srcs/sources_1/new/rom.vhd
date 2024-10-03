library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom is
    Generic
    (   
        N : integer := 16;
        addr_width : integer := 16;
        data_width : integer := 16
    );
    Port 
    ( 
        clk     : in  std_logic;                                    -- clock
        en      : in  std_logic;                                    -- enable
        addr    : in  std_logic_vector(addr_width-1 downto 0);      -- address input
        dout    : out std_logic_vector(data_width-1 downto 0)       -- instruction data output
    );
end rom;

architecture Behavioral of rom is
    type memory is array(0 to (2**addr_width)-1) of std_logic_vector(data_width-1 downto 0);        -- 65355 blocks memory
    signal rom_block : memory := (
                0  =>        "0001100000000010"   ,    --MOV R0, 0x02   
                2  =>        "0011000100000000"   ,    --LDR R1, [R0]
                4  =>        "0001100000000100"   ,    --MOV R0, 0x04
                6  =>        "0011001000000000"   ,    --LDR R2, [R0]  
                8  =>        "0100000100101000"   ,    --ADD R1, R1, R2               
                10 =>        "0001100000000110"   ,    --MOV R0, 0X06                                   
                12 =>        "0010000000000100"   ,    --STR [R0], R1
                14 =>        "0000100011010100"   ,    --JMP #0x35
                16 =>        "0000000010010111",       --CMP 0x4, 0x5
                18 =>        "0000100000111101",       --JEQ 0xf
                20 =>        "0000100000111110",       --JLT 0xf
                22 =>        "0000100000111111",       --JLT 0xf
                24 =>        "1111111111111111"   ,    -- HALT
        others => (others => '0')
    );
    
begin
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if (en = '1') then
                dout <= rom_block(to_integer(unsigned(addr)));
            end if;
        end if;
    end process;
end Behavioral;