// ============================================================
// 下半壳体 — Z ≤ 0，分型面在 Z=0
// 重构：先切电阻腔 → 再加 Boss柱+挡柱 → 最后切线缆孔
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

    difference() {  // === 最终切除 ===
        union() {

            // ===== 阶段 1: 挖空壳体 =====
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
            }

            // ===== 阶段 2: 添加到已切割完成的壳体上 =====
            // Boss 柱
            for (sx = [-1, 1], sy = [-1, 1]) {
                boss_top = half_h;  // 不分型面端，到齐
                translate([sx * BOSS_X, sy * BOSS_Y, -half_h]) {
                    cylinder(d1 = BOSS_REINFORCE_OD, d2 = BOSS_DIAMETER,
                             h  = BOSS_REINFORCE_H, $fn = 32);
                    translate([0, 0, BOSS_REINFORCE_H])
                        cylinder(d = BOSS_DIAMETER, h = boss_top - BOSS_REINFORCE_H, $fn = 32);
                }
            }

            // 线缆锯齿压紧（下半，齿尖向上，3齿）
            cable_clamp_teeth_bottom();

            // 线缆夹持柱
            cable_guide_posts_bottom();

            // 定位凸缘
            alignment_lip();
        }

        // ===== 最终切除：Boss 导孔 =====
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * BOSS_X, sy * BOSS_Y, -half_h - 0.1])
                cylinder(d = BOSS_PILOT_HOLE, h = half_h + 0.4, $fn = 24);
        }

        // ===== 最终切除：电缆通道（会切过挡柱，形成线缆导槽）=====
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
