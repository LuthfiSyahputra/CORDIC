
-- This is the Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    Port (
        a    : in  STD_LOGIC;
        b    : in  STD_LOGIC;
        cin  : in  STD_LOGIC;
        sum  : out STD_LOGIC;
        cout : out STD_LOGIC
    );
end FullAdder;

-- This is the Architecture
architecture Behavioral of FullAdder is
begin
    sum  <= a xor b xor cin;
    cout <= (a and b) or (b and cin) or (a and cin);
end Behavioral;
