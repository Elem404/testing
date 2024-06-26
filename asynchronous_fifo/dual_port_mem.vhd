library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_port_mem is
  generic(
    g_DATA_WIDTH  : positive := 8;
    g_ADDR_WIDTH  : positive := 4
  );
  port (
    -- first port
    i_CLK_a   : in  std_logic;
    i_CLKEN_a : in  std_logic;
    i_ADDR_a  : in  std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    i_DIN_a   : in  std_logic_vector(g_DATA_WIDTH-1 downto 0);

    -- second port
    i_CLK_b   : in  std_logic;
    i_ADDR_b  : in  std_logic_vector(g_ADDR_WIDTH-1 downto 0);
    o_DOUT_b  : out std_logic_vector(g_DATA_WIDTH-1 downto 0)
  );
end entity;

architecture behavior of dual_port_mem is

  type t_mem_type is array ((2**g_ADDR_WIDTH)-1 downto 0) of std_logic_vector(g_DATA_WIDTH-1 downto 0);
  signal r_memory : t_mem_type := (others=>(others=>'0'));

  signal s_clk_a : std_logic := '0';

begin

  s_clk_a <= i_CLK_a when i_CLKEN_a = '1' else '0';

  port_a : process(s_clk_a)
  begin
    if rising_edge(s_clk_a) then
      r_memory(to_integer(unsigned(i_ADDR_a))) <= i_DIN_a;
    end if;
  end process;

  port_b : process(i_CLK_b)
  begin
    if rising_edge(i_CLK_b) then
      o_DOUT_b <= r_memory(to_integer(unsigned(i_ADDR_b)));
    end if;
  end process;

end architecture;
