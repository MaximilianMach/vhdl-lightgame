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
    port (clk   : in std_logic;
          speed : in unsigned(19 downto 0);
          leds_out: out unsigned(15 downto 0); 
          stop  : in std_logic);
end led_behavior;

architecture behavioral of led_behavior is
    
    -- leds to sycle through
    signal leds: unsigned(15 downto 0) := (others => '0');
    signal count: unsigned(28 downto 0) := (others => '0');
   
    type state_type is (left, right, halt);
    signal state: state_type := left;


begin
    toggle: process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
            
            if stop = '1' then
                state <= halt;
            end if;
                        
            if count = speed then
                
                -- reset counter
                count <= (others=>'0');
                
                case state is
                    when left =>
                        leds <= shift_right(leds, 1);
                        if leds(0) = '1' then
                            state <= right;
                        end if;
                    when right =>
                        leds <= shift_left(leds, 1);
                        if leds(15) = '1' then
                            state <= left;
                        end if;
                    when halt =>
                        
                end case;

            end if;

        end if;
        leds_out <= leds;
    end process;
end behavioral; 
