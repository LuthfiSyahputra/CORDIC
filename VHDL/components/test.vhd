library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test is
-- Testbenches have NO ports!
end test;

architecture Behavioral of test is

    
    -- Step 2: Instantiate the Unit
    component SRlatch
        Port (
            S   : in STD_LOGIC;
            R   : in STD_LOGIC;
            Q   : out STD_LOGIC;
            Qn  : out STD_LOGIC
        );
    end component;
    
    component JK_flipflop is Port (
            J   : in STD_LOGIC;
            K   : in STD_LOGIC;
            clk : in STD_LOGIC;
            clear : in std_logic;
            Q   : out STD_LOGIC;
            Qn  : out STD_LOGIC
            );
    end component;

    component register_Sin_8 is Port (
            input : in STD_LOGIC;
            clk   : in STD_LOGIC;
            clear : in std_logic;
            output: out STD_LOGIC_VECTOR(7 downto 0)
            );
    end component;

    component register_8 is Port (
            input : in STD_LOGIC_VECTOR(7 downto 0);
            serial_input : in std_logic;
            sh_load : in std_logic;
            clk   : in STD_LOGIC;
            clear : in std_logic;
            output: out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component register_32 is Port (
            input : in STD_LOGIC_VECTOR(31 downto 0);
            serial_input : in std_logic;
            sh_load : in std_logic;
            clk   : in STD_LOGIC;
            clear : in std_logic;
            output: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- Step 1: Declare test signals
    signal data : STD_LOGIC_VECTOR(31 downto 0) := "01100101101001011010011101010101";
    signal S    : STD_LOGIC := '1';
    signal R    : STD_LOGIC := '0';
    signal Q    : STD_LOGIC;
    signal Qn    : STD_LOGIC;    

    -- signal D    : STD_LOGIC := '0';
    signal clk    : STD_LOGIC := '0';
    signal clear  : std_logic := '1';
    signal load   : std_logic := '0';
    signal Q_D    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Q_D2    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal Qn_D    : STD_LOGIC;    
    
begin
    -- SRlatch_tb: SRlatch Port map(
    --     S   => S,
    --     R   => R,
    --     Q   => Q,
    --     Qn  => Qn
    -- );
    -- Dlatch_tb: JK_flipflop port map (
        --     J   => S,
        --     K   => R,
    --     clk => Clk,
    --     clear => clear,
    --     Q   => Q_D,
    --     Qn  => Qn_D
    -- );


    
    
    reg1: register_32 port map (
        input => data(31 downto 0),
        serial_input => S,
        sh_load => load,
        Clk => clk,
        clear => clear,
        output => Q_D(31 downto 0)
    );

    reg2: register_Sin_8 port map (
            input => Q_D(0),
            clk => clk,
            clear => clear,
            output => Q_D2(7 downto 0)
    );
    
    -- Step 3: Test process (stimulus)
    process
    begin
        clear <= '0' after 100 ps;
        load <= '1';

        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        load <= '0';


        for i in 0 to 31 - 2 loop
            
            for j in i to i + 2 loop
                R <= data(j+1);
                S <= data(j);
                -- S <= '1';
                
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
