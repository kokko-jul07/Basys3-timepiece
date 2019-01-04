----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/01/04 12:01:36
-- Design Name: 
-- Module Name: MultiCounter - RTL
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

entity MultiCounter is
    generic ( NUMBER : INTEGER := 10 ); 
    port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           ENABLE : in STD_LOGIC;
           COUNT : inout STD_LOGIC_VECTOR (7 downto 0);
           CARRY : out STD_LOGIC);
end MultiCounter;

architecture RTL of MultiCounter is
begin
    process ( CLK, RST )
    begin
        if ( RST = '0' ) then
            COUNT <= (others => '0');
        elsif ( CLK'event and CLK = '1' ) then
            if ( COUNT = NUMBER ) then
                COUNT <= (others => '0');
            elsif ( ENABLE = '1' ) then
                COUNT <= COUNT + '1';
            end if;
        end if;
    end process;

    process ( CLK, RST )
    begin
        if ( RST = '0' ) then
            CARRY <= '0';
        elsif ( CLK'event and CLK = '1' ) then
            if ( COUNT = NUMBER ) then
                CARRY <= '1';
            else
                CARRY <= '0';
            end if;
        end if;
    end process;

end RTL;
