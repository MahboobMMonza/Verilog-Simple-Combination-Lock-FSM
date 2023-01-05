# Combination Lock FSM

This is a design for a simple combination lock written in Verilog using a Moore Finite State Machine,
for *Lab 4* of McMaster University's **Software Engineering 2DA4** course.

This repository includes the necessary Verilog code required for the circuit implementation, as well as
a detailed explanation of the design, which is explained below.

## Design Specifications

### I/O Specifications

* 4 switches implementing a 4-bit binary code key used to unlock the device (initially set to `0110`)
    * Read left-to-right
    * If 2 successive mismatches occur, the lock enters an alarm state that can only be exited by resetting the device
* 3 push-button inputs:
    * **Enter** (implemented as active HIGH)
    * **Change** (implemented as active HIGH)
    * **Reset** (implemented as active LOW)
* All push-button inputs are _conditioned_
    * Input conditioning must also be implemented as a sub-circuit
* Hexadecimal display to show the state of the lock
* Device runs on a 50 MHz clock
* It is assumed that only one button is pressed at a time

### Functional Specifications

* Lock starts in a neutral **_initial_** _locked_ state
    * The hexadecimal display outputs `-`
    * The lock code is set to `0110`
* Switches are manipulated to make a code combination
* When **Enter** is pressed, the combination is checked for a match. If a match occurs then:
    * The lock enters the _open_ state
    * The hexadecimal display outputs `O`
    * Lock stays in _open_ state until **Enter** is pressed again, after which it returns to the _locked_ state
* When **Change** is pressed, the code is checked for a match. If a match occurs then:
    * The lock enters the _new_ state
    * The hexadecimal output displays `n`
    * The lock remains in the _new_ state until **Change** or **Enter** is pressed again
        * When either button is pressed, the lock reads and stores the new binary code input represented by the switches
        * This new input is used as the lock's code, and the lock returns to the _locked_ state
* If the **Enter** and **Change** inputs are pressed consecutively and the combinations are incorrect, then:
    * The lock enters the _alarm_ state
    * The hexadecimal output displays `A`
    * The lock remains in the _alarm_ sate until **Reset** is pressed
* Whenever **Reset** is pressed, the lock returns to the **_initial_** _locked_ state and the lock code becomes `0110`

## Design Process

### Input Conditioning

The push-button inputs need to be conditioned to better represent a "press" in the circuit. To do this, the pulse length
of the button press is shortened to a clock cycle, and the button is not registered again until it is released. The
**Reset** button, however, does not need to be conditioned, since every consecutive reset that is read after the first
reset maintains the lock in the _**initial** locked_ state. This _conditioned_ input is what is actually read by the
lock for the **Enter** and **Change** button presses.

#### Conditioning Functional Specifications

* When the button is not pressed, the machine is in the _initial_ state and output is `0`
  * If the button is still not pressed by the next clock edge, this state is maintained
* If the button is pressed by the next clock edge, then the machine enters the _press_ state, and the output is `1`
  * If the button is unpressed by the next clock edge, it returns to the _initial_ state
* If the button is still pressed by the next clock edge, then the machine enters the _hold_ state, and the output is `0`
  * If the button is still pressed by the next clock edge, then this state is maintained
  * If the button is released by the next clock edge, then the machine returns to the _initial_ state