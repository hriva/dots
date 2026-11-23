-- pencil-light: role tokens migrated from lua/pencil-light.conf

local M = {}

-- Hex values stay lowercase and keep the leading '#', as in the original .conf.
local roles = {
    bg = "#f1f1f1",     -- base background
    fg = "#424242",     -- default text
    active = "#10a778", -- active tab
    idle = "#005f87",   -- inactive tab text
    warn = "#a89c14",   -- attention tone
    accent = "#b6d6fd", -- light blue accent (hover)
    sel = "#008ec4",    -- selected / cursor
}

local active_tab = {
    bg_color = roles.active,
    fg_color = roles.bg,
}

local inactive_tab = {
    bg_color = roles.bg,
    fg_color = roles.idle,
}

function M.colors()
    return {
        foreground = roles.fg,
        background = roles.bg,
        cursor_bg = roles.sel,
        cursor_border = roles.sel,
        selection_bg = roles.accent,
        selection_fg = roles.fg,
        tab_bar = {
            background = roles.bg,
            active_tab = active_tab,
            inactive_tab = inactive_tab,
            inactive_tab_hover = {
                bg_color = roles.accent,
                fg_color = roles.fg,
            },
            new_tab = inactive_tab,
            new_tab_hover = {
                bg_color = roles.accent,
                fg_color = roles.fg,
            },
            inactive_tab_edge = roles.idle,
        },
    }
end

function M.window_frame() -- (Fancy tab bar only)
    return {
        active_titlebar_bg = roles.bg,
        inactive_titlebar_bg = roles.bg,
    }
end

return M
