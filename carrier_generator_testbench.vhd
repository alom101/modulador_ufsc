library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity carrier_generator_testbench is
end entity carrier_generator_testbench;

architecture sim of carrier_generator_testbench is

    constant CLK_PERIOD   : time := 10 ns;      -- 100 MHz clock period
    constant WIDTH_RES    : positive := 8;     -- 12-bit sine amplitude resolution

    -- 100_000_000 / (2**8) = 390_625 Hz
    constant CLK_FREQ_G   : real := 100_000_000.0;
    constant SINE_FREQ_G  : real := 390_625.0;

    signal clk            : std_logic := '0';
    signal sine_out       : std_logic_vector(WIDTH_RES-1 downto 0);
    signal sim_done       : boolean := false;

begin

    dut: entity work.carrier_generator
        generic map (
            CLK_FREQ     => CLK_FREQ_G,
            DESIRED_FREQ => SINE_FREQ_G,
            WIDTH        => WIDTH_RES
        )
        port map (
            clk      => clk,
            sine_out => sine_out
        );

    clk_process : process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stimulus_proc: process
    begin
        wait for CLK_PERIOD * 300;
        
        sim_done <= true;
        wait;
    end process;

end architecture sim;
