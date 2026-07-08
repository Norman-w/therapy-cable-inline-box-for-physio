// ============================================================
// 线缆出线孔 — 半圆通孔，只穿过壁厚，不深入内腔
// ============================================================
include <parameters.scad>

// 孔半径和总长
_CH_R  = GLAND_HOLE_DIAM / 2;
_CH_L  = WALL_THICKNESS + GLAND_WALL_EXTRA * 2;  // 壁厚 + 内外各延伸一点

// 下半电缆半孔（Z ≤ 0）
module cable_channel_half_bottom() {
    translate([0, 0, -0.01])
    rotate([0, 90, 0])
        cylinder(r = _CH_R, h = _CH_L, center = true, $fn = 32);
}

// 上半电缆半孔（Z ≥ 0）
module cable_channel_half_top() {
    translate([0, 0, 0.01])
    rotate([0, 90, 0])
        cylinder(r = _CH_R, h = _CH_L, center = true, $fn = 32);
}
