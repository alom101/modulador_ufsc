library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    generic (
        WIDTH : positive := 8  -- Defines the bit-width (defaults to 8-bit if not specified)
    );
    Port (
        clk   : in  STD_LOGIC;                         -- Clock signal
        count : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) -- Generic-sized output
    );
end counter;

architecture Behavioral of counter is
    -- Internal register sized dynamically using the generic parameter
    signal count_reg : unsigned(WIDTH-1 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- Increment on every single clock cycle
            count_reg <= count_reg + 1;
        end if;
    end process;

    -- Assign the internal register to the output port
    count <= std_logic_vector(count_reg);

end Behavioral;
