# 山东大学博士学位论文 LaTeX 模板

**ctexbook · XeLaTeX · biblatex / Biber · PRL-like references**  
版本：1.2（2026-10-27）

本项目按用户提供的 `cover.pdf` 重建封面，正文使用山东大学公开研究生学位论文撰写指南中已核实的字体、字号、行距和页边距。文献样式按用户要求采用接近 REVTeX / PRL 的 APS 风格。**这是定制模板，不是学校官方模板，也不代表已通过学院的格式审查。** 规范来源、核验范围和待确认项见 `SOURCES.md`。

## 先编译

### Linux / TeX Live：Makefile（v1.2）

在项目根目录运行；已有 v1.1 项目只需替换 `Makefile`，不必覆盖论文内容：

```sh
make check              # 检查工具和主要宏包，不验证正式字体
make                    # 正式版：main.pdf
make preview            # 替代字体预览版：preview.pdf
make rebuild            # 强制重编译正式版
make rebuild-preview    # 强制重编译预览版
make clean              # 清理辅助文件，保留 PDF
make distclean          # 连同生成的 PDF 一起清理；不删除源 PDF
make help               # 列出全部命令
```

默认采用项目原有的 `latexmkrc`，明确使用 XeLaTeX；latexmk 按文档的
`backend=biber` 设置调用 Biber 并按需重复编译，不使用 BibTeX。
正文与发表文章目录的两个 `refsection` 由同一份 Biber 作业处理，
**不要单独执行 `biber publications`**。本次不修改任何 `.tex`、`.cls` 或 `.bib`。

TeX Live 已在 `PATH` 中时不必配置。自定义安装位置可通过环境或命令行指定：

```sh
make preview TEXBIN=/你的TeXLive安装目录/bin/x86_64-linux
# 或按本机真实目录修改后写入 shell 配置：
# export PATH="/你的TeXLive安装目录/bin/x86_64-linux:$PATH"
```

`TEXBIN` 必须是包含 `xelatex`、`biber`、`kpsewhich` 等命令的真实目录；
并非固定要求某个年份或 CPU 架构。应使用互相兼容的 biblatex / Biber，
避免意外混用系统发行版与另一套 TeX Live 的程序。

已有 TeX Live 但没有 latexmk 时，仍提供原来的固定四步编译：

```sh
make manual             # XeLaTeX -> Biber -> XeLaTeX -> XeLaTeX
make manual-preview     # 对 preview.tex 执行同样流程
```

固定四步后若日志仍提示需要重编译，应再运行 XeLaTeX；日常推荐自动判断轮次的
默认 latexmk 目标。Makefile 不自动安装软件，不执行 sudo，不要求 shell-escape。

可选维护命令：

```sh
make watch-preview      # 监视源文件并持续重编译，不打开 GUI，Ctrl-C 停止
make check-preview      # 编译预览并运行已有日志检查工具，需要 python3
make test               # 编译已有发表文章目录回归示例并检查日志，需要 python3
```

正式 / 预览版的输出路径与 v1.1 相同。两者共享部分章节 `.aux`，所以 Makefile
串行执行目标，即使传入 `-j` 也不同时编译；也不要另开终端同时构建本目录。
为避免全局 latexmk 配置改变引擎或输出位置，本 Makefile 使用 `-norc -r latexmkrc`，
只读取项目内配置。可用 `LATEXMK=/完整路径/latexmk` 或 `PYTHON=python3` 覆盖程序，
用 `LATEXMKFLAGS=-quiet` 追加选项；不要通过该变量更换作业名或输出目录。

**正式版仍要求 SimSun / SimHei / Times New Roman；TeX Live 可运行不代表这些字体
已经安装。** 缺少正式字体时先运行 `make preview`；本次不改变字体要求、封面布局或
发表文章目录的独立编号。清理命令需安装 latexmk；它们不会删除 `.tex`、`.bib`、
插图或插入的官方页面 PDF。

### 正式字体入口

在本机安装有合法授权的 **SimSun（宋体）、SimHei（黑体）、Times New Roman** 后，在项目根目录运行：

```sh
latexmk -r latexmkrc -xelatex main.tex
```

或者明确执行四步：

```sh
xelatex -interaction=nonstopmode -halt-on-error main.tex
biber main
xelatex -interaction=nonstopmode -halt-on-error main.tex
xelatex -interaction=nonstopmode -halt-on-error main.tex
```

输出为 `main.pdf`。Biber 后面是作业名 `main`，不是 `main.tex`，也不是 `references.bib`。编译引擎必须为 **XeLaTeX**；不要选 pdfLaTeX。模板不要求 shell-escape。

### 无学校所需字体的预览入口

```sh
latexmk -r latexmkrc -xelatex preview.tex
```

