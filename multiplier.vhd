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
    signal X : signed(DATA_WIDTH-1 downto 0);

    signal node_3x   : signed(DATA_WIDTH+1 downto 0); 
    signal node_13x  : signed(DATA_WIDTH+3 downto 0); 
    signal node_17x  : signed(DATA_WIDTH+4 downto 0); 
    signal node_45x  : signed(DATA_WIDTH+5 downto 0); 
    signal node_75x  : signed(DATA_WIDTH+6 downto 0); 
    signal node_77x  : signed(DATA_WIDTH+6 downto 0); 
    signal node_101x : signed(DATA_WIDTH+6 downto 0); 
    signal node_119x : signed(DATA_WIDTH+6 downto 0); 
    signal node_127x : signed(DATA_WIDTH+6 downto 0); 
    signal node_203x : signed(DATA_WIDTH+7 downto 0); 
    signal node_223x : signed(DATA_WIDTH+7 downto 0); 
    signal node_249x : signed(DATA_WIDTH+7 downto 0); 
    signal node_255x : signed(DATA_WIDTH+7 downto 0); 

    signal result    : signed((2*DATA_WIDTH)-1 downto 0);

begin

    X <= signed(carrier);

    node_3x   <= resize(shift_left(resize(X, DATA_WIDTH+2), 2) - X, node_3x'length);
    node_17x  <= resize(shift_left(resize(X, DATA_WIDTH+5), 4) + X, node_17x'length);
    node_127x <= resize(shift_left(resize(X, DATA_WIDTH+7), 7) - X, node_127x'length);
    node_255x <= resize(shift_left(resize(X, DATA_WIDTH+8), 8) - X, node_255x'length);

    node_13x  <= resize(shift_left(resize(X, DATA_WIDTH+4), 4) - resize(node_3x, DATA_WIDTH+4), node_13x'length);
    node_119x <= resize(resize(node_127x, DATA_WIDTH+7) - shift_left(resize(X, DATA_WIDTH+7), 3), node_119x'length);
    node_45x  <= resize(shift_left(resize(node_3x, DATA_WIDTH+6), 4) - resize(node_3x, DATA_WIDTH+6), node_45x'length);
    node_249x <= resize(resize(node_255x, DATA_WIDTH+8) - shift_left(resize(node_3x, DATA_WIDTH+8), 1), node_249x'length);
    node_223x <= resize(resize(node_255x, DATA_WIDTH+8) - shift_left(resize(X, DATA_WIDTH+8), 5), node_223x'length);

    node_77x  <= resize(resize(node_13x, DATA_WIDTH+7) + shift_left(resize(X, DATA_WIDTH+7), 6), node_77x'length);
    node_75x  <= resize(resize(node_127x, DATA_WIDTH+7) - shift_left(resize(node_13x, DATA_WIDTH+7), 2), node_75x'length);
    node_101x <= resize(shift_left(resize(node_13x, DATA_WIDTH+7), 3) - resize(node_3x, DATA_WIDTH+7), node_101x'length);
    node_203x <= resize(resize(node_255x, DATA_WIDTH+8) - shift_left(resize(node_13x, DATA_WIDTH+8), 2), node_203x'length);

    process(msg, X, node_3x, node_13x, node_45x, node_75x, node_101x, node_119x, node_127x, node_203x, node_223x, node_249x, node_255x)
    begin
        case to_integer(unsigned(msg)) is
            when 128    => result <= resize(shift_left(resize(X, DATA_WIDTH+7), 7), result'length);
            when 180    => result <= resize(shift_left(resize(node_45x, DATA_WIDTH+8), 2), result'length);
            when 223    => result <= resize(node_223x, result'length);
            when 249    => result <= resize(node_249x, result'length);
            when 255    => result <= resize(node_255x, result'length);
            when 238    => result <= resize(shift_left(resize(node_119x, DATA_WIDTH+8), 1), result'length);
            when 203    => result <= resize(node_203x, result'length);
            when 254    => result <= resize(shift_left(resize(node_127x, DATA_WIDTH+8), 1), result'length);
            when 101    => result <= resize(node_101x, result'length);
            when 52     => result <= resize(shift_left(resize(node_13x, DATA_WIDTH+4), 2), result'length);
            when 16     => result <= resize(shift_left(resize(X, DATA_WIDTH+4), 4), result'length);
            when 3      => result <= resize(node_3x, result'length);
            when 32     => result <= resize(shift_left(resize(X, DATA_WIDTH+5), 5), result'length);
            when 75     => result <= resize(node_75x, result'length);
            when 119    => result <= resize(node_119x, result'length);
            when others => result <= (others => '0');
        end case;
    end process;

    am_signal <= std_logic_vector(result);

end rtl_using_optimization;


architecture rtl_using_operator of multiplier is
begin

   am_signal <= std_logic_vector(signed(carrier) * signed(msg));

end rtl_using_operator;