-- iterm2-light: iTerm2 "background light" palette for WezTerm

local M = {}

local palette = {
    base = "#ffffff",
    overlay = "#ffffff",
    muted = "#686868",
    text = "#000000",
}

local active_tab = {
    bg_color = palette.overlay,
    fg_color = palette.text,
}

local inactive_tab = {
    bg_color = palette.base,
    fg_color = palette.muted,
}

function M.colors()
    return {
        tab_bar = {
            background = palette.base,
            active_tab = active_tab,
            inactive_tab = inactive_tab,
            inactive_tab_hover = active_tab,
            new_tab = inactive_tab,
            new_tab_hover = active_tab,
            inactive_tab_edge = palette.muted, -- (Fancy tab bar only)
        },
        ansi = { "#000000", "#c91b00", "#00c200", "#c7c400", "#0225c7", "#ca30c7", "#00c5c7", "#bababa" },
        brights = { "#686868", "#ff6e67", "#39d442", "#ccc934", "#6871ff", "#ff77ff", "#3ad7d9", "#ffffff" },
    }
end

function M.window_frame() -- (Fancy tab bar only)
    return {
        active_titlebar_bg = palette.base,
        inactive_titlebar_bg = palette.base,
    }
end

return M
