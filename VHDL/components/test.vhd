library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test is
-- Testbenches have NO ports!
end test;

architecture Behavioral of test is

    -- Step 1: Declare test signals
    signal data : STD_LOGIC_VECTOR(31 downto 0) := "10110100101001011010011101010101";
    signal S    : STD_LOGIC := '1';
    signal R    : STD_LOGIC := '0';
    signal Q    : STD_LOGIC;
    signal Qn    : STD_LOGIC;    

    -- signal D    : STD_LOGIC := '0';
    signal clk    : STD_LOGIC := '0';
    signal Q_D    : STD_LOGIC;
    signal Qn_D    : STD_LOGIC;    
    

    -- Step 2: Instantiate the Unit
    component SRlatch
        Port (
            S   : in STD_LOGIC;
            R   : in STD_LOGIC;
            Q   : out STD_LOGIC;
            Qn  : out STD_LOGIC
        );
    end component;

    component D_gatedlatch is
        Port (
            D   : in STD_LOGIC;
            clk : in STD_LOGIC;
            Q   : out STD_LOGIC;
            Qn  : out STD_LOGIC
        );
    end component;

begin
    SRlatch_tb: SRlatch Port map(
        S   => S,
        R   => R,
        Q   => Q,
        Qn  => Qn
    );
    Dlatch_tb: D_gatedlatch port map (
        D   => S,
        clk => Clk,
        Q   => Q_D,
        Qn  => Qn_D
    );

    -- Step 3: Test process (stimulus)
    process
    begin

        for i in 0 to 31 - 3 loop

            for j in i to i + 3 loop
                R <= (not data(j));
                S <= data(j);
                
                
                wait for 5 ns;
            end loop;
                
                
        clk <= (not clk);
            -- wait for 10 ns;
        end loop;  -- ii

        S <= '0'; R <= '0';
        wait for 10 ns;
        S <= '1'; R <= '0';
        wait for 10 ns;
        S <= '0'; R <= '0';
        wait for 10 ns;
        S <= '0'; R <= '1';
        wait for 10 ns;
        S <= '0'; R <= '0';
        wait for 10 ns;
        S <= '1'; R <= '0';
        wait for 10 ns;
        S <= '0'; R <= '1';
        wait for 10 ns;
        S <= '0'; R <= '0';
        wait for 10 ns;
        S <= '1'; R <= '1';
        wait for 10 ns;
        S <= '0'; R <= '0';
        wait for 10 ns;
          -- Creates a Left Shift using a For Loop


    end process;

end Behavioral;
