library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RippleCarryAdder32 is
    Port (
        A    : in  STD_LOGIC_VECTOR(31 downto 0);
        B    : in  STD_LOGIC_VECTOR(31 downto 0);
        Cin  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(31 downto 0);
        Cout : out STD_LOGIC
    );
end RippleCarryAdder32;

architecture Structural of RippleCarryAdder32 is

    -- Declare component for 8-bit adder
    component adder_8bit
        Port (
            A    : in  STD_LOGIC_VECTOR(7 downto 0);
            B    : in  STD_LOGIC_VECTOR(7 downto 0);
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC_VECTOR(7 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    -- Carry wires between blocks
    signal carry : STD_LOGIC_VECTOR(4 downto 0);

begin
    carry(0) <= Cin;

    -- 4 x 8-bit adder blocks
    ADD0: adder_8bit
        port map (
            A    => A(7 downto 0),
            B    => B(7 downto 0),
            Cin  => carry(0),
            Sum  => Sum(7 downto 0),
            Cout => carry(1)
        );

    ADD1: adder_8bit
        port map (
            A    => A(15 downto 8),
            B    => B(15 downto 8),
            Cin  => carry(1),
            Sum  => Sum(15 downto 8),
            Cout => carry(2)
        );

    ADD2: adder_8bit
        port map (
            A    => A(23 downto 16),
            B    => B(23 downto 16),
            Cin  => carry(2),
            Sum  => Sum(23 downto 16),
            Cout => carry(3)
        );

    ADD3: adder_8bit
        port map (
            A    => A(31 downto 24),
            B    => B(31 downto 24),
            Cin  => carry(3),
            Sum  => Sum(31 downto 24),
            Cout => carry(4)
        );

    Cout <= carry(4);

end Structural;
