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
TOOTH_FIRST_X   = 3.0;   // 第一齿距内端面（防止齿底超出外壳）

module cable_clamp_teeth_bottom() {
    half_h = BOX_HALF_INNER_H;
    tooth_h = half_h - TOOTH_GAP/2;
    bw = TOOTH_BASE_X;
    tw = TOOTH_TOP_X;
    w  = TOOTH_WIDTH_Y;
    // 下半每侧 2 齿，向中心偏移半个齿距 → 3包2 交错咬合
    count = TOOTH_COUNT - 1;
    offset = TOOTH_SPACING / 2;

    for (mx = [-1, 1]) {
        for (i = [0 : count - 1]) {
            tx = BOX_INNER_LENGTH/2 - TOOTH_FIRST_X - offset - i * TOOTH_SPACING;
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

// ============================================================
// 线缆夹持柱 — 上半壳最内齿旁，2柱夹住线缆防晃动
// 柱高从内顶面到分型面下 5mm，间隙 5mm 夹住线缆
// ============================================================
GUIDE_POST_X_OFFSET = 12.0;  // 柱远心端与最内齿立面(X=14)平齐
GUIDE_POST_Y_GAP     = 2.5;   // 柱 Y 半间距（间隙 5mm）
GUIDE_POST_SIZE      = 2.0;   // 柱截面边长（窄柱减少冲突）
GUIDE_POST_BELOW     = 5.0;   // 柱伸出分型面以下长度

module cable_guide_posts_top() {
    half_h = BOX_HALF_INNER_H;
    post_h = half_h + GUIDE_POST_BELOW;  // 9 + 5 = 14mm
    s = GUIDE_POST_SIZE;

    for (mx = [-1, 1]) {
        for (sy = [-1, 1]) {
            // 柱内边距 Y=0 正好 2.5mm → 间隙 5mm 夹住线缆
            y_pos = sy > 0 ? GUIDE_POST_Y_GAP
                           : -GUIDE_POST_Y_GAP - s;
            translate([mx * GUIDE_POST_X_OFFSET, y_pos, -GUIDE_POST_BELOW])
                cube([s, s, post_h]);
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
