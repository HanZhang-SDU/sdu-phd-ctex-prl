\NeedsTeXFormat{LaTeX2e}[2022-06-01]
\ProvidesClass{sduthesis}[2026/10/27 v1.1 Unofficial SDU doctoral thesis]
% 本模板不是学校官方发布的文档类。依据与待确认事项见 SOURCES.md。
\RequirePackage{iftex}
\ifXeTeX\else
  \ClassError{sduthesis}{XeLaTeX is required}{Select XeLaTeX; do not use pdfLaTeX.}
\fi
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=sdu,prefix=sdu@}
\DeclareStringOption[strict]{fonts}
\DeclareStringOption[prl]{bibstyle}
\DeclareBoolOption[false]{blind}
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessKeyvalOptions*
\edef\sdu@fonts{\sdu@fonts}
\edef\sdu@bibstyle{\sdu@bibstyle}
\LoadClass[UTF8,a4paper,zihao=-4,fontset=none]{ctexbook}
\RequirePackage{etoolbox}
\RequirePackage{fontspec}
\RequirePackage{amsmath,amsthm}
\RequirePackage{unicode-math}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{array,booktabs,longtable,tabularx}
\RequirePackage{caption,subcaption}
\RequirePackage{fancyhdr}
\RequirePackage[titles]{tocloft}
\RequirePackage{pdfpages}
\RequirePackage{xurl}
\RequirePackage{csquotes}

% ---------------------------------------------------------------
% 字体。strict 不允许在缺字体时悄悄换用 Fandol；portable 仅供预览。
% ---------------------------------------------------------------
\newif\ifsdu@portable
\ifdefstring{\sdu@fonts}{strict}{%
  \IfFontExistsTF{SimSun}{}{%
    \ClassError{sduthesis}{Required font SimSun is missing}
      {Install a lawfully licensed SimSun font, or compile preview.tex for a non-submission preview.}}
  \IfFontExistsTF{SimHei}{}{%
    \ClassError{sduthesis}{Required font SimHei is missing}
      {Install a lawfully licensed SimHei font.}}
  \IfFontExistsTF{Times New Roman}{}{%
    \ClassError{sduthesis}{Required font Times New Roman is missing}
      {Install a lawfully licensed Times New Roman font.}}
  \setmainfont{Times New Roman}
  \setCJKmainfont[AutoFakeBold=2.2]{SimSun}
  \setCJKsansfont[AutoFakeBold=2.2]{SimHei}
  \setCJKmonofont{SimSun}
  \setCJKfamilyfont{song}[AutoFakeBold=2.2]{SimSun}
  \setCJKfamilyfont{hei}[AutoFakeBold=2.2]{SimHei}
  \IfFontExistsTF{KaiTi}{\setCJKfamilyfont{kai}{KaiTi}}
    {\setCJKfamilyfont{kai}{SimSun}}
}{%
  \ifdefstring{\sdu@fonts}{portable}{%
    \sdu@portabletrue
    \setmainfont{XITS}[
      Extension=.otf,UprightFont=*-Regular,BoldFont=*-Bold,
      ItalicFont=*-Italic,BoldItalicFont=*-BoldItalic]
    \setCJKmainfont{FandolSong-Regular.otf}[
      BoldFont=FandolSong-Bold.otf,ItalicFont=FandolKai-Regular.otf]
    \setCJKsansfont{FandolHei-Regular.otf}[BoldFont=FandolHei-Bold.otf]
    \setCJKmonofont{FandolFang-Regular.otf}
    \setCJKfamilyfont{song}{FandolSong-Regular.otf}[BoldFont=FandolSong-Bold.otf]
    \setCJKfamilyfont{hei}{FandolHei-Regular.otf}[BoldFont=FandolHei-Bold.otf]
    \setCJKfamilyfont{kai}{FandolKai-Regular.otf}
    \ClassWarningNoLine{sduthesis}{PORTABLE FONTS: preview only, not for submission}
  }{%
    \ifdefstring{\sdu@fonts}{custom}{%
      \InputIfFileExists{config/fonts-local.tex}{}{%
        \ClassError{sduthesis}{config/fonts-local.tex is missing}
          {Copy fonts-local.tex.example and configure your licensed fonts.}}
    }{\ClassError{sduthesis}{Unknown fonts option}{Use strict, portable or custom.}}
  }
}
\providecommand{\songti}{\CJKfamily{song}}
\providecommand{\heiti}{\CJKfamily{hei}}
\providecommand{\kaishu}{\CJKfamily{kai}}
\setsansfont{lmsans10-regular.otf}[
  BoldFont=lmsans10-bold.otf,ItalicFont=lmsans10-oblique.otf,
  BoldItalicFont=lmsans10-boldoblique.otf]
