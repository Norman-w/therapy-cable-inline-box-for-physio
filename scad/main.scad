// ============================================================
// 理疗仪线缆串联电阻保护盒 — 主入口
// therapy-cable-inline-box-for-physio
//
// 用法：
//   预览装配：   VISUAL=true  , RENDER="assembly"
//   导出下半：   VISUAL=false , RENDER="bottom"   → openscad -o stl/bottom-half.stl
//   导出上半：   VISUAL=false , RENDER="top"      → openscad -o stl/top-half.stl
// ============================================================
include <parameters.scad>
include <utilities.scad>
include <resistor-holder.scad>
include <cable-gland.scad>
include <cable-strain-relief.scad>
include <bottom-half.scad>
include <top-half.scad>

// ===== 渲染模式 =====
RENDER = "assembly";  // "bottom" | "top" | "assembly" | "flat"

// ===== 装配视图间距 =====
ASSEMBLY_GAP = 18;  // 上下壳体分离间距 mm

// ============================================================
//  渲染入口
// ============================================================
if (RENDER == "bottom") {
    // 导出模式：仅下半壳体
    bottom_half();
} else if (RENDER == "top") {
    // 导出模式：仅上半壳体（自然方向）
    top_half();
} else if (RENDER == "flat") {
    // 合并打印：两半壳体平放在 XY 平面
    translate([0, -BOX_OUTER_WIDTH/2 - 5, 0])
        bottom_half();
    translate([0,  BOX_OUTER_WIDTH/2 + 5, 0])
        rotate([180, 0, 0])
            top_half();
} else {
    // 装配视图：上下壳体分开展示
    assembly_view();
}

// ============================================================
//  装配视图
// ============================================================
module assembly_view() {
    if (VISUAL) {
        // ---- 分色展示模式 ----
        // 下半壳体（暖白）
        color("ivory")
        translate([0, 0, -ASSEMBLY_GAP / 2])
            bottom_half();

        // 上半壳体（半透明蓝）
        color("lightblue", 0.5)
        translate([0, 0, +ASSEMBLY_GAP / 2])
            top_half();

        // 电阻占位模型
        color("beige")
        translate([0, 0, -BOX_HALF_INNER_H / 2])
            resistor_placeholder();

        // 线缆占位
        color("dimgray")
        for (mx = [-1, 1]) {
            translate([mx * (BOX_OUTER_LENGTH / 2 + GLAND_OUTER_EXTEND + 10), 0, 0])
            rotate([0, 90, 0])
                cylinder(d = CABLE_DIAMETER, h = 25, center = true, $fn = 32);
        }
    } else {
        // ---- 预览模式：仅下半（默认导出视角）----
        bottom_half();
    }
}

// ============================================================
//  快速尺寸验证（取消注释以显示尺寸参考立方体）
// ============================================================
// %translate([0, 0, -BOX_OUTER_HEIGHT/2])
//     cube([BOX_OUTER_LENGTH, BOX_OUTER_WIDTH, BOX_OUTER_HEIGHT], center=true);
