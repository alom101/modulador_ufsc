library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity am_modulator is
    generic (
        CLK_FREQ     : real := 100_000_000.0; -- 100 MHz default system clock 
        DESIRED_FREQ : real := 390_625.0;     -- Target RF carrier frequency
        DATA_WIDTH   : integer := 12          -- Bit resolution of the carrier wave and message 
    );
    port (
        clk         : in  std_logic;                                  -- Driven clock link
        msg         : in  std_logic_vector(DATA_WIDTH-1 downto 0);    -- Modulating baseband signal 
        am_out      : out std_logic_vector((2*DATA_WIDTH)-1 downto 0) -- Complete AM signal output 
    );
end entity am_modulator;

architecture structural of am_modulator is

    -- 1. Component Declaration for the Unified Carrier Generator
    component carrier_generator is
        generic (
            CLK_FREQ     : real := 100_000_000.0;
            DESIRED_FREQ : real := 390_625.0;
            WIDTH        : positive := 12
        );
        port (
            clk        : in  std_logic;
            sine_out   : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;

    -- 2. Component Declaration for the Signed Multiplier 
    component multiplier is
        generic (
            DATA_WIDTH : integer := 8 
        );
        port (
            carrier     : in  std_logic_vector(DATA_WIDTH-1 downto 0); 
            msg         : in  std_logic_vector(DATA_WIDTH-1 downto 0); 
            am_signal   : out std_logic_vector((2*DATA_WIDTH)-1 downto 0) 
        );
    end component;

    -- 3. Interconnect Signal linking Carrier Output to the Mixer 
    signal internal_carrier : std_logic_vector(DATA_WIDTH-1 downto 0); 

begin

    -- Instance 1: Generate the Carrier Sine Wave dynamically via Clock Math
    u_carrier_gen : carrier_generator
        generic map (
            CLK_FREQ     => CLK_FREQ,
            DESIRED_FREQ => DESIRED_FREQ,
            WIDTH        => DATA_WIDTH
        )
        port map (
            clk      => clk,            --
            sine_out => internal_carrier -- 
        );

    -- Instance 2: Mix Carrier wave with Message using the Selected Operator 
    u_mixer : multiplier
        generic map (
            DATA_WIDTH => DATA_WIDTH --
        )
        port map (
            carrier   => internal_carrier, -- 
            msg       => msg,              -- 
            am_signal => am_out            -- 
        );

end architecture structural;
