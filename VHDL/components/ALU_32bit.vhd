library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_32bit is
    Port (
        A    : in  STD_LOGIC_VECTOR(31 downto 0);
        B    : in  STD_LOGIC_VECTOR(31 downto 0);
        sub  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(31 downto 0);
        Cout : out STD_LOGIC
    );
end ALU_32bit;

architecture Structural of ALU_32bit is

    -- Declare component for 32-bit adder
    component RippleCarryAdder32
    Port (
        A    : in  STD_LOGIC_VECTOR(31 downto 0);
        B    : in  STD_LOGIC_VECTOR(31 downto 0);
        Cin  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(31 downto 0);
        Cout : out STD_LOGIC
    );
    end component;

    -- Carry wires between blocks
    signal sub_flag : STD_LOGIC;
    signal B_eff : STD_LOGIC_VECTOR(31 downto 0);

    
begin
    sub_flag <= sub;
    ALU_sub_neg: for i in 0 to 31 generate
        B_eff(i) <=  sub_flag xor B(i);
    end generate ALU_sub_neg;

    -- 4 x 8-bit adder blocks
    ADD: RippleCarryAdder32 port map (
            A    => A,
            B    => B_eff,
            Cin  => sub_flag,
            Sum  => Sum,
            Cout => Cout
        );

end Structural;
