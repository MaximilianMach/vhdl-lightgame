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
use IEEE.NUMERIC_STD.ALL;


entity led_behavior is
    port (clk : in std_logic;
          hold_in: in std_logic;
          counter_max: in unsigned(19 downto 0);
          led_out: out std_logic_vector(15 downto 0));
end led_behavior;

architecture behavioral of led_behavior is

    -- leds to cycle through
    -- set left led on using hex code
    signal led: unsigned(15 downto 0) := x"8000";

    -- init counter
    signal count: unsigned(28 downto 0) := (others => '0');
    
    -- define states
    type state_type is (right, left, hold);
    signal state: state_type := right;

    -- index of the active led - for blinking hit one
    signal pos: integer := 15;

begin
    toggle: process(clk)
    begin
        if rising_edge(clk) then

            count <= count + 1;

            if hold_in = '1' then
                state <= hold;
            end if;
            
            -- shift according to current speed
            if count >= counter_max then
                -- reset counter
                count <= (others=>'0');
                
                case state is
                    -- shift till right end
                    when right =>
                        led <= shift_right(led, 1);
                        
                        -- save current position
                        pos <= pos - 1;

                        if led(0) = '1' then
                            state <= left;
                        end if;

                    -- shift till left end
                    when left =>
                        led <= shift_left(led, 1);

                        -- save current position
                        pos <= pos + 1;

                        if led(15) = '1' then
                            state <= right;
                        end if;

                    -- blink hit led
                    when hold =>
                        led(pos) <= not led(pos);
                end case;

            end if;

        end if;
        end process;

    led_out <= std_logic_vector(led);

end behavioral;