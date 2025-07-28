library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity for 7-segment decoder (Common Anode)
entity seven_segment_decoder_ca is
    Port (
        count : in STD_LOGIC_VECTOR(3 downto 0); -- 4-bit input (0 to 9)
        segments : out STD_LOGIC_VECTOR(6 downto 0) -- 7-segment outputs (a to g, active-low)
    );
end seven_segment_decoder_ca;

architecture Behavioral of seven_segment_decoder_ca is
begin
    -- Process for decoding 4-bit input to 7-segment pattern
    process(count)
    begin
        case count is
            when "0000" => segments <= "0000001"; -- Display 0 (a,b,c,d,e,f)
            when "0001" => segments <= "1001111"; -- Display 1 (b,c)
            when "0010" => segments <= "0010010"; -- Display 2 (a,b,d,e,g)
            when "0011" => segments <= "0000110"; -- Display 3 (a,b,c,d,g)
            when "0100" => segments <= "1001100"; -- Display 4 (b,c,f,g)
            when "0101" => segments <= "0100100"; -- Display 5 (a,c,d,f,g)
            when "0110" => segments <= "0100000"; -- Display 6 (a,c,d,e,f,g)
            when "0111" => segments <= "0001111"; -- Display 7 (a,b,c)
            when "1000" => segments <= "0000000"; -- Display 8 (a,b,c,d,e,f,g)
            when "1001" => segments <= "0000100"; -- Display 9 (a,b,c,f,g)
            when others => segments <= "1111111"; -- Default: all off
        end case;
    end process;
end Behavioral;
