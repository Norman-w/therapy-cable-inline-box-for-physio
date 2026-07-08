// ============================================================
// 下半壳体 — Z ≤ 0，分型面在 Z=0
// 上包下：顶部外壁减薄 OVERLAP_T，让上半外壁包裹
// ============================================================
include <parameters.scad>
include <utilities.scad>
include <resistor-holder.scad>
include <cable-gland.scad>
include <cable-strain-relief.scad>

module bottom_half() {
    half_h = BOX_HALF_INNER_H;
    r_outer = CORNER_RADIUS;
    r_inner = max(r_outer - WALL_THICKNESS, 0.5);

    difference() {
        union() {
            // ===== 壳体：下半截正常壁厚，顶部减薄让上半包裹 =====
            difference() {
                // 外壳下半
                intersection() {
                    rounded_rect_prism(
                        BOX_OUTER_LENGTH, BOX_OUTER_WIDTH, BOX_OUTER_HEIGHT,
                        r_outer, center = true);
                    translate([0, 0, -BOX_OUTER_HEIGHT])
                        cube([BOX_OUTER_LENGTH * 2, BOX_OUTER_WIDTH * 2, BOX_OUTER_HEIGHT * 2],
                             center = true);
                }
                // 内腔下半
                intersection() {
                    rounded_rect_prism(
                        BOX_INNER_LENGTH, BOX_INNER_WIDTH, BOX_INNER_HEIGHT,
                        r_inner, center = true);
                    translate([0, 0, -BOX_INNER_HEIGHT])
                        cube([BOX_INNER_LENGTH * 2, BOX_INNER_WIDTH * 2, BOX_INNER_HEIGHT * 2],
                             center = true);
                }
                // 顶部外壁减薄 OVERLAP_T（供上半外壁包裹）
                overlap_recess_bottom();
            }

            // ===== Boss 柱（缩减 0.5mm 防挤压）=====
            for (sx = [-1, 1], sy = [-1, 1]) {
                boss_h = half_h - BOSS_FACE_GAP;
                translate([sx * BOSS_X, sy * BOSS_Y, -half_h]) {
                    cylinder(d1 = BOSS_REINFORCE_OD, d2 = BOSS_DIAMETER,
                             h  = BOSS_REINFORCE_H, $fn = 32);
                    translate([0, 0, BOSS_REINFORCE_H])
                        cylinder(d = BOSS_DIAMETER, h = boss_h - BOSS_REINFORCE_H, $fn = 32);
                }
            }

            // 线缆锯齿
            cable_clamp_teeth_bottom();
        }

        // ===== Boss 导孔 =====
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * BOSS_X, sy * BOSS_Y, -half_h - 0.1])
                cylinder(d = BOSS_PILOT_HOLE, h = half_h + 0.4, $fn = 24);
        }

        // ===== 电缆通道 =====
        for (mx = [-1, 1]) {
            translate([mx * BOX_OUTER_LENGTH / 2, 0, 0])
                cable_channel_half_bottom();
        }
    }
}

// 顶部外壁减薄：Z=-OVERLAP_H 到 Z=0，外壁削去 OVERLAP_T
module overlap_recess_bottom() {
    ro = CORNER_RADIUS;
    // 外圈：外壳顶部
    intersection() {
        rounded_rect_prism(
            BOX_OUTER_LENGTH + 1, BOX_OUTER_WIDTH + 1, OVERLAP_H * 2,
            ro, center = true);
        translate([0, 0, -OVERLAP_H/2])
            cube([BOX_OUTER_LENGTH + 2, BOX_OUTER_WIDTH + 2, OVERLAP_H + 0.1], center = true);
    }
    // 减内圈
    intersection() {
        rounded_rect_prism(
            BOX_OUTER_LENGTH - OVERLAP_T*2, BOX_OUTER_WIDTH - OVERLAP_T*2, OVERLAP_H * 2,
            max(ro - OVERLAP_T, 0.5), center = true);
        translate([0, 0, -OVERLAP_H/2 - 0.1])
            cube([BOX_OUTER_LENGTH, BOX_OUTER_WIDTH, OVERLAP_H + 0.4], center = true);
    }
}
