---------------
---- INPUT ----
---------------

-- Dead keys (us intl): type the key then the letter
-- '  + e = é  |  ` + e = è  |  ^ + e = ê  |  " + e = ë
-- '  + a = á  |  ` + a = à  |  ^ + a = â  |  " + a = ä
-- For the character alone: key + space (e.g. " + space = ")

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_variant = "intl",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/configuring/core/devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})