# vhdl-lightgame


## Function

A running light, which can be stopped using a button, should stop at a random target point. If the light is stopped at the point the run is won and will continue to the next level. Each level is harder than the last one by making the running light go faster.
After five hits, the game is won and shall display a lightshow to signalize the win to the player. With the next button press the game is set back to the init state and is thus reset.

## led_behavior

Simply sets the running light accoding to the current speed and includes the stop function.


# TODO
- [x] Determate target LED
- [x] Signalize win

  ~~Wrong thinking. Wont work as intended.~~
  
- [x] Check if LED was hit

  Testing still needs to be done

- [ ] Choose Counter Size
- [ ] Fix multiple Net Error