输出 `preview.pdf`。这个入口使用 TeX 发行版中的 **Fandol + XITS** 替代字体，页底会显示“预览：Fandol / XITS 替代字体，非提交版本”。

**随包预览 PDF 已实际编译；正式 SimSun / SimHei / Times New Roman 字体组合未在本次环境中完成排版测试，因为环境没有这些字体。** 不要删除预览提示后将替代字体当作已满足学校要求。正式入口缺少必需字体时会报错，不会静默切换到 Fandol。

采用集成编辑器时，把根文档指定为 `main.tex` 或 `preview.tex`，编译器设为 XeLaTeX，文献工具设为 Biber。不要直接编译 `chapters/` 下的章节。

## 文件结构

```text
main.tex                    正式入口；安排各部分的顺序
preview.tex                 仅改变字体模式的预览入口
sduthesis.cls               版面、字体、封面、目录和文献样式
config/metadata.tex         论文题目、姓名、导师、日期等
config/macros.tex           学科相关命令、定理环境
config/fonts-local.tex.example  自定义字体配置示例
front/                      摘要、符号表、官方页面插入位置
chapters/                   正文章节
back/                       附录、致谢、博士期间发表的文章目录、答辩情况页
references.bib              正文参考文献数据库
publications.bib            博士期间发表的文章数据库（独立编号）
assets/sdu-logo.png         从用户封面提取的校名与校徽位图
assets/cover-reference.pdf  用户原始封面，供比较；不参与默认正文编译
figures/                    放置研究插图
checks/verify_build.py       可选的编译日志检查工具
BUILD-REPORT.md             本次实际测试记录
SOURCES.md                  格式与软件文档来源
latexmkrc / Makefile         编译配置
```

## 修改封面和论文内容

编辑 `config/metadata.tex`：

```tex
\sduSetup{
  title         = {你的中文论文题目},
  title-en      = {Your Dissertation Title},
  author        = {张涵},
  student-id    = {202212108},
  school        = {物理学院},
  major         = {理论物理},
  supervisor    = {司宗国},
  co-supervisor = {蒋军},
  date          = {2027 年\quad 05 月\quad 21 日}
}
```

已填写的人名、单位、学号、分类号和日期来自上传封面；日期是沿用原稿，不是已确认的答辩日期。论文题目在原封面中未填写，所以这里明确使用占位文字。导师职称未作推断，需要时自行据实添加。

封面除校名校徽外均为可编辑文字，校名校徽保留原 PDF 内嵌位图。中英文题目依次排版，建议各不超过两行；很长的题目应调整 `sduthesis.cls` 中封面题目盒的宽度或字号，并查看 PDF，不能仅依赖无报错。

正文使用中英双标题命令，英文目录页码自动生成：

```tex
\bichapter{绪论}{Introduction}
\bisection{研究背景}{Research background}
\bisubsection{基本定义}{Basic definitions}
```

无编号但进入两个目录的部分使用：

```tex
\sduchapterstar{符号说明}{List of Symbols}
```

单独使用 `\chapter` / `\section` 仍可排版，但不会自动补出英文翻译及英文目录条目。图表与公式、交叉引用、三线表、定理、脚注的完整示例在 `chapters/02-methods.tex`。所有示例数字和曲线都是排版占位内容，不是科研结果。

## 正文字体和版面

| 项目 | 模板设置 |
| --- | --- |
| 中文正文 | 宋体 SimSun，小四号，即 12 bp |
| 拉丁文字、阿拉伯数字 | Times New Roman，正文 12 bp |
| 普通正文行距 | 固定基线间距 20 bp |
| 段落 | 首行缩进 2 个汉字，两端对齐，段前段后 0 |
| 纸张及页边距 | A4；上 28 mm，下 / 左 / 右 25 mm |
| 页眉 | 摘要起显示“山东大学博士学位论文”，居中，五号宋体 |
| 页码 | 前置部分罗马数字；正文起阿拉伯数字；居中五号 |
| 章标题 | 黑体加粗，小三号 15 bp |
| 数学 | unicode-math + XITS Math，区别于普通英文字体 |

这里的 `bp` 是 1/72 英寸，和 Word 磅值一致；TeX 的 `pt` 是 1/72.27 英寸。因此日志中的 `12.045pt` 和 `20.075pt` 分别对应 12 bp 与 20 bp，并不是字号错误。模板没有把 `1.5` 倍行距当成固定 20 磅的替代。

高于常规字高的行内公式可能触发 TeX 的局部行距保护；建议把复杂分式放入独立公式环境。小节标题间距、图表题注、脚注、参考文献字号及数学字体等具体设置是可修改的模板选择，不能一概称为学校逐项指定。

### 自定义字体路径

系统字体名称不一致，或在 Linux / 在线环境使用自行合法取得的字体时：将 `config/fonts-local.tex.example` 复制为 `config/fonts-local.tex`，设置本机可用的字体名称或文件路径，再把 `main.tex` 的 `\SDUFontMode` 默认值改为 `custom`。

