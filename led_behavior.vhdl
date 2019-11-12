----------------------------------------------------------------------------------
-- Company:
-- Engineer: Maximilian Mach
-- 
-- Create Date: 04.11.2019 13:49:30
-- Design Name: 
-- Module Name: led_behavior - Behavioral
-- Project Name: vhdl-lightgame
-- Target Devices: XILINX BASYS 3
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

entity led_behavior is
    port (clk   : in std_logic;
          speed : in unsigned(19 downto 0);
          led   : out std_logic );
end led_behavior;

architecture behavioral of led_behavior is
    
    -- leds to sycle through
    signal leds: unsigned(17 downto 0) := (others => '0');
    signal count: unsigned(28 downto 0) := (others => '0');

begin
    toggle: process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
            if count = speed then
                -- shift active led left
                if leds(17) /= 1 then 
                    leds <= leds * 2;
                else 
                    -- shift active led right
                end if;
            end if;
        end if;
    end process;
end behavioral; 