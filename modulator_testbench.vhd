library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulator_testbench is
end entity;

architecture sim of modulator_testbench is

    -- 1. Simulation Constants
    constant CLK_PERIOD   : time := 1 ns;      -- 100 MHz Main System Clock [cite: 7]
    constant DATA_WIDTH   : integer := 8;     -- 12-bit Signal Precision [cite: 33]

    constant SIGNAL_SIZE  : integer := 2**12;

    -- Frequencies set to generate a clean 8-bit internal carrier step counter
    constant CLK_FREQ_G   : real := 100_000_000.0;
    constant SINE_FREQ_G  : real := 390_625.0;

    -- 2. Signal Declarations
    signal clk            : std_logic := '0';
    signal msg            : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal am_out         : std_logic_vector((2*DATA_WIDTH)-1 downto 0);
    signal sim_done       : boolean := false;

begin

    -- 3. Instantiate the Unit Under Test (UUT)
    uut: entity work.am_modulator
        generic map (
            CLK_FREQ     => CLK_FREQ_G,
            DESIRED_FREQ => SINE_FREQ_G,
            DATA_WIDTH   => DATA_WIDTH
        )
        port map (
            clk    => clk,
            msg    => msg,
            am_out => am_out
        );

    -- 4. Main Clock Generation Process
    clk_process : process
    begin
        while not sim_done loop
            clk <= '0';
            wait for CLK_PERIOD / 2; -- [cite: 14]
            clk <= '1';
            wait for CLK_PERIOD / 2; -- [cite: 14]
        end loop;
        wait;
    end process;

    -- 5. Stimulus Process (Modulating Baseband Signal Control)
    stimulus_proc: process
    begin
        msg <= std_logic_vector(to_signed(0, DATA_WIDTH));
        wait for CLK_PERIOD * SIGNAL_SIZE;

        msg <= std_logic_vector(to_signed(2**7-1, DATA_WIDTH));
        wait for CLK_PERIOD * SIGNAL_SIZE;

        msg <= std_logic_vector(to_signed(-(2**7-1), DATA_WIDTH));
        wait for CLK_PERIOD * SIGNAL_SIZE;

        msg <= std_logic_vector(to_signed(2**5, DATA_WIDTH));
        wait for CLK_PERIOD * SIGNAL_SIZE;

        msg <= std_logic_vector(to_signed(2**3, DATA_WIDTH));
        wait for CLK_PERIOD * SIGNAL_SIZE;

        msg <= std_logic_vector(to_signed(2**4, DATA_WIDTH));
        wait for CLK_PERIOD * SIGNAL_SIZE;

        msg <= std_logic_vector(to_signed(2**2, DATA_WIDTH));
        wait for CLK_PERIOD * SIGNAL_SIZE;


        sim_done <= true;
        wait;
    end process;

end architecture;
