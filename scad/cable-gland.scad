// ============================================================
// 线缆密封/应力释放 — 压紧式半圆通道 + 抓线肋条
// 调用时模块已定位在壳体端面外侧（X = ±BOX_OUTER_LENGTH/2, Z=0 分型面）
// 通道沿 X 轴向内延伸（穿过壁厚进入内腔）并向外延伸（应力释放管）
// ============================================================
include <parameters.scad>

// 通道几何常量
_CH_R  = GLAND_CLAMP_DIAM / 2;                              // 压紧通道半径
_CH_L  = WALL_THICKNESS + GLAND_LENGTH + GLAND_OUTER_EXTEND; // 通道总长
// 通道中心相对端口位置（端口在 outer face）：
// 通道从 x = -(WALL+GLAND) 到 x = +GLAND_OUTER_EXTEND
// 中心在 x = (GLAND_OUTER - WALL - GLAND) / 2
_CH_X0 = (GLAND_OUTER_EXTEND - WALL_THICKNESS - GLAND_LENGTH) / 2;

// ---- 下半电缆半通道（Z ≤ 0）----
module cable_channel_half_bottom() {
    // 主半圆通道
    translate([_CH_X0, 0, -0.01])
    rotate([0, 90, 0])
        cylinder(r = _CH_R, h = _CH_L, center = true, $fn = 32);

    // 抓线肋条（仅在内腔段分布，避免在壁厚中）
    _grip_ribs(z = -0.01);
}

// ---- 上半电缆半通道（Z ≥ 0）----
module cable_channel_half_top() {
    // 主半圆通道
    translate([_CH_X0, 0, 0.01])
    rotate([0, 90, 0])
        cylinder(r = _CH_R, h = _CH_L, center = true, $fn = 32);

    // 抓线肋条
    _grip_ribs(z = 0.01);
}

// ---- 抓线肋条（内部实现）----
module _grip_ribs(z) {
    rib_r  = _CH_R + 0.6;       // 肋条半径（略大于通道）
    rib_th = 1.0;                // 肋条厚度
    // 肋条分布在内腔段，从 wall 内表面开始的 GLAND_LENGTH 范围内
    rib_start = -(WALL_THICKNESS + GLAND_LENGTH) + 2;  // 内腔段起点 + 边距
    rib_end   = -WALL_THICKNESS - 2;                     // 内腔段终点 - 边距
    rib_range = rib_end - rib_start;

    for (i = [0 : GLAND_RIB_COUNT - 1]) {
        rx = (GLAND_RIB_COUNT == 1)
            ? (rib_start + rib_end) / 2
            : rib_start + i * rib_range / (GLAND_RIB_COUNT - 1);
        translate([rx, 0, z])
        rotate([0, 90, 0])
            cylinder(r = rib_r, h = rib_th, center = true, $fn = 32);
    }
}
