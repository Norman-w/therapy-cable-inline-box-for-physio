// ============================================================
// 电阻固定座 — 矩形电阻型腔 + 引脚通道 + 焊接凹槽
// 坐标：型腔中心在原点，电阻长边沿 X 轴
// ============================================================
include <parameters.scad>

// 电阻腔体尺寸（含间隙）
RCAV_W = RESISTOR_BODY_WIDTH  + RESISTOR_CLEARANCE;   // ~9.4
RCAV_H = RESISTOR_BODY_HEIGHT + RESISTOR_CLEARANCE;   // ~9.4
RCAV_L = RESISTOR_BODY_LENGTH + RESISTOR_CLEARANCE;   // ~22.4

// 焊接点凹槽
SOLDER_POCKET_DIAM = 4.5;
SOLDER_POCKET_DEPTH = 5.0;
SOLDER_X = RESISTOR_BODY_LENGTH / 2 + RESISTOR_LEAD_LENGTH / 2;

// 电阻型腔下半部分（在下半壳体中切除）
// depth: 型腔深度（从分型面向下）
module resistor_cavity_bottom(depth) {
    // 电阻体主腔
    translate([0, 0, -depth/2])
        cube([RCAV_L, RCAV_W, depth + 0.1], center = true);

    // 引脚通道（从电阻体两端延伸到焊接区）
    for (mx = [-1, 1]) {
        // 引脚槽
        translate([mx * (RCAV_L/2 + RESISTOR_LEAD_LENGTH/2), 0, -depth/2])
            cube([RESISTOR_LEAD_LENGTH + 0.4, RESISTOR_LEAD_DIAMETER + 0.6, depth + 0.1], center = true);

        // 焊接凹槽（圆柱形，更大空间容纳焊锡）
        translate([mx * (RCAV_L/2 + RESISTOR_LEAD_LENGTH - 1), 0, -depth/2])
            cylinder(d = SOLDER_POCKET_DIAM, h = depth + 0.1, center = true, $fn = 24);
    }
}

// 电阻型腔上半部分（在上半壳体中切除）
module resistor_cavity_top(depth) {
    // 电阻体上盖凹槽
    translate([0, 0, +depth/2])
        cube([RCAV_L, RCAV_W, depth + 0.1], center = true);

    // 引脚通道
    for (mx = [-1, 1]) {
        translate([mx * (RCAV_L/2 + RESISTOR_LEAD_LENGTH/2), 0, +depth/2])
            cube([RESISTOR_LEAD_LENGTH + 0.4, RESISTOR_LEAD_DIAMETER + 0.6, depth + 0.1], center = true);

        // 焊接凹槽
        translate([mx * (RCAV_L/2 + RESISTOR_LEAD_LENGTH - 1), 0, +depth/2])
            cylinder(d = SOLDER_POCKET_DIAM, h = depth + 0.1, center = true, $fn = 24);
    }
}

// 完整电阻型腔（调试用，居中于原点）
module resistor_cavity_full() {
    cube([RCAV_L, RCAV_W, RCAV_H], center = true);

    for (mx = [-1, 1]) {
        translate([mx * (RCAV_L/2 + RESISTOR_LEAD_LENGTH/2), 0, 0])
            cube([RESISTOR_LEAD_LENGTH + 0.4, RESISTOR_LEAD_DIAMETER + 0.6, RCAV_H], center = true);

        translate([mx * (RCAV_L/2 + RESISTOR_LEAD_LENGTH - 1), 0, 0])
            rotate([0, 90, 0])
                cylinder(d = SOLDER_POCKET_DIAM, h = SOLDER_POCKET_DEPTH, center = true, $fn = 24);
    }
}

// 电阻占位模型（调试可视化）
module resistor_placeholder() {
    color("beige")
        cube([RESISTOR_BODY_LENGTH, RESISTOR_BODY_WIDTH, RESISTOR_BODY_HEIGHT], center = true);

    color("silver")
    for (mx = [-1, 1]) {
        translate([mx * (RESISTOR_BODY_LENGTH/2 + RESISTOR_LEAD_LENGTH/2), 0, 0])
            rotate([0, 90, 0])
                cylinder(d = RESISTOR_LEAD_DIAMETER, h = RESISTOR_LEAD_LENGTH, center = true, $fn = 16);
    }
}
