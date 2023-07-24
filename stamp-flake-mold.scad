use <flake-parametric.scad>

height = 2;
size = 25 * height;

mold_height = 6 * height;
mold_cutout_height = mold_height - 2 + 0.1;

params_flake = [
    [ "gap", 0.1 ],
    [ "height", 1.1 * height ],
    [ "scale", size ],
    [ "thickness", 0.25 ],
];

params_hex = [
    [ "height", mold_height ],
    [ "scale", 1.5 * size ],
];

params_cutout = [
    [ "height", mold_cutout_height ],
    [ "scale", 1.25 * size ],
];

params_handle_flake = [
    [ "gap", 0.1 ],
    [ "height", 2.1 * height ],
    [ "scale", size / 2 ],
    [ "thickness", 0.25 ],
];

if (true) {
difference() {
    difference() {
        inner_hex(params_hex);
        translate([0, 0, height]) flake(params_flake);
    }
    translate([0, 0, 2 * height]) inner_hex(params_cutout);
}
}

handle_top_size = 1.4 * size;
handle_top_height = 3 * size;
handle_top_offset = handle_top_height + handle_top_size / 2;
handle_mid_height = handle_top_height - mold_height + 2;
handle_mid_offset = handle_mid_height  / 2 + mold_height - 1;

if (true) {
union() {

    difference() {
        translate([0, 0, handle_top_offset])
            intersection() {
                cube(handle_top_size, center=true);
                sphere(size * 0.9, $fn=100);
            }
        translate([0, 0, handle_top_offset + handle_top_size / 2 - height * 2])
            flake(params_handle_flake);
    }

    difference() {
        translate([0, 0, handle_mid_offset])
        cylinder(h = handle_mid_height, r = size, center = true, $fn = 100);

        translate([0, 0, handle_mid_offset * 1.25])
        rotate_extrude(convexity = 10, $fn = 100)
        translate([handle_mid_height * 0.8, 0, 0])
        circle(r = handle_mid_height * 0.7, $fn = 100);
    }

    translate([0, 0, mold_height - 1])
    cylinder(h = 2 * height, r1 = 2 * height, r2 = 2 * height, center = true, $fn = 100);

    for (idx = [0 : 5]) {
        rotate([0, 0, idx * 60 - 18])
        translate([0.8 * size, 0, mold_height - 1])
        cylinder(h = 2 * height, r1 = 2 * height, r2 = 2 * height, center = true, $fn = 100);
    }
}
}
