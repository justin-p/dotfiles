#!/usr/bin/env python3
"""Generate bearded-gold Plymouth theme assets from pop-basic."""

from __future__ import annotations

import shutil
import struct
import subprocess
import sys
import tempfile
import zlib
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
OUT_DIR = SCRIPT_DIR / "bearded-gold"
SOURCE_DIR = Path("/usr/share/plymouth/themes/pop-basic")
LOCK_SVG = SCRIPT_DIR / "assets" / "padlock-f.svg"

GOLD_HEX = "#e39000"
GOLD = (0xE3, 0x90, 0x00, 255)
ACCENT_LINE_ROWS = 2


def write_rgba_png(path: Path, width: int, height: int, rgba: bytes) -> None:
    def chunk(tag: bytes, data: bytes) -> bytes:
        body = tag + data
        return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body) & 0xFFFFFFFF)

    raw = b"".join(b"\x00" + rgba[y * width * 4 : (y + 1) * width * 4] for y in range(height))
    compressed = zlib.compress(raw, 9)
    ihdr = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)
    png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", compressed) + chunk(b"IEND", b"")
    path.write_bytes(png)


def png_size(path: Path) -> tuple[int, int]:
    with path.open("rb") as f:
        f.read(8)
        f.read(4)
        assert f.read(4) == b"IHDR"
        return struct.unpack(">II", f.read(8))


def transparent_like(source: Path, dest: Path) -> None:
    width, height = png_size(source)
    write_rgba_png(dest, width, height, b"\x00" * (width * height * 4))


def make_entry_png(source: Path, dest: Path) -> None:
    """Password entry underline: transparent field with gold accent line."""
    width, height = png_size(source)
    rgba = bytearray(width * height * 4)
    line_start = max(0, height - ACCENT_LINE_ROWS)
    for y in range(line_start, height):
        for x in range(width):
            i = (y * width + x) * 4
            rgba[i : i + 4] = GOLD
    write_rgba_png(dest, width, height, bytes(rgba))


def _lock_path_d(svg_text: str) -> str:
    for line in svg_text.splitlines():
        if "<path" in line and 'd="' in line:
            return line.split('d="', 1)[1].split('"', 1)[0]
    raise ValueError(f"no path d= attribute in {LOCK_SVG}")


def make_lock_png(source: Path, dest: Path) -> None:
    """Jam Icons padlock-f rasterized in theme gold."""
    if not LOCK_SVG.is_file():
        print(f"error: lock SVG not found: {LOCK_SVG}", file=sys.stderr)
        raise SystemExit(1)

    width, height = png_size(source)
    path_d = _lock_path_d(LOCK_SVG.read_text())
    themed_svg = (
        '<svg xmlns="http://www.w3.org/2000/svg" '
        f'viewBox="-5 -2 24 24" width="{width}" height="{height}">\n'
        f'  <path fill="{GOLD_HEX}" d="{path_d}"/>\n'
        "</svg>\n"
    )

    with tempfile.TemporaryDirectory() as tmp:
        svg_path = Path(tmp) / "lock.svg"
        svg_path.write_text(themed_svg)
        cmd = ["npx", "--yes", "sharp-cli", "-i", str(svg_path), "-o", str(dest)]
        try:
            subprocess.run(cmd, check=True, capture_output=True, text=True)
        except (subprocess.CalledProcessError, FileNotFoundError) as err:
            bundled = SCRIPT_DIR / "bearded-gold" / "lock.png"
            if bundled.is_file() and bundled != dest:
                shutil.copy2(bundled, dest)
                print(f"warning: npx sharp-cli unavailable, kept existing lock.png ({err})", file=sys.stderr)
                return
            print("error: npx sharp-cli required to generate lock.png", file=sys.stderr)
            raise SystemExit(1) from err


def main() -> int:
    if not SOURCE_DIR.is_dir():
        print(f"error: source theme not found: {SOURCE_DIR}", file=sys.stderr)
        return 1

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    for item in SOURCE_DIR.iterdir():
        if item.name in {
            "pop-basic.plymouth",
            "header-image.png",
            "bgrt-fallback.png",
            "entry.png",
            "lock.png",
        }:
            continue
        if item.is_symlink():
            continue
        shutil.copy2(item, OUT_DIR / item.name)

    transparent_like(SOURCE_DIR / "header-image.png", OUT_DIR / "header-image.png")
    shutil.copy2(OUT_DIR / "header-image.png", OUT_DIR / "bgrt-fallback.png")
    make_entry_png(SOURCE_DIR / "entry.png", OUT_DIR / "entry.png")
    make_lock_png(SOURCE_DIR / "lock.png", OUT_DIR / "lock.png")

    print(f"generated assets in {OUT_DIR}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
