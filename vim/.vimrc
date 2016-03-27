
syntax on	" 语法高亮
colorscheme wombat256

set autoindent 	" 自动对齐
set smartindent " 开启新行时使用智能自动缩进
set cursorline	" 横线指示当前行
set tabstop=4
set shiftwidth=4

set ruler 	" 打开状态栏标尺

set incsearch	" 输入搜索内容时就显示搜索结果
set hlsearch	" 搜索时高亮显示被找到的文本

set showmatch	" 插入括号时，短暂地跳转到匹配的对应括号

set laststatus=2 "显示状态栏 (默认值为 1, 无法显示状态栏)
set cmdheight=1 " 显示状态栏 (默认值为 1, 无法显示状态栏)
" 设置在状态行显示的信息
" set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ %c:%l/%L%)
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")} "状态行显示的内容

"普通状态下输入f即可打印出function定义
nnoremap f ofunction () {<ENTER><ESC>i}<ESC>kwi
" 这样分号键就可以进入命令行模式
nnoremap ; :

inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap " ""<ESC>i
inoremap { {}<ESC>i
"inoremap { {<ESC>o}<ESC>ko
"输入("时补全");
inoremap (" ("");<ESC>hhi
inoremap then thenend<ESC>hhi<ENTER><BACKSPACE><ESC>ko

filetype on
