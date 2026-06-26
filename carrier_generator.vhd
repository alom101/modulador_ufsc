library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL; -- Required for ceil and log2 calculations at compile time

entity carrier_generator is
    generic (
        CLK_FREQ     : real := 100_000_000.0; -- 100 MHz default system clock
        DESIRED_FREQ : real := 390_625.0;     -- Target sine wave frequency
        WIDTH        : positive := 12         -- Data resolution width for the sine wave amplitude
    );
    port (
        clk        : in  std_logic;
        sine_out   : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity carrier_generator;

architecture structural of carrier_generator is

    -- 1. Compile-time calculation of the internal address bus width
    constant ADDR_WIDTH : integer := integer(ceil(log2(CLK_FREQ / DESIRED_FREQ)));

    -- 2. Component Declarations
    component counter is
        generic (
            WIDTH : positive := 8
        );
        port (
            clk   : in  std_logic;
            count : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

    component lut is
        generic (
            ADDR_WIDTH : integer := 8;
            DATA_WIDTH : integer := 12
        );
        port (
            addr     : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
            output   : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    -- 3. Interconnect Signal
    signal internal_addr : std_logic_vector(ADDR_WIDTH-1 downto 0);

begin

    -- Instance of the Counter sized to the calculated address width [cite: 1, 2]
    u_counter : counter
        generic map (
            WIDTH => ADDR_WIDTH
        )
        port map (
            clk   => clk,       -- [cite: 2]
            count => internal_addr
        );

    -- Instance of the Sine Look-Up Table matching the address depth and target amplitude resolution [cite: 15, 16]
    u_lut : lut
        generic map (
            ADDR_WIDTH => ADDR_WIDTH,
            DATA_WIDTH => WIDTH
        )
        port map (
            addr   => internal_addr, -- [cite: 16]
            output => sine_out       -- [cite: 16]
        );

end architecture structural;
