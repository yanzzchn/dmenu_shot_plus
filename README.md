<h1 align="center">dmenu_shot_plus</h1>
<p align="center">
  <a href="https://github.com/yanzzchn/dmenu_shot_plus">
    <img alt="dmenu_shot screenshot" src="./assets/menu_screenshot.png"/>
  </a>
</p>

 

我们的想法是有一个干净和易于使用的`dmenu`菜单，使用 `ImageMagic` 对 [Flameshot](https://flameshot.org) 的输出进行一些基本的图像处理。目前为止在 `Linux`上，最好的截图工具应该是 `Flameshot` 了，虽然功能很强大，但是缺少了一些定制化。 比如，无法对截图设置边框、圆角、添加水印、尺寸缩放等等。

使用过 `ImageMagic(convert)`的都应该知道这款命令行应用有多强大，可以对图片进行任意的处理，`dmenu_shot_plus`通过 `ImageMagic` 来进一步扩展 `Flameshot` 的功能。这里为大家带来这款通过扩展 `Flameshot` 截图脚本插件， 让 `Flameshot` 在 `Linux` 上功能更加丰富。 `dmenu_shot_plus` 对以前的版本进行了部分优化和改进。需要的朋友可以自己进一步深度开发，绝对可以媲美 `Mac` 以及 `Win` 上的一些截图应用。

**主要功能：**
- **[Bordered-Scaled](docs/actions.md#border-scaled)**: 截图边框加缩放，如果不输入缩放比例或尺寸，则直接截取带有边框和圆角的图片到剪贴板
- **[Trim](docs/actions.md#trim):** 剪所选区域周围多余的空白
- **[Remove_white](./docs/actions.md#remove_whilte)**: 有助于去除白色背景。它将用透明取代白色
- **[Negative](./docs/actions.md#negative)**: 反色，负片效果，类似胶卷
- **[Bordered](docs/actions.md#Bordered)**: 在捕获的屏幕截图周围添加圆角边框
- **[Scaled](docs/actions.md#scaled)**: 截图缩放，将有助于减小图片的存储体积
- **[Select_Window](docs/actions.md#select_window)**: 截取指定窗口 flameshot 需升级到最新版本才能使用

默认情况下，所有的输出都被复制到剪贴板。

**后续需要完善的功能：**
- 长截图支持
- 截图OCR文字识别
- 截图转PDF
- 支持通过 dmenu_shot_plus 保存到保存图片到任意为止
- 支持截图直接上传到第三方图床，并返回链接地址


详细请查阅文档：**[说明文档](https://github.com/yanzzchn/dmenu_shot_plus/docs/actions.md).**

-------

## Table of Content
- [Table of Content](#table-of-content)
- [How to use](#how-to-use)
- [依赖解决](#依赖解决)
- [Installation](#installation)
  - [Automatic Installation](#automatic-installation)
  - [Manual Installation （推荐）](#manual-installation-推荐)
- [Configuration](#configuration)
- [Uninstall](#uninstall)
- [Commands](#commands)
- [Contribution](#contribution)

-------

## How to use

After installation (which is basically copying [a shell file](https://github.com/yanzzchn/dmenu_shot_plus/dmenu_shot.sh) to your PATH), you can either use the `dmenu_shot` command in terminal or bind this command to a keyboard shortcut. If you don't know how, click on your Desktop Environment:

- [KDE](https://userbase.kde.org/Tutorials/hotkeys)
- [Xfce](https://docs.xfce.org/xfce/xfce4-settings/keyboard)
- [Gnome](https://help.gnome.org/users/gnome-help/stable/keyboard-shortcuts-set.html.en)

-------

## 依赖解决

This script expects the user to have the following softwares installed:
- Flameshot： dmenu_shot_plus 是 Flameshot 的扩展，自然必须先安装 Flameshot 截图应用
- dmenu (it can be custom built but should be available in the PATH)
- ImageMagic (specifically the `convert` command
- xclip
- make (This is only a dependency for automatic installation)

If you have the `make` installed, you can check what dependencies are installed and which ones are missing using:

```sh
make check
```

-------

## Installation

### Automatic Installation

When you have installed all the dependencies, simply do:

1. Clone this repo or download and extract the zip file

```sh
# To clone the repo
git clone https://github.com/yanzzchn/dmenu_shot.git 
```

OR

```sh
# To download the ZIP file
wget https://github.com/yanzzchn/dmenu_shot/archive/master.tar.gz
gunzip --keep dmenu_shot-master.tar.gz
```

2. Install using the Makefile:

```sh
cd dmenu_shot
make install
```

This will install the dmenu_shot to `~/.local/bin` (so it will NOT install it system-wise and will be only installed for the current user). This makes the command `dmenu_shot` be usable in your terminal. All you need to do is to close your terminal and open it again and run `dmenu_shot`. 

### Manual Installation （推荐）

1. Clone this repo or download and extract the zip file

```sh
# To clone the repo
git clone https://github.com/yanzzchn/dmenu_shot.git 
```

OR

```sh
# To download the ZIP file
wget https://github.com/yanzzchn/dmenu_shot/archive/master.tar.gz
gunzip --keep dmenu_shot-master.tar.gz
```

2. Copy the file to the location you want. I suggest `~/.local/bin`:

```sh
cd dmenu_shot
cp dmenu_shot.sh ~/.local/bin/dmenu_shot
```

-------

## Configuration

`dmenu_shot` can be configured using a simple TOML file. The default path would be `~/.config/dmenushot/config.toml` but you can set a environment variable named `DMENU_SHOT_CONF_PATH` to overwrite the default path and point the `dmenu_shot` to a custom file.

Until this version we accept a section named `[colors]` which can have the custom color values of the dmenu as shown below. You do not need to define all of them. You can also use comments and empty lines in the config file.

``` toml
# Anything after # is considered comment

[colors]
normal_foreground = "#ff6600"
normal_background = "#8501a7"
selection_foreground = "#ffcc00"
selection_background = "#fa0164"
```

If there is something unexpected in the config file, you will see some error messages to help you fix the issue.

-------

## Uninstall

If you have automatically installed `dmenu_shot`, you can easily remove/uninstall it automatically as well:

```sh
make remove
```

-------

## Commands

This is a dmenu script and user does not need to insteract with it using the command line, but just in case, a very short help is available using `--help` or `-h`.

There is also a small `help` available for the `make` which can be seen using `make help` and will output the following:

```
Available arguments:
- "make install" to install
- "make remove"  to uninstall (remove)
- "make check"   to check if you have all dependencies installed
- "make help"    to show this help
```

-------

## Contribution

To prevent this page to get lengthy, I moved the content of this part to [contribute page](https://github.com/yanzzchn/dmenu_shot/src/branch/main/docs/contribute.md).
