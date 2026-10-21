# 2_STL: print-ready parts (v0.3)
Laid flat, mm units, all fit a 256 mm bed. Same geometry as the KCL model.

| File | Print qty | Material | From KCL |
|---|---|---|---|
| base.stl | 1 | PETG | base.kcl |
| wheel.stl | 2 | PETG | drive.kcl |
| tire.stl | 2 | TPU 95A | drive.kcl |
| motor_strap.stl | 4 | PETG | drive.kcl |
| caster.stl | 2 | PETG | drive.kcl |
| bin.stl | 1 | PLA | body.kcl |
| torso.stl | 1 | PLA | body.kcl |
| back_door.stl | 1 | PLA | body.kcl |

SO-101 arm parts are not here: print the follower from https://github.com/TheRobotStudio/SO-ARM100 (STL/SO101/Follower).

## Why these look different from Zoo
Zoo shows the robot put together. These files are single parts, each turned to the position it prints in:
- base: plate on the bed, clamp blocks pointing up
- torso: upside down (roof on the bed)
- caster: flange on the bed
- wheel, tire, back_door, motor_strap: flat
- bin: open side up. Turn on supports (build plate only), because the floor sits 5 mm up on its 4 pegs.

Motors and the SO-101 arm are not printed parts, so they aren't here.
To see these exact STLs put back together, open 3_Docs/source/FLO_Mini_assembled_view.stl (view only, don't print it),
or look at 3_Docs/images/stl_parts_reassembled.png.