例如自行准备 `fonts/` 目录后，可在字体配置文件中按实际文件名设置：

```tex
\setmainfont{times.ttf}[
  Path=fonts/,
  BoldFont=timesbd.ttf,
  ItalicFont=timesi.ttf,
  BoldItalicFont=timesbi.ttf]
\setCJKmainfont{simsun.ttc}[Path=fonts/,AutoFakeBold=2.2]
\setCJKsansfont{simhei.ttf}[Path=fonts/,AutoFakeBold=2.2]
\setCJKmonofont{simsun.ttc}[Path=fonts/]
\setCJKfamilyfont{song}{simsun.ttc}[Path=fonts/,AutoFakeBold=2.2]
\setCJKfamilyfont{hei}{simhei.ttf}[Path=fonts/,AutoFakeBold=2.2]
\setCJKfamilyfont{kai}{simsun.ttc}[Path=fonts/]
```

`custom` 是显式人工配置，不会验证所选字体是否被学院认可。字体集合的字面索引、文件名、授权和可嵌入性由使用者核实。本项目**不提供任何字体文件**。

## PRL-like 文献样式

默认在 `sduthesis.cls` 加载：

```tex
\RequirePackage[
  backend=biber,style=phys,sorting=none,sortcites=true,
  autocite=plain,biblabel=brackets,
  articletitle=false,chaptertitle=false,pageranges=false,
  giveninits=true,maxbibnames=999,maxcitenames=2,
  doi=false,url=false,isbn=false,eprint=true
]{biblatex}
```

模板采用 `biblatex-phys` 文档所列 APS 配置，而不是只写 `style=phys` 后保留其 AIP 默认设置。默认正文是平排方括号编号，首次引用排序，连续三条及以上压缩，例如 `[1–3]`。文献表使用作者名字缩写、期刊缩写、粗体卷号、首页或文章号、括号年份，不显示期刊论文标题。这个配置接近 PRL 的惯常外观，但不是直接调用 `apsrev4-2.bst`，也不承诺与 REVTeX 4.2 对所有条目类型完全一致。

```tex
\cite{Higgs1964}
\cite{Higgs1964,Englert1964,Weinberg1967}
\autocite{Higgs1964}
\textcite{Weinberg1967}
\cite[508]{Higgs1964}
```

需要上标时，使用模板的 `\supcite{key}`，不要把它误当成默认 PRL 行内引用。该简易命令只接收引用键，不接收可选前注 / 后注。

文献数据库保留完整信息：

```bibtex
@article{Higgs1964,
  author       = {Higgs, Peter W.},
  title        = {Broken Symmetries and the Masses of Gauge Bosons},
  journaltitle = {Physical Review Letters},
  shortjournal = {Phys. Rev. Lett.},
  volume       = {13},
  pages        = {508--509},
  date         = {1964},
  doi          = {10.1103/PhysRevLett.13.508}
}
```

仅在 PRL 分支，Biber 的 source map 将有值的 `shortjournal` 用于排版；没有这个字段时保留 `journaltitle`。该过程不会修改原始 `.bib` 文件，也不会自动为所有期刊推断正确缩写。电子文章号放入 `eid`，页码范围用 `pages`。

DOI 保存并用于可点击文献链接；`doi=false` 主要控制是否打印 DOI 字符串。`phys` 对缺少页码和文章号的期刊条目有例外处理，可能仍打印 DOI。模板选择 `eprint=true`，因此含 arXiv 字段的条目可显示预印本号；在主文件中设置 `\ExecuteBibliographyOptions{eprint=false}` 可关闭。

需要打印文章题名时，在主文件中取消这行注释：

```tex
\ExecuteBibliographyOptions{articletitle=true}
```

不要再加载 `natbib`，不要使用 `\bibliographystyle{apsrev4-2}` 或 `\bibliography{...}`。数据库由 `\addbibresource` 指定，文献表由 `\printbibliography` 打印。

### 与学校提交规范分开处理

PRL 风格是按用户要求定制，不能等同于 GB/T 7714 格式。若学院要求另一格式，应先确认其指定版本。本模板另提供 `gb2015` 技术切换：把 `main.tex` 中 `\SDUBibStyle` 默认值由 `prl` 改为 `gb2015`，就会加载 `biblatex-gb7714-2015` 并继续使用 Biber。**此选项不表示 GB/T 7714-2015 必然是提交时要求的最新或适用版本。** 切换样式后重新运行完整编译流程。

## 博士期间发表的文章目录（独立编号）

将真实论文的 BibTeX 条目写入根目录的 `publications.bib`，然后编辑
`back/publications.tex`：

