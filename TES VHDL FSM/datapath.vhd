-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Define entity
entity fasediff is
    port (
        CLOCK : IN STD_LOGIC;
        RXLine : in std_logic;
        TXLine : out std_logic;
        hex : out std_logic_vector (7 downto 0);
        seg : out std_logic
    );
end fasediff;

-- Define architecture
ARCHITECTURE MAIN OF fasediff IS

-- Divider untuk membagi dan mendapatkan hasil rasio
component top_lv_divider is
    port (
        Clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        yB0_out : in STD_LOGIC_VECTOR (15 downto 0);  
        yBMAX : in STD_LOGIC_VECTOR (15 downto 0);
        ysearch_done : in STD_LOGIC;
        out_value : out STD_LOGIC_VECTOR (15 downto 0);
        process_done : out STD_LOGIC
    );
end component;

-- Modul untuk send data ke PC dan Menerima data dari PC
component uart is
    port (
        CLOCK : IN STD_LOGIC;
        RXLine :in std_logic;
        TXLine :out std_logic;
        Pair_num :out STD_LOGIC_VECTOR (8 DOWNTO 0);
        Y_Aout :out STD_LOGIC_VECTOR (15 DOWNTO 0);
        Y_Bout :out STD_LOGIC_VECTOR (15 DOWNTO 0);
        PHASE :in STD_LOGIC_VECTOR (15 DOWNTO 0);
        MAXA :IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        MAXB :IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        transmitkey :in std_logic;
        UNIVERSALRESET :out STD_LOGIC
    );
end component;

-- Module untuk mencari Y Max dan Y0 untuk lissajous
component top_level_combined is
    port (
        Clk : in STD_LOGIC;                -- Input clock (50MHz)
        reset : in STD_LOGIC;             -- Reset input
        y_A : in STD_LOGIC_VECTOR (15 downto 0);  -- Input sample data A
        y_B : in STD_LOGIC_VECTOR (15 downto 0);  -- Input sample data B
        data_pair_no : in STD_LOGIC_VECTOR (8 downto 0); -- 98 pair number, mulai dari '1'
        y_B_max : out STD_LOGIC_VECTOR (15 downto 0); -- MAX value y_B
        y_B0_out : out STD_LOGIC_VECTOR (15 downto 0); -- output yB pada data pair ke-1
        yA_Sign : out STD_LOGIC;         -- Output yA Sign saat yBmax
        ysearch_done : out STD_LOGIC      -- Tiga proses dalam mesin selesai
    );
end component;

-- Module untuk mencari arscinus dengan algoritma cordic
component CORDIC is
    generic (data_length : natural := 16);
    port (
        max10_clock : in std_logic;
        divider_done : in std_logic;
        purge : in std_logic;
        in_z : in std_logic_vector(data_length-1 downto 0);
        out_theta : out std_logic_vector(data_length-1 downto 0);
        out_cordic_done : out std_logic
    );
end component;

-- FSM untuk mengendalikan toplevel entity
component fsm_top_level is
    port (
        clock : in std_logic;
        y_search_done : in std_logic;
        divider_done : in std_logic;
        cordic_done : in std_logic;
        reset : in std_logic;
        divider_en : out std_logic;
        cordic_en : out std_logic;
        transmit_en : out std_logic
    );
end component;

-- Komponen komponen untuk memilih antara kuadran 1/4 atau 2/3
component MUX is
    generic (data_length: natural := 16);
    port (
        in_mux_A : in std_logic_vector(data_length-1 downto 0);
        in_mux_B : in std_logic_vector(data_length-1 downto 0);
        selector : in std_logic;
        out_mux : out std_logic_vector(data_length-1 downto 0)
    );
end component;

component Subtractor is
    generic (data_length: natural := 16);
    port (
        in_A, in_B : in std_logic_vector((data_length-1) downto 0);
        output : out std_logic_vector(data_length-1 downto 0)
    );
end component;

component Right_shifter is
    generic (data_length: natural := 16);
    port (
        in_data : in std_logic_vector(data_length-1 downto 0);
        shift : in std_logic_vector (5 downto 0);
        out_data : out std_logic_vector(data_length-1 downto 0)
    );
end component;

-- Clock sistem (untuk memastikan sistem stabil clock dibatasi)
component Clock_div is
    port (
        clk : in std_logic;         -- Input clock
        reset : in std_logic;       -- Reset untuk counter
        clk_out : out std_logic     -- Output Clock 1Hz
    );
end component;

-- Deklarasi signal
signal pair_num : std_logic_vector(8 downto 0):="000000000"; -- Output pair num dari uart
signal data_transmit , Y_B, Y_A, y_B_max, y_B0_out, divided, out_theta : STD_LOGIC_VECTOR(15 downto 0); -- Output Komponen
signal divided_Clock, Y_search_done, universal_reset, divider_done, out_cordic_done, yA_sign : std_logic; -- Output Flag dari Komponen
signal divider_en, cordic_en, transmit_en : std_logic; -- Output FSM
signal cordic_second_quadrant : std_logic_vector (15 downto 0); -- hasil cordic apabila berada di kuadran 2 atau 3
signal cordic_shifted : std_logic_vector (15 downto 0); -- hasil cordic setelah digeser (untuk mengurangi dengan pi)
signal SelectedQuadrant : std_logic_vector (15 downto 0); -- hasil cordic sesuai dengan kuadran

BEGIN
    hex<="0"&pair_num(6 downto 0); -- Untuk menunjukkan bahwa ada Data yang diterima
    seg <=transmit_en; -- 7 segment akan mati bila data sedang ditransmit

    -- Clock divider untuk FSM utama (untuk menjamin output dan komponen sudah stabil)
    clockDivider : clock_div port map (clock, universal_reset , divided_Clock);

    -- Modul uart
    rxtx : uart port map (clock, rxline, txline, pair_num, y_A, y_B, SelectedQuadrant, divided, y_B_max, transmit_en, universal_reset);

    -- Ysearch (Pencari di C dan lissajous)
    ysearchmax : top_level_combined port map (Clock, universal_reset, y_a, y_B, pair_num, y_B_max, y_B0_out, yA_sign, Y_search_done);

    -- Divider
	 divider : top_lv_divider port map (Clock, universal_reset, y_B0_out, y_B_max, divider_en ,divided, divider_done);

    -- FSM Top level
    fsm : fsm_top_level port map (divided_Clock, Y_search_done, divider_done, out_cordic_done, universal_reset, divider_en, cordic_en, transmit_en);

    -- 
	 Phasedifference : cordic generic map(16) port map (clock, cordic_en, universal_reset, divided, out_theta, out_cordic_done);

    -- Pilih Kuadran
    CordicShifter : Right_shifter generic map(16) port map (out_theta, "000010", cordic_shifted);
    QuadrantPicker : MUX generic map(16) port map (cordic_second_quadrant, cordic_shifted, yA_sign, SelectedQuadrant);
    SubtractRadian : Subtractor generic map(16) port map ("0011001000111101", cordic_shifted, cordic_second_quadrant);
 end main;
