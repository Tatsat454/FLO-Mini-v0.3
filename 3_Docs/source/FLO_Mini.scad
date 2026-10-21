// =====================================================================
//  FLO Mini  —  v0.1 concept CAD  (laundry-helper robot, ~21 in tall)
//  Units: mm.   Axes: +X forward, +Y left, +Z up.  Origin = floor, between wheels.
//
//  Design targets
//   * Payload: max 5 lb (2.3 kg) in the bin.  Robot itself ~4.5 lb.
//   * Every part fits a 256 x 256 x 256 mm bed (Bambu X1E at GT Invention Studio).
//   * Brain/face/camera: iPhone 14 Pro Max (160.7 x 77.6 x 7.85) in the head.
//   * Muscles: Arduino + 2x JGA25-370 gear motors (25 mm body, 4 mm D shaft)
//              + DS3218 shoulder servo + 2x MG90S (wrist, gripper).
//
//  Render one part:   openscad -D 'part="base"' -o base.stl FLO_Mini.scad
//  Parts: base, wheel, tire, motor_strap, caster, tower, arm, claw_plate,
//         jaw_left, jaw_right, bin, torso, back_door, neck, head, sprout, assembly
//
//  !! Concept geometry. Measure YOUR motors, servos and horns before printing
//  !! and adjust the parameters below. Not a certified lifting device.
// =====================================================================

part = "assembly";
$fn = 48;
eps = 0.01;

// ---------- global layout ----------
base_w   = 240;   // Y
base_d   = 250;   // X
base_t   = 6;
base_z   = 55;    // underside of base plate
base_top = base_z + base_t;          // 61
base_r   = 30;

wheel_d  = 80;  wheel_w = 24;  axle_z = wheel_d/2;
wheel_y  = base_w/2 + 6 + wheel_w/2; // 138

motor_d  = 25.4;                     // clearance for 25 mm motor body
clamp_y  = [62, 104];                // clamp block centres (each side)

caster_x = [100, -100];
ball_d   = 25.4;                     // 1 in steel ball / marble

// bin (front-centre, catches what the claw drops)
// bin now sits front-LEFT, beside the SO-101 arm (v0.3)
bin_x0 = -28; bin_x1 = 90; bin_y0 = 8; bin_y1 = 114; bin_h = 150; bin_wall = 2.4;
bin_pegs = [[bin_x0+10, bin_y0+10], [bin_x1-10, bin_y0+10], [bin_x0+10, bin_y1-10], [bin_x1-10, bin_y1-10]];

// SO-101 arm (TheRobotStudio, Apache-2.0) bolted front-RIGHT with 4 x M3 (same holes LeKiwi uses).
// so_x0/so_y0 = where the arm's own origin lands on the FLO plate; arm faces +X (forward).
so_x0 = 88; so_y0 = -62;
so_holes_arm = [[31.8, 45.8], [-31.8, 45.8], [27.8, -24.0], [-27.8, -24.0]];   // in the SO-101 frame
function so_to_flo(p) = [so_x0 - p[1], so_y0 + p[0]];

// torso (rear)
torso_x0 = -122; torso_x1 = -32; torso_wy = 180; torso_h = 250; wall = 2.4;
torso_tab_x = [torso_x0+14, torso_x1-14]; torso_tab_y = 74;   // tucked into the rounded corners
torso_top = base_top + torso_h;      // 311

// shoulder tower + arm
sh_x = 95; sh_z = 190;               // shoulder axis (servo shaft) position
tower_x0 = 75; tower_x1 = 115; tower_y0 = -50; tower_y1 = -16.5;
arm_L   = 170;                       // shoulder -> wrist
arm_t   = 6;
arm_y0  = -1;                        // arm plate occupies y = -1 .. 5
// poses (deg, + = up from horizontal)
pose_down = -38.6;   // claw tips on floor
pose_up   = 116;     // claw over bin

// head
head_tilt = 28;                      // look-down angle (camera must see floor)
neck_h    = 40;
phone     = [160.7, 77.6, 7.85];     // iPhone 14 Pro Max (W x H x T, landscape)

