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
TOOTH_FIRST_X   = 4.0;   // 第一齿距内端面

// 下半 3 齿（原来上半的3齿）
module cable_clamp_teeth_bottom() {
    half_h = BOX_HALF_INNER_H;
    tooth_h = half_h - TOOTH_GAP/2;
    bw = TOOTH_BASE_X;
    tw = TOOTH_TOP_X;
    w  = TOOTH_WIDTH_Y;

    for (mx = [-1, 1]) {
        for (i = [0 : TOOTH_COUNT - 1]) {
            tx = BOX_INNER_LENGTH/2 - TOOTH_FIRST_X - i * TOOTH_SPACING;
            translate([mx * tx, 0, -half_h])
                _tooth(bw, tw, tooth_h, w, mx < 0, invert = false);
        }
    }
}

// 上半 2 齿（原来下半的2齿，偏移半齿距交错）
module cable_clamp_teeth_top() {
    half_h = BOX_HALF_INNER_H;
    tooth_h = half_h - TOOTH_GAP/2;
    bw = TOOTH_BASE_X;
    tw = TOOTH_TOP_X;
    w  = TOOTH_WIDTH_Y;
    count = TOOTH_COUNT - 1;
    offset = TOOTH_SPACING / 2;

    for (mx = [-1, 1]) {
        for (i = [0 : count - 1]) {
            tx = BOX_INNER_LENGTH/2 - TOOTH_FIRST_X - offset - i * TOOTH_SPACING;
            translate([mx * tx, 0, TOOTH_GAP/2])
                _tooth(bw, tw, tooth_h, w, mx < 0, invert = true);
        }
    }
}

// ============================================================
// 线缆夹持柱 — 下半壳最内齿旁，柱从底板伸到分型面上5mm
// ============================================================
GUIDE_POST_Y_GAP     = 2.5;   // 柱 Y 半间距（间隙 5mm）
GUIDE_POST_SIZE      = 2.0;   // 柱截面边长
GUIDE_POST_ABOVE     = 5.0;   // 柱伸出分型面以上长度
GUIDE_POST_BASE_EXTRA = 1.5;  // 根部加固每侧加宽
GUIDE_POST_BASE_H    = 3.0;   // 根部加固段高度

module cable_guide_posts_bottom() {
    half_h = BOX_HALF_INNER_H;
    post_h = half_h + GUIDE_POST_ABOVE;
    s  = GUIDE_POST_SIZE;
    bs = s + GUIDE_POST_BASE_EXTRA * 2;
    upper_h = post_h - GUIDE_POST_BASE_H;
    off = GUIDE_POST_BASE_EXTRA;

    tooth_face_x = BOX_INNER_LENGTH/2 - TOOTH_FIRST_X - (TOOTH_COUNT-1)*TOOTH_SPACING;

    for (mx = [-1, 1]) {
        x_narrow = mx > 0 ? tooth_face_x - s : -tooth_face_x;
        x_wide   = mx > 0 ? tooth_face_x - bs : -tooth_face_x;

        for (sy = [-1, 1]) {
            y_narrow = sy > 0 ? GUIDE_POST_Y_GAP : -GUIDE_POST_Y_GAP - s;
            y_wide   = sy > 0 ? GUIDE_POST_Y_GAP - off : -GUIDE_POST_Y_GAP - s - off;

            translate([x_wide, y_wide, -half_h]) {
                // 根部锥形加固（靠底板，hull过渡）
                hull() {
                    cube([bs, bs, 0.01]);  // 宽底
                    translate([x_narrow - x_wide, y_narrow - y_wide, GUIDE_POST_BASE_H - 0.01])
                        cube([s, s, 0.01]);  // 窄顶
                }
                // 上部细柱
                translate([x_narrow - x_wide, y_narrow - y_wide, GUIDE_POST_BASE_H])
                    cube([s, s, upper_h]);
            }
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
