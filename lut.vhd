library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity lut is
    generic (
        ADDR_WIDTH : integer := 8; -- 256 points per cycle
        DATA_WIDTH : integer := 12 -- 12-bit signed output resolution
    );
    port (
        addr     : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        output   : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of lut is
    type lut_type is array (0 to (2**ADDR_WIDTH)-1) of signed(DATA_WIDTH-1 downto 0);

    function init_lut return lut_type is
        variable angle      : real;
        variable table      : lut_type;
    begin
        for i in table'range loop
            angle       := 2.0*MATH_PI * real(i) / real(2**ADDR_WIDTH-1);
            table(i)    := to_signed(integer(sin(angle)*real(2**(DATA_WIDTH-1)-1)), DATA_WIDTH);
        end loop;
        return table;
    end function;

    constant sin_table : lut_type := init_lut;
begin
    output <= std_logic_vector(sin_table(to_integer(unsigned(addr))));
end architecture;
