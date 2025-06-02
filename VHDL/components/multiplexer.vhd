
-- This is the Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_1 is
    Port (
        input : in std_logic_vector(1 downto 0);
        S     : in std_logic;
        output: out std_logic    
    );
end mux2_1;

-- This is the Architecture
architecture Behavioral of mux2_1 is
begin
    output <= (input(1) and S) or (input(0) and (not S));
end Behavioral;


-- This is the Entity
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4_1 is
    Port (
        input : in std_logic_vector(3 downto 0);
        S     : in std_logic_vector(1 downto 0);
        output: out std_logic
    );
end mux4_1;

-- This is the Architecture
architecture Behavioral of mux4_1 is
    signal S_not : std_logic_vector(1 downto 0);

begin
    S_not(0) <= not S(0);
    S_not(1) <= not S(1);
    output <=   (input(0) and (S_not(0) and S_not(1))) or  -- !S0 and !S1 = S0 nor S1
                (input(1) and (S(0)     and S_not(1))) or
                (input(2) and (S_not(0) and S(1)   ))  or
                (input(3) and (S(0)     and S(1)   ));
end Behavioral;
