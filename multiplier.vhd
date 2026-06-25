library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier is
    Generic (
        DATA_WIDTH : integer := 8
    );
    Port (
        carrier     : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        msg         : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        am_signal   : out std_logic_vector((2*DATA_WIDTH)-1 downto 0)
    );
end multiplier;


architecture rtl_using_optimization of multiplier is 


begin


end rtl_using_optimization;


architecture rtl_using_operator of multiplier is

begin

    am_signal <= std_logic_vector(signed(carrier) * signed(msg));

end rtl_using_operator;
