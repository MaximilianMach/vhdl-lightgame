----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2019 13:49:30
-- Design Name: 
-- Module Name: led_behavior - Behavioral
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

entity led_behavior is
    port ( clk : in std_logic;
           led : out std_logic );
end led_behavior;

architecture behavioral of led_behavior is

component lightgame is
    port (clk : in std_logic;
          btn : in std_logic;
          led_active : out std_logic);
end component;

begin
    toggle: process(clk)
    begin
        if rising_edge(clk) then
            -- toggle through leds
        end if;
    end process;
end behavioral;
