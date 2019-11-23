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
    signal l_win: unsigned := '0';
    signal r_win: unsigned := '1'
    signal win_two: unsigned:= '0';
    
    
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

                -- counts when to reset led position
                hit <= '0';

                -- start position are two in center
                l_win = l_win+1;
                r_win = r_win+1;

                if hit = '0' then
                    led[8] <= '1';
                    led[7] <= '1';
                    hit <= hit + 1;
                end if;


                if l_win > 15 then
                    l_win = '0';
                    r_win = '1';

                    -- init animation 2:
                    hit <= 'Z';
                end if;

                -- when already and ends:
                if hit <= 'Z' then
                    -- jump led from left to right with rising width
                    -- goes from outside to inside:
                    -- goes second
                    led = shift_right(led, l_win);
                    led = shift_left(led, r_win);
                else
                    -- goes from inside to outside
                    -- goes fitst
                    led = shift_left(led, l_win);
                    led + shift_right(led, r_win);
                end if;

                if btn = '1' then
                    state <= init;
                end if;
        end case;
    
    end if;
    end process;
end Behavioral;