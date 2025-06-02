library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SRlatch is
    Port (
        S   : in STD_LOGIC;
        R   : in STD_LOGIC;
        Q   : out STD_LOGIC;
        Qn  : out STD_LOGIC
    );
end SRlatch;


architecture Behavioral of SRlatch is
    signal Qout, Qoutn : STD_LOGIC; 
begin
    Qout <= R nor Qoutn;
    Qoutn <= S nor Qout;
    
    Q <= Qout;
    Qn <= Qoutn;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_gatedlatch is
    Port (
        D       : in STD_LOGIC;
        enable  : in STD_LOGIC;
        clear   : in STD_LOGIC;
        Q       : out STD_LOGIC;
        Qn      : out STD_LOGIC
    );
end D_gatedlatch;

architecture Behavioral of D_gatedlatch is
    signal S : std_logic := '1';
    signal R, Qout, Qoutn: STD_LOGIC; 

begin

    process
    begin
        if clear = '1' then
            -- The conventional gates clear capability produce infinite loop bug in simulation somehow
            -- Qout <= S nand Qoutn;
            -- Qoutn <= R nand Qout nand clear;
            -- S <= D nand enable       after 50 ps;
            -- R <= (not D) nand enable after 50 ps;

            Qout <= '0';
            Qoutn <= '1';
        elsif clear = '0' then
            Qout <= S nand Qoutn;
            Qoutn <= R nand Qout;
            S <= D nand enable       after 50 ps;
            R <= (not D) nand enable after 50 ps;
        end if;
        wait for 10 ps;
    end process;


    Q <= Qout;
    Qn <= Qoutn;
end Behavioral;




