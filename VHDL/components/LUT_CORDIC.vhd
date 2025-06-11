library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LUT_CORDIC_24 is
    Port (
        addr   : in  std_logic_vector(3 downto 0);
        data   : out std_logic_vector(23 downto 0)
    );
end LUT_CORDIC_24;

architecture LUT_ROM24 of LUT_CORDIC_24 is

    -- ROM type and contents
    type rom_type is array (0 to 15) of std_logic_vector(23 downto 0);
    constant ROM : rom_type := (
        0  => x"3243F6",
        1  => x"1DAC67",
        2  => x"0FADBA",
        3  => x"07F56E",
        4  => x"03FEAB",
        5  => x"01FFD5",
        6  => x"00FFFA",
        7  => x"007FFF",
        8  => x"003FFF",
        9  => x"001FFF",
        10 => x"000FFF",
        11 => x"0007FF",
        12 => x"0003FF",
        13 => x"0001FF",
        14 => x"000100",
        15 => x"000080"
    );

begin

    -- Combinational ROM access (MUX)
    data <= ROM(to_integer(unsigned(addr)));

end LUT_ROM24;
