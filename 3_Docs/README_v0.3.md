# FLO Mini v0.3: SO-101 arm prototype

**What changed from v0.2**
- The home-made tower, arm and claw are gone. A **SO-101 follower arm** (TheRobotStudio, Apache-2.0) now bolts to the **front-right** of the base with 4 × M3, using the same 4 holes in the SO-101's own base that the LeKiwi robot uses.
- The **bin moved to the front-left**, beside the arm. It's 118 × 106 × 150 mm (about 1.9 L) and still sits on 4 locating pegs.
- The right-side weight-saving window was removed, because the arm bolts go there.
- **Checked in CAD:** the arm in its default pose has 14 mm of clearance to the bin. It clears the torso, and the base sits flat on the plate.
- The torso, wheels, tires, casters, motor straps and back door are the same as v0.2.

## Print list
The FLO parts are in `stl/`, laid flat:

| Part | Qty | Material |
|---|---|---|
| base | 1 | PETG |
| bin | 1 | PLA or PETG |
| torso | 1 | PLA or PETG, roof down |
| back_door | 1 | PLA |
| wheel | 2 | PETG |
| tire | 2 | TPU 95A |
| caster | 2 | PETG |
| motor_strap | 4 | PETG |

**SO-101 parts:** print the **follower** arm from https://github.com/TheRobotStudio/SO-ARM100 (`STL/SO101/Follower`, choose the Bambu or Prusa plate). Use PLA or PETG, following their `3DPRINT.md`.

## Hardware added for the arm
- 4 × M3 × 25 + washers + nuts: SO-101 base to the FLO plate (nuts go under the plate)
- 6 × Feetech STS3215 serial-bus servos. Get the **12 V version** so it runs straight off the 3S battery, and check the listing's maximum voltage is at least 12.6 V. Otherwise use the 7.4 V version plus a 7.4 V buck converter rated 10 A or more.
- 1 × Waveshare bus-servo driver board (the one in the SO-101 BOM) plus a USB-C cable to the computer
- Not needed anymore: DS3218 and 2 × MG90S

## Drive motors
Use geared JGA25-370 12 V motors (130–170 rpm, 4 mm D-shaft). The free motors from the Hive are bare 380-size motors with no gearbox, so they spin far too fast to drive wheels on their own (see chat).

## Assembly
1. Base: motors, wheels, casters.
2. SO-101: build it per its guide, then bolt it on with 4 × M3 × 25 from above, nuts below.
3. Electronics in the torso, then the torso and back door.
4. Bin onto its pegs.

## Safety
In software, keep the arm from swinging back into the torso (anything behind the arm's base).
