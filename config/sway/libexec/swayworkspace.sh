#!/usr/bin/env bash

# swayworkspace provides custom workspace management for sway.
#
# Navigating to the previous/next workspace of the current output:
#   swayworkspace navigate [previous|next]
#
# Navigating to a specific workspace of the current output:
#   swayworkspace navigate <workspace_number>
#
# Moving the currently focused container to a workspace of the current output:
#   swayworkspace move <workspace_number>
#
#
# The program does yet support moving containers from one screen to another.
#
#
# Example Sway configuration:
#
#   exec_always swayworkspace startup
#   bindsym $mod+1 exec swayworkspace navigate 1
#
#   bindsym $mod+Shift+1 exec swayworkspace move 1
#
#   bindsym $mod+right exec swayworkspace navigate next
#   bindsym $mod+left exec swayworkspace navigate previous


WORKSPACE_NAMES=(
    ["1"]="1"
    ["2"]="2"
    ["3"]="3"
    ["4"]="4"
)

# Navigate to another workspace
# Args:
#   $1 = Direction (next or previous) or output number
function navigate {
    FOCUSED_WORKSPACE_NUM=$(swaymsg -t get_workspaces | jq --raw-output '. | map(select(.focused == true)) | .[0].name' | awk '{print $1}')
    FOCUSED_OUTPUT_NUM=$(swaymsg -t get_outputs | jq --raw-output '. | map(select(.focused==true)) | .[0].id')
    FOCUSED_WORKSPACE_NUM=$(expr ${FOCUSED_WORKSPACE_NUM} - ${FOCUSED_OUTPUT_NUM} \* 100)

    # Find the next workspace number
    if [[ $1 == "next" ]]; then
        TARGET_WORKSPACE_NUM=$(expr ${FOCUSED_WORKSPACE_NUM} + 1)
    elif [[ $1 == "previous" ]]; then
        TARGET_WORKSPACE_NUM=$(expr ${FOCUSED_WORKSPACE_NUM} - 1)
    else
        TARGET_WORKSPACE_NUM=$1
    fi

    if [[ ${TARGET_WORKSPACE_NUM} -gt 4 ]]; then
        TARGET_WORKSPACE_NUM="1"
    elif [[ ${TARGET_WORKSPACE_NUM} -lt 1 ]]; then
        TARGET_WORKSPACE_NUM="4"
    fi

    OUTPUT_AND_WORKSPACE_NUM=$(expr ${FOCUSED_OUTPUT_NUM} \* 100 + ${TARGET_WORKSPACE_NUM})
    TARGET_WORKSPACE_NAME=${WORKSPACE_NAMES[TARGET_WORKSPACE_NUM]}

    swaymsg "workspace ${OUTPUT_AND_WORKSPACE_NUM} ${TARGET_WORKSPACE_NUM} ${TARGET_WORKSPACE_NAME}"
}

# Move the focused container to another workspace
# Args:
#   $1 = Target workspace number
function move {
    FOCUSED_OUTPUT_NUM=$(swaymsg -t get_outputs | jq '. | map(select(.focused==true)) | .[0].id')
    TARGET_WORKSPACE_NUM=$1
    TARGET_WORKSPACE_NAME=${WORKSPACE_NAMES[$1]}
    OUTPUT_AND_WORKSPACE_NUM=$(expr ${FOCUSED_OUTPUT_NUM} \* 100 + ${TARGET_WORKSPACE_NUM})

    swaymsg  "move container to workspace ${OUTPUT_AND_WORKSPACE_NUM} ${TARGET_WORKSPACE_NUM} ${TARGET_WORKSPACE_NAME}"
}

# Initialize workspaces on all screens
# Args: None
function startup {
    ALL_OUTPUT_NAMES=$(swaymsg -t get_outputs | jq --raw-output 'map(select(.active == true)) | .[].name')
    for OUTPUT_NAME in ${ALL_OUTPUT_NAMES}; do
        swaymsg focus output ${OUTPUT_NAME}
        navigate 1
    done

    FIRST_OUTPUT_NAME=$(echo "${ALL_OUTPUT_NAMES}" | head -1)
    swaymsg focus output ${FIRST_OUTPUT_NAME}
}

if [[ $1 == "navigate" ]]; then
    navigate $2
elif [[ $1 == "move" ]]; then
    move $2
elif [[ $1 == "startup" ]]; then
    startup
else
    echo "unknown command"
    exit 1
fi
