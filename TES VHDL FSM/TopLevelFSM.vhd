-- Top Level FSM
-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_top_level is
    Port (
        Clock        : in std_logic;
        y_search_done: in std_logic;
        divider_done : in std_logic;
        cordic_done  : in std_logic;
        reset        : in std_logic;
        divider_en   : out std_logic;
        cordic_en    : out std_logic;
        transmit_en  : out std_logic
    );
end fsm_top_level;

architecture behavior of fsm_top_level is
    -- State Declaration
    type state_type is (Idle, dividing, cordic, Done);
    signal current_state, next_state : state_type := Idle;
begin

    -- State Transition Process
    process(clock, reset)
    begin
        if reset = '1' then  -- Reset to Idle state
            current_state <= Idle;
        elsif rising_edge(Clock) then
            current_state <= next_state;
        end if;
    end process;

    -- Next State Logic and Output Assignment
    process(current_state, y_search_done, divider_done, cordic_done)
    begin
        -- Default assignments to avoid latches
        divider_en <= '0';
        cordic_en  <= '0';
        transmit_en <= '0';
        next_state <= current_state;

        case current_state is
            when Idle =>
                if y_search_done = '1' then
                    divider_en <= '1';
                    next_state <= dividing;
                end if;

            when dividing =>
                divider_en <= '1';
                if divider_done = '1' then
                    next_state <= cordic;
                end if;

            when cordic =>
                cordic_en <= '1';
                if cordic_done = '1' then
                    next_state <= Done;
                end if;

            when Done =>
                transmit_en <= '1';
                -- Add a condition if transitioning out of Done is needed
                -- For example: next_state <= Idle;
        end case;
    end process;
end behavior;
