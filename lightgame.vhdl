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


library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity lightgame is
    port (clk : in std_logic;
          btn : in std_logic;
          led_out: out std_logic_vector(15 downto 0));
end lightgame;

architecture arch of lightgame is
    -- bind in component for running light
    component led_behavior is
        port (clk : in std_logic;
              hold_in: in std_logic;
              counter_max: in unsigned(19 downto 0);
              led_out2: out std_logic_vector(15 downto 0));
    end component;
    
    -- define states
    type state_type is (init, set, show, run, won);
    -- start with init state
    signal state:  state_type := init;
    
    -- counts the hits
    signal hit: integer;
    
    -- triggers interrupt in led_behavior
    signal hold: std_logic := '0';
    
    -- simple counter
    signal counter: unsigned (25 downto 0) := (others => '0');

    -- maximum counter value - determines the speed of the running light
    signal counter_max: unsigned (19 downto 0);

    -- vector for all the lights on the XLININX BASYS3 (15 left - 0 right)
    signal led: std_logic_vector (15 downto 0);
    signal led_game: std_logic_vector (15 downto 0);
    
    -- index of the target led in the led vector 
    -- the led will be led(target)
    signal target: integer;

    -- signals for the won state:
    -- start with two leds in center - grows outside in the state
    -- works like that: led(wpl downto wpr) = ws
    -- left position
    signal wpl: integer := 8;
    -- right position
    signal wpr: integer := 7;
    -- led state - 1 or 0 
    signal ws: std_logic := '1';
     
    
    begin
        -- bind in component of running led_behav (running light)
        led_behav: led_behavior port map(clk=>clk, hold_in=>hold, counter_max=>counter_max, led_out2=>led_game);
        process(clk)

    begin
    if rising_edge(clk) then

        case state is

            when init =>

                -- set the hits
                hit <= 0;

                -- set start speed
                counter_max <= (others=>'1');

                -- set counter
                counter <= (others=>'0');

            -- determinate target led
            when set =>

                counter <= counter + 1;

                -- wait for button to stop counter
                -- signalize target
                if btn = '1' then
                    -- take first 4 bits from counter and set its value as target index
                    target <= to_integer(counter (4 downto 0));
                    -- light up target
                    led(target) <= '1';
                    --reset counter
                    counter <= (others => '0');
                    -- continue to blink target
                    state <= show;
                end if;

            -- signalize target led
            when show =>
                counter <= counter + 1;

                -- if counter is on max let target led change state
                -- create blinking
                if counter = counter_max then
                    led(target) <= not led(target);
                end if;

                -- wait for btn to start game
                if btn = '1' then
                    counter <= (others => '0');
                    state <= run;
                end if;

            -- actual game part
            when run =>

                -- wait for btn to stop light
                if btn = '1' then
                    -- tell component that light shall be stopped
                    hold <= '1';

                    -- if target was hit - increase hit counter and speed
                    if led(target) = '1' then
                        hit <= hit + 1;

                        -- reduce counter_max -> make leds run faster
                        counter_max <= counter_max - to_unsigned(1,12);

                    -- otherwise reset game
                    else
                        state <= init;
                    end if;

                end if;

                -- signalize win after 5 hits
                if hit = 5 then 
                    state <= won;
                end if;
                
                led <= led_game;
            -- lightshow
            when won =>
                
                counter <= counter + 1;

                if counter = counter_max then
                    -- set two in center as defined
                    led(wpl downto wpl) <= (others=>ws);

                    if wpl /= 15 then
                        -- increase size of positions
                        wpl <= wpl + 1;
                        wpr <= wpr - 1;

                    else
                        -- recenter
                        wpl <= 8;
                        wpr <= 7;

                        -- set state to off
                        ws <= '0';
                    end if;

                end if;

                -- reset on btn press
                if btn = '1' then
                    state <= init;
                end if;
        end case;

    end if;
    end process;

    led_out <= led;

end arch;
