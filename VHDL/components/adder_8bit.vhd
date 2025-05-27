-- This is the Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder_8bit is
    Port (
        A    : in  std_logic_vector(7 downto 0);
        B    : in  std_logic_vector(7 downto 0);
        Cin  : in  std_logic;
        Sum  : out std_logic_vector(7 downto 0);
        Cout : out STD_LOGIC
    );
end adder_8bit;

architecture Structural of adder_8bit is

    -- Step 1: Declare test signals
    signal carry : std_logic_vector(8 downto 0);

    -- Step 2: Instantiate the Unit Under Test (UUT)
    component FullAdder
        Port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

begin
    carry(0) <= Cin;

    gen_adder: for i in 0 to 7 generate
        FA_inst: FullAdder
            port map (
                A    => A(i),
                B    => B(i),
                Cin  => carry(i),
                Sum  => Sum(i),
                Cout => carry(i+1)
            );
    end generate;

    Cout <= carry(8);
end Structural;

