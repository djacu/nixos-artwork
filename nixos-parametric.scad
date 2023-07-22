unit = [1, 0];
origin = [0, 0];

function rot2d(angle) = [
    [+cos(angle), -sin(angle)],
    [+sin(angle), +cos(angle)]
];

function inner_hex_points(data) = [
    for (angle = [0 : 60 : 300]) 
    dict_get(data, "scale") * rot2d(angle) * unit
];

module inner_hex(data) {
    linear_extrude(dict_get(data, "height"))
    polygon(inner_hex_points(data));
}


function lambda_points(data) =
let (
    lambda0 = [
        inner_hex_points(data)[2]
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(60) * unit,
        inner_hex_points(data)[5]
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(0) * unit,
        inner_hex_points(data)[5]
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(180) * unit,
        inner_hex_points(data)[2]
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(240) * unit,
    ],
    lambda1 = [
        origin
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(60) * unit
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(120) * unit,
        origin
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(60) * unit
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(-60) * unit,
        inner_hex_points(data)[4]
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(0) * unit,
        inner_hex_points(data)[4]
        + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(180) * unit,
    ]
)
[lambda0, lambda1];

function gap_points(data) = [
    inner_hex_points(data)[2]
    + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(60) * unit
    + dict_get(data, "scale") * dict_get(data, "gap") * rot2d(90) * unit,
    inner_hex_points(data)[2]
    + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(60) * unit
    + dict_get(data, "scale") * dict_get(data, "gap") * rot2d(-60) * unit,
    inner_hex_points(data)[2]
    + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(240) * unit
    + dict_get(data, "scale") * dict_get(data, "gap") * rot2d(-60) * unit,
    inner_hex_points(data)[2]
    + dict_get(data, "scale") * dict_get(data, "thickness") * rot2d(240) * unit
    + dict_get(data, "scale") * dict_get(data, "gap") * rot2d(180) * unit,
];


module lambda(data) {
    union() {
        if (dict_get(data, "gap") == 0) {
            linear_extrude(dict_get(data, "height")) polygon(lambda_points(data)[0]);
        } else
        {
            difference() {
                linear_extrude(dict_get(data, "height")) polygon(lambda_points(data)[0]);
                linear_extrude(4 * dict_get(data, "height"), center=true) polygon(gap_points(data));
            }
        }
        intersection() {
            linear_extrude(dict_get(data, "height")) polygon(lambda_points(data)[1]);
            inner_hex(data);
        }
    }
}

module flake(data) {
    for (idx = [0 : 5]) {
        rotate([0, 0, idx * 60]) 
        translate(-lambda_points(data)[0][0]) 
        translate([-dict_get(data, "scale"), 0, 0]) 
        lambda(data);
    }
}

function dict_get(dict, key) =
  dict[search([key], dict)[0]][1];

params = [
    [ "scale", 10/2.25 ],
    [ "thickness", 0.25 ],
    [ "height", 1 ],
    [ "gap", 0.05 ],
];

flake(params);
