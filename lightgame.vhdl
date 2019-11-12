
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Maximilian MACH
-- 
-- Create Date: 16.10.2019 15:42:06
-- Design Name: 
-- Module Name: lightgame - Behavioral
-- Project Name: lightgame
-- Target Devices: Xilinx 3
-- Tool Versions: 
-- Description: a little game which uses the leds on the basis3 board
--              similar to the game "Stacker"
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lightgame is
    port (clk : in std_logic;
          btn : in std_logic;
          led_active : out std_logic);
end lightgame;

architecture Behavioral of lightgame is
    
    component led_behavior is
        port (clk : in std_logic;
              speed: in unsigned(19 downto 0);
              led : out std_logic);
    end component;
    
    type state_type is (init, run, won);
    signal state:  state_type := init;
    signal hit: unsigned := "0";
    signal speed: unsigned (19 downto 0) := (others=>'0'); 

    signal old_btn: std_logic := '0'; -- saves the old state to check a btn toggle
    
    led_behav: led_behavior port map(clk, speed);

begin
process(clk)
    begin
    if rising_edge(clk) then
        case state is
            when init =>
                -- set start speed 
                speed <= "10000"; -- example speed
            when run =>
                hit <= hit + 1;
                if hit < 6 then
                    speed <= speed - to_unsigned(1,15);
                end if;
                if rising_edge(btn) then
                    -- if light not hit then
                    -- state <= init;
                    -- end if;
                end if;
                -- increase speed
            when won =>
                -- lightshow
                if rising_edge(btn) then
                    state <= init;
                end if;
        end case;
    
    end if;
    end process;
end Behavioral;
