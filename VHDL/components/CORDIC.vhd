library ieee;
use ieee.std_logic_1164.all;


entity CORDIC_vec is
    port (
        clk    : in std_logic;
        enable : in std_logic;  -- Enable
        reset  : in std_logic;

        X        : in std_logic_vector(31 downto 0); 
        Y_target : in std_logic_vector(31 downto 0); 

        done  : out std_logic;                      -- done
        angle : out std_logic_vector(24 downto 0)   -- angle
    );
end CORDIC_vec;


architecture datapath of CORDIC_vec is

    signal load_en, i_done : std_logic;
    signal X, Y, X_temp, Y_temp : std_logic_vector(31 downto 0);
    signal X_res, Y_res : std_logic_vector(31 downto 0);
    signal less_than : std_logic;


    component register_32 is Port (
        input : in STD_LOGIC_VECTOR(31 downto 0);
        serial_input : in std_logic;
        sh_load : in std_logic;
        clk   : in STD_LOGIC;
        clear : in std_logic;
        output: out STD_LOGIC_VECTOR(31 downto 0)
    );
    end component;

    component ALU_32bit is Port (
        A    : in  STD_LOGIC_VECTOR(31 downto 0);
        B    : in  STD_LOGIC_VECTOR(31 downto 0);
        sub  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(31 downto 0);
        Cout : out STD_LOGIC
    );
    end component;


    component CORDIC_cmp_decoder is Port (
        x_neg    : in std_logic;
        y_neg    : in std_logic;
        Y        : in std_logic_vector(31 downto 0);
        Y_target : in std_logic_vector(31 downto 0);
        inv      : out std_logic
    );
    end component;


    component LUT_CORDIC_24 is Port (
        addr   : in  std_logic_vector(3 downto 0);
        data   : out std_logic_vector(23 downto 0)
    );
    end component;


    component counter_4 is 
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
    end component;

begin

    X_reg: register_32 Port map (
        input        => X_temp,
        serial_input  > '0',
        sh_load       > load_en,
        clk           > clk,
        clear         > reset,
        output        > X
    );

    Y_reg: register_32 Port map (
        input        => Y_temp,
        serial_input => '0',
        sh_load      => load_en,
        clk          => clk,
        clear        => reset,
        output       => Y
    );

    Xtemp_reg: register_32 Port map (
        input        => X_res,
        serial_input => '0',
        sh_load      => i_done,
        clk          => clk,
        clear        => reset,
        output       => X_temp
    );
    Ytemp_reg: register_32 Port map (
        
        input        => Y_res,
        serial_input => '0',
        sh_load      => i_done,
        clk          => clk,
        clear        => reset,
        output       => Y_temp
    );


    CMP : CORDIC_cmp_decoder Port map (
        x_neg    => X(31),
        y_neg    => Y(31),
        Y        => Y,
        Y_target => Y_target,
        inv      => less_than
    );



end datapath;
