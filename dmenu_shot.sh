#!/usr/bin/env bash

#-------[ 内置函数 ]-------#
{
    # 一个获取自定义值作为输入的函数。获取一个字符串作为输入，作为消息使用。
    function func_get_input(){
        echo | dmenu -i -fn "UbuntuMono Nerd Font:size=11" \
                -nb "${colors_normal_background}" \
                -nf "${colors_normal_foreground}" \
                -sb "${colors_selection_background}" \
                -sf "${colors_selection_foreground}" \
                -p "${1}:"
    }

    # 一个读取和解析配置文件的函数，输入应该是配置文件的路径
    function func_parse_config(){
        local line section key value
        local regex_empty="^[[:blank:]]*$"
        local regex_comment="^[[:blank:]]*#"
        local regex_section="^[[:blank:]]*\[([[:alpha:]][[:alnum:]]*)\][[:blank:]]*$"
        local regex_keyval="^[[:blank:]]*([[:alpha:]_][[:alnum:]_]*)[[:blank:]]*=[[:blank:]]*[\"\']?([^\"\']*)[\"\']?"

        # 逐行读取行数并使用配置创建变量。
        while IFS='= ' read -r line
        do
            # skip if the line is empty
            [[ "${line}" =~ ${regex_empty} ]] && continue
            # skip if the line is comment
            [[ "${line}" =~ ${regex_comment} ]] && continue
            # if the line matches regex for section
            if [[ "${line}" =~ ${regex_section} ]]
            then
                section="${BASH_REMATCH[1]}"
                # echo "section=${section}"
            # if the line matches regex for key-value pair
            elif [[ "${line}" =~ ${regex_keyval} ]]
            then
                key="${BASH_REMATCH[1]}"
                value="${BASH_REMATCH[2]}"
                # echo "${key} = ${value}"
            # if the line does not match any of the above
            else
                echo "The following line in config is invalid:"
                echo "${line}"
            fi

            # create varible synamically using the combination of section and key
            declare -g "${section}_${key}"="${value}"

        done < "${1}"
    }
}

# 通过遮罩层叠进行添加边框
add_bordered(){
    if [ -n "$1" ]
    then
        resize="$1 $2"
        echo "${resize}\n"
        echo $resize
    else
        resize=''
    fi

    flameshot gui --raw \
			| convert png:- \
                $resize \
      			-format 'roundrectangle 6,6 %[fx:w+0],%[fx:h+0] 15,15' \
      			-write info:tmp.mvg \
      			-alpha set -bordercolor LightGray -border 2 \
				\( +clone -alpha transparent -background none \
				-fill white -stroke none -strokewidth 0 -draw @tmp.mvg \) \
				-compose DstIn -composite \
				\( +clone -alpha transparent -background none \
				-fill none -stroke LightGray -strokewidth 2 -draw @tmp.mvg \
				-fill none -stroke LightGray -strokewidth 2 -draw @tmp.mvg \) \
				-compose Over -composite png:- \
			| xclip -selection clipboard -target image/png 
        # 原始设置，单纯的添加一个红色边框，不包含圆角
        #flameshot gui --raw \
            #| convert png:- -bordercolor red -border 3 png:- \
         #   | convert png:- -bordercolor LightGray -border 2 png:- \
         #   | xclip -selection clipboard -target image/png
}


