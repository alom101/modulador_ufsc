library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lut_testbench is
end entity;

architecture sim of lut_testbench is
    constant ADDR_WIDTH : integer := 8;
    constant DATA_WIDTH : integer := 12;
    constant DELAY_PERIOD : time := 1 ns;

    signal addr     : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal output   : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
    uut: entity work.lut
        generic map (ADDR_WIDTH => ADDR_WIDTH, DATA_WIDTH => DATA_WIDTH)
        port map (addr => addr, output => output);

    stimulus_proc: process
    begin
        for i in 0 to 2**ADDR_WIDTH-1 loop
            wait for DELAY_PERIOD;
            addr <= std_logic_vector(unsigned(addr) + 1);
        end loop;
        wait for DELAY_PERIOD;
        wait;
    end process;
end architecture;
