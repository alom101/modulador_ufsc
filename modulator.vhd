library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity am_modulator is
    generic (
        ADDR_WIDTH : integer := 8;  -- Address width for the carrier LUT
        DATA_WIDTH : integer := 12  -- Resolution of the sine wave and message
    );
    port (
        addr        : in  std_logic_vector(ADDR_WIDTH-1 downto 0); -- Controls carrier frequency
        msg         : in  std_logic_vector(DATA_WIDTH-1 downto 0); -- Incoming modulating/message signal
        am_out      : out std_logic_vector((2*DATA_WIDTH)-1 downto 0) -- Modulated output
    );
end entity am_modulator;

architecture structural of am_modulator is

    -- Component Declaration for the Look-Up Table (Carrier Generator)
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

    -- Component Declaration for the Multiplier
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

    -- Internal Signal to connect the LUT carrier output to the Multiplier
    signal internal_carrier : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

    -- 1. Instance of the LUT to generate the Carrier Sine Wave
    u_carrier_lut : lut
        generic map (
            ADDR_WIDTH => ADDR_WIDTH,
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            addr   => addr,
            output => internal_carrier
        );

    -- 2. Instance of the Multiplier to mix the Carrier with the Message
    u_mixer : multiplier
        generic map (
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            carrier   => internal_carrier,
            msg       => msg,
            am_signal => am_out
        );

end architecture structural;