// ---------- servo / motor reference dims ----------
ds3218   = [40.0, 20.0, 40.5];       // L x W x H, flange plane 28 from bottom
ds_flange_len = 54.5; ds_hole_sp = 49.5;
mg90s    = [22.8, 12.2, 22.5];       // flange plane ~16 from bottom
mg_flange_len = 32.5; mg_hole_sp = 27.7; mg_shaft_off = 5.9;

// =====================================================================
//  helpers
// =====================================================================
module rbox(s, r) {               // rounded box, corner at origin
  r2 = min(r, min(s[0],s[1],s[2])/2 - eps);
  hull() for (x=[r2,s[0]-r2], y=[r2,s[1]-r2], z=[r2,s[2]-r2])
    translate([x,y,z]) sphere(r=r2, $fn=24);
}
module rrect(s, r) {              // 2D rounded rectangle centred
  offset(r) square([s[0]-2*r, s[1]-2*r], center=true);
}
module m3(h=40) cylinder(d=3.3, h=h, center=true, $fn=16);

// =====================================================================
//  BASE PLATE  (prints flat, 240 x 250)
// =====================================================================
module base() {
  difference() {
    union() {
      translate([0,0,base_z]) linear_extrude(base_t) rrect([base_d, base_w], base_r);
      // motor clamp blocks: stop 1 mm above the motor axis so the strap can squeeze
      for (s=[-1,1], cy=clamp_y)
        translate([-24, s*cy-6, axle_z+1]) cube([48, 12, base_z-axle_z-1+eps]);
    }
    // motor saddles
    for (s=[-1,1]) translate([0, s*(48+118)/2, axle_z])
      rotate([90,0,0]) cylinder(d=motor_d, h=72, center=true);
    // clamp bolts
    for (s=[-1,1], cy=clamp_y, x=[-19,19]) translate([x, s*cy, base_z]) m3(60);
    // caster bolts
    for (cx=caster_x, a=[90,210,330]) translate([cx+24*cos(a), 24*sin(a), base_z]) m3();
    // torso tabs
    for (x=torso_tab_x, y=[-torso_tab_y,torso_tab_y]) translate([x,y,base_z]) m3();
    // bin locating pegs
    for (p=bin_pegs) translate([p[0],p[1],base_z]) cylinder(d=6.5,h=40,center=true);
    // SO-101 arm base bolts
    for (h=so_holes_arm) let(q=so_to_flo(h)) translate([q[0],q[1],base_z]) m3();
    // wire pass-throughs (inside torso footprint)
    for (y=[-40,40]) translate([-45,y,base_z]) cylinder(d=14,h=40,center=true);
    // battery strap slots
    for (x=[-65,-40]) translate([x,0,base_z]) cube([4,60,40],center=true);
    // weight-saving windows under the bin (keep away from clamps / pegs)
    // weight-saving window under the bin only (the right side carries the SO-101 bolts)
    translate([22,40,base_z]) linear_extrude(40,center=true) rrect([60,30],8);
  }
}

module motor_strap() {          // prints flat; bolts up into clamp block
  difference() {
    union() {
      intersection() {
        rotate([90,0,0]) cylinder(r=motor_d/2+4, h=12, center=true);
        translate([-50,-10,-50]) cube([100,20,50]);
      }
      translate([-24,-6,-4]) cube([48,12,4]);
    }
    rotate([90,0,0]) cylinder(d=motor_d, h=20, center=true);
    for (x=[-19,19]) translate([x,0,0]) m3();
  }
}

