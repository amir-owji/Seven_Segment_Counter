library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Entity declaration for the binary counter
entity binary_counter is
    Port (
        clk_div : in STD_LOGIC;         -- Input clock from clock divider (1Hz, 2Hz, or 4Hz)
        reset : in STD_LOGIC;           -- Synchronous reset signal
        count : out STD_LOGIC_VECTOR(3 downto 0) -- 4-bit output count (0 to 9)
    );
end binary_counter;

architecture Behavioral of binary_counter is
    -- Internal signal for counter register
    signal counter_reg : unsigned(3 downto 0) := (others => '0'); -- 4-bit counter initialized to 0
begin
    -- Counting process
    process(clk_div, reset)
    begin
        if reset = '1' then
            counter_reg <= (others => '0'); -- Reset counter to 0
        elsif rising_edge(clk_div) then
            if counter_reg = 9 then
                counter_reg <= (others => '0'); -- Roll over to 0 after reaching 9
            else
                counter_reg <= counter_reg + 1; -- Increment counter
            end if;
        end if;
    end process;
    
    -- Connect internal counter to output
    count <= std_logic_vector(counter_reg);
end Behavioral;