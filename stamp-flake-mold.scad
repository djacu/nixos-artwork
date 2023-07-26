use <flake-parametric.scad>

resolution = 100;

height = 2;
size = 25 * height;

mold_height = 10 * height;
mold_cutout_height = mold_height - 2 + 0.1;

params_hex = [
    [ "height", mold_height ],
    [ "scale", 1.5 * size ],
];

params_flake_cutout = [
    [ "gap", 0.15 ],
    [ "height", 10 * height ],
    [ "scale", size ],
    [ "thickness", 0.25 ],
    [ "offset", 1 * height ],
];

params_hex_cutout = [
    [ "height", mold_cutout_height ],
    [ "scale", 1.25 * size ],
    [ "offset", 5 * height ],
];

params_handle_flake = [
    [ "gap", 0.1 ],
    [ "height", 2.1 * height ],
    [ "scale", size / 2 ],
    [ "thickness", 0.25 ],
];

if (false) {
difference() {
    difference() {
        inner_hex(params_hex);
        translate([0, 0, dict_get(params_flake_cutout, "offset")]) flake(params_flake_cutout);
    }
    translate([0, 0, dict_get(params_hex_cutout, "offset")]) inner_hex(params_hex_cutout);
}
}

handle_top_size = 1.4 * size;
handle_top_height = 3 * size;
handle_top_offset = handle_top_height + handle_top_size / 2;
handle_mid_height = handle_top_height - 4 * height + 2;
handle_mid_offset = handle_mid_height  / 2 + 4 * height - 1;

if (true) {
translate([4 * size, 0, 0])
union() {

    difference() {
        translate([0, 0, handle_top_offset])
            intersection() {
                cube(handle_top_size, center=true);
                sphere(size * 0.9, $fn=resolution);
            }
        translate([0, 0, handle_top_offset + handle_top_size / 2 - height * 2])
            flake(params_handle_flake);
    }

    difference() {
        translate([0, 0, handle_mid_offset])
        cylinder(h = handle_mid_height, r = size, center = true, $fn = resolution);

        translate([0, 0, handle_mid_offset * 1.25])
        rotate_extrude(convexity = 10, $fn = resolution)
        translate([handle_mid_height * 0.8, 0, 0])
        circle(r = handle_mid_height * 0.7, $fn = resolution);
    }

    translate([0, 0, 4 * height - 1])
    cylinder(h = 4 * height, r1 = 2 * height, r2 = 2 * height, center = true, $fn = resolution);

    for (idx = [0 : 5]) {
        rotate([0, 0, idx * 60 - 18])
        translate([0.8 * size, 0, 4 * height - 1])
        cylinder(h = 4 * height, r1 = 2 * height, r2 = 2 * height, center = true, $fn = resolution);
    }
}
}
