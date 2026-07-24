// ============================================================
// 上半壳体 — Z ≥ 0，分型面在 Z=0
// 旋钮 / 数码窗在此面（无合盖沉头孔）；四角为导孔柱承接底面螺丝
// ============================================================
include <parameters.scad>
include <utilities.scad>
include <module-holder.scad>
include <cable-gland.scad>
include <cable-strain-relief.scad>

// ===== 分区：公开 API =====

module top_half() {
    half_h = BOX_HALF_INNER_H;
    r_outer = CORNER_RADIUS;
    r_inner = max(r_outer - WALL_THICKNESS, 0.5);
    boss_base = 0.25;
    boss_h = half_h;

    difference() {
        union() {
            difference() {
                intersection() {
                    rounded_rect_prism(
                        BOX_OUTER_LENGTH, BOX_OUTER_WIDTH, BOX_OUTER_HEIGHT,
                        r_outer, center = true);
                    translate([0, 0, +BOX_OUTER_HEIGHT])
                        cube([BOX_OUTER_LENGTH * 2, BOX_OUTER_WIDTH * 2,
                              BOX_OUTER_HEIGHT * 2], center = true);
                }
                intersection() {
                    rounded_rect_prism(
                        BOX_INNER_LENGTH, BOX_INNER_WIDTH, BOX_INNER_HEIGHT,
                        r_inner, center = true);
                    translate([0, 0, +BOX_INNER_HEIGHT])
                        cube([BOX_INNER_LENGTH * 2, BOX_INNER_WIDTH * 2,
                              BOX_INNER_HEIGHT * 2], center = true);
                }
            }

            cable_clamp_teeth_top();

            // ===== 合盖四角导孔柱（承接自底面拧入的螺丝）=====
            for (sx = [-1, 1], sy = [-1, 1]) {
                bh = boss_h - boss_base;
                translate([sx * BOSS_X, sy * BOSS_Y, boss_base])
                    difference() {
                        union() {
                            cylinder(d = BOSS_DIAMETER,
                                     h = max(bh - BOSS_REINFORCE_H, 0.1),
                                     $fn = 32);
                            translate([0, 0, max(bh - BOSS_REINFORCE_H, 0)])
                                cylinder(d1 = BOSS_DIAMETER,
                                         d2 = BOSS_REINFORCE_OD,
                                         h = min(BOSS_REINFORCE_H, bh),
                                         $fn = 32);
                        }
                        translate([0, 0, -0.1])
                            cylinder(d = BOSS_PILOT_HOLE,
                                     h = bh + 0.2, $fn = 24);
                    }
            }
        }

        // 顶面不开合盖沉头孔 — 仅旋钮 / 数码窗
        module_cavity_top();
        module_windows_top();
        alignment_groove();

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
        linear_extrude(height = gh)
            rounded_rect_2d(gox * 2, goy * 2,
                            max(CORNER_RADIUS - WALL_THICKNESS + ALIGNMENT_LIP_W,
                                0.5));
        translate([0, 0, -0.1])
        linear_extrude(height = gh + 0.2)
            rounded_rect_2d(gix * 2, giy * 2,
                            max(CORNER_RADIUS - WALL_THICKNESS, 0.5));
    }
}
