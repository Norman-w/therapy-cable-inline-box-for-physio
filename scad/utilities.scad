// ============================================================
// 通用工具模块 — 圆角几何体
// ============================================================

// 2D 圆角矩形（用于 linear_extrude 的底面）
// x, y: 矩形尺寸, r: 圆角半径
module rounded_rect_2d(x, y, r) {
    hull() {
        for (ix = [-1, 1], iy = [-1, 1]) {
            translate([ix * (x/2 - r), iy * (y/2 - r), 0])
                circle(r = r, $fn = max(16, $fn/4));
        }
    }
}

// 3D 圆角长方体 — 所有 12 条边 + 8 个角均为圆角
// x, y, z: 长方体尺寸（沿各轴全长）, r: 圆角半径
// center=true 时几何体居中
module rounded_rect_prism(x, y, z, r, center = false) {
    x_off = center ? 0 : x/2;
    y_off = center ? 0 : y/2;
    z_off = center ? 0 : z/2;

    translate([x_off, y_off, z_off])
    hull() {
        for (ix = [-1, 1], iy = [-1, 1], iz = [-1, 1]) {
            translate([ix * (x/2 - r), iy * (y/2 - r), iz * (z/2 - r)])
                sphere(r = r, $fn = max(24, $fn/3));
        }
    }
}

// 圆角矩形壳体 — 带壁厚的中空圆角长方体
// outer_x/y/z: 外部尺寸, wall: 壁厚, r_outer: 外角圆角
// 内角自动计算
module rounded_shell(outer_x, outer_y, outer_z, wall, r_outer) {
    r_inner = max(r_outer - wall, 0.5);
    inner_x = outer_x - wall * 2;
    inner_y = outer_y - wall * 2;
    inner_z = outer_z - wall * 2;

    difference() {
        rounded_rect_prism(outer_x, outer_y, outer_z, r_outer);
        translate([0, 0, wall])
            rounded_rect_prism(inner_x, inner_y, inner_z + 0.2, r_inner);
    }
}
