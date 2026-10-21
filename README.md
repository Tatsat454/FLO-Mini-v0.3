Readme · MD
# FLO Mini 🧺🤖
 
A small, 3D-printed helper robot that picks clothes up off the floor and drops them in its bin. It's built to help older people around the house.
 
![FLO Mini v0.3 with the SO-101 arm](FLO_Mini_v0.3_SO101.png)
 
**Status: v0.3 prototype. The design is done; printing is next.**
 
| | |
|---|---|
| Size | 250 × 240 mm base, about 311 mm tall (no head yet) |
| Weight / payload | about 4 lb robot, 5 lb max in the bin |
| Arm | [SO-101](https://github.com/TheRobotStudio/SO-ARM100) follower arm (6 × Feetech STS3215, LeRobot-compatible) |
| Drive | 2 × JGA25-370 12 V geared motors, 80 mm wheels with TPU tires, 2 ball casters |
| Brain | Arduino + Cytron MDD3A now. Later an iPhone as camera, face and VLM brain |
| Power | 3S LiPo 2200 mAh |
| Printer | Bambu X1E (Georgia Tech Invention Studio). Every part fits a 256 mm bed |
| Cost | about $340 in parts (see the cost sheet) |
 
## Photos
 
| Assembled (from the print STLs) | Parts as they print |
|---|---|
| ![reassembled](stl_parts_reassembled.png) | ![parts](stl_parts_as_printed.png) |
 
| Front view | Other side |
|---|---|
| ![a](v03_a.png) | ![b](v03_b.png) |
 
*These are CAD renders. Photos of the real robot coming soon.*
 
## Files
 
- **FLO_Mini_v0.3_files.zip**: everything, so download and unzip it:
  - `1_KCL/`: the Zoo Design Studio model (open `main.kcl`). All sizes are in `parameters.kcl`
  - `2_STL/`: print-ready parts, already laid flat (see `2_STL/README.md` for quantity and material)
  - `3_Docs/`: build guide (PDF), 3D print plan (PDF), cost and print-plan spreadsheet, OpenSCAD source
- **FLO_Mini_Build_Guide.pdf**: the step-by-step build guide
## Print list
 
| Part | Qty | Material | Notes |
|---|---|---|---|
| base | 1 | PETG | plate on the bed, 4 walls / 25% |
| torso | 1 | PLA | roof on the bed |
| bin | 1 | PLA | open side up, supports from the build plate only |
| back_door | 1 | PLA | flat |
| wheel | 2 | PETG | flat |
| tire | 2 | TPU 95A | print slow |
| caster | 2 | PETG | flange down, 1 in steel ball |
| motor_strap | 4 | PETG | flat |
| SO-101 follower | 1 set | PLA | from [TheRobotStudio/SO-ARM100](https://github.com/TheRobotStudio/SO-ARM100) |
 
About 1.5 kg of filament and 38 print hours in total. **Print 1 motor strap and 1 wheel first** to check the fit.
 
## Roadmap
 
1. ✅ Design: CAD of every functional part
2. ⬜ Build + drive: print, assemble, drive by remote
3. ⬜ Arm control: SO-101 running in LeRobot
4. ⬜ Eyes + brain: iPhone as camera and a googly-eyes face
5. ⬜ Find + pick clothes: a VLM spots clothes, the robot drives over and picks them up
6. ⬜ Follow mode + cute shell. V2 gets a heavier build and a PAROL6-style arm
Full steps are in [FLO_Mini_Build_Guide.pdf](FLO_Mini_Build_Guide.pdf).
 
## Credits
 
- SO-101 arm: [TheRobotStudio](https://github.com/TheRobotStudio/SO-ARM100) (Apache-2.0)
- Robot control: [Hugging Face LeRobot](https://github.com/huggingface/lerobot)
- CAD: [Zoo Design Studio](https://zoo.dev) (KCL)
 
