library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_testbench is
end entity;

architecture sim of multiplier_testbench is
    constant DATA_WIDTH : integer := 4;
    constant DELAY_PERIOD : time := 1 ns;

    signal carrier  : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal msg      : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal output   : std_logic_vector(2*DATA_WIDTH-1 downto 0);

begin
    uut: entity work.multiplier(rtl_using_operator)
        generic map (DATA_WIDTH => DATA_WIDTH)
        port map (carrier => carrier, msg => msg, am_signal => output);

    stimulus_proc: process
    begin
        for x in 0 to 2**DATA_WIDTH-1 loop
            for y in 0 to 2**DATA_WIDTH-1 loop
                wait for DELAY_PERIOD;
                msg <= std_logic_vector(to_unsigned(x, DATA_WIDTH));
                carrier <= std_logic_vector(to_unsigned(y, DATA_WIDTH));
            end loop;
        end loop;
        wait for DELAY_PERIOD;
        wait;
    end process;
end architecture;
