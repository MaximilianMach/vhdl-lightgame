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
    use ieee.std_numeric.all;

entity lightgame is
    port (clk : in std_logic;
          btn : in std_logic;
          led_out: out std_logic_vector(15 downto 0);
          hold_out: out std_logic);
end lightgame;

architecture behavioral of lightgame is
    -- bind in component for running light
    component led_behavior is
        port (clk : in std_logic;
              counter_max: in unsigned(19 downto 0);
              leds_out : out std_logic_vector(15 downto 0));
    end component;
    
    -- define states
    type state_type is (init, set, show, run, won);
    -- start with init state
    signal state:  state_type := init;
    
    -- counts the hits
    signal hit: unsigned;
    
    -- simple counter
    signal counter: unsigned (25 downto 0) := (others => '0');

    -- maximum counter value - determines the speed of the running light
    signal counter_max: unsigned (19 downto 0);

    -- vector for all the lights on the XLININX BASYS3 (15 left - 0 right)
    signal led: std_logic_vector (15 downto 0) := (others=>'0');

    -- saves the shift which should be done for the winning signalisation
    -- two leds active, going in two different directions
    -- led(15 downto 8)
    signal l_win: unsigned := "0";
    -- led(7 downto 0)
    signal r_win: unsigned := "1";

    -- index of the target led in the led vector 
    -- the led will be led(target)
    signal target: integer;
     
    
    begin
        -- bind in component of running led_behav (running light)
        led_behav: led_behavior port map(clk=>clk, counter_max=>counter_max, leds_out=>led);
        process(clk)

    begin
    if rising_edge(clk) then

        case state is

            when init =>

                -- set the hits
                hit <= "0";

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
                if counter = (others=>'1') then
                    led(target) <= not led(target);
                end if;

                -- wait for btn to start game
                if btn = '1' then
                    counter <= (others => '0');
                    state <= run;
                end if;

            -- actual game part
            when run =>

                counter <= counter + 1;

                -- wait for btn to stop light
                if btn = '1' then
                    -- tell component that light shall be stopped
                    hold_out <= '1';

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

            -- lightshow
            when won =>

                -- counts when to reset led position
                hit <= "0";

                -- start position are two in center
                l_win <= l_win+1;
                r_win <= r_win+1;

                -- reused hit variable
                -- only run on first iteration:
                if hit = "0" then
                    led(8) <= '1';
                    led(7) <= '1';
                    hit <= hit + 1;
                end if;


                if l_win > 15 then
                    l_win <= "0";
                    r_win <= "1";

                    -- init animation 2:
                    hit <= "Z";
                end if;

                -- when at the end of both directions:
                if hit <= "Z" then
                    -- jump led from left to right with rising width
                    -- goes from outside to inside:
                    -- goes second
                    led <= shift_right(led, l_win); -- bullshit 💩
                    led <= shift_left(led, r_win); 
                else
                    -- goes from inside to outside
                    -- goes first
                    led <= shift_left(led, l_win);
                    led <= shift_right(led, r_win);
                end if;

                -- reset on btn press
                if btn = '1' then
                    state <= init;
                end if;
        end case;

    end if;
    end process;

    led_out <= led;

end behavioral;