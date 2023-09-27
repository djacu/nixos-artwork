use <parametric-flake.scad>

params = [
    [ "gap", 0.1 ],
    [ "height", 1 ],
    [ "scale", 10 ],
    [ "thickness", 0.5 ],
];

union() {
    flake(params);
}