#-------[ 参数解析 ]-------#
{
    if [[ "${1}" == "--help" ]] || [[ "${1}" == "-h" ]] || [[ "${1}" == "help" ]]
    then
        cat << 'EOF'

dmenu_shot provides a menu with set of custom commands to perform some simple automated image manipulation on 
screenshots taken using Flameshot, and then putting them into clipboard.
[dmenu_shot提供了一个菜单，其中有一组自定义命令，可以在屏幕上进行一些简单的自动图像处理。
在使用Flameshot拍摄的屏幕截图上执行一些简单的自动图像处理然后把它们放到剪贴板上。]

Commands:
    -h, --help    To show this help [现实此帮助信息]


Menu:
    Bordered_Scaled:  Screenshot border plus scaling, if you do not enter a scaling ratio or size,
                      then directly capture the image with a border and rounded corners to the clipboard
                      [截图边框加缩放，如果不输入缩放比例或尺寸，则直接截取带有边框和圆角的图片到剪贴板]

    Trim:             It just trims the extra spaces around the selected region.
                      [修剪所选区域周围多余的空白]

    Remove_white:     Useful to remove the white background. It will replace white with transparent. 
                      [有助于去除白色背景。它将用透明取代白色]

    Negative:         Convert the image to negative colors.
                      [反色,将图像转换为负色]

    Bordered:         Add border around the captured screenshot.
                      [在捕获的屏幕截图周围添加圆角边框]

    Scaled:           Resize the screenshot either by percentage (e.g 75%) or specific dimention (e.g 200x300).
                      [截图缩放，将有助于减小图片的存储体积]

    Select_Window:    Waits for user to select a window, then take screenshot of it.
                      [截取指定窗口 flameshot 需升级到最新版本才能使用]


Author:
    Mehrad Mahmoudian 
    You Ran Yan
    Zeng Yan


Git repository for bug report and contributions:
    https://github.com/yanzzchn/dmenu_shot
EOF
        exit 0
    fi
}


#-------[ load config ]-------#
{
    ## define the colors so that we have something to fallback to
    colors_normal_foreground="#ff6600"
    colors_normal_background="#8501a7"
    colors_selection_foreground="#ffcc00"
    colors_selection_background="#fa0164"

    # get the config path from environmental variable, otherwise fall back to ~/.config/dmenu_shot/config.toml
    if [[ -v DMENU_SHOT_CONF_PATH ]]
    then
        CONF_PATH="${DMENU_SHOT_CONF_PATH}"
    else
        CONF_PATH="${HOME}/.config/dmenu_shot/config.toml"
    fi

    # if the config file do exist
    if [[ -f "${CONF_PATH}" ]]
    then
        func_parse_config "${CONF_PATH}"
    else
        echo "The config file was not found in ${CONF_PATH}"
        echo "Falling back to some defaults!"
    fi
}


RET=$(echo -e "Scaled-Bordered\nTrim\nRemove_white\nNegative\nBordered\nScaled\nSelect_Window\nCancel" \
    | dmenu -i -fn "UbuntuMono Nerd Font:size=11" \
        -nb "${colors_normal_background}" \
        -nf "${colors_normal_foreground}" \
        -sb "${colors_selection_background}" \
        -sf "${colors_selection_foreground}" \
        -p "Select screenshot type:")

case $RET in
    Trim)
        flameshot gui --raw \
            | convert png:- -trim png:- \
            | xclip -selection clipboard -target image/png
        ;;
    Remove_white)
        flameshot gui --raw \
            | convert png:- -transparent white -fuzz 90% png:- \
            | xclip -selection clipboard -target image/png
        ;;
    Negative) 
        flameshot gui --raw \
            | convert png:- -negate -channel RGB png:- \
            | xclip -selection clipboard -target image/png
        ;;
    Bordered)
        add_bordered
        ;;
    Scaled)
        tmp_size=$(func_get_input "input resize value (e.g 75% or 200x300)");

        if [[ -n "${tmp_size}" ]]
        then
            flameshot gui -r \
                | convert png:- -resize "${tmp_size}" png:- \
                | xclip -selection clipboard -target image/png
        fi
        ;;
    Scaled-Bordered)
        tmp_size=$(func_get_input "input resize value (e.g 75% or 200x300)");

        if [[ -n "${tmp_size}" ]]
        then
            add_bordered -resize "${tmp_size}"
        else
            add_bordered
        fi
        ;;
    Select_Window)
        # get the window ID
        TMP_WINDOW_ID=$(xdotool selectwindow)
        
        
    
        unset WINDOW X Y WIDTH HEIGHT SCREEN
        # eval $(xdotool selectwindow getwindowgeometry --shell)
        eval $(xdotool getwindowgeometry --shell "${TMP_WINDOW_ID}")
        
        # Put the window in focus
        xdotool windowfocus --sync "${TMP_WINDOW_ID}"
        sleep 0.05
        
        # run flameshot in gui mode in the desired coordinates
        flameshot gui --region "${WIDTH}x${HEIGHT}+${X}+${Y}"
        
        ;;
	*) ;;
esac
