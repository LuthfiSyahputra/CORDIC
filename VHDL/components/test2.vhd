library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity test2 is

end entity test2;


architecture test_proc of test2 is
    
    signal clear : std_logic := '1';
    signal clk   : std_logic := '0';
    signal data  : std_logic_vector(31 downto 0) := x"DEADBEEF";
    signal output1 : std_logic_vector(31 downto 0) := (others => '0');
    signal output2 : std_logic_vector(31 downto 0) := (others => '0');


    signal out_1 : std_logic := '0';
    signal out_2 : std_logic_vector(1 downto 0) := (others => '0');
    signal out_4 : std_logic_vector(3 downto 0) := (others => '0');
    signal out_8 : std_logic_vector(7 downto 0) := (others => '0');
    signal out2_8 : std_logic_vector(7 downto 0) := (others => '0');
    signal out_16 : std_logic_vector(15 downto 0) := (others => '0');
    signal out_32 : std_logic_vector(31 downto 0) := "00000000000000000100000000000000";


    signal data_32 : std_logic_vector(31 downto 0)  := "00001111110001100100011101110111";
    signal data2_32 : std_logic_vector(31 downto 0) := "00110100001100101000000010000000";

    signal V : std_logic := '0';
    signal N : std_logic := '0';
    signal Z : std_logic := '0';

    signal enable : std_logic := '0';
    signal load   : std_logic := '0';

    component fp_divider
        generic (
            W : positive := 16;
            F : natural  := 11
        );
        port (
            clk     : in  std_logic;
            enable  : in  std_logic;
            A       : in  std_logic_vector(W-1 downto 0);
            B       : in  std_logic_vector(W-1 downto 0);
            done    : out std_logic;
            quo     : out std_logic_vector(W-1 downto 0);
            remain  : out std_logic_vector(W-1 downto 0)
        );
    end component;


    component upCounter is port (
        enable : in std_logic;
        clk    : in std_logic;
        clear  : in std_logic;
        Q      : out std_logic_vector(3 downto 0)
    );
    end component;

    component syncCounter is port (
        enable : in std_logic;
        clk    : in std_logic;
        clear  : in std_logic;
        Q      : out std_logic_vector(7 downto 0);
        Qn     : out std_logic_vector(7 downto 0);
        QD_c   : out std_logic -- Q_D carry (Qout_n and QD_n)
    );
    end component;

    component comparator_8 is port (
        A    : in  STD_LOGIC_VECTOR(7 downto 0);
        B    : in  STD_LOGIC_VECTOR(7 downto 0);
        V    : out std_logic;
        N    : out std_logic;
        Z    : out std_logic
    );
    end component;

    component cmp_decoder is Port (
        V    : in std_logic;
        N    : in std_logic;
        Z    : in std_logic;
        lt   : out std_logic
    );
    end component;

    component counter_4 is port (
        enable : in std_logic;
        D      : in std_logic_vector(3 downto 0);
        load_cnt : in std_logic;

        clk    : in std_logic;
        clear  : in std_logic;

        Q      : out std_logic_vector(3 downto 0);
        Qn     : out std_logic_vector(3 downto 0);
        Cout   : out std_logic -- Q_D carry (Qout_n and QD_n)
    );
    end component;

begin

    -- COUNTER : upCounter port map (
    --     enable => '1',
    --     clk    => clk,
    --     clear  => clear,
    --     Q      => out_4
    -- );
    
    -- SYNC_COUNTER : syncCounter port map (
    --     enable => '1',
    --     clk    => clk,
    --     clear  => clear,
    --     Q      => out_8,
    --     Qn     => out2_8,
    --     QD_c   => out_1
    -- );

    -- CMP : comparator_8 port map (
    --     A => out_8,
    --     B => out2_8,
    --     V => V,
    --     N => N,
    --     Z => Z
    -- );

    -- CMP_DEC : cmp_decoder port map (
    --     V => V,
    --     N => N,
    --     Z => Z,
    --     lt => out_1
    -- );

    -- CNT : counter_4 port map (
    --     enable => enable,
    --     D      => data(8 downto 5),
    --     load_cnt => load,

    --     clk    => clk,
    --     clear  => clear,

    --     Q      => out_4,
    --     Cout   => out_16(0)
    -- );

    U_fp_div24 : fp_divider
        generic map (
            W => 32,
            F => 26
        )
        port map (
            clk    => clk,
            enable => enable,
            A      => data_32,       -- std_logic_vector(23 downto 0)
            B      => data2_32,
            done   => out_1,
            quo    => output1,
            remain => output2
    );


    process begin
        clear <= '0' after 10 ps;
        enable <= '0';
        wait for 5 ns;

        load <= '1';
        clk <= '1' after 1 ns;
        
        for i in 0 to 128 loop
            wait for 2 ns;

            out2_8  <= "10000000";
            out_8 <= "01111111";

            enable <= '1';
            load <= '0';
            clk <= not clk;
        end loop;

    end process;
    
    
end architecture test_proc;