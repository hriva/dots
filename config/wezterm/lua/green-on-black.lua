-- green-on-black

local M = {}

local palette = {
    base = '#030303',
    overlay = '#26233a',
    muted = '#6e6a86',
    text = '#33DA7A',
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
	ansi = {'#171421','#C01C28','#26A269','#A2734C','#12488B','#A347BA','#2AA1B3','#D0CFCC'},
	brights = {'#5E5C64','#F66151','#33DA7A','#E9AD0C','#2A7BDE','#C061CB','#33C7DE','#FFFFFF'},
    }
end

function M.window_frame() -- (Fancy tab bar only)
    return {
        active_titlebar_bg = palette.base,
        inactive_titlebar_bg = palette.base,
    }
end

return M
