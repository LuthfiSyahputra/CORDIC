library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_flipflop is
    Port (
        D   : in STD_LOGIC;
        clk : in STD_LOGIC;
        clear : in std_logic;
        Q   : out STD_LOGIC;
        Qn  : out STD_LOGIC
    );
end D_flipflop;

architecture masterslave of D_flipflop is
    signal Q_slave, Qn_slave, clk2 : std_logic;
    signal Q_master : std_logic := '0';

    component D_gatedlatch Port (
        D       : in STD_LOGIC;
        enable  : in STD_LOGIC;
        clear   : in std_logic;
        Q       : out STD_LOGIC;
        Qn      : out STD_LOGIC
    );
    end component;


begin
    clk2 <= not clk;
    
    master: D_gatedlatch port map(
        D => D,
        enable => clk2,
        clear => clear,
        Q => Q_master
    );

    slave: D_gatedlatch port map(
        D => Q_master,
        enable => clk,
        clear => clear,
        Q => Q_slave,
        Qn => Qn_slave
    );

    Q  <= Q_slave;
    Qn <= Qn_slave;
end masterslave;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T_flipflop is
    Port (
        T   : in STD_LOGIC;
        clk : in STD_LOGIC;
        clear : in std_logic;
        Q   : out STD_LOGIC;
        Qn  : out STD_LOGIC
    );
end T_flipflop;


architecture Behavioral of T_flipflop is
    signal D_t1, Q_sig, Qn_sig : std_logic;
    -- signal Q_sig  :std_logic := '0';
    -- signal Qn_sig :std_logic := '1';
    component D_flipflop Port (
        D       : in STD_LOGIC;
        clk     : in STD_LOGIC;
        clear   : in std_logic;
        Q       : out STD_LOGIC;
        Qn      : out STD_LOGIC
    );
    end component;

begin
    flipflop : D_flipflop port map (
        D   => D_t1,
        clk => clk,
        clear => clear,
        Q   => Q_sig,
        Qn  => Qn_sig
        );
        
    D_t1 <= (Q_sig xor T);
    Q <= Q_sig;
    Qn <= Qn_sig;
    
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JK_flipflop is
    Port (
        J   : in STD_LOGIC;
        K   : in STD_LOGIC;
        clk : in STD_LOGIC;
        clear : in std_logic;
        Q   : out STD_LOGIC;
        Qn  : out STD_LOGIC
    );
end JK_flipflop;

architecture Behavioral of JK_flipflop is
    signal D_t1, Q_sig, Qn_sig : std_logic;
    -- signal Q_sig  :std_logic := '0';
    -- signal Qn_sig :std_logic := '1';
    component D_flipflop Port (
        D       : in STD_LOGIC;
        clk     : in STD_LOGIC;
        clear   : in std_logic;
        Q       : out STD_LOGIC;
        Qn      : out STD_LOGIC
    );
    end component;

begin
    flipflop : D_flipflop port map (
        D   => D_t1,
        clk => clk,
        clear => clear,
        Q   => Q_sig,
        Qn  => Qn_sig
        );
        
    D_t1 <= (Qn_sig and J) or (Q_sig and (not K));
    Q <= Q_sig;
    Qn <= Qn_sig;
    
end Behavioral;
