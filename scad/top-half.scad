// ============================================================
// 上半壳体 — Z ≥ 0，分型面在 Z=0
// 上包下：外壁向下延伸 OVERLAP_H 包裹下半壳体
// ============================================================
include <parameters.scad>
include <utilities.scad>
include <resistor-holder.scad>
include <cable-gland.scad>
include <cable-strain-relief.scad>

module top_half() {
    half_h = BOX_HALF_INNER_H;
    r_outer = CORNER_RADIUS;
    r_inner = max(r_outer - WALL_THICKNESS, 0.5);
    boss_h = half_h - BOSS_FACE_GAP;
    top_boss_od = BOSS_DIAMETER;
    top_boss_id = SCREW_CLEARANCE;

    difference() {
        union() {
            // ===== 壳体 + 包围裙边 =====
            difference() {
                union() {
                    // 主壳体上半
                    intersection() {
                        rounded_rect_prism(
                            BOX_OUTER_LENGTH, BOX_OUTER_WIDTH, BOX_OUTER_HEIGHT,
                            r_outer, center = true);
                        translate([0, 0, +BOX_OUTER_HEIGHT])
                            cube([BOX_OUTER_LENGTH * 2, BOX_OUTER_WIDTH * 2, BOX_OUTER_HEIGHT * 2],
                                 center = true);
                    }
                    // 包围裙边：从 Z=0 向下延伸 OVERLAP_H，壁厚 OVERLAP_T
                    overlap_skirt_top();
                }
                // 内腔上半
                intersection() {
                    rounded_rect_prism(
                        BOX_INNER_LENGTH, BOX_INNER_WIDTH, BOX_INNER_HEIGHT,
                        r_inner, center = true);
                    translate([0, 0, +BOX_INNER_HEIGHT])
                        cube([BOX_INNER_LENGTH * 2, BOX_INNER_WIDTH * 2, BOX_INNER_HEIGHT * 2],
                             center = true);
                }
            }

            // ===== 线缆锯齿 =====
            cable_clamp_teeth_top();

            // ===== 线缆夹持柱 =====
            cable_guide_posts_top();

            // ===== Boss 柱（缩减 0.5mm）=====
            for (sx = [-1, 1], sy = [-1, 1]) {
                translate([sx * BOSS_X, sy * BOSS_Y, 0])
                    difference() {
                        union() {
                            cylinder(d = top_boss_od, h = boss_h - BOSS_REINFORCE_H, $fn = 32);
                            translate([0, 0, boss_h - BOSS_REINFORCE_H])
                                cylinder(d1 = top_boss_od, d2 = BOSS_REINFORCE_OD,
                                         h  = BOSS_REINFORCE_H, $fn = 32);
                        }
                        translate([0, 0, -0.1])
                            cylinder(d = top_boss_id, h = boss_h + 0.2, $fn = 32);
                    }
            }
        }

        // ===== 锥形沉头孔 =====
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * BOSS_X, sy * BOSS_Y, boss_h])
                cylinder(d1 = SCREW_CLEARANCE, d2 = SCREW_HEAD_DIAMETER,
                         h  = WALL_THICKNESS + 0.1, $fn = 32);
        }

        // ===== 电缆通道 =====
        for (mx = [-1, 1]) {
            translate([mx * BOX_OUTER_LENGTH / 2, 0, 0])
                cable_channel_half_top();
        }
    }
}

// 包围裙边：从 Z=0 向下 OVERLAP_H，壁厚 OVERLAP_T
module overlap_skirt_top() {
    ro = CORNER_RADIUS;
    difference() {
        intersection() {
            rounded_rect_prism(
                BOX_OUTER_LENGTH + 0.2, BOX_OUTER_WIDTH + 0.2, OVERLAP_H * 2,
                ro, center = true);
            translate([0, 0, -OVERLAP_H/2])
                cube([BOX_OUTER_LENGTH + 2, BOX_OUTER_WIDTH + 2, OVERLAP_H + 0.1], center = true);
        }
        intersection() {
            rounded_rect_prism(
                BOX_OUTER_LENGTH - OVERLAP_T*2, BOX_OUTER_WIDTH - OVERLAP_T*2, OVERLAP_H * 2,
                max(ro - OVERLAP_T, 0.5), center = true);
            translate([0, 0, -OVERLAP_H/2 - 0.1])
                cube([BOX_OUTER_LENGTH, BOX_OUTER_WIDTH, OVERLAP_H + 0.4], center = true);
        }
        for (mx = [-1, 1]) {
            translate([mx * BOX_OUTER_LENGTH / 2, 0, -OVERLAP_H/2])
                cube([BOX_OUTER_LENGTH/4, CABLE_DIAMETER + 2, OVERLAP_H + 0.2], center = true);
        }
    }
}
