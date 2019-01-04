----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/01/04 12:53:16
-- Design Name: 
-- Module Name: TestMultiCounter - SIM
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestMultiCounter is
--  Port ( );
end TestMultiCounter;

architecture SIM of TestMultiCounter is
    constant cycle : time := 100 ns;
    constant number : INTEGER := 10;
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal enable : STD_LOGIC := '0';
    signal count : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal carry : STD_LOGIC := '0';
    component MultiCounter is
        generic ( NUMBER : INTEGER := 10 ); 
        port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               ENABLE : in STD_LOGIC;
               COUNT : inout STD_LOGIC_VECTOR (7 downto 0);
               CARRY : out STD_LOGIC);
    end component;

begin
    mc : MultiCounter
            generic map ( NUMBER => number )
            port map ( CLK => clk, RST => rst, ENABLE => enable, COUNT => count, CARRY => carry );

    process
    begin
        wait for (cycle/2);
        clk <= not clk;
    end process;

    process ( clk )
    begin
        if ( clk'event and clk = '1' ) then
            enable <= not enable;
        end if;
    end process;

    process
    begin
        rst <= '0';
        wait for (cycle*2); rst <= '1';
        wait for (20*cycle*2); rst <= '0';
        wait for (cycle*2); rst <= '1';
        wait for (20*cycle*2);
        assert false
        report "Simulation Complete!!"
        severity Failure;
        wait;
    end process;

end SIM;
