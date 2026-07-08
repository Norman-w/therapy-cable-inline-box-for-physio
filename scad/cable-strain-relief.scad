// ============================================================
// 线缆锯齿压紧 — 梯形齿，尖端有 4mm 间隙压紧 5mm 线缆
// 齿从壳壁延伸到分型面附近，立面朝中心、斜面朝入口
// ============================================================
include <parameters.scad>

TOOTH_COUNT     = 3;
TOOTH_WIDTH_Y   = 8.0;   // 齿宽 Y向
TOOTH_BASE_X    = 4.0;   // 齿底宽 X向
TOOTH_TOP_X     = 1.5;   // 齿顶平台宽 X向（梯形平顶，不尖）
TOOTH_GAP       = 4.0;   // 上下齿尖间隙（夹紧5mm线缆）
TOOTH_SPACING   = 4.0;   // 齿间距 X向
TOOTH_FIRST_X   = 2.0;   // 第一齿距内端面

module cable_clamp_teeth_bottom() {
    half_h = BOX_HALF_INNER_H;
    tooth_h = half_h - TOOTH_GAP/2;   // 9 - 2 = 7mm
    bw = TOOTH_BASE_X;
    tw = TOOTH_TOP_X;
    w  = TOOTH_WIDTH_Y;

    for (mx = [-1, 1]) {
        for (i = [0 : TOOTH_COUNT - 1]) {
            tx = BOX_INNER_LENGTH/2 - TOOTH_FIRST_X - i * TOOTH_SPACING;
            // 齿在底板 Z=-half_h，高 tooth_h，尖在 Z=-TOOTH_GAP/2=-2
            translate([mx * tx, -w/2, -half_h])
            // 负X侧镜像，让立面始终朝中心、斜面朝入口
            if (mx < 0) {
                mirror([1,0,0]) _tooth_positive(bw, tw, w, tooth_h);
            } else {
                _tooth_positive(bw, tw, w, tooth_h);
            }
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
            // 齿尖在 Z=+TOOTH_GAP/2=+2，底板在 Z=+half_h=+9
            translate([mx * tx, -w/2, TOOTH_GAP/2])
            if (mx < 0) {
                mirror([1,0,0]) _tooth_positive(bw, tw, w, tooth_h);
            } else {
                _tooth_positive(bw, tw, w, tooth_h);
            }
        }
    }
}

// 正X侧的梯形齿（立面在 X=0 朝中心，斜面朝外）
module _tooth_positive(bw, tw, w, h) {
    polyhedron(
        points = [
            [0,  0, 0],       // 0: 底内
            [0,  w, 0],       // 1: 底内远
            [bw, 0, 0],       // 2: 底外
            [bw, w, 0],       // 3: 底外远
            [0,  0, h],       // 4: 顶内（立面顶）
            [0,  w, h],       // 5: 顶内远
            [tw, 0, h],       // 6: 顶外（平顶外）
            [tw, w, h],       // 7: 顶外远
        ],
        faces = [
            [0, 2, 3, 1],     // 底面
            [0, 1, 5, 4],     // 立面（朝内，垂直）
            [2, 6, 7, 3],     // 斜面（朝外）
            [4, 6, 7, 5],     // 顶面（平顶）
            [0, 4, 6, 2],     // 侧面
            [1, 3, 7, 5],     // 侧面远
        ]
    );
}
