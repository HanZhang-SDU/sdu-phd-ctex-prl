# v1.2 Linux / TeX Live Makefile 更新与检查记录

测试日期：2026-10-27。

## 本次变更范围

只修改 `Makefile`、`README.md` 和本检查报告。与 v1.1 比较，所有 `.tex`、
`.cls`、`.bib`、`latexmkrc`、封面素材及随包 `preview.pdf` 均逐字节不变。
已编辑论文的用户只需替换项目根目录的 `Makefile`，无须覆盖其他文件。

- 正式 / 预览编译、强制重编译、文件监视、依赖检查、日志检查及回归测试目标。
- `TEXBIN` 可显式指定 TeX Live 二进制目录，不固定年份或体系架构。
- 默认调用 latexmk；备用 `manual` / `manual-preview` 直接执行 XeLaTeX、Biber、XeLaTeX、XeLaTeX。
- `clean` 保留 PDF；`distclean` 清理生成的 PDF，不删除源 PDF 或论文源文件。
- 为避免共享章节辅助文件竞争，同一个 make 调用内禁用并行执行。

## 本次实际环境

Linux，GNU Make；XeTeX 0.999996（TeX Live 2025/dev/Debian）；latexmk 4.86；Biber 2.20。
预览字体使用已有 Fandol / XITS 配置；未安装正式 SimSun / SimHei / Times New Roman 字体。

## 实际通过的测试

1. `make check` 和 `make check TEXBIN=/usr/bin`：编译工具及主要宏包检查通过。
2. `make check-preview`：全新辅助文件状态下实际编译成功；原有日志检查通过。
3. `make test`：发表文章目录回归示例实际编译成功；原有日志检查通过。
4. 额外解析 `.bbl` 验证：预览正文 section 0 仅四条正文文献，section 1 仅两条发表文章占位文献；回归示例正文顺序为 Higgs / Englert，独立列表顺序各自符合源码，互不串联。
5. 再次 `make preview` 显示 Nothing to do，不重复执行无必要的编译。
6. `make check LATEXMK=/no-such-latexmk` 明确报缺少 latexmk，返回非零退出码。
7. `make main` 在当前缺少 SimSun 的环境中按设计失败，不自动替换为预览字体。
8. `make clean` 保留预览和回归测试 PDF，并清理辅助文件；`make distclean` 删除这两个生成 PDF；逐文件 SHA-256 校验确认所有非生成源文件（包括封面参考 PDF）均未变动。
9. 清理后执行 `make manual-preview LATEXMK=/no-such-latexmk`，不依赖 latexmk 编译成功；随后日志检查通过。

## 限制

正式字体版本未在本环境完成 PDF 排版；不据此作学校格式认证。本次只验证构建流程，
未重新进行 PDF 的逐页视觉审查。持续监视目标未做长时间交互测试。不同 Linux 发行版、
不同 TeX Live 版本和用户自定义系统环境未全部覆盖。

---

# v1.1 本次更新与检查记录

测试日期：2026-10-27。

## 本次变更

- 将章标题及中文目录项改为“博士期间发表的文章目录”，同步更新英文目录项。
- 新增 `sdupublications` 环境和独立的 `publications.bib`。
- 环境内 `\cite{key,...}` 局部转为选入操作，环境末尾打印完整条目；环境外的普通 `\cite` 保持不变。
- 采用独立 `refsection`，按首次选入顺序从 `[1]` 编号；正文参考文献显式选取 `section=0`。
- 仅在发表文章目录中开启题名显示；封面、正文、字体配置及正文 PRL-like 样式不改。
- 新增可复现测试源文件 `checks/publications-regression.tex`。

## 本次实际通过的检查

