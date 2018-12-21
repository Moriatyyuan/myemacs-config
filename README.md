# 主要用于Python开发,其他环境未配置.PS:(太特么难得折腾了)
  
---------------------------------
  
# 环境准备
1. 需要保证系统使用的是python3,在命令行敲python3 能正常进入python3  
2. 最好是把python3的bin目录加入环境变量,否则可能autopep8无法使用  
3. 保证已安装pip3  
4. 最好安装Ubuntu Mono字体,采用11号大小,效果最佳  
  
---------------------------------
  
# 安装方法
1. 先安装emacs(emacs安装方法自行解决),本环境最好使用无GUI界面的emacs版本(arch中是`sudo pacman -S emacs-nox`)  
2. `pip3 install elpy rope jedi yapf autopep8==1.4 epc argparse pycodestyle==2.3.0 flake8==3.5.0 pylint`  
3. 为了补全js,还需要安装nodejs和npm(安装问题自己解决),然后执行`npm install -g tern`安装tern,PS:(补全js要用到)  
4. 把.emacs.d和.emacs以及.tern-config都放入用户home目录中  
5. 系统需要安装`lvm35`和`clang35`这两个是用于C语言头文件补全(arch中是`sudo pacman -S lvm35 clang35`)  
6. 终端输入`emacs`启动emcas,第一次启动会自动下载所需要的插件,需要等几分钟,等插件安装完毕后,重启emacs即可  
  
---------------------------------
  
# Emacs快捷键简单说明
在emacs中,`M`代表`Alt`键,`C`代表`Ctrl`键  
`M-j` 表示按Alt+j  
`C-j` 表示按Ctrl+j  
`C-c C-c` 表示按两次Ctrl+c  
`C-c o` 表示先按Ctrl+c 再按o  
  
---------------------------------
  
# Emacs自带快捷键说明
`C-x C-s` 保存当前文件  
`C-x C-c` 退出emacs  
  
--------------------------------
  
# 本环境快捷键说明
`f1` 打开.emacs这个配置文件  
`M-w` 复制,没有选中任何东西的话就是复制当前行  
`C-w` 剪切,没有选中任何东西的话就是剪切当前行  
`C-/` 代码注释  
`C-a` 全选  
`C-v` 进入块选择模式,类似Vim的virtual模式  
`C-u` 跳转到文件开头,类似Vim的gg  
`C-l` 跳转到文件结尾,类似Vim的G  
`M-ESC` 放弃本次命令操作,类似vim的按两下ESC  
`C-g` 跳转到指定行  
`M-right` 跳转到行尾  
`M-left`  跳转到行首  
`M-j` 多窗口模式的时候,跳转到其他窗口  
`M-m` 打开buffer列表  
`M-k` 关闭当前窗口  
`M-n` 切换到已打开的buffer  
`C-f` 查找文件  
`M-/` 代码补全提示  
`C-c o` 代码重构,比方说,将光标放在某个单词上,按下如下所示的组合键,就选中了当前文件中所有的这个单词  
`C-c k` 代码扩展,比方说,for之后按下如下所示的组合键,就自动展开为一个for语句  
`C-c C-c` 直接运行当前编辑的Python文件,没有shell  
`f5` 直接运行当前编辑的Python文件,会打开一个shell buffer再运行  
`M-o` 打开最近使用过的文件  
`M-0 ~ 9` 多窗口模式中,快速定位到指定的窗口号  
`M-q` 打开函数导航窗口,可直接选择该函数跳转  