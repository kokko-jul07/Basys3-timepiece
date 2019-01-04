----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/01/03 09:35:39
-- Design Name: 
-- Module Name: PulseGenerator - RTL
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PulseGenerator is
    generic ( TIMING : INTEGER := 0 ); 
    port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           PULSE : out STD_LOGIC );
end PulseGenerator;

architecture RTL of PulseGenerator is
    signal counter : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    process
    begin
        if ( RST = '1' ) then
            counter <= (others => '0');
        elsif ( CLK'event and CLK = '1' ) then
            counter <= counter + '1';
        end if;
    end process;

    process
    begin
        if ( RST = '1' ) then
            PULSE <= '0';
        elsif ( CLK'event and CLK = '1' ) then
            if ( counter = TIMING ) then
                PULSE <= '1';
            end if;
        end if;
    end process;

end RTL;
