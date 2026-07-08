// ============================================================
// 线缆锯齿压紧 — 上下半壳各 3 道三角齿
// 螺丝拧紧时将线缆压入锯齿槽内咬住
// ============================================================
include <parameters.scad>

// 锯齿参数
TOOTH_COUNT       = 3;     // 每端锯齿数
TOOTH_WIDTH       = 8.0;   // 齿宽 (Y向，横跨线缆)
TOOTH_HEIGHT      = 2.0;   // 齿高 (Z向，凸出分型面)
TOOTH_SPACING     = 3.5;   // 齿间距 (X向)
TOOTH_FIRST_X     = 2.0;   // 第一齿距内端面距离
TOOTH_FLAT         = 0.5;   // 齿顶平台宽度（避免太尖）

module cable_clamp_teeth_bottom() {
    half_h = BOX_HALF_INNER_H;
    h = TOOTH_HEIGHT;

    for (mx = [-1, 1]) {
        for (i = [0 : TOOTH_COUNT - 1]) {
            tx = mx * (BOX_INNER_LENGTH / 2 - TOOTH_FIRST_X - i * TOOTH_SPACING);
            translate([tx, -TOOTH_WIDTH/2, 0])
                // 三角齿：斜面朝外、立面朝内（拉线缆时越咬越紧）
                polyhedron(
                    points = [
                        [0, 0, 0],                // 0: 底部近端
                        [0, TOOTH_WIDTH, 0],      // 1: 底部远端
                        [-2, 0, 0],               // 2: 斜底近端
                        [-2, TOOTH_WIDTH, 0],     // 3: 斜底远端
                        [-1, 0, h],               // 4: 齿顶近端
                        [-1, TOOTH_WIDTH, h],     // 5: 齿顶远端
                    ],
                    faces = [
                        [0, 1, 3, 2],  // 底面
                        [0, 2, 4],     // 斜面（朝外）
                        [4, 5, 1, 0],  // 立面（朝内，垂直）
                        [2, 3, 5, 4],  // 顶面
                        [1, 5, 3],     // 侧面
                    ]
                );
        }
    }
}

module cable_clamp_teeth_top() {
    half_h = BOX_HALF_INNER_H;
    h = TOOTH_HEIGHT;

    for (mx = [-1, 1]) {
        for (i = [0 : TOOTH_COUNT - 1]) {
            tx = mx * (BOX_INNER_LENGTH / 2 - TOOTH_FIRST_X - i * TOOTH_SPACING);
            // 上半的齿向下凸出（Z为负），与下半齿对咬
            translate([tx, -TOOTH_WIDTH/2, -h])
                polyhedron(
                    points = [
                        [0, 0, h],                // 0: 顶面近端
                        [0, TOOTH_WIDTH, h],      // 1: 顶面远端
                        [-2, 0, h],               // 2: 斜面顶近端
                        [-2, TOOTH_WIDTH, h],     // 3: 斜面顶远端
                        [-1, 0, 0],               // 4: 齿尖近端
                        [-1, TOOTH_WIDTH, 0],     // 5: 齿尖远端
                    ],
                    faces = [
                        [0, 1, 3, 2],  // 顶面
                        [0, 2, 4],     // 斜面（朝外）
                        [4, 5, 1, 0],  // 立面（朝内）
                        [2, 3, 5, 4],  // 底面
                        [1, 5, 3],     // 侧面
                    ]
                );
        }
    }
}
