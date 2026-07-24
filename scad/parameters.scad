// ============================================================
// 理疗仪线缆串联保护盒 — 全局参数（v2 调速器）
// therapy-cable-inline-box-for-physio
//
// 模组：Synairy ESC-Adaptor V02（插针拆除，焊线引出）
// 布局：自板左缘 10~15 轴 / 18.5~27 数码管；二者板宽居中
// ============================================================

// ===== 分区：常量/配置 =====

// ---- 模组 PCB（32×12，插针不计）----
MODULE_LENGTH       = 32.0;
MODULE_WIDTH        = 12.0;
MODULE_PCB_THICK    = 1.6;
MODULE_CLEARANCE    = 0.6;

// 模组安装孔（板心坐标）— 盒内螺丝锁入下半罗马柱
// 对角：距左上 / 右下顶点 X、Y 各约 1.5mm
MODULE_HOLE_DIAM    = 2.0;
MODULE_HOLE_INSET   = 1.5;
MODULE_HOLES = [
    [-(MODULE_LENGTH/2 - MODULE_HOLE_INSET),  +(MODULE_WIDTH/2 - MODULE_HOLE_INSET)], // 左上 → (-14.5, +4.5)
    [+(MODULE_LENGTH/2 - MODULE_HOLE_INSET),  -(MODULE_WIDTH/2 - MODULE_HOLE_INSET)]  // 右下 → (+14.5, -4.5)
];

// ---- 电位器轴（板左缘 10~15mm，板宽居中）----
// 板心坐标：X = (10+15)/2 - 16 = -3.5
KNOB_CENTER_X       = -3.5;
KNOB_CENTER_Y       =  0.0;
KNOB_SHAFT_DIAM     =  5.0;
KNOB_WINDOW_DIAM    =  6.5;     // 开孔加大，消化打印公差、保证轴易装
KNOB_BODY_DIAM      = 10.0;
// 腔内净高：罗马柱顶面以上到顶盖内壁 = 7.5（装板不晃、轴能露出）
KNOB_CAVITY_H       =  7.5;
KNOB_BODY_HEIGHT    = KNOB_CAVITY_H;  // 电位器本体占满该净高
KNOB_CAP_DIAM       = 10.7;
KNOB_CAP_HEIGHT     = 10.0;

// ---- 数码管（板左缘 18.5~27mm，长边 12，板宽居中）----
// 板心：X = (18.5+27)/2 - 16 = 6.75；沿板长 8.5，沿板宽 12
DISPLAY_CENTER_X    =  6.75;
DISPLAY_CENTER_Y    =  0.0;
DISPLAY_SIZE_X      =  8.5;     // 18.5~27
DISPLAY_SIZE_Y      = 12.0;     // 长边
DISPLAY_WINDOW_GAP  =  0.2;
DISPLAY_HEIGHT_ABOVE = 6.5;     // 可调：壳内数码管高度

// ---- 线缆 ----
CABLE_DIAMETER      = 5.0;
CABLE_STRIP_LENGTH  = 18.0;

// ---- 壳体内腔 ----
// 上半内高 = KNOB_CAVITY_H（PCB 顶在分型面）；下半对称
BOX_INNER_LENGTH    = 70.0;
BOX_INNER_WIDTH     = 22.0;
BOX_INNER_HEIGHT    = KNOB_CAVITY_H * 2;  // 15：上半 7.5 给旋钮柱

WALL_THICKNESS      = 1.6;
BOX_OUTER_LENGTH    = BOX_INNER_LENGTH + WALL_THICKNESS * 2;
BOX_OUTER_WIDTH     = BOX_INNER_WIDTH  + WALL_THICKNESS * 2;
BOX_OUTER_HEIGHT    = BOX_INNER_HEIGHT + WALL_THICKNESS * 2;
BOX_HALF_INNER_H    = BOX_INNER_HEIGHT / 2;

CORNER_RADIUS       = 3.0;

// ---- 合盖螺丝 Boss（壳外 4 颗 M2，四角）----
BOSS_DIAMETER       = 5.0;
BOSS_PILOT_HOLE     = 1.7;
BOSS_REINFORCE_OD   = 7.5;
BOSS_REINFORCE_H    = 2.5;
BOSS_X              = 28.0;
BOSS_Y              =  7.5;
SCREW_CLEARANCE     = 2.3;
SCREW_HEAD_DIAMETER = 5.0;
SCREW_HEAD_DEPTH    = 1.8;

// ---- 模组罗马柱（盒内锁 PCB，仅下半）----
MODULE_BOSS_DIAMETER     = 5.0;
MODULE_BOSS_PILOT        = 1.7;
MODULE_BOSS_REINFORCE_OD = 7.0;
MODULE_BOSS_REINFORCE_H  = 2.0;

PCB_TOP_Z           = 0.0;
PCB_BOTTOM_Z        = PCB_TOP_Z - MODULE_PCB_THICK;

// ---- 电缆出线孔 ----
GLAND_HOLE_DIAM     = 5.4;
GLAND_WALL_EXTRA    = 1.5;
GLAND_OUTER_EXTEND  = 0.0;

ALIGNMENT_LIP_H     = 0.8;
ALIGNMENT_LIP_W     = 0.8;
PRINT_TOLERANCE     = 0.2;

VISUAL = false;
$fn = 64;
