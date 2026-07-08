// ============================================================
// 线缆 S 型绕柱 — 4 根矩形挡柱在中轴线上
// ============================================================
include <parameters.scad>

STRAIN_POST_W          = 3.0;   // 柱宽 (X向)
STRAIN_POST_D          = 4.0;   // 柱厚 (Y向)
STRAIN_POST_ENTRY_GAP  = 1.0;   // 柱 A 距内端面
STRAIN_POST_SPACING    = 9.0;   // 柱 A 到柱 B 的 X 间距
STRAIN_POST_ABOVE      = 5.0;   // 凸出分型面以上

module cable_strain_relief_posts() {
    half_h = BOX_HALF_INNER_H;
    post_h = half_h + STRAIN_POST_ABOVE;

    for (mx = [-1, 1]) {
        ax = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP);
        bx = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP - STRAIN_POST_SPACING);

        for (cx = [ax, bx]) {
            translate([cx - STRAIN_POST_W/2, -STRAIN_POST_D/2, -half_h])
                cube([STRAIN_POST_W, STRAIN_POST_D, post_h]);
        }
    }
}