\setmonofont{lmmono10-regular.otf}[ItalicFont=lmmono10-italic.otf,Scale=MatchLowercase]
% 数学字体为模板选择，并非把数学符号强制替换成 Times New Roman。
\setmathfont{XITSMath-Regular.otf}[BoldFont=XITSMath-Bold.otf]

% ---------------------------------------------------------------
% 正文。bp = 1/72 inch，与 Word 的“磅”相同；TeX pt 则为 1/72.27 inch。
% 段前段后 0；普通文本基线距 20bp；高公式允许 TeX 扩大局部距离。
% ---------------------------------------------------------------
\geometry{top=28mm,bottom=25mm,left=25mm,right=25mm,
  headheight=5mm,headsep=8mm,footskip=7.5mm}
\linespread{1}
\let\sdu@normal\normalsize
\renewcommand{\normalsize}{%
  \sdu@normal\fontsize{12bp}{20bp}\selectfont
  \abovedisplayskip=8bp plus 2bp minus 2bp
  \belowdisplayskip=8bp plus 2bp minus 2bp
  \abovedisplayshortskip=4bp plus 2bp
  \belowdisplayshortskip=6bp plus 2bp minus 2bp}
\renewcommand{\small}{\fontsize{10.5bp}{16bp}\selectfont}
\renewcommand{\footnotesize}{\fontsize{9bp}{13bp}\selectfont}
\setlength{\parskip}{0pt}
\setlength{\parindent}{2\ccwd}
\setlength{\emergencystretch}{1em}
\raggedbottom
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}
\ctexset{
  chapter={name={,},number=\arabic{chapter},
    format=\centering\heiti\bfseries\fontsize{15bp}{20bp}\selectfont,
    beforeskip=24bp,afterskip=18bp,fixskip=true,afterindent=true},
  section={format=\heiti\bfseries\fontsize{14bp}{20bp}\selectfont,
    beforeskip=18bp,afterskip=6bp,afterindent=true},
  subsection={format=\heiti\bfseries\fontsize{12bp}{20bp}\selectfont,
    beforeskip=12bp,afterskip=6bp,afterindent=true},
  subsubsection={format=\heiti\bfseries\fontsize{12bp}{20bp}\selectfont,
    beforeskip=12bp,afterskip=6bp,afterindent=true},
  contentsname={目\quad 录},listfigurename={插图目录},listtablename={表格目录}
}
\renewcommand{\thefigure}{\thechapter-\arabic{figure}}
\renewcommand{\thetable}{\thechapter-\arabic{table}}
\renewcommand{\theequation}{\thechapter.\arabic{equation}}
\DeclareCaptionFont{sducaption}{\songti\fontsize{10.5bp}{14bp}\selectfont}
\captionsetup{font=sducaption,labelfont=normalfont,labelsep=quad,
  skip=6bp,justification=centering,singlelinecheck=true}
\captionsetup[table]{position=top}
\captionsetup[figure]{position=bottom}
\captionsetup[sub]{font=sducaption}
\renewcommand{\arraystretch}{1.2}

% 页眉从摘要开始；罗马页码与正文阿拉伯页码分开计数。
\newcommand{\sdu@header}{山东大学博士学位论文}
\ifsdu@blind\renewcommand{\sdu@header}{博士学位论文}\fi
\fancypagestyle{sdu}{%
  \fancyhf{}
  \fancyhead[C]{\songti\fontsize{10.5bp}{13bp}\selectfont\sdu@header}
  \fancyfoot[C]{\rmfamily\fontsize{10.5bp}{13bp}\selectfont\thepage}
  \renewcommand{\headrulewidth}{0.4pt}
  \renewcommand{\footrulewidth}{0pt}}
\fancypagestyle{plain}{%
  \fancyhf{}
  \fancyhead[C]{\songti\fontsize{10.5bp}{13bp}\selectfont\sdu@header}
  \fancyfoot[C]{\rmfamily\fontsize{10.5bp}{13bp}\selectfont\thepage}
  \renewcommand{\headrulewidth}{0.4pt}}
