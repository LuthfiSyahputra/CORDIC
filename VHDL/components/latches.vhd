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
        D   : in STD_LOGIC;
        clk : in STD_LOGIC;
        Q   : out STD_LOGIC;
        Qn  : out STD_LOGIC
    );
end D_gatedlatch;

architecture Behavioral of D_gatedlatch is
    signal S : std_logic := '1';
    signal R, Qout, Qoutn: STD_LOGIC; 

begin

    S <= D nand clk;
    R <= (not D) nand clk;

    Qout <= S nand Qoutn;
    Qoutn <= R nand Qout;

    Q <= Qout;
    Qn <= Qoutn;
end Behavioral;
