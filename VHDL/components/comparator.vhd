library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_8 is
    Port (
        A    : in  STD_LOGIC_VECTOR(7 downto 0);
        B    : in  STD_LOGIC_VECTOR(7 downto 0);
        V    : out std_logic;
        N    : out std_logic;
        Z    : out std_logic
    );
end comparator_8;

architecture Structural of comparator_8 is


    -- Step 1: Declare test signals
    signal carry : std_logic_vector(8 downto 0);
    signal sum   : std_logic_vector(7 downto 0);
    signal B_neg : std_logic_vector(7 downto 0);

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
    carry(0) <= '1';
    
    gen_adder: for i in 0 to 7 generate
        B_neg(i) <= not B(i);
        FA_inst: FullAdder
        port map (
            A    => A(i),
            B    => B_neg(i),
            Cin  => carry(i),
            Sum  => sum(i),
            Cout => carry(i+1)
            );

    end generate;
    
    Z <= not (sum(7) or sum(6) or sum(5) or sum(4) or sum(3) or sum(2) or sum(1) or sum(0));
    N <= sum(7);
    V <= carry(8) xor carry(7);

end Structural;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_16 is
    Port (
        A    : in  STD_LOGIC_VECTOR(15 downto 0);
        B    : in  STD_LOGIC_VECTOR(15 downto 0);
        V    : out std_logic;
        N    : out std_logic;
        Z    : out std_logic
    );
end comparator_16;

architecture Structural of comparator_16 is


    -- Step 1: Declare test signals
    signal carry : std_logic_vector(16 downto 0);
    signal sum   : std_logic_vector(15 downto 0);
    signal B_neg : std_logic_vector(15 downto 0);

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
    carry(0) <= '1';
    
    gen_adder: for i in 0 to 15 generate
        B_neg(i) <= not B(i);
        FA_inst: FullAdder
        port map (
            A    => A(i),
            B    => B_neg(i),
            Cin  => carry(i),
            Sum  => sum(i),
            Cout => carry(i+1)
            );

    end generate;
    
    Z <= not (sum(15) or sum(14) or sum(13) or sum(12) or 
              sum(11) or sum(10) or sum(9) or sum(8) or 
              sum(7) or sum(6) or sum(5) or sum(4) or 
              sum(3) or sum(2) or sum(1) or sum(0));

    N <= sum(15);
    V <= carry(16) xor carry(15);

end Structural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_32 is
    Port (
        A    : in  STD_LOGIC_VECTOR(31 downto 0);
        B    : in  STD_LOGIC_VECTOR(31 downto 0);
        V    : out std_logic;
        N    : out std_logic;
        Z    : out std_logic
    );
end comparator_32;

architecture Structural of comparator_32 is


    -- Step 1: Declare test signals
    signal carry : std_logic_vector(32 downto 0);
    signal sum   : std_logic_vector(31 downto 0);
    signal B_neg : std_logic_vector(31 downto 0);

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
    carry(0) <= '1';
    
    gen_adder: for i in 0 to 31 generate
        B_neg(i) <= not B(i);
        FA_inst: FullAdder
        port map (
            A    => A(i),
            B    => B_neg(i),
            Cin  => carry(i),
            Sum  => sum(i),
            Cout => carry(i+1)
            );

    end generate;

    Z <= not (sum(31) or sum(30) or sum(29) or sum(28) or 
              sum(27) or sum(26) or sum(25) or sum(24) or 
              sum(23) or sum(22) or sum(21) or sum(20) or 
              sum(19) or sum(18) or sum(17) or sum(16) or 
              sum(15) or sum(14) or sum(13) or sum(12) or 
              sum(11) or sum(10) or sum(9) or sum(8) or 
              sum(7) or sum(6) or sum(5) or sum(4) or 
              sum(3) or sum(2) or sum(1) or sum(0));

    N <= sum(31);
    V <= carry(32) xor carry(31);

end Structural;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cmp_decoder is
    Port (
        V    : in std_logic;
        N    : in std_logic;
        Z    : in std_logic;
        lt   : out std_logic
    );
end cmp_decoder;

architecture Behavioral of cmp_decoder is
begin
    lt <= N xor V;
    -- eq <= Z;
    -- le <= (N xor V or Z;
    -- ge <= not (N xor V);
    -- gt <= not ((N xor V) or Z)
end Behavioral;
