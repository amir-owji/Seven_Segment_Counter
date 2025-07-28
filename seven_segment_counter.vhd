library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity for top-level module
entity seven_segment_counter is
    Port (
        clk_in : in STD_LOGIC;          -- Input clock (50MHz)
        reset : in STD_LOGIC;           -- Synchronous reset signal
        btn_up : in STD_LOGIC;          -- Button to increase speed
        btn_down : in STD_LOGIC;        -- Button to decrease speed
        segments : out STD_LOGIC_VECTOR(6 downto 0) -- 7-segment outputs (a to g, active-low for CA)
    );
end seven_segment_counter;

architecture Structural of seven_segment_counter is
    -- Component declarations
    component clock_divider
        Port (
            clk_in : in STD_LOGIC;
            reset : in STD_LOGIC;
            speed_sel : in STD_LOGIC_VECTOR(1 downto 0);
            clk_out : out STD_LOGIC
        );
    end component;

    component binary_counter
        Port (
            clk_div : in STD_LOGIC;
            reset : in STD_LOGIC;
            count : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component seven_segment_decoder_ca
        Port (
            count : in STD_LOGIC_VECTOR(3 downto 0);
            segments : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    component speed_control
        Port (
            clk_in : in STD_LOGIC;
            reset : in STD_LOGIC;
            btn_up : in STD_LOGIC;
            btn_down : in STD_LOGIC;
            speed_sel : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    -- Internal signals
    signal clk_div : STD_LOGIC;             -- Divided clock signal
    signal count : STD_LOGIC_VECTOR(3 downto 0); -- Counter output
    signal speed_sel : STD_LOGIC_VECTOR(1 downto 0); -- Speed selection signal
begin
    -- Instantiate components
    clk_divider_inst : clock_divider
        port map (
            clk_in => clk_in,
            reset => reset,
            speed_sel => speed_sel,
            clk_out => clk_div
        );

    counter_inst : binary_counter
        port map (
            clk_div => clk_div,
            reset => reset,
            count => count
        );

    decoder_inst : seven_segment_decoder_ca
        port map (
            count => count,
            segments => segments
        );

    speed_control_inst : speed_control
        port map (
            clk_in => clk_in,
            reset => reset,
            btn_up => btn_up,
            btn_down => btn_down,
            speed_sel => speed_sel
        );
end Structural;