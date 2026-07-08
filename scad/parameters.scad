// ============================================================
// 理疗仪线缆串联电阻保护盒 — 全局参数
// therapy-cable-inline-box-for-physio
// ============================================================

// ---- 电阻参数 (5W 水泥电阻，矩形封装) ----
RESISTOR_BODY_WIDTH  = 9.0;     // 电阻体宽度 mm（垂直 X 轴）
RESISTOR_BODY_HEIGHT = 9.0;     // 电阻体高度 mm（垂直 Z 轴）
RESISTOR_BODY_LENGTH = 22.0;    // 电阻体长度 mm（沿 X 轴 / 线缆方向）
RESISTOR_LEAD_DIAMETER = 0.8;   // 引脚线径 mm
RESISTOR_LEAD_LENGTH   = 8.0;   // 引脚保留长度（焊接端）
RESISTOR_CLEARANCE     = 0.4;   // 型腔与电阻体间隙

// ---- 线缆参数 ----
CABLE_DIAMETER      = 5.0;      // 线缆外径 mm
CABLE_STRIP_LENGTH  = 20.0;     // 剥线长度（电阻 + 焊接区域）

// ---- 壳体参数 ----
WALL_THICKNESS      = 1.6;      // 壁厚 mm（FDM 0.4mm 喷嘴 × 4 层）
BOX_INNER_LENGTH    = 50.0;     // 内部长度 mm
BOX_INNER_WIDTH     = 20.0;     // 内部宽度 mm
BOX_INNER_HEIGHT    = 18.0;     // 内部总高度 mm（= 每半 9mm）

// 导出尺寸
BOX_OUTER_LENGTH    = BOX_INNER_LENGTH + WALL_THICKNESS * 2;
BOX_OUTER_WIDTH     = BOX_INNER_WIDTH  + WALL_THICKNESS * 2;
BOX_OUTER_HEIGHT    = BOX_INNER_HEIGHT + WALL_THICKNESS * 2;
BOX_HALF_INNER_H    = BOX_INNER_HEIGHT / 2;  // 每半内腔深度

// ---- 圆角参数 ----
CORNER_RADIUS       = 3.0;      // 外角圆角半径 mm

// ---- Boss 柱 / 螺丝参数 (M2 自攻螺丝) ----
BOSS_DIAMETER       = 5.0;      // Boss 柱外径
BOSS_PILOT_HOLE     = 1.7;      // M2 自攻导孔直径
BOSS_REINFORCE_OD   = 8.0;      // Boss 柱根部加固外径
BOSS_REINFORCE_H     = 3.0;      // 锥形加固段高度
BOSS_X              = 17.0;     // Boss 柱 X 偏移（距中心，给挡柱留空间）
BOSS_Y              = 7.0;      // Boss 柱 Y 偏移（距中心）
SCREW_CLEARANCE     = 2.3;      // 上半壳体螺丝通孔
SCREW_HEAD_DIAMETER = 5.0;      // 沉头孔直径（M2 pan head）
SCREW_HEAD_DEPTH    = 1.8;      // 沉头孔深度
SCREW_BOSS_OD       = 6.5;      // 上半螺丝位凸台外径（壳体外的定位圆柱）
SCREW_BOSS_HEIGHT   = 0.6;      // 凸台高度

// ---- 电缆出线孔 ----
// 孔只穿过壁厚 + 少量延伸，不深入内腔，避免打到内部结构
GLAND_HOLE_DIAM     = 5.4;      // 出线孔径（CABLE 5mm + 0.4 间隙）
GLAND_WALL_EXTRA    = 1.5;      // 壁厚之外的额外延伸（向内多 0.5mm）

// ---- 定位结构 ----
ALIGNMENT_LIP_H     = 0.8;      // 分型面定位凸缘高度
ALIGNMENT_LIP_W     = 1.2;      // 凸缘宽度

// ---- 打印公差 ----
PRINT_TOLERANCE     = 0.2;      // 配合面公差

// ===== 视觉模式 =====
VISUAL = false;  // true=分色装配展示, false=仅下半壳体（导出模式）

$fn = 64;  // 全局圆滑度
