" _________  ____ ____   ___  _   _  ____    __     _____ __  __ 
"|__  / ___|/ ___/ ___| / _ \| \ | |/ ___|   \ \   / /_ _|  \/  |
"  / / |  _| |  _\___ \| | | |  \| | |  _ ____\ \ / / | || |\/| |
" / /| |_| | |_| |___) | |_| | |\  | |_| |_____\ V /  | || |  | |
"/____\____|\____|____/ \___/|_| \_|\____|      \_/  |___|_|  |_|

let mapleader=" "	"让空格键变成leader键
syntax on		"代码高亮
set number		"显示行号
set ruler		"打开状态栏标尺
set norelativenumber	"以当前行号向上下递加
set cursorline		"强调当前行
set wrap		"字不会超出窗体
set showcmd		"显示cmd命令
set wildmenu 		"命令行提示
set hlsearch		"搜索高亮
exec "nohlsearch"
set incsearch		"边搜边高亮
set ignorecase		"搜索忽略大小写	
set smartcase		"智能大小写搜索
set nocompatible
set clipboard=unnamed   "终端下输入vim --version | grep clipboard，如果出现+clipboard则可以使用---与系统共享剪贴板
filetype on		"识别不同的文件格式
filetype indent on
filetype plugin on
filetype plugin indent on
set mouse=a		"让鼠标有用
set encoding=utf-8	"设置格式uhf-8
set tabstop=2		"缩进设置
set scrolloff=5 "上下余留5行"
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start	"让光标可以由下一行退格到上一行末尾

noremap = nzz		"检索后查询高亮内容
noremap - Nzz
noremap <LEADER><CR> :nohlsearch<CR> 	"空格加回车取消高亮
map S :w<CR>			"大写S保存
map Q :q<CR>			"大写Q退出
map R :source $MYVIMRC<CR>	"重新加载
"向上下左右分屏：hjkl-左下上右
map sl :set splitright<CR>:vsplit 
map sh :set nosplitright<CR>:vsplit 
map sk :set nosplitbelow<CR>:split 
map sj :set splitbelow<CR>:split 
"空格+方向：hjkl即转向相应分屏
map <LEADER>l <C-w>l
map <LEADER>h <C-w>h
map <LEADER>k <C-w>k
map <LEADER>j <C-w>j
map <LEADER><right> <C-w>l
map <LEADER><left> <C-w>h
map <LEADER><up> <C-w>k
map <LEADER><down> <C-w>j
"ctrl+上下左右调整分屏大小
map <C-up> :res +5<CR>
map <C-down> :res -5<CR>
map <C-left> :vertical resize -5<CR>
map <C-right> :vertical resize +5<CR>
"上下分屏改成左右分屏
map sv <C-w>t<C-w>H
map sn <C-w>t<C-w>K
"新标签:nt + 新文件名
map nt :tabe 
"跳转标签页快捷键大写N大写P
nmap <S-N> :bn<CR>
nmap <S-p> :bp<CR>
"先安装figlet
"map tx :r !figlet 
"placeholder
map <LEADER><LEADER> <ESC>/<++><CR>:nohlsearch<CR>c4l
"选中后按U即可转变大写
inoremap <C-u> <esc>gUiwea

"插件
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'  "vim主题
Plug 'iamcco/markdown-preview.vim'  "MarkDown语法预览插件
Plug 'iamcco/mathjax-support-for-mkdp'  "预览数学公式插件
Plug 'scrooloose/nerdtree'  "NERDTree
Plug 'luochen1990/rainbow'  "彩虹括号插件
Plug 'jiangmiao/auto-pairs' "自动括号补全
Plug 'junegunn/vim-easy-align'  "符号对齐
Plug 'mattn/emmet-vim'  "HTML拓展
Plug 'mhinz/vim-startify' "启动页面美化
call plug#end()	

"Airline配置
let g:airline#extensions#tabline#enabled = 1
"设置电力线字体启用
let g:airline_powerline_fonts = 1
"永远显示状态栏
set laststatus=2
"在windows中用xshell连接打开vim可以显示色彩
set t_Co=256     
"设置airline主题
let g:airline_theme='bubblegum'
"VIM主题配置
colorscheme gruvbox
set background=dark    " Setting dark mode

"markdown插件使用
let g:mkdp_path_to_chrome = "/usr/bin/google-chrome-stable"
" 设置 chrome 浏览器的路径（或是启动 chrome（或其他现代浏览器）的命令）
" 如果设置了该参数, g:mkdp_browserfunc 将被忽略
let g:mkdp_browserfunc = 'MKDP_browserfunc_default'
" vim 回调函数, 参数为要打开的 url
let g:mkdp_auto_start = 1
" 设置为 1 可以在打开 markdown 文件的时候自动打开浏览器预览，只在打开
" markdown 文件的时候打开一次
let g:mkdp_auto_open = 1
" 设置为 1 在编辑 markdown 的时候检查预览窗口是否已经打开，否则自动打开预
" 览窗口
let g:mkdp_auto_close = 1
" 在切换 buffer 的时候自动关闭预览窗口，设置为 0 则在切换 buffer 的时候不
" 自动关闭预览窗口
let g:mkdp_refresh_slow = 0
" 设置为 1 则只有在保存文件，或退出插入模式的时候更新预览，默认为 0，实时
" 更新预览
let g:mkdp_command_for_global = 0
" 设置为 1 则所有文件都可以使用 MarkdownPreview 进行预览，默认只有 markdown
" 文件可以使用改命令
let g:mkdp_open_to_the_world = 0
" 设置为 1, 在使用的网络中的其他计算机也能访问预览页面
" 默认只监听本地（127.0.0.1），其他计算机不能访问
nmap <silent> <F8> <Plug>MarkdownPreview        " 普通模式
imap <silent> <F8> <Plug>MarkdownPreview        " 插入模式
nmap <silent> <C-F8> <Plug>StopMarkdownPreview    " 普通模式
imap <silent> <C-F8> <Plug>StopMarkdownPreview    " 插入模式

"NERDTree配置
"自动打开NERDTree
"autocmd vimenter * NERDTree
"设置NERDTree打开快捷键为tt
map tt :NERDTreeToggle<CR>
"窗口大小
let NERDTreeWinSize=20
"是否默认显示行号
let NERDTreeShowLineNumbers=0
"是否默认显示隐藏文件
let NERDTreeShowHidden=1
" 显示书签列表
let NERDTreeShowBookmarks=0
