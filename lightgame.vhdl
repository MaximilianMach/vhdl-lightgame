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
    signal led: std_logic_vector (15 downto 0) := (others=>'0');
    
    
    begin
        led_behav: led_behavior port map(clk=>clk, speed=>speed, led=>led);
        process(clk)

    begin
    if rising_edge(clk) then
        case state is
            when init =>
                -- set start speed 
                speed <= (others=>'1');

            when run =>
                if hit < 6 then
                    -- increase speed
                    speed <= speed - to_unsigned(1,12);
                end if;
                if btn = '1' then
                    halt <= '1';
                    
                    if led = target then
                        hit <= hit + 1;
                    else
                        state <= init;
                    end if;

                end if;

            when won =>
                -- lightshow
                
                if btn = '1' then
                    state <= init;
                end if;
        end case;
    
    end if;
    end process;
end Behavioral;