// =====================================================================
//  WHEEL + TPU TIRE
// =====================================================================
module wheel() {                 // axis = Z for printing
  rim_d = wheel_d - 6;           // 74
  difference() {
    union() {
      cylinder(d=rim_d, h=wheel_w);
      for (z=[0, wheel_w-2]) translate([0,0,z]) cylinder(d=rim_d+4, h=2);
      cylinder(d=16, h=wheel_w+8);              // hub boss (motor side)
    }
    // spoke windows
    for (a=[0:60:300]) rotate(a) translate([22,0,-1]) cylinder(d=18, h=wheel_w+2);
    // 4 mm D-shaft
    translate([0,0,-1]) intersection() {
      cylinder(d=4.2, h=wheel_w+10, $fn=24);
      translate([-2.1,-1.6,0]) cube([4.2,4.2,wheel_w+10]);
    }
    // set screw + nut trap
    translate([0,0,wheel_w+4]) rotate([-90,0,0]) { cylinder(d=3.3,h=10); translate([0,0,4]) rotate(30) cylinder(d=6.4,h=2.6,$fn=6); }
  }
}
module tire() {                  // print in TPU
  difference() { cylinder(d=wheel_d+2, h=wheel_w-4); translate([0,0,-1]) cylinder(d=wheel_d-6.4, h=wheel_w); }
}

// =====================================================================
//  CASTER (snap a 1" steel ball / marble in; prints upside-down)
// =====================================================================
module caster() {
  h = base_z - 8;                // from z=8 up to plate
  difference() {
    union() {
      cylinder(d=36, h=h);
      translate([0,0,h-4]) cylinder(d=60, h=4);
    }
    translate([0,0,ball_d/2-8+0]) sphere(d=ball_d+0.8);
    translate([0,0,-1]) cylinder(d=23.6, h=3);
    for (a=[0:90:270]) rotate(a) translate([-0.75,0,-1]) cube([1.5,20,10]);   // flex slits
    for (a=[90,210,330]) translate([24*cos(a),24*sin(a),h]) m3(12);
    translate([0,0,ball_d/2+4]) cylinder(d=20, h=h);                          // grease/lighten
  }
}

// =====================================================================
//  SHOULDER TOWER  (DS3218 slides in from the inner face, shaft -> +Y)
// =====================================================================
module tower() {
  sy = -4 - (ds3218[2]-28);      // flange seat face  (y = -16.5)
  difference() {
    union() {
      translate([tower_x0, tower_y0, base_top]) cube([tower_x1-tower_x0, sy-tower_y0, sh_z+25-base_top]);
      // bolt feet
      translate([tower_x0, -62, base_top]) cube([tower_x1-tower_x0, 58, 5]);
    }
    // servo body pocket
    translate([sh_x-ds3218[1]/2-0.2, sy-30, sh_z-30.2]) cube([ds3218[1]+0.4, 31, ds3218[0]+0.4]);
    // flange screw holes
    for (z=[sh_z-10-ds_hole_sp/2, sh_z-10+ds_hole_sp/2], x=[sh_x-5, sh_x+5])
      translate([x, sy, z]) rotate([90,0,0]) cylinder(d=2.8, h=16, center=true);
    // cable exit
    translate([sh_x, tower_y0, base_top+25]) rotate([90,0,0]) cylinder(d=10,h=20,center=true);
    // feet bolts
    for (x=[85,105], y=[-56,-10.5]) translate([x,y,base_top]) m3();
    // lighten
    translate([sh_x, (tower_y0+sy)/2, base_top+45]) cube([24, 20, 50], center=true);
  }
}

// =====================================================================
//  ARM  (in its own frame: shoulder at origin, wrist at +X, plate y=0..6)
// =====================================================================
module arm() {
  wx = arm_L;
  mg_body_x0 = wx + mg_shaft_off - mg90s[0];
  difference() {
    hull() {
      rotate([-90,0,0]) cylinder(r=16, h=arm_t);
      translate([wx,0,0]) rotate([-90,0,0]) cylinder(r=17, h=arm_t);
    }
    // DS3218 horn: centre + 4 x M3 (drill to match your horn)
    rotate([-90,0,0]) cylinder(d=9, h=30, center=true);
    for (a=[0:90:270]) rotate([0,a,0]) translate([7,0,0]) rotate([-90,0,0]) cylinder(d=2.5,h=30,center=true);
    // lightening slots
    for (x=[45, 95]) translate([x,0,0]) rotate([-90,0,0]) linear_extrude(30,center=true) rrect([38,14],7);
    // wrist servo (MG90S) through-pocket + flange holes
    translate([mg_body_x0-0.2, -1, -mg90s[1]/2-0.2]) cube([mg90s[0]+0.4, 10, mg90s[1]+0.4]);
    for (dx=[-mg_hole_sp/2, mg_hole_sp/2]) translate([mg_body_x0+mg90s[0]/2+dx, 0, 0]) rotate([-90,0,0]) cylinder(d=2,h=30,center=true);
  }
}

