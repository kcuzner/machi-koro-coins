// Machi Koro Replacement Coints
// Material: SLA Resin
// Nozzle: 0.3mm
// Layer height: <0.21875mm


// We use various dimensions, depending on where I pulled them from (PCB CAD is inches, physical measurements are mm)
inches = 25.4;
mm = 1;
degrees = 1;

//Set up for higher resolution circles
$fn = 180;

//Variables

pad_manifold = 0.01 * mm; //padding for maintaining a manifold (avoiding zero-width shapes)

svg_size = 15 * mm;
svg_x_tweak = -1 * mm;
svg_y_tweak = 0 * mm;

coin_height = 2 * mm;
heads_height = 0.5 * mm;
tails_depth = 0.5 * mm;

ring_size = 2 * mm;

crown_bot_y = -6 * mm;
crown_bot_width = 7 * mm;
crown_top_y = 7 * mm;
crown_top_width = 10 * mm;

module Heads() {
  translate([0, 0, -pad_manifold]) {
    translate([svg_x_tweak, svg_y_tweak, 0]) {
      linear_extrude(height = heads_height + pad_manifold) {
        import("one.svg", center=true);
      }
    }
    difference() {
      cylinder(h=heads_height + pad_manifold, r=svg_size / 2, center=false);
      translate([0, 0, -pad_manifold]) {
        cylinder(
          h=heads_height + 3 * pad_manifold,
          r=svg_size/2 - ring_size, center=false);
      }
    }
  }
}

module Tails() {
  polygon(points = [[-crown_bot_width/2, crown_bot_y/2], [crown_bot_width/2, crown_bot_y/2],
    [crown_top_width/2, crown_top_y/2], [-crown_top_width/2, crown_top_y/2]]);
}

module OneCoin() { // `make` me
  Heads();
  Tails();
}

OneCoin();

