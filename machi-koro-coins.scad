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

coin_height = 2 * mm;
heads_height = 0.5 * mm;
tails_depth = 0.5 * mm;

ring_size = 2 * mm;

module Heads() {
  translate([0, 0, -pad_manifold]) {
    linear_extrude(height = heads_height + pad_manifold) {
      import("one.svg", center=true);
    }
    difference() {
      cylinder(h=heads_height, r=svg_size / 2, center=false);
      cylinder(
        h=heads_height + 2 * pad_manifold,
        r=svg_size/2 - ring_size, center=true);
    }
  }
}

module Tails() {
}

module OneCoin() { // `make` me
  Heads();
}

OneCoin();

