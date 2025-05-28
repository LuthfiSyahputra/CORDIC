library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_Sin_8 is
    Port (
        input : in STD_LOGIC;
        clk   : in STD_LOGIC;
        clear : in std_logic;
        output: out STD_LOGIC_VECTOR(7 downto 0)
    );
end register_Sin_8;

architecture behavioral of register_Sin_8 is
    signal Q : std_logic_vector(8 downto 0);

    component D_flipflop Port (
        D       : in STD_LOGIC;
        clk     : in STD_LOGIC;
        clear   : in std_logic;
        Q       : out STD_LOGIC;
        Qn      : out STD_LOGIC
    );
    end component;


begin
    Q(8) <= input;
    gen_reg: for  i in 7 downto 0 generate
        REG : D_flipflop port map(
            D => Q(i+1),
            clk => clk,
            clear => clear,
            Q => Q(i)
        );
    end generate;

    -- out_reg: for  i in 7 downto 0 generate
    output <= Q(7 downto 0);
    -- end generate out_reg;

end behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_8 is
    Port (
        input : in STD_LOGIC_VECTOR(7 downto 0);
        serial_input : in std_logic;
        sh_load : in std_logic;
        clk   : in STD_LOGIC;
        clear : in std_logic;
        output: out STD_LOGIC_VECTOR(7 downto 0)
    );
end register_8;

architecture REG_A of register_8 is
    signal Q, D : std_logic_vector(8 downto 0);
    signal shift : std_logic;

    component D_flipflop Port (
        D       : in STD_LOGIC;
        clk     : in STD_LOGIC;
        clear   : in std_logic;
        Q       : out STD_LOGIC;
        Qn      : out STD_LOGIC
    );
    end component;


begin
    shift <= not sh_load; -- assuming ideal driving fan-in fan-out gates (up to 8 gates)
    Q(8) <= serial_input;
    D_parallel_reg: for  i in 7 downto 0 generate
        D(i) <= (Q(i + 1) and shift) or (input(i) and sh_load); -- switch between parallel input or shift
    end generate D_parallel_reg;
        
    gen_reg: for  i in 7 downto 0 generate
        REG : D_flipflop port map(
            D => D(i),
            clk => clk,
            clear => clear,
            Q => Q(i)
        );
    end generate;

    output <= Q(7 downto 0);

 end REG_A;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_16 is
    Port (
        input : in STD_LOGIC_VECTOR(15 downto 0);
        serial_input : in std_logic;
        sh_load : in std_logic;
        clk   : in STD_LOGIC;
        clear : in std_logic;
        output: out STD_LOGIC_VECTOR(15 downto 0)
    );
end register_16;

architecture REG_AX of register_16 is
    signal output_sig : std_logic_vector(15 downto 0);

    component register_8 Port (
        input : in STD_LOGIC_VECTOR(7 downto 0);
        serial_input : in std_logic;
        sh_load : in std_logic;
        clk   : in STD_LOGIC;
        clear : in std_logic;
        output: out STD_LOGIC_VECTOR(7 downto 0)
    );
    end component;


begin

    REG1 : register_8 port map (
        input        => input(15 downto 8),
        serial_input => serial_input,
        sh_load      => sh_load,
        clk          => clk,
        clear        => clear,
        output       => output_sig(15 downto 8)
    );

    REG2 : register_8 port map (
        input        => input(7 downto 0),
        serial_input => output_sig(8),
        sh_load      => sh_load,
        clk          => clk,
        clear        => clear,
        output       => output_sig(7 downto 0)
    );
    output <= output_sig;

 end REG_AX;

 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_32 is
    Port (
        input : in STD_LOGIC_VECTOR(31 downto 0);
        serial_input : in std_logic;
        sh_load : in std_logic;
        clk   : in STD_LOGIC;
        clear : in std_logic;
        output: out STD_LOGIC_VECTOR(31 downto 0)
    );
end register_32;

architecture REG_EAX of register_32 is
    signal output_sig : std_logic_vector(32 downto 0);

    component register_8 Port (
        input : in STD_LOGIC_VECTOR(7 downto 0);
        serial_input : in std_logic;
        sh_load : in std_logic;
        clk   : in STD_LOGIC;
        clear : in std_logic;
        output: out STD_LOGIC_VECTOR(7 downto 0)
    );
    end component;


begin
    output_sig(32) <= serial_input;
    reg_part: for i in 3 downto 0 generate
        REG : register_8 port map (
            input        => input(( ((i+1) * 8) - 1) downto (i * 8)),
            serial_input => output_sig(i*8),
            sh_load      => sh_load,
            clk          => clk,
            clear        => clear,
            output       => output_sig((((i+1) * 8) - 1) downto (i * 8))
        );
    end generate reg_part;

    output <= output_sig(31 downto 0);

 end REG_EAX;