library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_operator is
    Port (
        carrier   : in  std_logic_vector(7 downto 0);
        msg       : in  std_logic_vector(7 downto 0);
        am_signal : out std_logic_vector(15 downto 0)
    );
end top_operator;

architecture wrapper of top_operator is
begin
    inst: entity work.multiplier(rtl_using_operator)
        generic map (DATA_WIDTH => 8)
        port map (carrier => carrier, msg => msg, am_signal => am_signal);
end wrapper;