unit = [1, 0];
origin = [0, 0];


/*
    Returns a 2D rotation matrix given an angle.
*/
function rot2d(angle) = [
    [+cos(angle), -sin(angle)],
    [+sin(angle), +cos(angle)]
];


/*
    Calculates the points for a hexagon.
    Used to reference off of for creating the lambda.
*/
function inner_hex_points(data) = [
    for (angle = [0 : 60 : 300]) 
    dict_get(data, "scale") * rot2d(angle) * unit
];


/*
    Generates a hexagon solid.
    Used to intersect with the short lambda leg.
*/
module inner_hex(data) {
    polygon(inner_hex_points(data));
}


/*
    Calculates the points for making a lambda.
*/
function lambda_points(data) =
// lambda0 is the long leg and lambda1 is the short leg.
let (
    lambda0 = [
        inner_hex_points(data)[2]
        + dict_get(data, "thickness") * rot2d(60) * unit,
        inner_hex_points(data)[5]
        + dict_get(data, "thickness") * rot2d(0) * unit,
        inner_hex_points(data)[5]
        + dict_get(data, "thickness") * rot2d(180) * unit,
        inner_hex_points(data)[2]
        + dict_get(data, "thickness") * rot2d(240) * unit,
    ],
    lambda1 = [
        origin
        + dict_get(data, "thickness") * rot2d(60) * unit
        + dict_get(data, "thickness") * rot2d(120) * unit,
        origin
        + dict_get(data, "thickness") * rot2d(60) * unit
        + dict_get(data, "thickness") * rot2d(-60) * unit,
        inner_hex_points(data)[4]
        + dict_get(data, "thickness") * rot2d(0) * unit,
        inner_hex_points(data)[4]
        + dict_get(data, "thickness") * rot2d(180) * unit,
    ]
)
[lambda0, lambda1];


/*
    Calculates the points for making a gap between lambdas.
*/
function gap_points(data) = [
    inner_hex_points(data)[2]
    + dict_get(data, "thickness") * rot2d(60) * unit
    + dict_get(data, "gap") * rot2d(90) * unit,
    inner_hex_points(data)[2]
    + dict_get(data, "thickness") * rot2d(60) * unit
    + dict_get(data, "gap") * rot2d(-60) * unit,
    inner_hex_points(data)[2]
    + dict_get(data, "thickness") * rot2d(240) * unit
    + dict_get(data, "gap") * rot2d(-60) * unit,
    inner_hex_points(data)[2]
    + dict_get(data, "thickness") * rot2d(240) * unit
    + dict_get(data, "gap") * rot2d(180) * unit,
];


/*
    Generates a single lambda at the origin.
*/
module lambda(data) {
    linear_extrude(dict_get(data, "height"))
    union() {
        if (dict_get(data, "gap") == 0) {
            polygon(lambda_points(data)[0]);
        } else
        {
            difference() {
                polygon(lambda_points(data)[0]);
                polygon(gap_points(data));
            }
        }
        intersection() {
            polygon(lambda_points(data)[1]);
            inner_hex(data);
        }
    }
}


/*
    Generates a NixOS flake.
*/
module flake(data) {
    new_data = update_params(data);
    for (idx = [0 : 5]) {
        rotate([0, 0, idx * 60]) 
        translate(-lambda_points(new_data)[0][0])
        translate([-dict_get(new_data, "scale"), 0, 0])
        lambda(new_data);
    }
}


/*
    Returns the value from a associative array/dictionary type structure given some key.

    Values can be of any type.
    The dictionary must of be of the form:
    [
        [ "key0", <value0> ],
        [ "key1", <value1> ],
        ...
    ]
*/
function dict_get(dict, key) =
  dict[search([key], dict)[0]][1];


/*
    Updates the user parameters so the flake is unit size when `scale = 1`.
*/
function update_params(data) = let
    // factor was empirically found. It gives a flake that is circumscribed by the unit circle.
    (factor = 2.25) [
    [ "gap", dict_get(data, "scale") * dict_get(data, "gap") / factor ],
    [ "height", dict_get(data, "height") ],
    [ "scale", dict_get(data, "scale") / factor ],
    [ "thickness", dict_get(data, "scale") * dict_get(data, "thickness") / factor ],
];


/*
    The parameters for generating a NixOS flake.

    `gap` - The gap between lambdas.
    `height` - The z-height of the flake.
    `scale` - The radial (x,y) size of the flake.
    `thickness` - The thickness of the lambda legs.

    `scale` updates `gap` and `thcikness` so there is no need to compesate these values.
    A `gap` of 0 will leave no gap between the lambdas.
    A `gap` of 1 will remove the top portion of the long lambda leg until the point where the two lambda legs intersect.

    A `gap` of 0.05 to 0.1 is a good value for replicating the official NixOS flake.
    A `thickness` of 0.25 is a good value for replicating the official NixOS flake.
    OpenSCAD doesn't have a concept of units so use `scale` and `height` values in the desired ratio.
*/
params = [
    [ "gap", 0.05 ],
    [ "height", 1 ],
    [ "scale", 10 ],
    [ "thickness", 0.25 ],
];


flake(params);
