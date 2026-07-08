// ============================================================
// 线缆 S 型绕柱加固 — 两组挡柱强制线缆走 S 弯
// 装在下半壳体，从底板伸到分型面以上
// ============================================================
include <parameters.scad>

// 挡柱参数
STRAIN_POST_DIAM       = 3.5;   // 柱径
STRAIN_POST_Y_OFFSET   = 3.0;   // 两柱 Y 向错开距离（±）
STRAIN_POST_X_SPACING  = 8.0;   // 两柱 X 向间距
STRAIN_POST_ENTRY_GAP  = 5.0;   // 第一柱距内端面距离

module cable_strain_relief_posts() {
    half_h = BOX_HALF_INNER_H;
    post_h = half_h + 3.0;  // 从底板伸到分型面以上 3mm

    for (mx = [-1, 1]) {
        // 柱 A（靠近线缆入口，偏 +Y）
        ax = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP);
        ay = STRAIN_POST_Y_OFFSET;
        // 柱 B（靠内，偏 -Y）
        bx = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP - STRAIN_POST_X_SPACING);
        by = -STRAIN_POST_Y_OFFSET;

        for (pos = [[ax, ay], [bx, by]]) {
            translate([pos[0], pos[1], -half_h])
                cylinder(d = STRAIN_POST_DIAM, h = post_h, $fn = 24);
        }
    }
}
