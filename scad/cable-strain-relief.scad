// ============================================================
// 线缆锯齿压紧 — 上下半壳各 3 道三角齿，从壳壁延伸到齿尖
// 螺丝拧紧时将线缆压入锯齿槽内咬住
// ============================================================
include <parameters.scad>

TOOTH_COUNT       = 3;
TOOTH_WIDTH       = 8.0;   // 齿宽 (Y向)
TOOTH_HEIGHT      = 2.0;   // 齿尖凸出分型面高度
TOOTH_SPACING     = 3.5;   // 齿间距 (X向)
TOOTH_FIRST_X     = 2.0;   // 第一齿距内端面
TOOTH_BASE_LEN    = 3.0;   // 齿底 X 向长度

module cable_clamp_teeth_bottom() {
    half_h = BOX_HALF_INNER_H;
    // 从底板到齿尖的总高度
    total_h = half_h + TOOTH_HEIGHT;  // 9 + 2 = 11mm

    for (mx = [-1, 1]) {
        for (i = [0 : TOOTH_COUNT - 1]) {
            tx = mx * (BOX_INNER_LENGTH / 2 - TOOTH_FIRST_X - i * TOOTH_SPACING);
            translate([tx, -TOOTH_WIDTH/2, -half_h])
                // 梯形棱柱：底面在底板，尖顶在分型面上方
                polyhedron(
                    points = [
                        // 底面（Z=0，在底板上）
                        [0,              0, 0],
                        [0, TOOTH_WIDTH, 0],
                        [TOOTH_BASE_LEN, 0, 0],
                        [TOOTH_BASE_LEN, TOOTH_WIDTH, 0],
                        // 齿尖（Z=total_h，在分型面上方）
                        [TOOTH_BASE_LEN/2, 0,              total_h],
                        [TOOTH_BASE_LEN/2, TOOTH_WIDTH,    total_h],
                    ],
                    faces = [
                        [0, 2, 3, 1],     // 底面
                        [0, 1, 5, 4],     // 立面（朝内，垂直）
                        [0, 4, 2],         // 斜面（朝外）
                        [1, 3, 5],         // 侧面
                        [2, 4, 5, 3],     // 斜面顶
                    ]
                );
        }
    }
}

module cable_clamp_teeth_top() {
    half_h = BOX_HALF_INNER_H;
    total_h = half_h + TOOTH_HEIGHT;

    for (mx = [-1, 1]) {
        for (i = [0 : TOOTH_COUNT - 1]) {
            tx = mx * (BOX_INNER_LENGTH / 2 - TOOTH_FIRST_X - i * TOOTH_SPACING);
            // 从内顶面向下延伸到齿尖
            translate([tx, -TOOTH_WIDTH/2, -TOOTH_HEIGHT])
                polyhedron(
                    points = [
                        // 顶面（Z=total_h，在内顶面上）
                        [0,              0, total_h],
                        [0, TOOTH_WIDTH, total_h],
                        [TOOTH_BASE_LEN, 0, total_h],
                        [TOOTH_BASE_LEN, TOOTH_WIDTH, total_h],
                        // 齿尖（Z=0，在分型面下方）
                        [TOOTH_BASE_LEN/2, 0,              0],
                        [TOOTH_BASE_LEN/2, TOOTH_WIDTH,    0],
                    ],
                    faces = [
                        [0, 2, 3, 1],     // 顶面
                        [0, 1, 5, 4],     // 立面（朝内）
                        [0, 4, 2],         // 斜面（朝外）
                        [1, 3, 5],         // 侧面
                        [2, 4, 5, 3],     // 斜面底
                    ]
                );
        }
    }
}
