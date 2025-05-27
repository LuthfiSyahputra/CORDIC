library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder_tb is
-- Testbenches have NO ports!
end FullAdder_tb;

architecture Behavioral of FullAdder_tb is

    -- Step 1: Declare test signals
    signal a    : STD_LOGIC := '0';
    signal b    : STD_LOGIC := '0';
    signal cin  : STD_LOGIC := '0';
    signal sum  : STD_LOGIC;
    signal cout : STD_LOGIC;

    -- Step 2: Instantiate the Unit Under Test (UUT)
    component FullAdder
        Port (
            a    : in  STD_LOGIC;
            b    : in  STD_LOGIC;
            cin  : in  STD_LOGIC;
            sum  : out STD_LOGIC;
            cout : out STD_LOGIC
        );
    end component;

begin
    uut: FullAdder port map (
        a => a,
        b => b,
        cin => cin,
        sum => sum,
        cout => cout
    );

    -- Step 3: Test process (stimulus)
    process
    begin
        -- Test 0 + 0 + 0
        a <= '0'; b <= '0'; cin <= '0';
        wait for 10 ns;

        -- Test 0 + 1 + 0
        a <= '0'; b <= '1'; cin <= '0';
        wait for 10 ns;

        -- Test 1 + 1 + 0
        a <= '1'; b <= '1'; cin <= '0';
        wait for 10 ns;

        -- Test 1 + 1 + 1
        a <= '1'; b <= '1'; cin <= '1';
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
