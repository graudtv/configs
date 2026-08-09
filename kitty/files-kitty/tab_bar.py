# pyright: reportMissingImports=false

import datetime

import time
from kitty.fast_data_types import Screen
from kitty.rgb import Color
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title, TabAccessor, apply_title_template, powerline_symbols, Formatter, draw_attributed_string
from kitty.utils import color_as_int

from kitty.fast_data_types import get_boss, get_options

dbg_idx = 0

def dbg(*args):
    global dbg_idx
    with open("/tmp/kitty-dbg", "a") as f:
        print(f"[{dbg_idx}]", *args, file=f)
        dbg_idx += 1

def draw_tab_with_separator(
    draw_data: DrawData, screen: Screen, tab: TabBarData, before: int, max_tab_length: int, index: int, is_last: bool, extra_data: ExtraData
) -> int:
    if draw_data.leading_spaces:
        screen.draw(' ' * draw_data.leading_spaces)
    draw_title_custom(draw_data, screen, tab, index, max_tab_length)
    trailing_spaces = min(max_tab_length - 1, draw_data.trailing_spaces)
    max_tab_length -= trailing_spaces
    extra = screen.cursor.x - before - max_tab_length
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw('…')
    if trailing_spaces:
        screen.draw(' ' * trailing_spaces)
    end = screen.cursor.x
    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0
    if not is_last:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)
    screen.cursor.bg = 0
    return end


def draw_tab_with_powerline(
    draw_data: DrawData, screen: Screen, tab: TabBarData, before: int, max_tab_length: int, index: int, is_last: bool, extra_data: ExtraData
) -> int:
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
        needs_soft_separator = next_tab_bg == tab_bg
    else:
        next_tab_bg = default_bg
        needs_soft_separator = False

    separator_symbol, soft_separator_symbol = powerline_symbols.get(draw_data.powerline_style, ('', ''))
    min_title_length = 1 + 2
    start_draw = 2

    if screen.cursor.x == 0:
        screen.cursor.bg = tab_bg
        screen.draw(' ')
        start_draw = 1

    screen.cursor.bg = tab_bg
    if min_title_length >= max_tab_length:
        screen.draw('…')
    else:
        draw_title_custom(draw_data, screen, tab, index, max_tab_length)
        extra = screen.cursor.x + start_draw - before - max_tab_length
        if extra > 0 and extra + 1 < screen.cursor.x:
            screen.cursor.x -= extra + 1
            screen.draw('…')

    if not needs_soft_separator:
        screen.draw(' ')
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_tab_bg
        screen.draw(separator_symbol)
    else:
        prev_fg = screen.cursor.fg
        if tab_bg == tab_fg:
            screen.cursor.fg = default_bg
        elif tab_bg != default_bg:
            c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
            c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
            if c1 < c2:
                screen.cursor.fg = default_bg
        screen.draw(f' {soft_separator_symbol}')
        screen.cursor.fg = prev_fg

    end = screen.cursor.x
    if end < screen.columns:
        screen.draw(' ')
    return end

def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    #dbg(f"draw_data {draw_data}, tab {tab}, before {before}, max_title_length {max_title_length}, index {index}, is_last {is_last}, extra_data {extra_data}")
    #return draw_tab_with_powerline(draw_data, screen, tab, before, max_title_length, index, is_last, extra_data)
    return draw_tab_with_separator(draw_data, screen, tab, before, max_title_length, index, is_last, extra_data)

def get_tab_name(tab: TabBarData) -> str:
    if not tab:
        return t.title
    t = get_boss().tab_for_id(tab.tab_id)
    if t.name:
        return t.name
    ta = TabAccessor(tab.tab_id)

    time.sleep(0.01)
    active_exe = ta.active_exe
    #oldest_exe = ta.active_oldest_exe
    #if active_exe != oldest_exe:
    #    return f"{active_exe} ({oldest_exe})"
    return active_exe

def apply_title_template_custom(draw_data: DrawData, tab: TabBarData, index: int, max_title_length: int = 0) -> str:
    title = draw_data.title_template
    if tab.is_active and draw_data.active_title_template is not None:
        title = draw_data.active_title_template

    title = title.replace('{name}', get_tab_name(tab))
    title = title.replace('{title}', tab.title)

    return title

def draw_title_custom(draw_data: DrawData, screen: Screen, tab: TabBarData, index: int, max_title_length: int = 0) -> None:
    title = apply_title_template_custom(draw_data, tab, index, max_title_length)
    fmt = Formatter
    fg = lambda color: getattr(fmt.fg, color)
    bg = lambda color: getattr(fmt.bg, color)
    bgc = '_1e1e1e'

    if tab.is_active:
        c1 = '_3a3d41'
        c2 = '_ffffff'
    else:
        c1 = '_323336'
        c2 = '_888888'

    title = f"{fg(c1)}{bg(bgc)}{fg(c2)}{bg(c1)}{title}{fg(c1)}{bg(bgc)}"

    before_draw = screen.cursor.x
    draw_attributed_string(title, screen)
    #screen.draw(title)
    if draw_data.max_tab_title_length > 0:
        x_limit = before_draw + draw_data.max_tab_title_length
        if screen.cursor.x > x_limit:
            screen.cursor.x = x_limit - 1
            screen.draw('…')
