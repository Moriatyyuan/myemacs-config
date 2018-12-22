;;========================================================================================
;;                                 F1打开.emacs文件
;;========================================================================================
(defun open-emacsconfig()
  (interactive)
  (find-file "~/.emacs"))
(global-set-key (kbd "<f1>") 'open-emacsconfig)
;;========================================================================================
;;         基础快捷键说明: M = Alt, C = Ctrl, M-x = Alt+x, C-s = Ctrl+s 以此类推
;;========================================================================================
;;                                  插件管理器配置
;;========================================================================================
;;
;;  M-x package-list-packages 列出插件列表
;;  i  - 选择要安装的包
;;  d  - 选择要删除的包
;;  U  - 升级已安装的包
;;  x  - 执行操作
;;  M-x package－install 插件名(这种方法也可以安装插件)
;;  C-s 搜索插件,再次按则向下继续搜索
;;
;;========================================================================================
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; 最新版仓库
  (add-to-list 'package-archives (cons "melpa" (concat proto "://elpa.emacs-china.org/melpa/")) t)
  ;; 稳定版仓库
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://elpa.emacs-china.org/melpa-stable/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.emacs-china.org/gnu/")))))
(package-initialize)

;; 列表中定义的插件,如果没安装则自动安装
;; company-c-headers 需要开启最新版仓库
(defvar my-packages/packages '(
                               elpy
                               yasnippet
                               company-jedi
                               flycheck
                               py-autopep8
                               highlight-parentheses
                               company-tern
                               tern
                               js2-mode
                               web-mode
                               iedit
                               company-c-headers
                               neotree
                               window-numbering
                               imenu-list
                               ) "Default packages")
(require 'cl)
(defun my-packages/packages-installed-p ()
  (loop for pkg in my-packages/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (my-packages/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg my-packages/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;;========================================================================================
;; 主题设置,经典的color-theme插(需先安装)件内置几十款主题(注意一定要开启Linux的256色终端)
;; 个人认为不好看,所以没用
;;========================================================================================
;;(require 'color-theme)
;;(color-theme-initialize)
;;(color-theme-deep-blue)

;;========================================================================================
;;            自定义主题,把你下载的emacs主题放入下面的文件夹,然后load即可
;;========================================================================================
(add-to-list 'custom-theme-load-path "~/.emacs.d/custom-theme")
;; 已安装的主题
(load-theme 'hipster t)

;;=======================================================================================
;;                                  设置(utf-8)模式
;;=======================================================================================
;;默认写入文件的编码
(setq default-buffer-file-coding-system 'utf-8)
;;默认读取文件的编码
(prefer-coding-system 'utf-8)
;;终端方式的编码方式
;;(set-terminal-coding-system 'utf-8)
;;键盘输入的编码方式
;;(set-keyboard-coding-system 'utf-8)
;;读取或写入文件名的编码方式
;;(setq file-name-coding-system 'utf-8)
;;========================================================================================

;;========================================================================================
;;                       复制当前行,当没有选中时,M-w就是复制当前行
;;========================================================================================
(global-set-key "\M-w"
(lambda ()
  (interactive)
  (if mark-active
      (kill-ring-save (region-beginning)
      (region-end))
    (progn
     (kill-ring-save (line-beginning-position)
     (line-end-position))
     (message "copied line")))))

;;========================================================================================
;;                       剪切当前行,当没有选中时,C-w就是剪切当前行
;;========================================================================================
(global-set-key "\C-w"
(lambda ()
(interactive)
(if mark-active
(kill-region (region-beginning)
(region-end))
(progn
(kill-region (line-beginning-position)
(line-end-position))
(message "killed line")))))


;;========================================================================================
;;             解决终端下,nogui模式,矩形选中后复制无法粘贴到外部程序的问题。
;;========================================================================================
;; linux需要安装xsel
(setq x-select-enable-clipboard t)
(unless window-system
 (when (getenv "DISPLAY")
  (defun xsel-cut-function (text &optional push)
    (with-temp-buffer
      (insert text)
      (call-process-region (point-min) (point-max) "xsel" nil 0 nil "--clipboard" "--input")))
  (defun xsel-paste-function()
    (let ((xsel-output (shell-command-to-string "xsel --clipboard --output")))
      (unless (string= (car kill-ring) xsel-output)
        xsel-output )))
  (setq interprogram-cut-function 'xsel-cut-function)
  (setq interprogram-paste-function 'xsel-paste-function)
  ))

;;=========================================================================================
;;                                  注释当前行 "Ctrl+/"
;;=========================================================================================
(defun qiang-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
If no region is selected and current line is not blank and we are not at the end of the line,
then comment current line.
Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key (kbd "C-_") 'qiang-comment-dwim-line)

;;========================================================================================
;;                                 yasnippet模板系统
;;========================================================================================
;; https://github.com/AndreaCrotti/yasnippet-snippets # 模版下载地址
(require 'yasnippet)
(yas-global-mode 1)

;;========================================================================================
;;                                显示空格及其颜色配置
;;========================================================================================
;; 显示空格
(require 'whitespace)
(global-whitespace-mode t)

;; 粉色代表超过80个字符的部分,由lines-tail 参数控制
;; space-mark 参数表示显示空格
;; newline-mark 表示显示末尾的$符号
;; lines-tail 表示显示超过80个字符后的部分,用粉色高亮
;; trailing 表示高亮显示行尾的空格
;; spaces 下面要控制whitespace-space就必须包含这个参数
;; newline 下面要控制whitespace-newline就必须包含这个参数
;; 根据时间自动切换主题

(setq whitespace-style
      '(face
        ;; trailing blanks
        trailing
        ;; empty lines at beginning and/or end of buffer
        ;; empty
        ;; line is longer `whitespace-line-column'
        lines-tail
        ;; tab or space at the beginning of the line according to
        ;; `indent-tabs-mode'
        indentation
        ;; show tab as » (see `whitespace-display-mappings')
        tab-mark
        space-mark
        spaces
        ))

;; 设置空格字符的颜色
(set-face-attribute 'whitespace-space nil :background "black")
(set-face-attribute 'whitespace-space nil :foreground "dim gray")

;;========================================================================================
;;                                    其他杂项配置
;;========================================================================================
;; 设置背景色
;; (set-background-color "black")

;; 启动emacs时全屏
(setq initial-frame-alist (quote ((fullscreen . maximized))))

;; 关闭覆盖文件时自动备份 ~ 符号开头
(setq make-backup-files nil)

;; 关闭未保存文件时退出,自动保存 #文件名# 这样的文件
(setq auto-save-default nil)

;; 内置的linum行号是左对齐,不舒服
(global-linum-mode t)
;; (set-face-background 'linum "#000000")
(set-face-foreground 'linum "#CD661D")
;; 设置行号格式
(setq linum-format "%d:")

;; 括号匹配
(show-paren-mode t)

;; 高亮显示当前行
(global-hl-line-mode 1)
(set-face-background 'hl-line "#BEBEBE")
(set-face-foreground 'hl-line "#000000")

;; 设置选中区域颜色
(set-face-background 'region "#1C86EE")
(set-face-foreground 'region "#000000")

;; 光标靠近鼠标指针时，让鼠标指针自动让开
(mouse-avoidance-mode 'animate)

;; 高亮显示选中的区域
(transient-mark-mode t)

;; 不要总是没完没了的问yes or no,而是改用y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; 保存上次光标所在位置
(require 'saveplace)
(setq-default save-place t)
(save-place-mode 1)

;; 显示时间，格式如下
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)

;; 设置个人信息,也许在某些地方有用
(setq user-full-name "JinLei Wang")
(setq user-mail-address "1976883731@qq.com")

;; 语法高亮
(global-font-lock-mode t)
(font-lock-add-keywords 'lisp-mode '("[(]" "[)]"))

;; 输入左边的括号,就会自动补全右边的部分.包括(), "", [] , {} , 等等。
(electric-pair-mode t)

;; 在状态条显示当前光标在哪个函数体内部
(which-function-mode t)

;; 打开压缩文件时自动解压
(auto-compression-mode 1)

;; 设置TAB的默认宽度
(setq default-tab-width 4)
(setq python-indent-guess-indent-offset nil)
(setq-default indent-tabs-mode nil);

;; 关闭错误提示声
(setq visible-bell t)

;; 自动缩进
(setq-default c-basic-offset 4)
(global-set-key (kbd "RET") 'newline-and-indent)

;; 设置光标为竖线
(setq-default cursor-type 'bar)
;; (set-cursor-color "blue")  ;; 估计只有在GUI下才生效

;; 终端下鼠标支持,需要gpm
;; (xterm-mouse-mode t)

;; 关闭启动画面
(setq inhibit-startup-message t)

;;========================================================================================
;;  注意下面的配置在EmacsGUI下才生效,如果不使用GUI则最好注释,如果不使用GUI最好也不要使用主题
;;========================================================================================
;; 设置字体
;; 先通过GUI的Set Default Font选择字体,然后M-x describe-font 获取字体信息,然后写在这里
;; 设置字体为Ubuntu-mono
;;(set-default-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")

;; 隐藏菜单栏、工具栏、滚动条
;;(tool-bar-mode 0)
;;(menu-bar-mode 0)
;;(scroll-bar-mode 0)

;;========================================================================================
;;                                  自定义按键绑定
;;========================================================================================
;; (define-key key-translation-map (kbd "your-key") (kbd "target-key"))
;; 按Ctrl+a 全选
(define-key key-translation-map (kbd "C-a") (kbd "C-x h"))
;; 按Ctrl+v 进入块模式
(define-key key-translation-map (kbd "C-v") (kbd "C-@"))
;; Alt+u指向文件的开头,Alt+l指向文件的结尾
(define-key key-translation-map (kbd "M-u") (kbd "M-<"))
(define-key key-translation-map (kbd "M-l") (kbd "M->"))
;; 按Alt+ESC放弃操作
(define-key key-translation-map (kbd "M-ESC") (kbd "C-g"))
;; 按Ctrl+g 跳转到指定行
(define-key key-translation-map (kbd "C-g") (kbd "M-g g"))
;; 按Alt+方向键左,Alt+方向键右 移动到行首行尾
(define-key key-translation-map (kbd "<M-left>") (kbd "<home>"))
(define-key key-translation-map (kbd "<M-right>") (kbd "<end>"))
;; 按Alt+j 移动到其他窗口,j是jump的意思
(define-key key-translation-map (kbd "M-j") (kbd "C-x o"))
;; 按Alt+m 打开buffer列表,m是map的意思
(define-key key-translation-map (kbd "M-m") (kbd "C-x C-b"))
;; 按Alt+k 关闭当前窗口,k是kill的意思
(define-key key-translation-map (kbd "M-k") (kbd "C-x 0"))
;; 按Alt+n 切换已打开的文件,n是next的意思
(define-key key-translation-map (kbd "M-n") (kbd "C-x b"))
;; 按Ctrl+f 查找打开文件,f是find的意思
(define-key key-translation-map (kbd "\C-f") (kbd "C-x C-f"))

;;========================================================================================
;; company自动补全,快捷键Alt+/ (company 和 auto-complete 都是补全插件,用哪个自己随意,这里我用company)
;;========================================================================================
(require 'company)
;; 全局开启
(global-company-mode t)
;; 显示菜单延迟
(setq company-idle-delay .1)
;; 开始补全数字
(setq company-minimum-prefix-length 1)
;; 补全快捷键
(global-set-key "\M-/" 'company-complete)
;; 将自动补全设置成jedi
(setq elpy-rpc-backend "jedi")
;; 设置自动扩展,比方说,for之后按下如下所示的组合键,就自动展开为一个for语句
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
;; 用于重构,比方说,将光标放在某个单词上,按下如下所示的组合键,就选中了当前文件中所有的这个单词。
(define-key global-map (kbd "C-c o") 'iedit-mode)
;; 补全时能识别简写，这个是说如果我写了 "import tensorflow as tf" ，那么我再输入 "tf." 的时候能自动补全
(setq jedi:use-shortcuts t)
;; 让补全列表里的各项左右对齐
(setq company-tooltip-align-annotations t)
;; 输入句点符号 "." 的时候自动弹出补全列表，这个主要是方便用来选择 Python package 的子模块或者方法
(setq jedi:complete-on-dot t)
;; 补全列表里的项按照使用的频次排序，这样经常使用到的会放在前面，减少按键次数
(setq company-transformers '(company-sort-by-occurrence))
;; 默认使用 M-n 和 M-p 来在补全列表里移动，改成 C-n 和 C-p
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
;; 设置让 TAB 也具备相同的功能
(define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
(define-key company-active-map (kbd "S-TAB") 'company-select-previous)
(define-key company-active-map (kbd "<backtab>") 'company-select-previous)
;; 解决删除一个字符后补全提示就没有了的问题
(add-to-list 'company-begin-commands  'backward-delete-char-untabify)
(add-to-list 'company-begin-commands  'backward-kill-word)

;;========================================================================================
;;                                      C/C++
;;========================================================================================
;; 函数补全需要安装lvmm35 和 clang35
;; 头文件补全
(add-to-list 'company-backends 'company-c-headers)

;;========================================================================================
;;                                      Python
;;========================================================================================
(setq py-python-command "python3")
(setq elpy-rpc-python-command "python3") ;; 这条命令才是Python3补全的关键,前提是在shell中可以直接敲python3进入python shell
(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")
;;(setq pyvenv-virtualenvwrapper-python "/usr/bin/python3") ;; 如果没有使用虚拟环境,这条可以不启用
(require 'elpy)
;; 开启elpy插件
(elpy-enable)
;; 关闭缩进提示线
(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))
;; C-cC-c 直接运行当前python文件,主要用于单元测试
(defun shell-command-on-buffer()
(interactive)
(shell-command (concat "python3 " (buffer-file-name))))  ;; 这里运行的是Python3哦
(defvar my-keys-minor-mode-map
(let ((map (make-sparse-keymap)))
(define-key map (kbd "C-c C-c") 'shell-command-on-buffer) map) "my-keys-minor-mode keymap.")
(define-minor-mode my-keys-minor-mode "A minor mode so that my key settings override annoying major modes." :init-value t :lighter " Unit-Test(C-c C-c)")
(my-keys-minor-mode 1)
(setq elpy-company-add-completion-from-shell t)

;; F5运行,比上面的好处是有shell回显
(defun python/run-current-file (&optional directory)
  "Execute the current python file."
  (interactive
   (list (or (and current-prefix-arg
                  (read-directory-name "Run in directory: " nil nil t))
             default-directory)))
  (when (buffer-file-name)
    (let* ((command (or (and (boundp 'executable-command) executable-command)
                        (concat "python3 " (buffer-file-name))))
           (default-directory directory)
           (compilation-ask-about-save nil))
      (executable-interpret (read-shell-command "Run: " command)))))
(define-key python-mode-map [f5] 'python/run-current-file)

;;========================================================================================
;;          recentf-mode(Alt+o 打开最近使用过的文件),数据库在.emacs.d/recentf
;;========================================================================================
(recentf-mode 1)
(setq recentf-max-menu-items 35)
;; o是open的意思
(global-set-key (kbd "M-o") 'recentf-open-files)

;;========================================================================================
;;                         当前被选中的所有替换成你输入的字符
;;========================================================================================
(delete-selection-mode t)

;;========================================================================================
;;                                    实时代码检查
;;========================================================================================
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
;;如果使用的是Python3,则需用pip3安装pylint否则,实时代码检查将不可用
(setq flycheck-python-pylint-executable "/usr/bin/pylint") ;; 这里指定pylint的位置

;;========================================================================================
;;             遵循PEP8规范,保存时自动格式化代码，并纠正所有不符合PEP8标准的错误
;;========================================================================================
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)  ;; 要注意,如果没有把python3的bin目录加入环境变量,那么这个也是无法正常工作的哦

;; windows下需要开启下面的,并且需要安装KDiff3这个软件，否则autopep8无法正常使用
;(add-hook 'before-save-hook 'delete-trailing-whitespace)
;(add-hook 'find-file-hook 'find-file-check-line-endings)

;(defun dos-file-endings-p ()
;(string-match "dos" (symbol-name buffer-file-coding-system)))
;(defun find-file-check-line-endings ()
;(when (dos-file-endings-p)
;     (set-buffer-file-coding-system 'undecided-unix)
;     (set-buffer-modified-p nil)))

;;========================================================================================
;;                                       透明
;;========================================================================================
;; (set-frame-parameter (selected-frame) 'alpha '(88 70))
;; (add-to-list 'default-frame-alist '(alpha 88 70))


;;========================================================================================
;;                                   括号匹配插件
;;========================================================================================
(require 'highlight-parentheses)
(global-highlight-parentheses-mode t)

;;========================================================================================
;;                             Web开发相关: js html css
;;========================================================================================
;; 把tern后端添加到company中
(require 'company-tern)
(add-to-list 'company-backends 'company-tern)
(add-to-list 'company-backends 'company-css)

;; 打开.js文件自动启动js2-mode
;; 打开.html文件自动启动web-mode
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode)
         ("\\.html\\'" . web-mode)
         ("\\.css\\'" . css-mode))
       auto-mode-alist))

;; 打开js文件自动启动js补全
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)
                           (company-mode)))

;; 打开html文件自动开启js补全
(add-hook 'web-mode-hook (lambda ()
                           (tern-mode)
                           (company-mode)
                           ))

;; 缩进为4个空格
(defun my-web-mode-indent-setup ()
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4))
(add-hook 'web-mode-hook 'my-web-mode-indent-setup)

;;========================================================================================
;;                                 neotree目录树插件
;;========================================================================================
;; H       切换显示隐藏文件。
;; C-c C-n 创建文件，若以 / 结尾则表示创建文件夹。
;; C-c C-d 删除文件或目录。
;; C-c C-r 重命名文件或目录。
(require 'neotree)
(neotree-toggle)
;; 不要老是自动改变项目根目录
(setq-default neo-autorefresh nil)
;; 设定窗口宽度
(setq neo-window-width 35)
;; 应用宽度
(neotree-stretch-toggle)
(neotree-stretch-toggle)
;; 设置宽度为不固定
(setq neo-window-fixed-size nil)
;; 默认移动到右边的窗口
(windmove-right)

;;========================================================================================
;;                                 根据窗口编号切换窗口
;; 按Alt+0 ~ 9 切换窗口
;;========================================================================================
(require 'window-numbering)
(window-numbering-mode t)

;;========================================================================================
;;                             imenu-list右侧显示函数列表
;;========================================================================================
(require 'imenu-list)
;; 绑定快捷键,q是query的意思
(global-set-key (kbd "M-q") #'imenu-list-smart-toggle)
;; 将焦点移动到imenu-list
(setq imenu-list-focus-after-activation t)
;; 自动调整imenu-list窗口大小
;; (setq imenu-list-auto-resize t)

;; 实现选择后自动关闭imenu-list窗口
(advice-add 'imenu-list-goto-entry :after
            #'(lambda (&rest args)
                (imenu-list-smart-toggle)))

;;========================================================================================
;;                                   shell相关说明
;;========================================================================================
;; 进入shell模式的方式是 M-x shell , 使用这个命令就可以 进入shell模式,
;; 但是每次你键入这个命令都会进入同一个shell，如何打开多个shell呢？

;; 在使用上面的命令打开shell的时候,shell所在buffer的名字是 *shell* ,
;; 每次你键入上面的命 令都会切换到这个buffer ,
;; 你可以使用 M-x rename-buffer 来为这个buffer起个新名字。
;; 比如 shell-debug ， 这样再使用 M-x shell 的时候就会新开一个shell。以这种方式，你可以开任意 多个shell。

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-time-mode t)
 '(package-selected-packages
   (quote
    (window-numbering web-mode py-autopep8 neotree js2-mode imenu-list iedit highlight-parentheses flycheck elpy company-tern company-jedi company-c-headers)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "DAMA" :slant normal :weight normal :height 105 :width normal)))))
