library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity declaration for the clock divider
entity clock_divider is
    Port (
        clk_in : in STD_LOGIC;          -- Input clock (50MHz)
        reset : in STD_LOGIC;           -- Synchronous reset signal
        speed_sel : in STD_LOGIC_VECTOR(1 downto 0); -- Speed selection (00: 1Hz, 01: 2Hz, 10: 4Hz)
        clk_out : out STD_LOGIC         -- Output clock with selected frequency
    );
end clock_divider;

architecture Behavioral of clock_divider is
    -- Constants for dividing 50MHz clock (20ns period)
    constant CLK_FREQ : integer := 50_000_000; -- Input clock frequency (50MHz)
--    constant DIV_1HZ : integer := CLK_FREQ / 1; -- Divider for 1Hz (50,000,000 cycles)
--    constant DIV_2HZ : integer := CLK_FREQ / 2; -- Divider for 2Hz (25,000,000 cycles)
--    constant DIV_4HZ : integer := CLK_FREQ / 4; -- Divider for 4Hz (12,500,000 cycles)
    constant DIV_1HZ : integer := 10; -- Divider for 1Hz (50,000,000 cycles)
    constant DIV_2HZ : integer := 5; -- Divider for 2Hz (25,000,000 cycles)
    constant DIV_4HZ : integer := 3; -- Divider for 4Hz (12,500,000 cycles)
    
    -- Internal signals
    signal counter : unsigned(25 downto 0) := (others => '0'); -- Counter for clock division (26 bits to handle up to 50M)
    signal clk_div : STD_LOGIC := '0'; -- Internal signal for output clock
    signal max_count : integer; -- Maximum count value based on selected frequency
begin
    -- Process to select maximum count based on speed_sel
    process(speed_sel)
    begin
        case speed_sel is
            when "00" => max_count <= DIV_1HZ; -- Select 1Hz (50M cycles)
            when "01" => max_count <= DIV_2HZ; -- Select 2Hz (25M cycles)
            when "10" => max_count <= DIV_4HZ; -- Select 4Hz (12.5M cycles)
            when others => max_count <= DIV_1HZ; -- Default to 1Hz for invalid inputs
        end case;
    end process;
    
    -- Process for clock division
    process(clk_in, reset)
    begin
        if reset = '1' then
            counter <= (others => '0'); -- Reset counter to 0
            clk_div <= '0'; -- Reset output clock to 0
        elsif rising_edge(clk_in) then
            if counter = max_count - 1 then
                counter <= (others => '0'); -- Reset counter when max_count is reached
                clk_div <= not clk_div; -- Toggle output clock (creates square wave)
            else
                counter <= counter + 1; -- Increment counter
            end if;
        end if;
    end process;
    
    -- Connect internal clock signal to output
    clk_out <= clk_div;
end Behavioral;

--Libraries:
--IEEE.STD_LOGIC_1164: Provides STD_LOGIC and STD_LOGIC_VECTOR types for digital signals.
--IEEE.NUMERIC_STD: Enables unsigned type for arithmetic operations (e.g., counter increment).

--Entity:
--clk_in: 50MHz input clock (20ns period).
--reset: Synchronous reset to initialize the counter and output clock.
--speed_sel: 2-bit input to select the output frequency (00: 1Hz, 01: 2Hz, 10: 4Hz).
--clk_out: Output clock with the selected frequency.

--Architecture:
--Constants:
--CLK_FREQ: Defines the 50MHz input clock.
--DIV_1HZ, DIV_2HZ, DIV_4HZ: Calculate the number of cycles needed for 1Hz (50M), 2Hz (25M), and 4Hz (12.5M).
--Signals:
--counter: A 26-bit unsigned counter (2^26 = 67,108,864, sufficient for 50M cycles).
--clk_div: Internal signal for the output clock.
--max_count: Stores the divider value based on speed_sel.

--Frequency Selection Process:
--A combinational process that sets max_count based on speed_sel using a case statement.
--Defaults to 1Hz for invalid inputs (e.g., "11").

--Clock Division Process:
--Sensitive to clk_in and reset.
--On reset, clears counter and clk_div.
--On each rising edge of clk_in, increments counter.
--When counter reaches max_count - 1, it resets to 0 and toggles clk_div, producing the desired frequency.

--Output Assignment:
--clk_out is directly assigned the value of clk_div.