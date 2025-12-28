# shellcheck shell=ash
# Tick customize.sh
#
# ---------------------------------------------------------------------------------------
# CUSTOM INSTALLATION LOGIC
# ---------------------------------------------------------------------------------------
[ -f "$MODPATH/lib/kamfw/.kamfwrc" ] && . "$MODPATH/lib/kamfw/.kamfwrc" || abort '! File "kamfw/.kamfwrc" does not exist!'
# 作者注：导入以上工具库，会自动依据ROOT管理器
# 进行一些特殊处理
# 比如，如果是magisk.补全META-INF
# boot-completed --> service
# 记得在boot-completed调用：
# wait_boot_if_magisk
# 详见 lib/kamfw/magisk.sh
# lib/kamfw/ksu.sh
# lib/kamfw/ap.sh
import __customize__
# i18n
import i18n
import lang

# 任务一：模块使用指南
set_i18n "USAGE_GUIDE" \
    "zh" "使用教程：\n1. 概述：Tick 基于 pueue，按需启动守护进程（Lazy-Start）。\n2. 注册任务（推荐在模块的 service.sh 中）：\n   示例：\n   if [ -f \"/system/bin/tick\" ]; then\n       tick reg \"\${MODID}:optimize\" \"15m\" \"sh \${MODDIR}/scripts/opt.sh\"\n   fi\n3. 常用命令：\n   - tick reg \"MODID:task\" \"TIME\" \"CMD\" — 注册/更新任务\n   - tick unreg \"MODID:task\" — 注销任务\n   - tick st / tick status — 查看状态\n   - tick log \"MODID:task\" — 查看日志\n4. 时间格式：支持缩写（\"30s\", \"15m\", \"1h\", \"2d\"）和标准 Cron 表达式（\"0 3 * * *\"）。\n5. 存放位置：/data/adb/tick（目录权限 700），配置文件 pueue.yml（权限 600）。\n6. 调试：若任务未运行，检查 pueue 二进制是否与设备 ABI 匹配，及 /data/adb/tick/pueue.yml 的权限。" \
    "en" "Usage guide:\n1. Overview: Tick is a tiny scheduling wrapper around pueue that starts the daemon lazily.\n2. Register tasks (recommended in your module's service.sh):\n   Example:\n   if [ -f \"/system/bin/tick\" ]; then\n       tick reg \"\${MODID}:optimize\" \"15m\" \"sh \${MODDIR}/scripts/opt.sh\"\n   fi\n3. Common commands:\n   - tick reg \"MODID:task\" \"TIME\" \"CMD\" — register/update a job\n   - tick unreg \"MODID:task\" — unregister a job\n   - tick st / tick status — show tasks & daemon status\n   - tick log \"MODID:task\" — view logs\n4. Time formats: supports shorthands (\"30s\", \"15m\", \"1h\", \"2d\") and standard cron (\"0 3 * * *\").\n5. Paths & perms: runtime dir is /data/adb/tick (700), pueue.yml should be 600.\n6. Troubleshooting: check that bundled pueue matches the device ABI and pueue.yml permissions." \
    "ja" "使用方法：\n  1. 概要：Tick は pueue をラップした軽量なスケジューラです。\n  2. タスクの登録は service.sh で行うことを推奨します。" \
    "ko" "사용 안내：\n  1. 개요: Tick 은 pueue 를 래핑한 경량 스케줄러입니다.\n  2. 작업 등록은 module 의 service.sh 에서 수행하세요."

# print： ui_print plus
print "$(i18n "USAGE_GUIDE")"

# 安装检查与权限设置（将尽量在安装阶段做最小可行性检查并设置权限）
set_i18n "INSTALL_CHECK" \
    "zh" "正在安装：检查设备兼容性与内置二进制..." \
    "en" "Installing: checking device compatibility and bundled binaries..." \
    "ja" "インストール: デバイスの互換性とバイナリを確認しています..." \
    "ko" "설치 중: 기기 호환성 및 번들 바이너리 확인 중..."

set_i18n "INSTALL_OK" \
    "zh" "安装成功：权限设置完毕，运行目录已初始化。" \
    "en" "Install successful: permissions set and runtime directory initialized." \
    "ja" "インストール成功: パーミッションが設定され、ランタイムディレクトリが初期化されました。" \
    "ko" "설치 성공: 권한이 설정되고 런타임 디렉터리가 초기화되었습니다."

print "$(i18n "INSTALL_CHECK")"

print "$(i18n "INSTALL_OK")"

import launcher
launch url "https://github.com/LIghtJUNction/Tick"

# import rich --> 这里有更多，比如 ask函数 confirm函数