\newcommand{\sdu@clearmatter}{\if@openright\cleardoublepage\else\clearpage\fi}
\renewcommand{\frontmatter}{\sdu@clearmatter\@mainmatterfalse\pagenumbering{Roman}\pagestyle{sdu}}
\renewcommand{\mainmatter}{\sdu@clearmatter\@mainmattertrue\pagenumbering{arabic}\pagestyle{sdu}}
\renewcommand{\backmatter}{\clearpage\@mainmatterfalse}
\renewcommand{\cftchapfont}{\songti}
\renewcommand{\cftchappagefont}{\rmfamily}
\renewcommand{\cftsecfont}{\songti}
\renewcommand{\cftsubsecfont}{\songti}
\setlength{\cftbeforechapskip}{6bp}
\setlength{\cftbeforesecskip}{0bp}
\setlength{\cftbeforesubsecskip}{0bp}
\setlength{\cftchapnumwidth}{2.5em}
\setlength{\cftsecindent}{1em}
\setlength{\cftsecnumwidth}{3em}
\setlength{\cftsubsecindent}{2em}
\setlength{\cftsubsecnumwidth}{4em}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
% tocloft 的默认标题不一定换页；统一用 ctex 的无编号章标题。
\renewcommand{\tableofcontents}{\chapter*{\contentsname}\@starttoc{toc}}

% ---------------------------------------------------------------
% 文献样式：主分支是 biblatex-phys 的 APS/PRL-like 设置。
% ---------------------------------------------------------------
\ifdefstring{\sdu@bibstyle}{prl}{%
  \RequirePackage[
    backend=biber,style=phys,sorting=none,sortcites=true,
    autocite=plain,biblabel=brackets,
    articletitle=false,chaptertitle=false,pageranges=false,
    giveninits=true,maxbibnames=999,maxcitenames=2,
    doi=false,url=false,isbn=false,eprint=true
  ]{biblatex}
  % 同时提供全称 journaltitle 和缩写 shortjournal 时，PRL 分支使用后者。
  \DeclareSourcemap{\maps[datatype=bibtex]{\map[overwrite]{%
    \step[fieldsource=shortjournal,final]
    \step[fieldset=journaltitle,origfieldval]}}}
}{%
  \ifdefstring{\sdu@bibstyle}{gb2015}{%
    \RequirePackage[backend=biber,style=gb7714-2015,sorting=none,
      gbpub=false]{biblatex}
  }{\ClassError{sduthesis}{Unknown bibstyle option}{Use prl or gb2015.}}
}
\renewcommand*{\bibfont}{\songti\fontsize{10.5bp}{16bp}\selectfont}
\setlength{\bibitemsep}{3bp}
\setlength{\bibparsep}{0pt}

