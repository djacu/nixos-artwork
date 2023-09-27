use <parametric-flake.scad>

params = [
    [ "gap", 0.1 ],
    [ "height", 1 ],
    [ "scale", 10 ],
    [ "thickness", 0.5 ],
    [ "colors", ["#5277C3", "#7EBAE4"]],
];

scale = dict_get(params, "scale");

num = 5;
for (x=[-num:num], y=[-num:num]) {
    translate([x*scale*1.57 - y*scale/1.76, y*scale*1.48 - x*scale*0.25, 0])
    flake(params);
}
