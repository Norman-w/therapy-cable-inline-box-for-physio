// ============================================================
// 上半壳体 — Z ≥ 0，分型面在 Z=0
// Boss 柱从内顶面到分型面，与下半 Boss 柱同外径对接
// ============================================================
include <parameters.scad>
include <utilities.scad>
include <resistor-holder.scad>
include <cable-gland.scad>
include <cable-strain-relief.scad>

module top_half() {
    half_h = BOX_HALF_INNER_H;             // = 9mm
    r_outer = CORNER_RADIUS;
    r_inner = max(r_outer - WALL_THICKNESS, 0.5);

    // 上半 Boss 柱
    top_boss_od = BOSS_DIAMETER;
    top_boss_id = SCREW_CLEARANCE;
    // 缩短在分型面端（Z=0.5起），靠壳壁端齐平（到Z=9）
    boss_base = 0.5;
    boss_h = half_h;

    difference() {
        union() {
            // ===== 挖空的壳体 =====
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

            // ===== 线缆锯齿压紧（上半，齿尖向下，2齿）=====
            cable_clamp_teeth_top();

            // ===== Boss 柱 ×4（分型面端缩0.5mm，壳壁端齐平）=====
            for (sx = [-1, 1], sy = [-1, 1]) {
                bh = boss_h - boss_base;
                translate([sx * BOSS_X, sy * BOSS_Y, boss_base])
                    difference() {
                        union() {
                            cylinder(d = top_boss_od,
                                     h = bh - BOSS_REINFORCE_H, $fn = 32);
                            translate([0, 0, bh - BOSS_REINFORCE_H])
                                cylinder(d1 = top_boss_od,
                                         d2 = BOSS_REINFORCE_OD,
                                         h  = BOSS_REINFORCE_H, $fn = 32);
                        }
                        translate([0, 0, -0.1])
                            cylinder(d = top_boss_id,
                                     h = bh + 0.2, $fn = 32);
                    }
            }
        }

        // ===== 锥形沉头孔（从壳壁外表面向下打通）=====
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * BOSS_X, sy * BOSS_Y, half_h - 0.3])
                cylinder(d1 = SCREW_CLEARANCE,
                         d2 = SCREW_HEAD_DIAMETER,
                         h  = WALL_THICKNESS + 0.6, $fn = 32);
        }

        // ===== 定位凹槽 =====
        alignment_groove();

        // ===== 电缆通道 =====
        for (mx = [-1, 1]) {
            translate([mx * BOX_OUTER_LENGTH / 2, 0, 0])
                cable_channel_half_top();
        }
    }
}

module alignment_groove() {
    gh  = ALIGNMENT_LIP_H + 0.3;
    gox = BOX_INNER_LENGTH / 2 + ALIGNMENT_LIP_W + PRINT_TOLERANCE;
    goy = BOX_INNER_WIDTH  / 2 + ALIGNMENT_LIP_W + PRINT_TOLERANCE;
    gix = BOX_INNER_LENGTH / 2 - PRINT_TOLERANCE;
    giy = BOX_INNER_WIDTH  / 2 - PRINT_TOLERANCE;

    difference() {
        translate([0, 0, 0])
        linear_extrude(height = gh)
            rounded_rect_2d(gox * 2, goy * 2,
                            max(CORNER_RADIUS - WALL_THICKNESS + ALIGNMENT_LIP_W, 0.5));
        translate([0, 0, -0.1])
        linear_extrude(height = gh + 0.2)
            rounded_rect_2d(gix * 2, giy * 2,
                            max(CORNER_RADIUS - WALL_THICKNESS, 0.5));
    }
}