\RequirePackage[unicode,bookmarksnumbered,hidelinks]{hyperref}
\RequirePackage{bookmark}
\pdfstringdefDisableCommands{\def\quad{ }\def\qquad{ }}
\urlstyle{same}
% 外观：PRL 是平排方括号，不是上标。学校若要上标，可显式使用这个命令。
\NewDocumentCommand{\supcite}{m}{\textsuperscript{\cite{#1}}}

% 中英目录条目由同一处标题写入，不手工维护页码。
\NewDocumentCommand{\bichapter}{m m}{%
  \chapter{#1}\addcontentsline{toe}{chapter}{\protect\numberline{\thechapter}#2}}
\NewDocumentCommand{\bisection}{m m}{%
  \section{#1}\addcontentsline{toe}{section}{\protect\numberline{\thesection}#2}}
\NewDocumentCommand{\bisubsection}{m m}{%
  \subsection{#1}\addcontentsline{toe}{subsection}{\protect\numberline{\thesubsection}#2}}
\NewDocumentCommand{\sduchapterstar}{m m}{%
  \chapter*{#1}\phantomsection
  \addcontentsline{toc}{chapter}{#1}\addcontentsline{toe}{chapter}{#2}}
\newcommand{\sduEnglishContents}{%
  \chapter*{CONTENTS}\begingroup
  \renewcommand{\cftchapfont}{\rmfamily}
  \renewcommand{\cftsecfont}{\rmfamily}
  \renewcommand{\cftsubsecfont}{\rmfamily}
  \@starttoc{toe}\endgroup}
\defbibheading{sdubib}[参考文献]{\sduchapterstar{#1}{References}}

% 独立的博士期间发表文章目录。
% refsection 隔离数据、引用记录和编号；不是仅改变打印筛选条件。
% 仅在此环境内部，\cite{key,...} 表示“选入文章目录”，不打印零散引用号。
% 环境结束时统一输出完整条目；正文的 \cite 定义不受影响。
% 可选参数可换为其他 .bib 文件，例如 [references.bib]。
\newif\ifsdu@pubitems
\NewDocumentEnvironment{sdupublications}{O{publications.bib}}{%
  \sduchapterstar{博士期间发表的文章目录}{Publications during the doctoral study}%
  \begin{refsection}[#1]%
  \begin{refcontext}[sorting=none]%
  \ifdefstring{\sdu@bibstyle}{prl}{\toggletrue{bbx:articletitle}}{}%
  \sdu@pubitemsfalse
  \RenewDocumentCommand{\cite}{m}{%
    \sdu@pubitemstrue\nocite{##1}\ignorespaces}%
  \ignorespaces
}{%
  \par
  \ifsdu@pubitems
    \printbibliography[heading=none]%
  \fi
  \end{refcontext}%
  \end{refsection}%
}

\newcommand{\cnkeywords}[1]{\par\vspace{10bp}\noindent\textbf{关键词：}#1\par}
\newcommand{\enkeywords}[1]{\par\vspace{10bp}\noindent\textbf{Keywords: }#1\par}

% ---------------------------------------------------------------
% 封面数据：用户只需修改 config/metadata.tex。
% ---------------------------------------------------------------
\def\sdu@title{中文论文题目（请替换）}
\def\sdu@entitle{Dissertation Title (Please Replace)}
\def\sdu@author{作者姓名}
\def\sdu@studentid{学号}
\def\sdu@classification{分类号}
\def\sdu@secrecy{公开}
\def\sdu@schoolcode{10422}
\def\sdu@school{培养单位}
\def\sdu@training{非定向}
\def\sdu@major{专业名称}
\def\sdu@supervisor{指导教师}
\def\sdu@cosupervisor{}
\def\sdu@date{年\quad 月\quad 日}
\define@key{sduinfo}{title}{\def\sdu@title{#1}}
\define@key{sduinfo}{title-en}{\def\sdu@entitle{#1}}
\define@key{sduinfo}{author}{\def\sdu@author{#1}}
\define@key{sduinfo}{student-id}{\def\sdu@studentid{#1}}
\define@key{sduinfo}{classification}{\def\sdu@classification{#1}}
\define@key{sduinfo}{secrecy}{\def\sdu@secrecy{#1}}
\define@key{sduinfo}{school-code}{\def\sdu@schoolcode{#1}}
\define@key{sduinfo}{school}{\def\sdu@school{#1}}
\define@key{sduinfo}{training}{\def\sdu@training{#1}}
\define@key{sduinfo}{major}{\def\sdu@major{#1}}
\define@key{sduinfo}{supervisor}{\def\sdu@supervisor{#1}}
\define@key{sduinfo}{co-supervisor}{\def\sdu@cosupervisor{#1}}
\define@key{sduinfo}{date}{\def\sdu@date{#1}}
\newcommand{\sduSetup}[1]{\setkeys{sduinfo}{#1}}
\newcommand{\sduTitle}{\sdu@title}
\newcommand{\sduTitleEn}{\sdu@entitle}
\newcommand{\sduIfBlindTF}[2]{\ifsdu@blind #1\else #2\fi}
\newcommand{\sdu@private}[1]{\ifsdu@blind 匿名\else #1\fi}

% 根据用户 cover.pdf 第1页绝对位置重建；校名校徽来自原 PDF 的内嵌位图。
% 除校名校徽外，所有信息都是可编辑的 LaTeX 文字。
\newcommand{\sduMakeCover}{%
  \clearpage\thispagestyle{empty}\hypersetup{pageanchor=false}
  \begin{tikzpicture}[remember picture,overlay]
    \begin{scope}[shift={(current page.north west)},x=1bp,y=-1bp]
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (90,111.36) {分类号：};
      \node[anchor=base west,inner sep=0,font=\rmfamily\fontsize{15bp}{18bp}\selectfont] at (163.8,111.36) {\sdu@classification};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (360,111.36) {单位代码：};
      \node[anchor=base west,inner sep=0,font=\rmfamily\fontsize{15bp}{18bp}\selectfont] at (435,111.36) {\sdu@schoolcode};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (90,142.6) {密\quad 级：};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (163.8,142.6) {\sdu@secrecy};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (360,142.6) {学\quad 号：};
      \node[anchor=base west,inner sep=0,font=\rmfamily\fontsize{15bp}{18bp}\selectfont] at (435,142.6) {\sdu@private{\sdu@studentid}};
      \ifsdu@blind\else
        \node[anchor=north west,inner sep=0] at (176.15,191.71)
          {\includegraphics[width=0.6\textwidth]{assets/sdu-logo.jpg}};
      \fi
      \node[anchor=base,inner sep=0,font=\heiti\fontsize{58bp}{64bp}\selectfont] at (297.66,338.04)
        {\makebox[370bp][s]{博\hfil 士\hfil 学\hfil 位\hfil 论\hfil 文}};
      \node[anchor=base,inner sep=0,font=\rmfamily\fontsize{18bp}{22bp}\selectfont] at (297.66,377.5)
        {Dissertation for Doctoral Degree};
      \node[anchor=base,inner sep=0,font=\heiti\fontsize{26bp}{30bp}\selectfont] at (297.66,405.8)
        {（学术学位）};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (90,433.8) {论文题目：};
      % 中英文题目在一个段落盒中依次排版，避免二行中文题目覆盖英文。
      % 推荐中文至多两行、英文至多两行；更长题目需减小下面字号。
      \node[anchor=north,inner sep=0,text width=365bp,align=center]
        at (297.66,442) {\centering
          {\heiti\bfseries\fontsize{22bp}{25bp}\selectfont\sdu@title\par}
          \vspace{3bp}
          {\rmfamily\bfseries\fontsize{14bp}{16bp}\selectfont\sdu@entitle\par}};
      \foreach \y in {548,576,604,632,660,688}{\draw[line width=.45bp] (240,\y)--(435,\y);}
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (150,545.8) {作\enspace 者\enspace 姓\enspace 名};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (150,573.8) {培\enspace 养\enspace 单\enspace 位};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (150,601.8) {培\enspace 养\enspace 方\enspace 式};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (150,629.8) {专\enspace 业\enspace 名\enspace 称};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (150,657.8) {指\enspace 导\enspace 教\enspace 师};
      \node[anchor=base west,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (150,685.8) {合\enspace 作\enspace 导\enspace 师};
      \node[anchor=base,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (337.5,541.8) {\sdu@private{\sdu@author}};
      \node[anchor=base,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (337.5,569.8) {\sdu@school};
      \node[anchor=base,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (337.5,597.8) {\sdu@training};
      \node[anchor=base,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (337.5,625.8) {\sdu@major};
      \node[anchor=base,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (337.5,653.8) {\sdu@private{\sdu@supervisor}};
      \node[anchor=base,inner sep=0,font=\songti\fontsize{15bp}{18bp}\selectfont] at (337.5,681.8) {\sdu@private{\sdu@cosupervisor}};
      \node[anchor=base,inner sep=0,font=\heiti\fontsize{16bp}{20bp}\selectfont] at (297.66,763.8) {\sdu@date};
    \end{scope}
  \end{tikzpicture}\null\clearpage
}
\NewDocumentCommand{\sduPendingPage}{m m}{%
  \clearpage\thispagestyle{empty}
  \vspace*{35mm}\begin{center}{\heiti\fontsize{18bp}{26bp}\selectfont #1}\end{center}
  \vspace{12mm}\noindent #2\par
  \vspace{8mm}\noindent\textbf{此页是模板占位页，不是学校正式表格；提交前必须替换。}
  \clearpage}

\AtBeginDocument{%
  \normalfont\normalsize\setlength{\parindent}{2\ccwd}
  \hypersetup{pdftitle={\sdu@title},pdfauthor={\sdu@author},
    pdfsubject={Shandong University doctoral thesis template}}
  \ifsdu@blind\hypersetup{pdfauthor={},pdfsubject={Anonymous doctoral dissertation}}\fi
  \typeout{SDU-CHECK: body-size=\f@size pt; baseline=\the\baselineskip; indent=\the\parindent}
  \typeout{SDU-CHECK: textwidth=\the\textwidth; textheight=\the\textheight}
}
\ifsdu@portable
  \AddToHook{shipout/foreground}{%
    \begin{tikzpicture}[remember picture,overlay]
      \node[anchor=south,text=gray,font=\songti\fontsize{7bp}{9bp}\selectfont]
        at ([yshift=6mm]current page.south)
        {预览：Fandol / XITS 替代字体，非提交版本};
    \end{tikzpicture}}
\fi
\endinput
