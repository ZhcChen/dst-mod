# 蜂群驯化师 Mod 开发指南

## 快捷命令

### 上传 mod
当用户说"上传mod"时，执行以下命令：
```bash
steamcmd +login 1406736605 +workshop_build_item /Users/chen/code/dst-mod/mods/bee-tamer/workshop_upload.vdf +quit
```

### 同步到本地
当用户说"同步mod"时，执行：
```bash
bash /Users/chen/code/dst-mod/mods/bee-tamer/sync_to_game.sh
```

## 项目结构

- `modmain.lua` - Mod 入口文件
- `modinfo.lua` - Mod 元信息
- `scripts/prefabs/` - Prefab 定义
- `scripts/components/` - 自定义组件
- `images/inventoryimages/` - 物品图标