// =====================================================================
//  CLAW  (own frame: wrist axis at origin, jaws point -Z, plate normal = Y)
//   claw_plate y = 26..29 ; grip MG90S body hangs toward -Y (to y~13)
//   spacer block y = 10..26 bolts to the wrist servo horn
// =====================================================================
gear_r = 12;  piv = [[-12,-30],[12,-30]];
jaw_y = 39.5;   // jaws sit in front of the MG90S horn (flange on plate face y=29, horn top ~y39)
module gear2d(phase=0) {
  n = 12;
  difference() {
    union() {
      circle(r=gear_r-2.5);
      for (i=[0:n-1]) rotate(i*360/n + phase)
        polygon([[gear_r-2.6,-2.2],[gear_r+2,-1.1],[gear_r+2,1.1],[gear_r-2.6,2.2]]);
    }
    circle(d=3.4, $fn=16);
  }
}
module finger2d(s=1) {            // s=-1 left, +1 right (left built, right mirrored)
  hull() { circle(r=7); translate([-5,-26]) circle(r=4.5); }
  hull() { translate([-5,-26]) circle(r=4.5); translate([9,-50]) circle(r=3.5); }
}
module jaw(side="left") {
  p = side=="left" ? piv[0] : piv[1];
  translate([p[0], 6, p[1]]) rotate([90,0,0]) linear_extrude(6) {
    intersection() {                          // only teeth facing the other jaw
      gear2d(side=="left" ? 0 : 15);
      rotate(side=="left" ? 0 : 180) translate([0,-20]) square([20,40]);
    }
    if (side=="left") finger2d(); else mirror([1,0]) finger2d();
  }
}
module jaw_cut(side="left") {     // jaw + its holes
  p = side=="left" ? piv[0] : piv[1];
  difference() {
    jaw(side);
    translate([p[0], 3, p[1]]) rotate([90,0,0]) {
      if (side=="left") {
        cylinder(d=5.2, h=20, center=true);                         // horn screw access
        for (r=[8.5, 12]) translate([-0.25*r, -r, 0]) cylinder(d=1.6, h=20, center=true); // horn arm screws
      } else cylinder(d=3.4, h=20, center=true);                    // M3 pivot bolt
    }
  }
}
module claw_plate() {
  difference() {
    union() {
      translate([-28, 26, -42]) cube([56, 3, 54]);              // main plate
      translate([-10, 16, -2]) cube([20, 10.01, 14]);           // spacer: wrist horn top is ~y16
      translate([piv[1][0], 28.9, piv[1][1]]) rotate([-90,0,0]) cylinder(d=9, h=jaw_y-28.9); // idler standoff
    }
    // wrist horn screws
    for (x=[-5,5]) translate([x, 0, 5]) rotate([-90,0,0]) cylinder(d=2,h=60,center=true);
    // grip servo (MG90S) shaft at left pivot, body toward +X
    bx0 = piv[0][0] - mg_shaft_off;
    translate([bx0-0.2, 20, piv[0][1]-mg90s[1]/2-0.2]) cube([mg90s[0]+0.4, 12, mg90s[1]+0.4]);
    for (dx=[-mg_hole_sp/2, mg_hole_sp/2]) translate([bx0+mg90s[0]/2+dx, 26, piv[0][1]]) rotate([-90,0,0]) cylinder(d=2,h=12,center=true);
    // idler pivot (M3 shoulder bolt)
    translate([piv[1][0], 26, piv[1][1]]) rotate([-90,0,0]) cylinder(d=3.3,h=40,center=true);
  }
}
module claw_assembly(open=20) {
  color("WhiteSmoke") claw_plate();
  color("Turquoise") translate([0,jaw_y,0]) {
    translate([piv[0][0],0,piv[0][1]]) rotate([0,-open,0]) translate([-piv[0][0],0,-piv[0][1]]) jaw_cut("left");
    translate([piv[1][0],0,piv[1][1]]) rotate([0, open,0]) translate([-piv[1][0],0,-piv[1][1]]) jaw_cut("right");
  }
  color("DimGray") translate([piv[0][0]-mg_shaft_off, 13, piv[0][1]-mg90s[1]/2]) cube([mg90s[0], 22.5, mg90s[1]]);
}

