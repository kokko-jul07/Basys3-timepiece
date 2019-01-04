----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/01/03 10:06:55
-- Design Name: 
-- Module Name: TestPulseGenerator - RTL
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

entity TestPulseGenerator is
--  Port ( );
end TestPulseGenerator;

architecture SIM of TestPulseGenerator is
    constant cycle : time := 100 ns;
    constant timing : INTEGER := 10;
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC;
    signal pulse : STD_LOGIC := '0';
    component PulseGenerator is
        generic ( TIMING : INTEGER := 0 ); 
        port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               PULSE : out STD_LOGIC );
    end component;
begin
    pg : PulseGenerator
            generic map ( TIMING => timing )
            port map ( CLK => clk, RST => rst, PULSE => pulse );

process
    begin
        wait for (cycle/2);
        clk <= not clk;
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
