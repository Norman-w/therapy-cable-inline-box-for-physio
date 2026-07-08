// ============================================================
// 线缆锯齿压紧 — hull 梯形齿，水密可靠
// 上下齿尖间隙 4mm 压紧 5mm 线缆
// ============================================================
include <parameters.scad>

TOOTH_COUNT     = 3;
TOOTH_WIDTH_Y   = 8.0;   // 齿宽 Y向
TOOTH_BASE_X    = 4.0;   // 齿底宽 X向
TOOTH_TOP_X     = 1.5;   // 齿顶平台宽
TOOTH_GAP       = 4.0;   // 上下齿尖间隙
TOOTH_SPACING   = 4.0;   // 齿间距 X向
TOOTH_FIRST_X   = 2.0;   // 第一齿距内端面

module cable_clamp_teeth_bottom() {
    half_h = BOX_HALF_INNER_H;
    tooth_h = half_h - TOOTH_GAP/2;   // 7mm
    bw = TOOTH_BASE_X;
    tw = TOOTH_TOP_X;
    w  = TOOTH_WIDTH_Y;

    for (mx = [-1, 1]) {
        for (i = [0 : TOOTH_COUNT - 1]) {
            tx = BOX_INNER_LENGTH/2 - TOOTH_FIRST_X - i * TOOTH_SPACING;
            // 齿底在 Z=-9, 尖在 Z=-2
            translate([mx * tx, 0, -half_h])
                _tooth(bw, tw, tooth_h, w, mx < 0, invert = false);
        }
    }
}

module cable_clamp_teeth_top() {
    half_h = BOX_HALF_INNER_H;
    tooth_h = half_h - TOOTH_GAP/2;   // 7mm
    bw = TOOTH_BASE_X;
    tw = TOOTH_TOP_X;
    w  = TOOTH_WIDTH_Y;

    for (mx = [-1, 1]) {
        for (i = [0 : TOOTH_COUNT - 1]) {
            tx = BOX_INNER_LENGTH/2 - TOOTH_FIRST_X - i * TOOTH_SPACING;
            // 齿尖在 Z=+2, 底在 Z=+9
            translate([mx * tx, 0, TOOTH_GAP/2])
                _tooth(bw, tw, tooth_h, w, mx < 0, invert = true);
        }
    }
}

// hull 两块矩形板 = 梯形棱柱，自动水密
// invert=false: 底宽顶窄（下半齿：宽在壳壁，窄在齿尖）
// invert=true:  底窄顶宽（上半齿：窄在齿尖，宽在壳壁）
module _tooth(bw, tw, h, w, mirror_x, invert = false) {
    x0 = mirror_x ? -bw : 0;
    xt = mirror_x ? -tw : 0;
    hull() {
        translate([invert ? xt : x0, -w/2, 0])
            cube([invert ? tw : bw, w, 0.01]);
        translate([invert ? x0 : xt, -w/2, h - 0.01])
            cube([invert ? bw : tw, w, 0.01]);
    }
}
