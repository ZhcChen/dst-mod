#!/usr/bin/env python3
"""
Klei TEX 格式转换工具
将 PNG 图片转换为 Don't Starve 游戏使用的 TEX 格式

参考: https://forums.kleientertainment.com/forums/topic/60137-guide-what-is-a-tex-file-and-how-to-make-one/
"""

import os
import sys
import struct
from PIL import Image

# TEX 文件头魔数
KTEX_MAGIC = b'KTEX'

# 像素格式
PIXEL_FORMAT_DXT1 = 0
PIXEL_FORMAT_DXT3 = 1
PIXEL_FORMAT_DXT5 = 2
PIXEL_FORMAT_ARGB = 4
PIXEL_FORMAT_RGB = 5

# 纹理类型
TEXTURE_TYPE_2D = 0

def png_to_tex(png_path, tex_path=None):
    """
    将 PNG 转换为 TEX 格式

    Args:
        png_path: PNG 文件路径
        tex_path: 输出 TEX 文件路径（可选）
    """
    if tex_path is None:
        tex_path = os.path.splitext(png_path)[0] + '.tex'

    # 打开图片
    img = Image.open(png_path)

    # 确保是 RGBA 格式
    if img.mode != 'RGBA':
        img = img.convert('RGBA')

    width, height = img.size

    # 获取像素数据
    pixels = img.tobytes()

    # 转换为 BGRA 格式（Klei 使用 BGRA）
    bgra_pixels = bytearray()
    for i in range(0, len(pixels), 4):
        r, g, b, a = pixels[i:i+4]
        bgra_pixels.extend([b, g, r, a])

    # 构建 TEX 文件
    with open(tex_path, 'wb') as f:
        # 写入魔数
        f.write(KTEX_MAGIC)

        # 写入头部信息 (32 位值)
        # 格式: platform | pixel_format | texture_type | mipmap_count | flags
        # 简化版本：使用 ARGB 格式，无 mipmap
        header = 0
        header |= (0 & 0xF)           # platform: 0 = default
        header |= ((PIXEL_FORMAT_ARGB & 0x1F) << 4)   # pixel format
        header |= ((TEXTURE_TYPE_2D & 0xF) << 9)      # texture type
        header |= ((1 & 0x1F) << 13)  # mipmap count = 1
        header |= ((3 & 0x3) << 18)   # flags = 3 (pre-cave format)

        f.write(struct.pack('<I', header))

        # Mipmap 信息
        f.write(struct.pack('<H', width))
        f.write(struct.pack('<H', height))
        f.write(struct.pack('<H', 1))  # pitch (简化)
        f.write(struct.pack('<I', len(bgra_pixels)))  # data size

        # 写入像素数据
        f.write(bytes(bgra_pixels))

    print(f"转换完成: {png_path} -> {tex_path}")
    return tex_path


def generate_xml(tex_name, width, height, xml_path=None):
    """
    生成对应的 XML atlas 文件

    Args:
        tex_name: TEX 文件名（不含路径）
        width: 图片宽度
        height: 图片高度
        xml_path: 输出 XML 文件路径
    """
    if xml_path is None:
        xml_path = os.path.splitext(tex_name)[0] + '.xml'

    # 元素名（不含扩展名）
    element_name = os.path.splitext(tex_name)[0]

    xml_content = f'''<Atlas>
    <Texture filename="{tex_name}" />
    <Elements>
        <Element name="{element_name}.tex" u1="0" u2="1" v1="0" v2="1" />
    </Elements>
</Atlas>
'''

    with open(xml_path, 'w') as f:
        f.write(xml_content)

    print(f"生成 XML: {xml_path}")
    return xml_path


def convert_inventory_icon(png_path, output_dir=None):
    """
    转换物品栏图标（完整流程）

    Args:
        png_path: PNG 文件路径
        output_dir: 输出目录（可选）
    """
    if output_dir is None:
        output_dir = os.path.dirname(png_path)

    # 获取文件名
    basename = os.path.basename(png_path)
    name_without_ext = os.path.splitext(basename)[0]

    # 打开图片获取尺寸
    img = Image.open(png_path)
    width, height = img.size

    # 转换 TEX
    tex_path = os.path.join(output_dir, name_without_ext + '.tex')
    png_to_tex(png_path, tex_path)

    # 生成 XML
    xml_path = os.path.join(output_dir, name_without_ext + '.xml')
    generate_xml(name_without_ext + '.tex', width, height, xml_path)

    print(f"完成: {name_without_ext}")
    return tex_path, xml_path


def main():
    if len(sys.argv) < 2:
        print("用法: python tex_converter.py <png_file> [output_dir]")
        print("      python tex_converter.py --batch <directory>")
        sys.exit(1)

    if sys.argv[1] == '--batch':
        # 批量转换目录下所有 PNG
        directory = sys.argv[2] if len(sys.argv) > 2 else '.'
        for filename in os.listdir(directory):
            if filename.lower().endswith('.png'):
                png_path = os.path.join(directory, filename)
                convert_inventory_icon(png_path)
    else:
        # 单个文件转换
        png_path = sys.argv[1]
        output_dir = sys.argv[2] if len(sys.argv) > 2 else None
        convert_inventory_icon(png_path, output_dir)


if __name__ == '__main__':
    main()
