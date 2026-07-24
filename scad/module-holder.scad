// ============================================================
// 调速器模组座 — 型腔 / 开窗 / 占位（Synairy ESC-Adaptor V02）
// 坐标：板心在原点，长边沿 X，元件面朝 +Z
// 螺丝：盒内穿过 PCB 锁入下半 Boss（上盖无外露螺孔）
// ============================================================
include <parameters.scad>

// ===== 分区：常量/配置 =====
MCAV_L = MODULE_LENGTH + MODULE_CLEARANCE * 2;
MCAV_W = MODULE_WIDTH  + MODULE_CLEARANCE * 2;

DISP_WIN_X = DISPLAY_SIZE_X + DISPLAY_WINDOW_GAP * 2;
DISP_WIN_Y = DISPLAY_SIZE_Y + DISPLAY_WINDOW_GAP * 2;

// ===== 分区：公开 API =====

module module_cavity_bottom() {
    depth = MODULE_PCB_THICK + 0.3;
    translate([0, 0, PCB_TOP_Z - depth / 2])
        cube([MCAV_L, MCAV_W, depth + 0.1], center = true);
}

// 上半：壳内元器件净空（电位器柱高 KNOB_CAVITY_H；数码管高度可调）
module module_cavity_top() {
    clearance_h = 2.0;
    translate([0, 0, PCB_TOP_Z + clearance_h / 2])
        cube([MCAV_L, MCAV_W, clearance_h + 0.1], center = true);

    // 数码管（DISPLAY_HEIGHT_ABOVE 可调，勿超过 KNOB_CAVITY_H）
    translate([DISPLAY_CENTER_X, DISPLAY_CENTER_Y,
               PCB_TOP_Z + DISPLAY_HEIGHT_ABOVE / 2])
        cube([DISPLAY_SIZE_X + 0.6, DISPLAY_SIZE_Y + 0.6,
              DISPLAY_HEIGHT_ABOVE + 0.2], center = true);

    // 电位器本体：占满罗马柱顶以上到顶盖内壁的 7.5mm 净高
    translate([KNOB_CENTER_X, KNOB_CENTER_Y, PCB_TOP_Z])
        cylinder(d = KNOB_BODY_DIAM + 0.8, h = KNOB_CAVITY_H + 0.2, $fn = 48);
}

// 上盖开窗：轴孔 + 数码窗 + 按键（贯穿至外壳顶）
module module_windows_top() {
    top_outer_z = BOX_HALF_INNER_H + WALL_THICKNESS + 0.2;
    cut_h = top_outer_z - PCB_TOP_Z + 0.4;

    translate([KNOB_CENTER_X, KNOB_CENTER_Y, PCB_TOP_Z - 0.2])
        cylinder(d = KNOB_WINDOW_DIAM, h = cut_h, $fn = 48);

    translate([DISPLAY_CENTER_X, DISPLAY_CENTER_Y,
               PCB_TOP_Z + cut_h / 2 - 0.2])
        cube([DISP_WIN_X, DISP_WIN_Y, cut_h], center = true);
}

module module_placeholder() {
    color("black")
    translate([0, 0, PCB_BOTTOM_Z + MODULE_PCB_THICK / 2])
        cube([MODULE_LENGTH, MODULE_WIDTH, MODULE_PCB_THICK], center = true);

    // 壳内电位器本体
    color("dimgray")
    translate([KNOB_CENTER_X, KNOB_CENTER_Y, PCB_TOP_Z])
        cylinder(d = KNOB_BODY_DIAM, h = KNOB_BODY_HEIGHT, $fn = 48);

    // 轴伸出上盖
    top_z = BOX_HALF_INNER_H + WALL_THICKNESS;
    color("silver")
    translate([KNOB_CENTER_X, KNOB_CENTER_Y, PCB_TOP_Z])
        cylinder(d = KNOB_SHAFT_DIAM - 0.2, h = top_z + 2, $fn = 24);

    // 壳外旋钮帽
    color("gold")
    translate([KNOB_CENTER_X, KNOB_CENTER_Y, top_z])
        cylinder(d = KNOB_CAP_DIAM, h = KNOB_CAP_HEIGHT, $fn = 48);

    color("dimgray")
    translate([DISPLAY_CENTER_X, DISPLAY_CENTER_Y,
               PCB_TOP_Z + DISPLAY_HEIGHT_ABOVE / 2])
        cube([DISPLAY_SIZE_X, DISPLAY_SIZE_Y, DISPLAY_HEIGHT_ABOVE],
             center = true);
}
