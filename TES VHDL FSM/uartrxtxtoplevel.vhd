--UARTRXTX TOP LEVEL
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Define entity
entity UART is
    port (
        transmitkey        : IN  STD_LOGIC;
        CLOCK             : IN  STD_LOGIC;
        RXLine            : IN  STD_LOGIC;
		  PHASE				  : IN STD_LOGIC;
        MAXA              : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        MAXB              : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  Pair_num          : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
        Y_Aout           	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Y_Bout           	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  TXLine					: OUT STD_LOGIC :='1';
        UNIVERSALRESET    : OUT STD_LOGIC
    );
end UART;

architecture MAIN of UART is

-- Deklarasi sinyal
signal SEND_DATA, penanda, enreg1, reset, READY, universal_reset: STD_LOGIC := '0'; 
signal RX_DATA, TX_DATA, SR , firsthalf, secondhalf: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal TX_BUSY, RX_BUSY: STD_LOGIC;
signal y_a, y_b: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal enreg: std_logic;
signal tallynum, REDUCEDTALLY: STD_LOGIC_VECTOR(9 DOWNTO 0):="0000000000";
signal outcounter, oldcounter, datanum: STD_LOGIC_VECTOR(8 DOWNTO 0):="000000000";

-- Komponen
component SEND_SELECTOR is
    port (
        TX_BUSY        : IN  STD_LOGIC;    -- Indicates if the system is busy
        ENABLE         : IN  STD_LOGIC;
        DATA1          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        DATA2          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        DATA3          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        DATAOUT        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  UNIVERSAKRESET : OUT STD_LOGIC;
        SELECTOR_READY : OUT STD_LOGIC;
		  resetflag		  : in std_logic	
    );
end component;

component GENERAL_DECODER is
    port (
        CLOCK       : IN  STD_LOGIC;
		  START		  : IN STD_LOGIC;
        DATA   	  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        BUSY        : OUT STD_LOGIC;
        TX_LINE     : OUT STD_LOGIC
    );
end component;

component uart_rx is
    port (
        i_CLOCK : IN  STD_LOGIC;
        i_RX    : IN  STD_LOGIC;
        o_DATA  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_READY : OUT STD_LOGIC := '1'
    );
end component;

component register8bit is
    port (
        A       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        En      : IN  STD_LOGIC;
		  Res 	 : IN STD_LOGIC;
        Clk     : IN  STD_LOGIC;
        Data    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end component;

component register16bit is
    port (
        A1  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		  A2  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        En      : IN  STD_LOGIC;
		  Res : IN STD_LOGIC;
        Clk     : IN  STD_LOGIC;
        Data       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
end component;

component fsm_receive is
    port (
        BUSY    : IN  STD_LOGIC;
        penanda : IN  STD_LOGIC :='0';
        CLOCK     : IN  STD_LOGIC;
		  ENERG1  : OUT STD_LOGIC;
        ENEREG  : OUT STD_LOGIC
    );
end component;

component FSM_READY is
    port (
			CURRENTCOUNTER : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
			CLOCK : IN STD_LOGIC;
			READY_KEY : OUT STD_LOGIC:= '0';
			DATANUM : OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
    );
end component;k

component counter10bit is
    port (
        En, Clk,Res : IN  STD_LOGIC;
        Count       : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
end component;

begin
-- Instansiasi komponen
FSMR: FSM_READY
    port map (
        OUTCOUNTER, CLOCK, READY, datanum
    );

tally: counter10bit
    port map (
        en => EnREG1,
		 Res => reset,
        Clk => CLOCK,
        Count => tallynum
    );

register1: register8bit
    port map (
        A => SR,
        En => EnREG,
        Clk => Clock,
        Data => FIRSTHALF
    );

register2: register8bit
    port map (
        A1 => FIRSTHALF,
		  A2 => SECONDHALF,
        En => ENREG1,
		  RES => reset,
        Clk => CLOCK,
        Data => y_b
    );

registerA: register16bit
    port map (
        A1 => FIRSTHALF,
        A2 => SECONDHALF,
        en => ENREG1,
		  Res => reset,
        Clk => CLOCK,
        Data => y_b
    );

reg4: register16bit
    port map (
        A1 => y_b(15 DOWNTO 8),
        A2 => y_b(7 DOWNTO 0),
       En => ENREG1,
		 Res => reset,
        Clk => CLOCK,
        Data => y_a
    );

SELECTORSEND: SEND_SELECTOR
    port map (
        TX_BUSY         => TX_BUSY,
        ENABLE          => TransmitKey,
        DATA1           => Phase,
        DATA2           => MAXA,
        DATA3           => MAXB,
        DATAOUT         => TX_DATA,
        UNIVERSALRESET  => UNIVERSAL_RESET,
        SELECTOR_READY  => SEND_DATA,
        resetflag       => '0'
    );

FSM_R: FSM_RECEIVE
    port map (
        RX_BUSY, penanda, clock, enreg1, enreg
    );

-- Membagi data yang diperoleh (per byte) sehingga counter 2byte:
process (tallynum)
begin
    if (unsigned(tallynum) = 0) then
        reducedtally <= "0000000000";
    else
        reducedtally <= std_logic_vector(unsigned(tallynum) - 1);
    end if;
    OUTCOUNTER <= reducedtally(9 DOWNTO 1);
end process;

-- Komponen pengirim dan penerima UART
RECEIVE: uart_rx port map (CLOCK, RXLINE, RX_DATA, RX_BUSY);
SEND: GENERAL_DECODER port map (CLOCK, SEND_DATA, TX_BUSY, TX_DATA, TXLINE);

-- Assign sinyal ke output
y_bout <= y_b;
y_aout <= y_a;
pair_num <= datanum;
UNIVERSALRESET <= UNIVERSAL_RESET;
reset <= universal_reset;

-- Penanda data pertama
process (RX_BUSY)
begin
    if (RX_BUSY'EVENT AND RX_BUSY='1') then
        penanda <= '1';
    elsif (RX_BUSY'EVENT AND RX_BUSY='0' AND penanda='1') then
        SR <= RX_DATA;
    end if;
end process;

end MAIN;

