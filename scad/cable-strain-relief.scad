// ============================================================
// 线缆 S 型绕柱加固 — 两组大截面矩形挡柱强制线缆走 S 弯
// 装在下半壳体，从底板伸到分型面以上 5mm
// ============================================================
include <parameters.scad>

// 大截面矩形挡柱，清晰可见
STRAIN_POST_W          = 4.0;   // 柱宽 (X向)
STRAIN_POST_D          = 8.0;   // 柱厚 (Y向) — 大截面确保挡住线缆
STRAIN_POST_Y_OFFSET   = 4.0;   // Y 向偏移（柱中心距 Y=0 的距离）
STRAIN_POST_X_SPACING  = 10.0;  // 两柱 X 向间距
STRAIN_POST_ENTRY_GAP  = 1.0;   // 第一柱距内端面
STRAIN_POST_ABOVE      = 5.0;   // 凸出分型面以上

module cable_strain_relief_posts() {
    half_h = BOX_HALF_INNER_H;
    post_h = half_h + STRAIN_POST_ABOVE;

    for (mx = [-1, 1]) {
        // 柱 A：靠近线缆入口，偏 +Y，挡住直行路线
        ax = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP);
        ay = STRAIN_POST_Y_OFFSET;
        // 柱 B：靠内，偏 -Y，形成 S 弯第二拐点
        bx = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP - STRAIN_POST_X_SPACING);
        by = -STRAIN_POST_Y_OFFSET;

        for (pos = [[ax, ay], [bx, by]]) {
            translate([pos[0] - STRAIN_POST_W/2, pos[1] - STRAIN_POST_D/2, -half_h])
                cube([STRAIN_POST_W, STRAIN_POST_D, post_h]);
        }
    }
}
