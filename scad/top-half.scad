// ============================================================
// 上半壳体 — Z ≥ 0，分型面在 Z=0
// Boss 柱从内顶面到分型面，与下半 Boss 柱同外径对接
// ============================================================
include <parameters.scad>
include <utilities.scad>
include <resistor-holder.scad>
include <cable-gland.scad>

module top_half() {
    half_h = BOX_HALF_INNER_H;             // = 9mm
    r_outer = CORNER_RADIUS;
    r_inner = max(r_outer - WALL_THICKNESS, 0.5);

    // 上半 Boss 柱：外径同下半 Φ5，内孔 Φ2.3（螺丝通孔）
    top_boss_od = BOSS_DIAMETER;            // = 5mm
    top_boss_id = SCREW_CLEARANCE;          // = 2.3mm

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

            // ===== Boss 柱 ×4（内顶面根部锥形加固，到分型面与下半对接）=====
            for (sx = [-1, 1], sy = [-1, 1]) {
                translate([sx * BOSS_X, sy * BOSS_Y, 0])
                    difference() {
                        union() {
                            // 直柱段（分型面到锥形根部）
                            cylinder(d = top_boss_od,
                                     h = half_h - BOSS_REINFORCE_H, $fn = 32);
                            // 锥形根部（Φ5 过渡到 Φ8，在内顶面处加粗）
                            translate([0, 0, half_h - BOSS_REINFORCE_H])
                                cylinder(d1 = top_boss_od,
                                         d2 = BOSS_REINFORCE_OD,
                                         h  = BOSS_REINFORCE_H, $fn = 32);
                        }
                        // 内孔
                        translate([0, 0, -0.1])
                            cylinder(d = top_boss_id,
                                     h = half_h + 0.2, $fn = 32);
                    }
            }
        }

        // ===== 锥形沉头孔 ×4（锥尖嵌入 Boss 内孔 0.5mm，消除薄面）=====
        for (sx = [-1, 1], sy = [-1, 1]) {
            // 锥体从内顶面下方 0.5mm 开始，确保与 Boss 内孔重叠
            translate([sx * BOSS_X, sy * BOSS_Y, half_h - 0.5])
                cylinder(d1 = SCREW_CLEARANCE,
                         d2 = SCREW_HEAD_DIAMETER,
                         h  = WALL_THICKNESS + 0.6, $fn = 32);
        }

        // ===== 定位凹槽 =====
        alignment_groove();

        // ===== 电阻上盖凹槽 =====
        resistor_cavity_top(half_h * 0.35);

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