// =====================================================================
//  BIN  (open top, 100 x 180 x 128, ~2.1 L)
// =====================================================================
module bin() {
  L = bin_x1-bin_x0; W = bin_y1-bin_y0;
  difference() {
    union() {
      translate([bin_x0, bin_y0, base_top]) rbox([L, W, bin_h+10], 10);
      for (p=bin_pegs) translate([p[0],p[1],base_top-5]) cylinder(d=6, h=5.5);
    }
    translate([bin_x0+bin_wall, bin_y0+bin_wall, base_top+3]) rbox([L-2*bin_wall, W-2*bin_wall, bin_h+20], 8);
    translate([bin_x0-5, bin_y0-5, base_top+bin_h]) cube([L+10, W+10, 20]);   // flat top rim
    // finger holes front and back for carrying
    for (x=[bin_x0, bin_x1]) translate([x, (bin_y0+bin_y1)/2, base_top+bin_h-18]) rotate([0,90,0]) linear_extrude(10,center=true) rrect([16,50],7);
  }
}
module so101_ref() {   // reference only: the SO-101 assembly STL in its default pose
  translate([so_x0, so_y0, base_top-0.4]) rotate([0,0,90]) import("so101_assembly_ref.stl");
}

// =====================================================================
//  TORSO SHELL  (open bottom, rear door)  90 x 180 x 250
// =====================================================================
module torso() {
  L = torso_x1-torso_x0;
  difference() {
    union() {
      difference() {
        translate([torso_x0, -torso_wy/2, base_top]) rbox([L, torso_wy, torso_h+20], 22);
        translate([torso_x0-1, -torso_wy, base_top-30]) cube([L+2, 2*torso_wy, 30]);   // flat bottom
        translate([torso_x0-1, -torso_wy, torso_top]) cube([L+2, 2*torso_wy, 40]);     // flat top
        translate([torso_x0+wall, -torso_wy/2+wall, base_top-1]) rbox([L-2*wall, torso_wy-2*wall, torso_h-wall+1], 20);
      }
      // bottom bolt tabs
      for (x=torso_tab_x, y=[-torso_tab_y,torso_tab_y]) translate([x-8,y-8,base_top]) cube([16,16,4]);
      // neck boss on the inside of the top
      translate([(torso_x0+torso_x1)/2, 0, torso_top-6]) cylinder(d=64, h=6);
    }
    for (x=torso_tab_x, y=[-torso_tab_y,torso_tab_y]) translate([x,y,base_top]) m3();
    // neck cable hole + bolts
    translate([(torso_x0+torso_x1)/2, 0, torso_top]) { cylinder(d=22,h=30,center=true);
      for (a=[0,120,240]) rotate(a) translate([26,0,0]) m3(); }
    // pilot holes for the back door screws
    for (y=[-60,60], z=[base_top+14, base_top+186]) translate([torso_x0, y, z]) rotate([0,90,0]) cylinder(d=2.5,h=10,center=true);
    // rear service door opening
    translate([torso_x0, 0, base_top+20+80]) cube([20, 130, 160], center=true);
    // front cable hole (arm servo) + vents
    translate([torso_x1, -30, base_top+20]) rotate([0,90,0]) cylinder(d=12,h=20,center=true);
    for (z=[base_top+150 : 14 : base_top+210]) translate([torso_x1, 0, z]) cube([20, 90, 5], center=true);
    // power switch hole (16 mm) on the side
    translate([(torso_x0+torso_x1)/2, torso_wy/2, base_top+40]) rotate([90,0,0]) cylinder(d=16,h=20,center=true);
  }
}
module back_door() {             // snap/screw-on rear cover, prints flat
  difference() {
    translate([-3,-70,0]) cube([3,140,180]);
    for (y=[-60,60], z=[4,176]) translate([-1,y,z]) rotate([0,90,0]) cylinder(d=3.3,h=10,center=true);
  }
}

