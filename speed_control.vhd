library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity for speed control module with button inputs
entity speed_control is
    Port (
        clk_in : in STD_LOGIC;          -- Input clock (50MHz)
        reset : in STD_LOGIC;           -- Synchronous reset signal
        btn_up : in STD_LOGIC;          -- Button to increase speed
        btn_down : in STD_LOGIC;        -- Button to decrease speed
        speed_sel : out STD_LOGIC_VECTOR(1 downto 0) -- Speed selection (00: 1Hz, 01: 2Hz, 10: 4Hz)
    );
end speed_control;

architecture Behavioral of speed_control is
    -- Constants for debounce
    constant DEBOUNCE_COUNT : integer := 500_000; -- 10ms debounce at 50MHz (20ns period)
    
    -- Internal signals
    signal counter_debounce : integer range 0 to DEBOUNCE_COUNT := 0; -- Debounce counter
    signal btn_up_debounced : STD_LOGIC := '0'; -- Debounced up button
    signal btn_down_debounced : STD_LOGIC := '0'; -- Debounced down button
    signal speed_reg : unsigned(1 downto 0) := "00"; -- Internal speed register
begin
    -- Debounce process for buttons
    process(clk_in, reset)
    begin
        if reset = '1' then
            counter_debounce <= 0; -- Reset debounce counter
            btn_up_debounced <= '0'; -- Reset debounced up button
            btn_down_debounced <= '0'; -- Reset debounced down button
        elsif rising_edge(clk_in) then
            if (btn_up = '1' or btn_down = '1') and counter_debounce < DEBOUNCE_COUNT then
                counter_debounce <= counter_debounce + 1; -- Count up while button is pressed
            elsif counter_debounce = DEBOUNCE_COUNT then
                btn_up_debounced <= btn_up; -- Set debounced value after debounce period
                btn_down_debounced <= btn_down;
                counter_debounce <= 0; -- Reset counter
            else
                counter_debounce <= 0; -- Reset if no button press
            end if;
        end if;
    end process;

    -- Speed control process
    process(clk_in, reset)
    begin
        if reset = '1' then
            speed_reg <= "00"; -- Reset speed to 1Hz
        elsif rising_edge(clk_in) then
            if btn_up_debounced = '1' and speed_reg < "10" then
                speed_reg <= speed_reg + 1; -- Increase speed if up button pressed
            elsif btn_down_debounced = '1' and speed_reg > "00" then
                speed_reg <= speed_reg - 1; -- Decrease speed if down button pressed
            end if;
        end if;
    end process;

    -- Connect internal speed register to output
    speed_sel <= std_logic_vector(speed_reg);
end Behavioral;