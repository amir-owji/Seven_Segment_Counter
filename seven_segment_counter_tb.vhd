library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench entity
entity seven_segment_counter_tb is
end seven_segment_counter_tb;

architecture Behavioral of seven_segment_counter_tb is
    -- Signals for testbench 
    signal clk_in : STD_LOGIC := '0'; -- Input clock (50MHz)
    signal reset : STD_LOGIC := '0'; -- Reset signal
    signal btn_up : STD_LOGIC := '0'; -- Up button
    signal btn_down : STD_LOGIC := '0'; -- Down button
    signal segments : STD_LOGIC_VECTOR(6 downto 0); -- 7-segment output
    
    -- Clock period for 50MHz (20ns)
    constant CLK_PERIOD : time := 20 ns;
    
    -- Component declaration for DUT
    component seven_segment_counter
        Port (
            clk_in : in STD_LOGIC;
            reset : in STD_LOGIC;
            btn_up : in STD_LOGIC;
            btn_down : in STD_LOGIC;
            segments : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
begin
    -- Instantiate DUT
    DUT: seven_segment_counter
        port map (
            clk_in => clk_in,
            reset => reset,
            btn_up => btn_up,
            btn_down => btn_down,
            segments => segments
        );
    
    -- Clock generation process (50MHz)
    process
    begin
        while true loop
            clk_in <= '0';
            wait for CLK_PERIOD / 2; -- 10ns low
            clk_in <= '1';
            wait for CLK_PERIOD / 2; -- 10ns high
        end loop;
    end process;
    
    -- Stimulus process for testing
    process
    begin
        -- Initial reset
        reset <= '1';
        wait for 40 ns; -- Hold reset for 2 clock cycles
        reset <= '0';
        wait for 40 ns;
        
        -- Wait to observe counting at 1Hz (approx 10 seconds)
        wait for 10_000_000 ns; -- 10 seconds
        
        -- Test increasing speed to 2Hz
        btn_up <= '1';
        wait for 10_000_000 ns; -- Hold for 10ms (debounce period)
        btn_up <= '0';
        wait for 5_000_000 ns; -- Wait 5 seconds to observe 2Hz
        
        -- Test increasing speed to 4Hz
        btn_up <= '1';
        wait for 10_000_000 ns;
        btn_up <= '0';
        wait for 2_500_000 ns; -- Wait 2.5 seconds to observe 4Hz
        
        -- Test decreasing speed to 2Hz
        btn_down <= '1';
        wait for 10_000_000 ns;
        btn_down <= '0';
        wait for 5_000_000 ns;
        
        -- Test reset during operation
        reset <= '1';
        wait for 40 ns;
        reset <= '0';
        wait for 5_000_000 ns;
        
        -- End simulation
        wait;
    end process;
end Behavioral;