// =====================================================================
//  NECK  (top face tilted = head_tilt)
// =====================================================================
module neck() {
  difference() {
    union() {
      cylinder(d=50, h=4);
      cylinder(d=34, h=neck_h);
      translate([0,0,neck_h]) rotate([0,head_tilt,0]) translate([0,0,-4]) cylinder(d=46, h=6);
    }
    translate([0,0,neck_h]) rotate([0,head_tilt,0]) translate([0,0,2]) cylinder(d=100,h=40);  // flatten top
    translate([0,0,-1]) cylinder(d=20, h=neck_h+20);
    for (a=[0,120,240]) rotate(a) translate([19,0,0]) m3(12);
    translate([0,0,neck_h]) rotate([0,head_tilt,0]) for (a=[60,180,300]) rotate(a) translate([16,0,0]) m3(20);
  }
}

// =====================================================================
//  HEAD  (local frame: face toward +X, centre at origin; mounts on neck)
//   iPhone 14 Pro Max slides in from the top, landscape, screen out.
// =====================================================================
hd = [72, 206, 132];             // depth, width, height
module head() {
  slot = [phone[2]+0.9, phone[0]+1.8, phone[1]+1.8];   // 8.75 x 162.5 x 79.4
  front_wall = 2.6;
  sx = hd[0]/2 - front_wall - slot[0];                   // slot back face
  difference() {
    union() {
      translate(-hd/2) rbox(hd, 30);
      // cute ear pods
      for (s=[-1,1]) translate([-4, s*(hd[1]/2-2), 6]) scale([1,0.55,1]) sphere(r=20);
    }
    // hollow interior
    translate(-hd/2 + [3,3,3]) rbox(hd - [6,6,6], 27);
    // phone slot (open to the top for insertion)
    translate([sx, -slot[1]/2, -slot[2]/2]) cube([slot[0], slot[1], hd[2]]);
    // screen window (front) and camera-bump window (back), both 3 mm lips
    translate([hd[0]/2-front_wall-1, 0, 0]) rotate([0,90,0]) linear_extrude(10) rrect([phone[1]-6, phone[0]-6], 9);
    translate([sx-6, 0, 0]) rotate([0,90,0]) linear_extrude(7) rrect([phone[1]-5, phone[0]-5], 9);
    // charging cable slot (either end)
    for (s=[-1,1]) translate([sx+slot[0]/2, s*hd[1]/2, 0]) cube([6, 30, 14], center=true);
    // sprout socket
    translate([0,0,hd[2]/2-10]) cylinder(d=6.3, h=20);
    // neck mount bolts + cable hole
    translate([-8,0,-hd[2]/2]) { cylinder(d=18, h=20, center=true);
      for (a=[60,180,300]) rotate(a) translate([16,0,0]) m3(30); }
  }
  // neck mounting pad inside the bottom
  translate([-8,0,-hd[2]/2+2]) difference() {
    cylinder(d=46, h=6);
    translate([0,0,-1]) cylinder(d=18,h=10);
    for (a=[60,180,300]) rotate(a) translate([16,0,0]) m3(30);
  }
}
module sprout() {
  cylinder(d=6, h=8);                       // peg
  translate([0,0,8]) cylinder(d=9, h=34);
  translate([0,0,40]) {
    rotate([0,-35,0]) translate([0,0,16]) scale([0.45,1.0,1.6]) rotate([90,0,0]) cylinder(r=11,h=3,center=true);
    rotate([0, 35,0]) translate([0,0,13]) scale([0.45,1.0,1.4]) rotate([90,0,0]) cylinder(r=10,h=3,center=true);
  }
}

