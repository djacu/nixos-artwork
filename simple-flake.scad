use <flake-parametric.scad>

params_top = [
    [ "gap", 0.075 ],
    [ "height", 2 ],
    [ "scale", 10 ],
    [ "thickness", 0.25 ],
];

params_bottom = [
    [ "gap", 0 ],
    [ "height", 1.1 ],
    [ "scale", 10 ],
    [ "thickness", 0.25 ],
];

union() {
    translate([0, 0, 1]) flake(params_top);
    flake(params_bottom);
}
