
-- green-on-black

local M = {}

local palette = {
    base = '#1e1e1e',
    overlay = '#1e1e1e',
    muted = '#595b59',
    text = '#f7f6ec',
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
        ansi = {"#343935","#cf3f61","#7bb75b","#e9b32a","#4c9ad4","#a57fc4","#389aad","#fafaf6"},
        brights = {"#595b59","#d18fa6","#767f2c","#78592f","#135979","#604291","#76bbca","#b2b5ae"},
    }
end

function M.window_frame() -- (Fancy tab bar only)
    return {
        active_titlebar_bg = palette.base,
        inactive_titlebar_bg = palette.base,
    }
end

return M
