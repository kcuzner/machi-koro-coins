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

ring_size = 1 * mm;

crown_bot_y = -7 * mm;
crown_bot_width = 7 * mm;
crown_top_y = 7 * mm;
crown_top_width = 9 * mm;

star_inner_size = 0.3 * mm;
star_outer_size = 0.75 * mm;

reeding_size = 0.5 * mm;

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

// borrowed in spirit from https://gist.github.com/anoved/9622826
// (the original had problems with degenerate triangles which results
// in an incomplete mesh)
module Star(points, inner, outer, height) {
  function x(r, a) = r * cos(a);
  function y(r, a) = r * sin(a);
  incr = 360 / points;
  linear_extrude(height=height) {
    points = [ for (p = [0 : points-1])
      each [[x(outer, incr * p), y(outer, incr * p)],
        [x(inner, incr * p + incr / 2), y(inner, incr * p + incr / 2)]]];
    polygon(points = points);
  }
}

module Tails() {
  translate([0, 0, -pad_manifold]) {
    linear_extrude(height=tails_depth+pad_manifold) {
      polygon(points = [
        // Bottom left
        [-crown_bot_width/2, crown_bot_y/2],
        // Bottom right
        [crown_bot_width/2, crown_bot_y/2],
        // Right point
        [crown_top_width/2, crown_top_y/3],
        // Right trench
        [crown_top_width/6, 0],
        // Center point
        [0, crown_top_y/2],
        // Left trench
        [-crown_top_width/6, 0],
        // Left point
        [-crown_top_width/2, crown_top_y/3]]);
    }
    translate([-crown_top_width/3, crown_top_y/2, 0]) {
      Star(points=7,
        inner=star_inner_size, outer=star_outer_size,
        height=tails_depth+pad_manifold);
    }
    translate([crown_top_width/3, crown_top_y/2, 0]) {
      Star(points=7,
        inner=star_inner_size, outer=star_outer_size,
        height=tails_depth+pad_manifold);
    }
  }
}

module Reeding(d, h, size) {
  circ = PI * d;
  count = round(circ / (size*1.375 ));
  incr = 360 / count;
  for (i = [0 : count-1]) {
    a = i * incr;
    rotate([0, 0, a]) {
      translate([d/2, 0, h/2]) {
        cylinder(h=h, d=size, center=true);
      }
    }
  }
}

module OneCoin() { // `make` me
  difference() {
    union() {
      translate([0, 0, coin_height - heads_height]) {
        Heads();
      }
      cylinder(h=coin_height - heads_height, d=svg_size);
    }
    Tails();
    translate([0, 0, -pad_manifold]) {
      Reeding(d=svg_size, h=coin_height+pad_manifold*2, size=reeding_size);
    }
  }
}

OneCoin();

