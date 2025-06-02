
library IEEE;
use IEEE.std_logic_1164.all;

entity downCounter is 
    port (
        enable : in std_logic;
        clk    : in std_logic;
        clear  : in std_logic;
        Q      : out std_logic_vector(3 downto 0)
    );
end downCounter;


architecture Behavioral of downCounter is

    signal  Q_N : std_logic_vector(4 downto 0); 
    
    component T_flipflop is Port (
            T   : in STD_LOGIC;
            clk : in STD_LOGIC;
            clear : in std_logic;
            Q   : out STD_LOGIC;
            Qn  : out STD_LOGIC
        );
    end component;
begin
    
    
    Q_N(0) <= clk;
    gen: for i in 0 to 3 generate
        CNT_n : T_flipflop port map (
            T => enable,
            clk   => Q_N(i),
            clear => clear,
            Q => Q_N(i+1)
        );
        Q <= Q_N(4 downto 1);
        
    end generate gen;
    
end architecture Behavioral;


library IEEE;
use IEEE.std_logic_1164.all;

entity upCounter is 
    port (
        enable : in std_logic;
        clk    : in std_logic;
        clear  : in std_logic;
        Q      : out std_logic_vector(3 downto 0)
    );
end upCounter;


architecture Behavioral of upCounter is

    signal  Q_N : std_logic_vector(4 downto 0); 
    
    component T_flipflop is Port (
            T   : in STD_LOGIC;
            clk : in STD_LOGIC;
            clear : in std_logic;
            Q   : out STD_LOGIC;
            Qn  : out STD_LOGIC
        );
    end component;
begin
    
    
    Q_N(0) <= clk;
    gen: for i in 0 to 3 generate
        CNT_n : T_flipflop port map (
            T => enable,
            clk   => Q_N(i),
            clear => clear,
            Q => Q(i),
            Qn => Q_N(i+1)
        );
        
    end generate gen;
    
end architecture Behavioral;

library IEEE;
use IEEE.std_logic_1164.all;

entity syncCounter is 
    port (
        enable : in std_logic;
        clk    : in std_logic;
        clear  : in std_logic;
        Q      : out std_logic_vector(7 downto 0);
        Qn     : out std_logic_vector(7 downto 0);
        Cout   : out std_logic -- Q_D carry (Qout_n and QD_n)
    );
end syncCounter;


architecture Behavioral of syncCounter is

    signal  Q_D : std_logic_vector(7 downto 0);
    signal carry : std_logic_vector(8 downto 0);
    signal  Q_out : std_logic_vector(7 downto 0); 
    signal  Qn_out : std_logic_vector(7 downto 0);
    
    component T_flipflop is Port (
            T   : in STD_LOGIC;
            clk : in STD_LOGIC;
            clear : in std_logic;
            Q   : out STD_LOGIC;
            Qn  : out STD_LOGIC
        );
    end component;

    component D_flipflop is Port (
        D   : in STD_LOGIC;
        clk : in STD_LOGIC;
        clear : in std_logic;
        Q   : out STD_LOGIC;
        Qn  : out STD_LOGIC
    );
    end component;

begin
    
    
    -- Q_D(0) <= enable;

    -- Qin_Data: for i in 7 downto 1 generate
    --     Q_D(i) <= Q_D(i-1) and Q_out(i-1);
    -- end generate Qin_Data;

    -- model_T: for i in 7 downto 0 generate
    --     CNT_n : T_flipflop port map (
    --         T => Q_D(i),
    --         clk   => clk,
    --         clear => clear,
    --         Q => Q_out(i),
    --         Qn => Qn_out(i)
    --     );
    -- end generate model_T;

    carry(0) <= enable; -- cin / enable
    Qin_Data: for i in 7 downto 0 generate
        carry(i+1) <= carry(i) and Q_out(i);
        Q_D(i) <= carry(i) xor Q_out(i);
    end generate Qin_Data;

    model_D: for i in 7 downto 0 generate
        CNT_n : D_flipflop port map (
            D => Q_D(i),
            clk   => clk,
            clear => clear,
            Q => Q_out(i),
            Qn => Qn_out(i)
        );
    end generate model_D;



    Q <= Q_out; -- Up Counter Output
    Qn <= Qn_out; -- Down Counter output
    Cout <= carry(8);
end architecture Behavioral;


library IEEE;
use IEEE.std_logic_1164.all;

entity counter_4 is 
    port (
        enable : in std_logic;
        D      : in std_logic_vector(3 downto 0);
        load_cnt : in std_logic;

        clk    : in std_logic;
        clear  : in std_logic;
        
        Q      : out std_logic_vector(3 downto 0);
        Qn     : out std_logic_vector(3 downto 0);
        Cout   : out std_logic -- Q_D carry (Qout_n and QD_n)
    );
end counter_4;

architecture Behavioral of counter_4 is

    signal Q_D : std_logic_vector(3 downto 0);
    signal Q_in : std_logic_vector(3 downto 0);
    signal carry : std_logic_vector(4 downto 0);
    signal Q_out : std_logic_vector(3 downto 0); 
    signal Qn_out : std_logic_vector(3 downto 0);
    signal mux_in : std_logic_vector(7 downto 0);
    
    component T_flipflop is Port (
            T   : in STD_LOGIC;
            clk : in STD_LOGIC;
            clear : in std_logic;
            Q   : out STD_LOGIC;
            Qn  : out STD_LOGIC
        );
    end component;

    component D_flipflop is Port (
        D   : in STD_LOGIC;
        clk : in STD_LOGIC;
        clear : in std_logic;
        Q   : out STD_LOGIC;
        Qn  : out STD_LOGIC
    );
    end component;


    component mux2_1 is Port (
        input : in std_logic_vector(1 downto 0);
        S     : in std_logic;
        output: out std_logic    
    );
    end component;

begin
    
    
    -- Q_D(0) <= enable;

    -- Qin_Data: for i in 7 downto 1 generate
    --     Q_D(i) <= Q_D(i-1) and Q_out(i-1);
    -- end generate Qin_Data;

    -- model_T: for i in 7 downto 0 generate
    --     CNT_n : T_flipflop port map (
    --         T => Q_D(i),
    --         clk   => clk,
    --         clear => clear,
    --         Q => Q_out(i),
    --         Qn => Qn_out(i)
    --     );
    -- end generate model_T;

    carry(0) <= enable; -- cin / enable
    Qin_Data: for i in 3 downto 0 generate
        carry(i+1) <= carry(i) and Q_out(i);
        Q_in(i) <= carry(i) xor Q_out(i);

        mux_in( ((i*2) + 1) downto (i*2)) <= (D(i) & Q_in(i));
        SEL : mux2_1 port map (
            input => mux_in(((i*2) + 1) downto (i*2)),
            S => load_cnt,
            output => Q_D(i)
        );
    end generate Qin_Data;

    model_D: for i in 3 downto 0 generate
        CNT_n : D_flipflop port map (
            D => Q_D(i),
            clk   => clk,
            clear => clear,
            Q => Q_out(i),
            Qn => Qn_out(i)
        );
    end generate model_D;



    Q <= Q_out; -- Up Counter Output
    Qn <= Qn_out; -- Down Counter output
    Cout <= carry(4);
end architecture Behavioral;