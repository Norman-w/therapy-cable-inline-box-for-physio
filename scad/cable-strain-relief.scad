// ============================================================
// 线缆 S 型绕柱加固 — 4 根矩形挡柱在中轴线上，根部加宽加固
// ============================================================
include <parameters.scad>

STRAIN_POST_W          = 3.0;   // 柱宽 (X向)
STRAIN_POST_D          = 4.0;   // 柱厚 (Y向)
STRAIN_POST_ENTRY_GAP  = 1.0;   // 柱 A 距内端面
STRAIN_POST_SPACING    = 9.0;   // 柱 A 到柱 B 的 X 间距
STRAIN_POST_ABOVE      = 5.0;   // 凸出分型面以上
STRAIN_BASE_EXTRA      = 1.5;   // 根部每侧加宽量
STRAIN_BASE_H          = 3.0;   // 根部加宽段高度

module cable_strain_relief_posts() {
    half_h = BOX_HALF_INNER_H;
    post_h = half_h + STRAIN_POST_ABOVE;          // 14mm 总高
    upper_h = post_h - STRAIN_BASE_H;             // 上部直柱 11mm
    bw = STRAIN_POST_W + STRAIN_BASE_EXTRA * 2;   // 底座宽 6mm
    bd = STRAIN_POST_D + STRAIN_BASE_EXTRA * 2;   // 底座厚 7mm
    bx = STRAIN_BASE_EXTRA;  // 上部相对底座的偏移

    for (mx = [-1, 1]) {
        ax = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP);
        bx = mx * (BOX_INNER_LENGTH / 2 - STRAIN_POST_ENTRY_GAP - STRAIN_POST_SPACING);

        for (cx = [ax, bx]) {
            translate([cx - bw/2, -bd/2, -half_h]) {
                // 加宽底座
                cube([bw, bd, STRAIN_BASE_H]);
                // 上部窄柱
                translate([bx, bx, STRAIN_BASE_H])
                    cube([STRAIN_POST_W, STRAIN_POST_D, upper_h]);
            }
        }
    }
}