```tex
\begin{sdupublications}
  \cite{my-paper-1}
  \cite{my-paper-2,my-paper-3}
\end{sdupublications}
```

其中的引用键必须与 `publications.bib` 中的条目键一致。默认提供两个**虚构占位条目**，
仅用于展示排版和测试编号隔离，不能作为作者实际发表成果；请替换并删除提示文字。

本环境自动生成章标题“博士期间发表的文章目录”、中文目录项及相应英文目录项。
文章按首次加入的顺序编号为 `[1]`、`[2]`、`[3]`，输出完整作者、题目、期刊、卷、
页码或文章号、年份。正文 PRL-like 文献表仍默认隐藏文章题目。

**这里的 `\cite{...}` 是本环境内的选入命令**：它局部调用 `\nocite`，随后在环境末尾
统一打印文章目录，不会额外出现一行零散的 `[1][2]`。支持单个键或逗号分隔的多个键；
重复加入只输出一次。这里不接受 `\cite[页码]{key}`、星号引用或正文式前后注；
本环境之外的 `\cite` 完全保留原有功能。

隔离机制是 `biblatex` 的独立 `refsection`，不是只设置一个文献分类或重置数字。
默认情况下，正文使用 `references.bib`，发表文章目录局部读取 `publications.bib`。
正文参考文献显式限定 `section=0`；文章目录中的引用不会消耗正文编号，也不会因
加入文章目录而被纳入正文参考文献。不要手动重置 `enumiv` 或 `labelnumber`。

若使用同一个数据库，可写：

```tex
\begin{sdupublications}[references.bib]
  \cite{my-paper-1,my-paper-2}
\end{sdupublications}
```

同一条目如在正文也被**明确引用**，会按正文自己的编号正常出现在正文参考文献中，
同时仍可在发表文章目录中拥有不同的独立编号；这不是编号串联。
同一条目只需要保存在选定数据库中一次，不要在多个数据源中重复定义相同引用键。

修改后仍按原方式编译，不需要第二次独立运行 Biber：

```sh
latexmk -r latexmkrc -xelatex preview.tex
# 本机具备正式字体时：
latexmk -r latexmkrc -xelatex main.tex
```

首次升级或发现残留旧标题、旧编号时，先用 `latexmk -r latexmkrc -C preview.tex`
（正式入口则是 `main.tex`）清理再编译。编译所用字体、封面位置和正文样式均未改动。

可选回归测试（在项目根目录运行）：

```sh
latexmk -r latexmkrc -xelatex -jobname=check-publications checks/publications-regression.tex
python checks/verify_build.py check-publications
```

该测试包含同一篇文章同时出现在正文和文章目录、重复选入、批量选入、
倒序选入、空目录，以及离开环境后恢复普通 `\cite` 和文章题名设置。

## 官方扉页、声明、签名和答辩记录

研究生院于 2025-04-03 发布了“2024版学位论文封面（扉页）”。本模板按用户提供的封面重建外封面，并给正式页面保留插入位置，不自行改写声明原文，也不生成签名。

将经学院确认、填写或签署的 PDF 放到以下路径，会自动替换占位页：

```text
front/title-page.pdf           现行正式扉页
front/declarations.pdf         原创性声明和使用授权声明，可多页
back/review-and-defense.pdf    学位论文评阅与答辩情况表，可多页
```

若当批次只需其中部分或要求不同排列顺序，修改 `main.tex` 与相应插入文件。封面和这些官方页不能仅凭 LaTeX 编译成功认定合规。提交前必须移除所有提示性占位页面。

## 双面、匿名和提交检查

默认 `twoside,openany`，不强制每章从奇数页开始；需要奇数页起章时改为 `openright`。不要把排版自动插入的空白页和正文页混淆。

文档类有 `blind=true` 辅助选项，会隐藏封面作者 / 学号 / 导师及校名校徽，清空 PDF 作者元数据，并跳过声明、致谢、成果及答辩记录等默认插入项。**这不是完整匿名化工具**：正文、引用、文件名、图片、来源 PDF、元数据和 `config/metadata.tex` 仍需人工检查；不要把含原始封面和个人信息的源代码压缩包当作匿名送审材料。

提交前至少确认：题目及身份信息、日期、章节与中英文摘要、所有占位页、实际字体嵌入、目录页码、未解析引用、跨页图表、数学符号和引用标准。`checks/verify_build.py` 只做技术检查，不做院校规范认证。

```sh
python checks/verify_build.py preview
```

主编译依赖：ctex、fontspec、unicode-math / XITS、geometry、TikZ、fancyhdr、tocloft、caption / subcaption、booktabs、pdfpages、hyperref、biblatex、biblatex-phys、Biber、latexmk。GB 分支另需 biblatex-gb7714-2015。请保持本地 biblatex 与 Biber 来自互相兼容的发行版；不要单独混用不匹配的版本。