// =====================================================================
//  ASSEMBLY / PREVIEW
// =====================================================================
function wrist(a) = [sh_x + arm_L*cos(a), sh_z + arm_L*sin(a)];

module place_wheels() {
  for (s=[-1,1]) translate([0, s*wheel_y, axle_z]) rotate([s*90,0,0]) translate([0,0,-wheel_w/2]) {
    color("WhiteSmoke") wheel(); color("DimGray") tire();
  }
}
module motors() {
  color("Silver") for (s=[-1,1]) translate([0, s*83, axle_z]) rotate([90,0,0]) cylinder(d=25, h=70, center=true);
}
module arm_pose(a, claw_open=15) {
  translate([sh_x, arm_y0, sh_z]) rotate([0,-a,0]) {
    color("WhiteSmoke") arm();
    // claw stays pointing down: counter-rotate at wrist
    translate([arm_L,0,0]) rotate([0, a, 0]) claw_assembly(claw_open);
  }
}
module head_placed() {
  nx = (torso_x0+torso_x1)/2;
  translate([nx, 0, torso_top]) {
    color("WhiteSmoke") neck();
    translate([0,0,neck_h]) rotate([0,head_tilt,0]) translate([8, 0, hd[2]/2+2]) {
      color("WhiteSmoke") head();
      // phone + eyes
      translate([hd[0]/2-2.6-phone[2]-0.45, -phone[0]/2, -phone[1]/2]) color("Black") cube([phone[2], phone[0], phone[1]]);
      for (s=[-1,1]) translate([hd[0]/2-2.0, s*32, 6]) rotate([0,90,0]) {
        color("White") cylinder(d=30, h=0.8); color("Black") translate([4,0,0.8]) cylinder(d=13, h=0.8); }
      color("Turquoise") translate([hd[0]/2-2.0, 0, -18]) rotate([0,90,0]) scale([0.45,1,1]) difference(){ cylinder(d=26,h=0.8); translate([-14,-14,-1]) cube([14,28,3]); }
      color("LimeGreen") translate([0,0,hd[2]/2-10]) sprout();
    }
  }
}
module assembly(a=pose_down) {
  color("WhiteSmoke") base();
  for (s=[-1,1], cy=clamp_y) color("Gainsboro") translate([0, s*cy, axle_z]) motor_strap();
  motors();
  place_wheels();
  for (cx=caster_x) translate([cx,0,8]) { color("Gainsboro") caster(); color("Silver") translate([0,0,ball_d/2-8]) sphere(d=ball_d); }
  color("Turquoise", 0.92) bin();
  color("WhiteSmoke") torso();
  color("Turquoise") translate([torso_x0-0.1, 0, base_top+10]) back_door();
  color("SteelBlue") so101_ref();
}

// =====================================================================
//  PART SELECTOR (each part placed flat / printable)
// =====================================================================
if      (part=="base")        rotate([180,0,0]) base();  // plate on the bed, clamp blocks up
else if (part=="motor_strap") rotate([180,0,0]) motor_strap();
else if (part=="wheel")       wheel();
else if (part=="tire")        tire();
else if (part=="caster")      rotate([180,0,0]) caster();
else if (part=="tower")       translate([0,0,-base_top]) tower();
else if (part=="arm")         rotate([90,0,0]) arm();
else if (part=="claw_plate")  rotate([-90,0,0]) translate([0,-26,0]) claw_plate();
else if (part=="jaw_left")    rotate([-90,0,0]) jaw_cut("left");
else if (part=="jaw_right")   rotate([-90,0,0]) jaw_cut("right");
else if (part=="bin")         translate([0,0,-base_top+5]) bin();
else if (part=="so101")       so101_ref();
else if (part=="torso")       rotate([180,0,0]) translate([0,0,-torso_top]) torso();
else if (part=="back_door")   rotate([0,-90,0]) back_door();
else if (part=="neck")        neck();
else if (part=="head")        rotate([0,-90,0]) head();
else if (part=="sprout")      sprout();
else if (part=="assembly_up") assembly(pose_up);
else                          assembly(pose_down);
