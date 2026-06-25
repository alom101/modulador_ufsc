library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_testbench is
end counter_testbench;

architecture Behavioral of counter_testbench is
    constant CLK_PERIOD : time := 10 ns;
    constant WIDTH      : positive := 8;

    component counter is
        generic (
            WIDTH : positive := 8
        );
        Port (
            clk   : in  STD_LOGIC;
            count : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
        );
    end component;

    signal clk      : STD_LOGIC := '0';
    signal count    : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
begin

    uut: counter
        generic map (
            WIDTH => WIDTH
        )
        port map (
            clk   => clk,
            count => count
        );

    clk_process : process
    begin
        for i in 0 to 2**WIDTH loop 
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait; 
    end process;

end Behavioral;
