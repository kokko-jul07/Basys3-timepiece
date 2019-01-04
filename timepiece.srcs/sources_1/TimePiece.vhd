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
    signal khz : STD_LOGIC := '0';
    signal carrysec : STD_LOGIC := '0';
    signal carrymin1 : STD_LOGIC := '0';
    signal carrymin2 : STD_LOGIC := '0';
    signal carryhour : STD_LOGIC := '0';
    signal carryday : STD_LOGIC := '0';
    signal min1 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal min2 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal hour : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal switch : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
begin
    d7s : Decode7Seg
            port map ( CLK => CLK, RST => RST, NUM => num, SEG => SEG );
    pg1s : PulseGenerator
            generic map ( TIMING => 10000000 )
            port map ( CLK => CLK, RST => RST, PULSE => carrysec );
    pg1khz : PulseGenerator
            generic map ( TIMING => 100000 )
            port map ( CLK => CLK, RST => RST, PULSE => khz );
    mc60 : MultiCounter
            generic map ( NUMBER => 60 )
            port map ( CLK => CLK, RST => RST, ENABLE => carrysec, COUNT => LED, CARRY => carrymin1 );
    mcmin1 : MultiCounter
            generic map ( NUMBER => 10 )
            port map ( CLK => CLK, RST => RST, ENABLE => carrymin1, COUNT => min1, CARRY => carrymin2 );
    mcmin2 : MultiCounter
            generic map ( NUMBER => 6 )
            port map ( CLK => CLK, RST => RST, ENABLE => carrymin2, COUNT => min2, CARRY => carryhour );
    mchour : MultiCounter
            generic map ( NUMBER => 24 )
            port map ( CLK => CLK, RST => RST, ENABLE => carryhour, COUNT => hour, CARRY => carryday );

    process ( CLK, RST )
    begin
        if ( RST = '1' ) then
            switch <= (others => '0');
        elsif ( CLK'event and CLK = '1' ) then
            if ( khz = '1' ) then
                switch <= switch + '1';
            end if;
        end if;
    end process;

    -- 7seg LED dynamic control
    process ( CLK, RST )
    begin
        if ( RST = '1' ) then
            num <= (others => '0');
        elsif ( CLK'event and CLK = '1' ) then
            case switch is
                when "00" =>
                    num <= min1(3 downto 0);
                    AN <= "1110";
                when "01" =>
                    num <= min2(3 downto 0);
                    AN <= "1101";
                when "10" =>
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
                    AN <= "1011";
                when "11" =>
                    case hour is
                        when X"00" => num <= X"0"; when X"01" => num <= X"0";
                        when X"02" => num <= X"0"; when X"03" => num <= X"0";
                        when X"04" => num <= X"0"; when X"05" => num <= X"0";
                        when X"06" => num <= X"0"; when X"07" => num <= X"0";
                        when X"08" => num <= X"0"; when X"09" => num <= X"0";
                        when X"0A" => num <= X"1"; when X"0B" => num <= X"1";
                        when X"0C" => num <= X"1"; when X"0D" => num <= X"";
                        when X"0E" => num <= X"1"; when X"0F" => num <= X"";
                        when X"10" => num <= X"1"; when X"11" => num <= X"";
                        when X"12" => num <= X"1"; when X"13" => num <= X"";
                        when X"14" => num <= X""; when X"15" => num <= X"";
                        when X"16" => num <= X""; when X"17" => num <= X"";
                        when others => num <= X"0";
                    end case;
                    AN <= "0111";
                when others =>
                    SEG <= "1111111";
                    AN <= "1111";
            end case;
        end if;
    end process;

end RTL;
