// ============================================================
// 线缆 S 型绕柱加固 — 两组挡柱强制线缆走 S 弯
// 装在下半壳体，从底板伸到分型面以上
// ============================================================
include <parameters.scad>

// 矩形挡柱参数
STRAIN_POST_W          = 2.5;   // 柱宽 (X向)
STRAIN_POST_D          = 5.0;   // 柱厚 (Y向)
STRAIN_POST_Y_OFFSET   = 3.0;   // 两柱 Y 向错开距离（±）
STRAIN_POST_X_SPACING  = 8.0;   // 两柱 X 向间距
STRAIN_POST_ENTRY_GAP  = 5.0;   // 第一柱距内端面距离
STRAIN_POST_ABOVE      = 5.0;   // 凸出分型面以上高度

module cable_strain_relief_posts() {
    half_h = BOX_HALF_INNER_H;
    post_h = half_h + STRAIN_POST_ABOVE;  // 从底板伸到分型面以上 5mm

    for (mx = [-1, 1]) {
        // 柱 A（靠近线缆入口，偏 +Y）
        ax = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP);
        ay = STRAIN_POST_Y_OFFSET;
        // 柱 B（靠内，偏 -Y）
        bx = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP - STRAIN_POST_X_SPACING);
        by = -STRAIN_POST_Y_OFFSET;

        for (pos = [[ax, ay], [bx, by]]) {
            translate([pos[0] - STRAIN_POST_W/2, pos[1] - STRAIN_POST_D/2, -half_h])
                cube([STRAIN_POST_W, STRAIN_POST_D, post_h]);
        }
    }
}
