// ============================================================
// 下半壳体 — Z ≤ 0，分型面在 Z=0
// Boss 柱从底板到分型面，与上半 Boss 柱对接
// ============================================================
include <parameters.scad>
include <utilities.scad>
include <resistor-holder.scad>
include <cable-gland.scad>

module bottom_half() {
    half_h = BOX_HALF_INNER_H;
    r_outer = CORNER_RADIUS;
    r_inner = max(r_outer - WALL_THICKNESS, 0.5);

    difference() {
        union() {
            // ===== 挖空的壳体 =====
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

            // ===== Boss 柱 ×4（根部锥形加固，从内底板到分型面）=====
            for (sx = [-1, 1], sy = [-1, 1]) {
                translate([sx * BOSS_X, sy * BOSS_Y, -half_h]) {
                    // 锥形根部：Φ8 过渡到 Φ5
                    cylinder(d1 = BOSS_REINFORCE_OD,
                             d2 = BOSS_DIAMETER,
                             h  = BOSS_REINFORCE_H, $fn = 32);
                    // 直柱段
                    translate([0, 0, BOSS_REINFORCE_H])
                        cylinder(d = BOSS_DIAMETER,
                                 h = half_h - BOSS_REINFORCE_H, $fn = 32);
                }
            }

            // ===== 定位凸缘 =====
            alignment_lip();
        }

        // ===== Boss 导孔（贯穿锥形底座 + 直柱段）=====
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * BOSS_X, sy * BOSS_Y, -half_h - 0.1])
                cylinder(d = BOSS_PILOT_HOLE, h = half_h + 0.4, $fn = 24);
        }

        // ===== 电阻型腔 =====
        resistor_cavity_bottom(half_h * 0.7);

        // ===== 电缆通道 =====
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
        translate([0, 0, 0])
        linear_extrude(height = lh)
            rounded_rect_2d(lox * 2, loy * 2,
                            max(CORNER_RADIUS - WALL_THICKNESS + lw, 0.5));
        translate([0, 0, -0.1])
        linear_extrude(height = lh + 0.2)
            rounded_rect_2d(lix * 2, liy * 2,
                            max(CORNER_RADIUS - WALL_THICKNESS, 0.5));
    }
}