1. 用 XeLaTeX + Biber 完整编译 `preview.tex`，得到 17 页 PDF；最终日志无未定义引用、缺失字符或 overfull box，Biber 无错误。仅有原来的替代字体预览提示。
2. 检查 `.bbl`：正文 section 0 仅含原来的四条文献；文章目录 section 1 仅含两个明确标注的虚构占位条目，顺序符合添加顺序。
3. 实际编译独立回归测试：正文第一条为 `[1]`，文章目录从 `[1]` 重新开始；同一条目在正文为 `[1]`、在文章目录为 `[3]`。目录之后的正文新引用为 `[2]`，再引用原条目仍为 `[1]`。
4. 回归测试覆盖多键加入、重复加入去重、倒序加入、多个独立列表及空列表；正文 `\cite` 定义与原始文章题名开关均恢复。
5. 将 v1.1 与上一版 PDF 使用相同渲染器逐页比较：封面（第 1 页）、正文及图表（第 9–12 页）、正文参考文献（第 13 页）、附录（第 14 页）、致谢（第 15 页）、答辩页（第 17 页）像素相同。目录页仅相应变更标题。
6. 单独渲染并目视检查新的文章目录页：标题、说明、编号、论文条目没有重叠或截断。

## 限制

本次预览仍为 Fandol / XITS 字体。未生成正式 SimSun / SimHei / Times New Roman 字体版本；不是学校格式认证。文章数据库中的两条记录是虚构排版占位，不是作者的研究成果，使用时须替换。

---

# v1.0 历史检查记录（保留作参考，以下项目并非本次全部重测）


测试日期：2026-10-27。

## 实际环境

- XeTeX 3.141592653-2.6-0.999996，TeX Live 2025/dev/Debian。
- Biber 2.20。
- biblatex-phys v1.1c（2024-07-26）。
- 预览字体：FandolSong、FandolHei、XITS、XITS Math；代码片段使用 Latin Modern Mono。

## 已完成

1. `latexmk -r latexmkrc -xelatex preview.tex` 完整编译通过，Biber 正常运行，得到 17 页 PDF。
2. 最终日志无未定义文献、未定义交叉引用、缺失字符或 overfull box；Biber 日志无警告或错误。仅保留模板主动发出的 portable-font 预览警告。
3. PDF 文本与字体信息检查：正文汉字 12 bp；普通连续正文行基线差 20 bp；首行缩进 24 bp；左正文边界距纸边 25 mm。
4. 引用压缩 `[1–3]` 正常；同条目重复引用保持原编号；四条参考文献均生成；PRL 期刊缩写、粗体卷号、首页 / 文章号、括号年份正常；文章题名被隐藏而非从数据库删除。
5. 四条参考文献都有可点击 DOI 链接；arXiv 字段示例正常。
6. 中文目录与英文目录各自独立分页，英文摘要未与目录混排；前置部分和正文分别从 I / 1 起编页码。
7. 对完整 PDF 进行了渲染检查，并单独查看封面、目录、正文 / 图表和参考文献页面。
8. 在独立复制的测试目录，将 `bibstyle` 改为 `gb2015`，用同一 Biber 流程编译通过；无上述错误。此测试仅验证技术可用性，不验证提交时应采用哪个标准版本。
9. `main.tex` 正式入口在缺少 SimSun 的环境中按设计报错，不会静默使用预览字体。

## 未完成 / 不保证的事项

- 由于本次环境没有 SimSun、SimHei 和 Times New Roman，未实际生成正式字体 PDF。正式入口的排版、字体嵌入与打印结果需在具有合法字体的环境中再次检查。
- 这些技术检查不是院校格式认证，也不验证学院当批次通知、声明签名、正文内容真实性或研究结果。
- 超长题目、复杂跨页表格、海量参考文献、所有 biblatex 条目类型及完整匿名化均不在本次示例测试范围内。
- PDF 中的提示性占位页面和示例内容必须在提交前替换。

重现日志检查：`python checks/verify_build.py preview`。源代码包不保留编译中间文件，运行完整编译后即可重新生成检查所需日志。
