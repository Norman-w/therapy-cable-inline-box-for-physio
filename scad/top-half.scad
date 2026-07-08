// ============================================================
// 上半壳体 — Z ≥ 0，分型面在 Z=0
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
            // ===== 壳体 =====
            difference() {
                intersection() {
                    rounded_rect_prism(
                        BOX_OUTER_LENGTH, BOX_OUTER_WIDTH, BOX_OUTER_HEIGHT,
                        r_outer, center = true);
                    translate([0, 0, +BOX_OUTER_HEIGHT])
                        cube([BOX_OUTER_LENGTH * 2, BOX_OUTER_WIDTH * 2, BOX_OUTER_HEIGHT * 2],
                             center = true);
                }
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

            // ===== Boss 柱（端面缩减 BOSS_FACE_GAP）=====
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
            translate([sx * BOSS_X, sy * BOSS_Y, boss_h - 0.3])
                cylinder(d1 = SCREW_CLEARANCE, d2 = SCREW_HEAD_DIAMETER,
                         h  = WALL_THICKNESS + 0.4, $fn = 32);
        }

        // ===== 电缆通道 =====
        for (mx = [-1, 1]) {
            translate([mx * BOX_OUTER_LENGTH / 2, 0, 0])
                cable_channel_half_top();
        }
    }
}
