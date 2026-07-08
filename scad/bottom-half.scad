// ============================================================
// 下半壳体 — Z ≤ 0，分型面在 Z=0
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
            // ===== 壳体 =====
            difference() {
                intersection() {
                    rounded_rect_prism(
                        BOX_OUTER_LENGTH, BOX_OUTER_WIDTH, BOX_OUTER_HEIGHT,
                        r_outer, center = true);
                    translate([0, 0, -BOX_OUTER_HEIGHT])
                        cube([BOX_OUTER_LENGTH * 2, BOX_OUTER_WIDTH * 2, BOX_OUTER_HEIGHT * 2],
                             center = true);
                }
                intersection() {
                    rounded_rect_prism(
                        BOX_INNER_LENGTH, BOX_INNER_WIDTH, BOX_INNER_HEIGHT,
                        r_inner, center = true);
                    translate([0, 0, -BOX_INNER_HEIGHT])
                        cube([BOX_INNER_LENGTH * 2, BOX_INNER_WIDTH * 2, BOX_INNER_HEIGHT * 2],
                             center = true);
                }
            }

            // ===== Boss 柱（端面缩减 BOSS_FACE_GAP 防挤压）=====
            for (sx = [-1, 1], sy = [-1, 1]) {
                boss_h = half_h - BOSS_FACE_GAP;
                translate([sx * BOSS_X, sy * BOSS_Y, -half_h]) {
                    cylinder(d1 = BOSS_REINFORCE_OD, d2 = BOSS_DIAMETER,
                             h  = BOSS_REINFORCE_H, $fn = 32);
                    translate([0, 0, BOSS_REINFORCE_H])
                        cylinder(d = BOSS_DIAMETER, h = boss_h - BOSS_REINFORCE_H, $fn = 32);
                }
            }

            // ===== 内衬密封圈（1mm厚，向下2mm+向上2mm凸出）=====
            inner_liner();

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

// 内衬密封圈：嵌入壳壁1mm，内面与原腔内壁齐平，Boss和过线处留空
module inner_liner() {
    lh = LINER_EXTEND * 2;  // 4mm 总高
    lox = BOX_INNER_LENGTH/2;
    loy = BOX_INNER_WIDTH/2;
    lr  = max(CORNER_RADIUS - WALL_THICKNESS, 0.5);

    // 外圈 = 比内腔大1mm（嵌入壳壁），内圈 = 内腔（齐平）
    translate([-lox - LINER_THICKNESS, -loy - LINER_THICKNESS, -LINER_EXTEND])
    difference() {
        // 外边界：比内腔大1mm
        rounded_rect_prism(
            (lox + LINER_THICKNESS)*2, (loy + LINER_THICKNESS)*2, lh,
            lr + LINER_THICKNESS, center=false);
        // 内边界：原腔内壁（保留，齐平）
        translate([LINER_THICKNESS, LINER_THICKNESS, -0.1])
            rounded_rect_prism(lox*2, loy*2, lh + 0.2, lr, center=false);
        // 挖空 Boss 位
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([lox + LINER_THICKNESS + sx*BOSS_X,
                       loy + LINER_THICKNESS + sy*BOSS_Y, -1])
                cylinder(d = BOSS_DIAMETER + 4, h = lh + 2, $fn = 32);
        }
        // 挖空过线处
        for (mx = [-1, 1]) {
            translate([lox + LINER_THICKNESS + mx*BOX_INNER_LENGTH/2,
                       loy + LINER_THICKNESS, -1])
                cube([WALL_THICKNESS*3, CABLE_DIAMETER + 4, lh + 2], center = true);
        }
    }
}
