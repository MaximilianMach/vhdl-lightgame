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
          led_out: out std_logic_vector(15 downto 0);
          hold: out std_logic);
end lightgame;

architecture Behavioral of lightgame is
    
    component led_behavior is
        port (clk : in std_logic;
              counter_max: in unsigned(19 downto 0);
              leds_out : out std_logic_vector(15 downto 0));
    end component;
    
    type state_type is (init, show, run, won);
    signal state:  state_type := init;
    signal hit: unsigned := "0";
    
    
    signal counter_max: unsigned (19 downto 0) := (others=>'1');
    
    signal halt: std_logic;

    signal led: std_logic_vector (15 downto 0) := (others=>'0');
    signal l_win: unsigned := "0";
    signal r_win: unsigned := "1";
    signal win_two: unsigned := "0";

    
    signal target: integer;
     
    signal counter: unsigned (25 downto 0) := (others => '0');
    signal switch: unsigned := "0";
    
    begin
        led_behav: led_behavior port map(clk=>clk, counter_max=>counter_max, leds_out=>led);
        process(clk)

    begin
    if rising_edge(clk) then

        case state is
            when init =>
                -- set start speed
                counter_max <= (others=>'1');

                counter <= counter + 1;

                -- signalize target and change state
                -- decide target led with the time it took till btn press
                if btn = '1' then
                    -- take first 4 bits from counter and set its value as target led
                    target <= to_integer(counter (4 downto 0));
                    -- set as target
                    led(target) <= '1';
                    
                    --reset counter
                    counter <= (others => '1');
                    
                    state <= show;
                end if;
                    
            -- signalize target led
            when show =>
                counter <= counter + 1;

                -- if counter equals counter_max let target led change state
                -- creates blinking
                if counter <= counter_max then
                    led(target) <= not led(target);
                end if;

                if btn = '1' then
                    counter <= (others => '0');
                    state <= run;
                end if;

            when run =>

                counter <= counter + 1;

                if hit >= 1 then
                    -- reduce counter_max -> make leds run faster
                    counter_max <= counter_max - to_unsigned(1,12);
                end if;


                if btn = '1' then
                    halt <= '1';
                    
                    if led(target) = '1' then
                        hit <= hit + 1;
                    else
                        state <= init;
                    end if;
                end if;
                
                if hit = 6 then 
                    state <= won;
                end if;

            when won =>
                -- lightshow

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
                    led <= shift_right(led, l_win); -- bullshit
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

end Behavioral; 