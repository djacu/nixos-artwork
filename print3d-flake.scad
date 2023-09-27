use <parametric-flake.scad>

params_top = [
    [ "gap", 0.1 ],
    [ "height", 2 ],
    [ "scale", 10 ],
    [ "thickness", 0.5 ],
    [ "colors", ["#5277C3", "#7EBAE4"]],
];

params_bottom = [
    [ "gap", 0 ],
    [ "height", 1.1 ],
    [ "scale", 10 ],
    [ "thickness", 0.5 ],
    [ "colors", ["#5277C3", "#7EBAE4"]],
];

union() {
    translate([0, 0, 1]) flake(params_top);
    flake(params_bottom);
}
