----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/01/03 09:35:39
-- Design Name: 
-- Module Name: TimePiece - RTL
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

entity TimePiece is
    generic ( TIMING1 : INTEGER := 100000000; 
              TIMING2 : INTEGER := 100000 );
    port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR(7 downto 0);
           SEG : out STD_LOGIC_VECTOR(6 downto 0);
           AN : out STD_LOGIC_VECTOR(3 downto 0)
    );
end TimePiece;

architecture RTL of TimePiece is
    component Decode7Seg is
        Port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               NUM : in STD_LOGIC_VECTOR (3 downto 0);
               SEG : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    component PulseGenerator is
        generic ( TIMING : INTEGER := 0 ); 
        port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               PULSE : out STD_LOGIC );
    end component;
    component MultiCounter is
        generic ( NUMBER : INTEGER := 10 ); 
        port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               ENABLE : in STD_LOGIC;
               COUNT : out STD_LOGIC_VECTOR (7 downto 0);
               CARRY : out STD_LOGIC);
    end component;
    signal num : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal carrysec : STD_LOGIC := '0';
    signal carry1khz : STD_LOGIC := '0';
    signal carrymin01 : STD_LOGIC := '0';
    signal carrymin10 : STD_LOGIC := '0';
    signal carryhour : STD_LOGIC := '0';
    signal carryday : STD_LOGIC := '0';
    signal min01 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal min10 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal hour : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal ledsw : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
begin
    d7s : Decode7Seg
            port map ( CLK => CLK, RST => RST, NUM => num, SEG => SEG );
    pg1s : PulseGenerator
            generic map ( TIMING => TIMING1 )
            port map ( CLK => CLK, RST => RST, PULSE => carrysec );
    pg1khz : PulseGenerator
            generic map ( TIMING => TIMING2 )
            port map ( CLK => CLK, RST => RST, PULSE => carry1khz );
    mc60 : MultiCounter
            generic map ( NUMBER => 60 )
            port map ( CLK => CLK, RST => RST, ENABLE => carrysec, COUNT => LED, CARRY => carrymin01 );
    mcmin01 : MultiCounter
            generic map ( NUMBER => 10 )
            port map ( CLK => CLK, RST => RST, ENABLE => carrymin01, COUNT => min01, CARRY => carrymin10 );
    mcmin10 : MultiCounter
            generic map ( NUMBER =>  6 )
            port map ( CLK => CLK, RST => RST, ENABLE => carrymin10, COUNT => min10, CARRY => carryhour );
    mchour : MultiCounter
            generic map ( NUMBER => 24 )
            port map ( CLK => CLK, RST => RST, ENABLE => carryhour, COUNT => hour, CARRY => carryday );

    process ( CLK, RST )
    begin
        if ( RST = '1' ) then
            ledsw <= (others => '0');
        elsif ( CLK'event and CLK = '1' ) then
            if ( carry1khz = '1' ) then
                ledsw <= ledsw + '1';
            end if;
        end if;
    end process;

    process ( CLK, RST )
    begin
        if ( RST = '1' ) then
        elsif ( CLK'event and CLK = '1' ) then
            case ledsw is
                when "00" => AN <= "1110"; num <= min01(3 downto 0);
                when "01" => AN <= "1101"; num <= min10(3 downto 0);
                when "10" => AN <= "1011";
                    case hour is
                        when X"00" => num <= X"0"; when X"01" => num <= X"1";
                        when X"02" => num <= X"2"; when X"03" => num <= X"3";
                        when X"04" => num <= X"4"; when X"05" => num <= X"5";
                        when X"06" => num <= X"6"; when X"07" => num <= X"7";
                        when X"08" => num <= X"8"; when X"09" => num <= X"9";
                        when X"0A" => num <= X"0"; when X"0B" => num <= X"1";
                        when X"0C" => num <= X"2"; when X"0D" => num <= X"3";
                        when X"0E" => num <= X"4"; when X"0F" => num <= X"5";
                        when X"10" => num <= X"6"; when X"11" => num <= X"7";
                        when X"12" => num <= X"8"; when X"13" => num <= X"9";
                        when X"14" => num <= X"0"; when X"15" => num <= X"1";
                        when X"16" => num <= X"2"; when X"17" => num <= X"3";
                        when others => num <= X"0";
                    end case;
                when "11" => AN <= "0111";
                    case hour is
                        when X"00" => num <= X"0"; when X"01" => num <= X"0";
                        when X"02" => num <= X"0"; when X"03" => num <= X"0";
                        when X"04" => num <= X"0"; when X"05" => num <= X"0";
                        when X"06" => num <= X"0"; when X"07" => num <= X"0";
                        when X"08" => num <= X"0"; when X"09" => num <= X"0";
                        when X"0A" => num <= X"1"; when X"0B" => num <= X"1";
                        when X"0C" => num <= X"1"; when X"0D" => num <= X"1";
                        when X"0E" => num <= X"1"; when X"0F" => num <= X"1";
                        when X"10" => num <= X"1"; when X"11" => num <= X"1";
                        when X"12" => num <= X"1"; when X"13" => num <= X"1";
                        when X"14" => num <= X"2"; when X"15" => num <= X"2";
                        when X"16" => num <= X"2"; when X"17" => num <= X"2";
                        when others => num <= X"0";
                    end case;
                when others => AN <= "1111"; num <= X"0";
            end case;
        end if;
    end process;

end RTL;
