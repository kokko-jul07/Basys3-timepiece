----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/01/04 17:04:16
-- Design Name: 
-- Module Name: TestTimePiece - SIM
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

entity TestTimePiece is
--  Port ( );
end TestTimePiece;

architecture SIM of TestTimePiece is
    constant cycle : time := 100 ns;
    constant timing1 : INTEGER := 5;
    constant timing2 : INTEGER := 3;
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal led : STD_LOGIC_VECTOR(7 downto 0);
    signal seg : STD_LOGIC_VECTOR(6 downto 0);
    signal an  : STD_LOGIC_VECTOR(3 downto 0);
    component TimePiece is
        generic ( TIMING1 : INTEGER := 100000000; 
                  TIMING2 : INTEGER := 100000 );
        port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               LED : out STD_LOGIC_VECTOR(7 downto 0);
               SEG : out STD_LOGIC_VECTOR(6 downto 0);
               AN : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

begin
    tp : TimePiece
            generic map ( TIMING1 => timing1, TIMING2 => timing2 )
            port map ( CLK => clk, RST => rst, LED => led, SEG => seg, AN => an );
    
    process
    begin
        wait for (cycle/2);
        clk <= not clk;
    end process;
    
    process
    begin
        rst <= '1';
        wait for (cycle*2); rst <= '0';
        wait for (10000*cycle*2);
        assert false
        report "Simulation Complete!!"
        severity Failure;
        wait;
    end process;

end SIM;
