scale = 10;
thickness = 0.25;
height = 1;
origin = [0, 0];
gap = 0.005;
fudge = 0.01;

scaled_unit = scale * [1, 0];
scaled_gap = scale * gap;
fudge_scaled = scale * fudge;

function rot2d(angle) = [
    [+cos(angle), -sin(angle)],
    [+sin(angle), +cos(angle)]
];

inner_hex_points = [
    for (angle = [0 : 60 : 300]) 
    rot2d(angle) * scaled_unit
];

module inner_hex(height) {
    linear_extrude(height=height)
    polygon(inner_hex_points);
}


function lambda_points() =
let (
    lambda0 = [
        inner_hex_points[2]
        + thickness * rot2d(60) * scaled_unit,
        inner_hex_points[5]
        + thickness * rot2d(0) * scaled_unit,
        inner_hex_points[5]
        + thickness * rot2d(180) * scaled_unit,
        inner_hex_points[2]
        + thickness * rot2d(240) * scaled_unit,
    ],
    lambda1 = [
        origin
        + thickness * rot2d(60) * scaled_unit
        + thickness * rot2d(120) * scaled_unit,
        origin
        + thickness * rot2d(60) * scaled_unit
        + thickness * rot2d(-60) * scaled_unit,
        inner_hex_points[4]
        + thickness * rot2d(0) * scaled_unit,
        inner_hex_points[4]
        + thickness * rot2d(180) * scaled_unit,
    ]
)
[lambda0, lambda1];

function gap_points() = [
    inner_hex_points[2]
    + thickness * rot2d(60) * scaled_unit
    + fudge_scaled * rot2d(90) * scaled_unit,
    inner_hex_points[2]
    + thickness * rot2d(60) * scaled_unit
    + scaled_gap * rot2d(-60) * scaled_unit,
    inner_hex_points[2]
    + thickness * rot2d(240) * scaled_unit
    + scaled_gap * rot2d(-60) * scaled_unit,
    inner_hex_points[2]
    + thickness * rot2d(240) * scaled_unit
    + fudge_scaled * rot2d(180) * scaled_unit,
];


module lambda(height) {
    union() {
        if (gap == 0) {
            linear_extrude(height) polygon(lambda_points()[0]);
        } else
        {
            difference() {
                linear_extrude(height) polygon(lambda_points()[0]);
                linear_extrude(4, center=true) polygon(gap_points());
            }
        }
        intersection() {
            linear_extrude(height) polygon(lambda_points()[1]);
            inner_hex(height);
        }
    }
}

module circular_pattern(num) {
    for (idx = [0 : num - 1]) {
        rotate([0, 0, idx * 60]) 
        translate(-lambda_points()[0][0]) 
        translate([-scale, 0, 0]) 
        lambda(height);
    }
}

circular_pattern(6);

//difference(){
//    linear_extrude(1) color([0, 1, 0]) polygon(lambda_points()[0]);
//    linear_extrude(4, center=true) color([0, 1, 0]) polygon(gap_points());
//}