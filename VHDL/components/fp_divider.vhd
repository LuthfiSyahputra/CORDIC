library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fp_divider is
    generic (
        W : positive := 16;   -- total width  (e.g. 16, 24, 32…)
        F : natural  :=  11    -- fractional bits (radix-point position)
    );
    port (
        clk     : in  std_logic;
        enable  : in  std_logic;                        -- Enable
        A       : in  std_logic_vector(W-1 downto 0);   -- dividend  (Q(W-F).F)
        B       : in  std_logic_vector(W-1 downto 0);   -- divisor   (Q(W-F).F)
        done    : out std_logic;                        -- valid out
        quo     : out std_logic_vector(W-1 downto 0);   -- quotient  (Q(W-F).F)
        rem     : out std_logic_vector(W-1 downto 0)    -- remainder (same scaling as inputs)
    );
end fp_divider;

architecture rtl of fp_divider is
    signal dividend_s : signed((W+F)-1 downto 0);  -- widened dividend
    signal quo_fp     : signed(W-1 downto 0);
    signal rem_fp     : signed(W-1 downto 0);
    signal enable_d   : std_logic := '0';

    signal A_fp  : signed(W-1 downto 0);    -- dividend  (Q(W-F).F)
    signal B_fp  : signed(W-1 downto 0);    -- divisor   (Q(W-F).F) 
begin
    process(clk)
    begin
        A_fp <= signed(A);
        B_fp <= signed(B);

        if rising_edge(clk) then
            ----------------------------------------------------------------
            -- 1.  Left-shift dividend by F to preserve fractional precision:
            ----------------------------------------------------------------
            dividend_s <= resize(A_fp, W+F) sll F;  -- ×2^F

            ----------------------------------------------------------------
            -- 2.  Divide and mod in a single clock tick
            --     (numeric_std “/” and “rem” work on SIGNED/UNSIGNED)
            ----------------------------------------------------------------
            if B_fp /= 0 then
                quo_fp  <= resize(dividend_s / B_fp, W);  -- Q(W-F).F
                rem_fp <= resize(dividend_s rem B_fp, W);
            else
                quo_fp  <= (others => '0');  -- simple divide-by-zero protection
                rem_fp <= (others => '0');
            end if;

            ----------------------------------------------------------------
            -- 3.  Pipeline valid flag
            ----------------------------------------------------------------
            enable_d <= enable;
        end if;
    end process;

    -- Outputs
    quo <= std_logic_vector(quo_fp);
    rem <= std_logic_vector(rem_fp);
    done    <= enable_d;
end rtl;
