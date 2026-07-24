// ============================================================
// 下半壳体 — Z ≤ 0，分型面在 Z=0
// - 四角 Boss：壳外 M2 合盖
// - 模组罗马柱：盒内螺丝锁 PCB（与线缆立柱错开）
// ============================================================
include <parameters.scad>
include <utilities.scad>
include <module-holder.scad>
include <cable-gland.scad>
include <cable-strain-relief.scad>

// ===== 分区：公开 API =====

module bottom_half() {
    half_h = BOX_HALF_INNER_H;
    r_outer = CORNER_RADIUS;
    r_inner = max(r_outer - WALL_THICKNESS, 0.5);
    shell_boss_h = half_h;                      // 合盖柱到分型面
    module_boss_h = half_h + PCB_BOTTOM_Z;      // 罗马柱到 PCB 底

    difference() {
        union() {
            difference() {
                difference() {
                    intersection() {
                        rounded_rect_prism(
                            BOX_OUTER_LENGTH, BOX_OUTER_WIDTH, BOX_OUTER_HEIGHT,
                            r_outer, center = true);
                        translate([0, 0, -BOX_OUTER_HEIGHT])
                            cube([BOX_OUTER_LENGTH * 2, BOX_OUTER_WIDTH * 2,
                                  BOX_OUTER_HEIGHT * 2], center = true);
                    }
                    intersection() {
                        rounded_rect_prism(
                            BOX_INNER_LENGTH, BOX_INNER_WIDTH, BOX_INNER_HEIGHT,
                            r_inner, center = true);
                        translate([0, 0, -BOX_INNER_HEIGHT])
                            cube([BOX_INNER_LENGTH * 2, BOX_INNER_WIDTH * 2,
                                  BOX_INNER_HEIGHT * 2], center = true);
                    }
                }
                module_cavity_bottom();
            }

            // ===== 合盖四角 Boss =====
            for (sx = [-1, 1], sy = [-1, 1]) {
                translate([sx * BOSS_X, sy * BOSS_Y, -half_h]) {
                    cylinder(d1 = BOSS_REINFORCE_OD, d2 = BOSS_DIAMETER,
                             h = min(BOSS_REINFORCE_H, shell_boss_h), $fn = 32);
                    if (shell_boss_h > BOSS_REINFORCE_H)
                        translate([0, 0, BOSS_REINFORCE_H])
                            cylinder(d = BOSS_DIAMETER,
                                     h = shell_boss_h - BOSS_REINFORCE_H,
                                     $fn = 32);
                }
            }

            // ===== 模组罗马柱（盒内锁 PCB）=====
            for (p = MODULE_HOLES) {
                translate([p[0], p[1], -half_h]) {
                    cylinder(d1 = MODULE_BOSS_REINFORCE_OD,
                             d2 = MODULE_BOSS_DIAMETER,
                             h = min(MODULE_BOSS_REINFORCE_H, module_boss_h),
                             $fn = 32);
                    if (module_boss_h > MODULE_BOSS_REINFORCE_H)
                        translate([0, 0, MODULE_BOSS_REINFORCE_H])
                            cylinder(d = MODULE_BOSS_DIAMETER,
                                     h = module_boss_h - MODULE_BOSS_REINFORCE_H,
                                     $fn = 32);
                }
            }

            cable_clamp_teeth_bottom();
            cable_guide_posts_bottom();
            alignment_lip();
        }

        // 合盖导孔
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * BOSS_X, sy * BOSS_Y, -half_h - 0.1])
                cylinder(d = BOSS_PILOT_HOLE, h = shell_boss_h + 0.4, $fn = 24);
        }

        // 模组罗马柱导孔
        for (p = MODULE_HOLES) {
            translate([p[0], p[1], -half_h - 0.1])
                cylinder(d = MODULE_BOSS_PILOT,
                         h = module_boss_h + 0.4, $fn = 24);
        }

        for (mx = [-1, 1]) {
            translate([mx * BOX_OUTER_LENGTH / 2, 0, 0])
                cable_channel_half_bottom();
        }
    }
}

module alignment_lip() {
    lh  = ALIGNMENT_LIP_H;
    lw  = ALIGNMENT_LIP_W;
    lox = BOX_INNER_LENGTH / 2 + lw;
    loy = BOX_INNER_WIDTH  / 2 + lw;
    lix = BOX_INNER_LENGTH / 2 - PRINT_TOLERANCE;
    liy = BOX_INNER_WIDTH  / 2 - PRINT_TOLERANCE;

    difference() {
        linear_extrude(height = lh)
            rounded_rect_2d(lox * 2, loy * 2,
                            max(CORNER_RADIUS - WALL_THICKNESS + lw, 0.5));
        translate([0, 0, -0.1])
        linear_extrude(height = lh + 0.2)
            rounded_rect_2d(lix * 2, liy * 2,
                            max(CORNER_RADIUS - WALL_THICKNESS, 0.5));
    }
}
