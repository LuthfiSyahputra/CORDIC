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





library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CORDIC_cmp_decoder is
    Port (
        x_neg    : in std_logic;
        y_neg    : in std_logic;
        Y        : in std_logic_vector(31 downto 0);
        Y_target : in std_logic_vector(31 downto 0);

        inv      : out std_logic
    );
end CORDIC_cmp_decoder;

architecture Behavioral of CORDIC_cmp_decoder is
    signal C, V, N, Z : std_logic := '0';
    component comparator_32 is Port (
        A    : in  STD_LOGIC_VECTOR(31 downto 0);
        B    : in  STD_LOGIC_VECTOR(31 downto 0);
        V    : out std_logic;
        N    : out std_logic;
        Z    : out std_logic
    );
    end component;

begin
    
    CMP : comparator_32 Port map (
        A  => Y,
        B  => Y_target,
        V  =>  V,
        N  =>  N,
        Z  =>  Z
    );

    C <= N xor V;   -- LESS THAN 
    inv <= (x_neg and y_neg) or (C and (not x_neg));

end Behavioral;