##################################
# 备忘文档 -- 可删除               #
# You can delete this section    #
##################################
# This script is sourced by the module installer script after all files are extracted
# and default permissions/secontext are applied.
#
# Useful for:
# - Checking device compatibility (ARCH, API)
# - Setting special permissions
# - Customizing installation based on user environment
#
# ---------------------------------------------------------------------------------------
# AVAILABLE VARIABLES
# ---------------------------------------------------------------------------------------
# (KernelSU-only) KSU (bool):           true if running in KernelSU environment
# (KernelSU-only) KSU_VER (string):     KernelSU version string (e.g. v0.9.5)
# (KernelSU-only) KSU_VER_CODE (int):   KernelSU version code (userspace)
# (KernelSU-only) KSU_KERNEL_VER_CODE (int): KernelSU version code (kernel space)
# NOTE: KernelSU variables are only provided by KernelSU (not guaranteed on stock Magisk).
# Guard usage example:
#    if [ "$KSU" = "true" ]; then
#        # KernelSU-only logic
#    else
#        # Fallback for Magisk/APatch or other environments
#    fi
#
# KernelPatch/KernelSU/APatch related variables
# (KernelPatch-only) KERNELPATCH (bool):   true if running in KernelPatch environment
# (KernelPatch-only) KERNEL_VERSION (hex): Kernel version inherited from KernelPatch (e.g. 50a01 -> 5.10.1)
# (KernelPatch-only) KERNELPATCH_VERSION (hex): KernelPatch version identifier (e.g. a05 -> 0.10.5)
# (KernelPatch-only) SUPERKEY (string):    Value provided by KernelPatch for invoking kpatch/supercall
# NOTE: The KernelPatch variables above are provided by KernelPatch and may NOT exist on a stock Magisk installation.
#       If your module must work on both, check for their presence before using them:
#         if [ -n "$KERNELPATCH" ] && [ "$KERNELPATCH" = "true" ]; then
#           # KernelPatch-specific handling
#         fi
#
# APatch related variables
# (APatch-only) APATCH (bool):        true if running in APatch environment
# (APatch-only) APATCH_VER_CODE (int): APatch current version code (e.g. 10672)
# (APatch-only) APATCH_VER (string):  APatch version string (e.g. "10672")
# NOTE: The APatch variables above are specific to APatch (a Magisk fork). They are NOT guaranteed to exist on stock Magisk.
#       Guard your scripts like:
#         if [ "$APATCH" = "true" ]; then
#           # APatch-specific logic
#         fi
#
# Common environment variables (present across environments)
# BOOTMODE (bool):      always true in KernelSU and APatch (recovery / boot mode)
# MODPATH (path):       Path where module files are installed (e.g. /data/adb/modules/Tick)
# TMPDIR (path):        Path to temporary directory
# ZIPFILE (path):       Path to the installation ZIP
# ARCH (string):        Device architecture: arm, arm64, x86, x64
# IS64BIT (bool):       true if ARCH is arm64 or x64
# API (int):            Android API level (e.g. 33 for Android 13)
#
# WARNING:
# - In APatch, MAGISK_VER_CODE is typically 27000 and MAGISK_VER is 27.0 (so some Magisk-related checks behave differently).
# - Many KernelPatch/APatch features are not present on stock Magisk. When writing portable installation code,
#   explicitly check for variable presence and provide sensible fallbacks:
#     if [ -n "$APATCH" ] && [ "$APATCH" = "true" ]; then
#         # APatch-only handling
#     else
#         # Stock Magisk fallback handling (or skip)
#     fi
#
# ---------------------------------------------------------------------------------------
# AVAILABLE FUNCTIONS
# ---------------------------------------------------------------------------------------
# ui_print <msg>
#     Print message to console. Avoid 'echo'.
#
# abort <msg>
#     Print error message and terminate installation.
#
# set_perm <target> <owner> <group> <permission> [context]
#     Set permissions for a file.
#     Default context: "u:object_r:system_file:s0"
#
# set_perm_recursive <dir> <owner> <group> <dirperm> <fileperm> [context]
#     Recursively set permissions for a directory.
#     Default context: "u:object_r:system_file:s0"
#
# ---------------------------------------------------------------------------------------
# KERNELSU FEATURES
# ---------------------------------------------------------------------------------------
#
# REMOVE (Whiteout):
# List directories/files to be "removed" from the system (overlaid with whiteout).
# KernelSU executes: mknod <TARGET> c 0 0
#
# REMOVE="
# /system/app/BloatwareApp
# /system/priv-app/AnotherApp
# "
#
# REPLACE (Opaque):
# List directories to be replaced by an empty directory (or your module's version).
# KernelSU executes: setfattr -n trusted.overlay.opaque -v y <TARGET>
#
# REPLACE="
# /system/app/YouTube
# "
#
