# 来源与核验范围

整理日期：2026-10-27。模板是用户定制作品，并非山东大学发布或认可的文档类。

## 用户提供的封面

`assets/cover-reference.pdf` 是用户上传的单页 `cover.pdf`。该文件提供封面布局、校名校徽、学位类型和已填写信息。中文 / 英文论文题目在原稿中为空，模板明确保留可替换的占位题目。校名校徽为从该 PDF 提取的 1009 × 324 像素位图，不是重新绘制的官方矢量标志。

## 学校公开资料

1. **《山东大学研究生学位论文撰写指南》**，文件日期 2022-01-05。
   - 官方发布 / 下载入口：
     `https://glxyyjs.sdu.edu.cn/info/1029/1478.htm`
   - 法学院托管附件：
     `https://www.law.sdu.edu.cn/system/_content/download.jsp?owner=1751041819&urltype=news.DownloadAttachUrl&wbfileid=8009851`
   - 基础医学院托管附件：
     `https://www.bmsgrade.sdu.edu.cn/system/_content/download.jsp?owner=1396382596&urltype=news.DownloadAttachUrl&wbfileid=7658427`
   - 本次通过官方页面及附件的公开检索索引核实：正文宋体小四、首行两字符、两端对齐、段前段后零、固定 20 磅；有数学表达式的段落可调整行距。页边距上 2.8 cm、其余 2.5 cm；页眉边距 1.5 cm、页脚边距 1.75 cm；页眉从摘要开始；五号字体页眉与居中页码等关键项目。
   - 附件直连在本次环境存在下载 / 验证码 / 响应类型限制，未取得可逐页核对的完整官方文件。因此这里只声明已经核实的关键条款，不声称对 2026 年所有学院、全部细节或未来批次进行了完整合规审核。

2. **“2024版学位论文封面（扉页）”**，研究生院公开页面，发布日期 2025-04-03：
   `https://www.grad.sdu.edu.cn/info/1138/20664.htm`
   - 据此提供 `front/title-page.pdf` 插入位置；不把用户封面自动认作这一官方附件，也不改写其中的签字字段。

3. 参考的较早官方规范网页（不是现行优先依据）：
   `https://www.tjsl.sdu.edu.cn/info/1375/6201.htm`
   - 网页发布日期较晚，但正文是较早规范。若与 2022 指南或学院现行通知冲突，应以后者为准，不能只按网页更新时间判断版本。

## 软件与参考文献样式

4. Joseph Wright 维护的 **biblatex-phys**：
   - CTAN 项目：`https://ctan.org/pkg/biblatex-phys`
   - 维护者说明源码：`https://github.com/josephwright/biblatex-phys/blob/main/biblatex-phys.tex`
   - 手册：`https://mirrors.ctan.org/macros/latex/contrib/biblatex-contrib/biblatex-phys/biblatex-phys.pdf`
   - 手册明确给出 APS 分支的 `autocite=plain`、`articletitle=false`、`biblabel=brackets`、`chaptertitle=false`、`pageranges=false` 设置。模板使用这些设置，配合 Biber 的 `sorting=none`、缩写期刊名映射等。手册说明其文献表遵循 REVTeX 风格，但它不是 `apsrev4-2.bst` 本身。
   - 本次编译环境安装的是 phys v1.1c（2024-07-26）；在线手册显示 v1.1e（2025-04-09）。实际测试版本见 BUILD-REPORT.md，不混淆在线最新文档与本地已安装版本。

5. 示例文献的出版者 / 作者原始记录：
   - Higgs 1964：`https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.13.508`
   - Englert / Brout 1964：`https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.13.321`
   - Weinberg 1967：`https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.19.1264`
   - Cowan et al.：`https://arxiv.org/abs/1007.1727`
   这些条目只用于测试引用排版，不是对用户论文内容或研究成果的补写。

## 学校条款、用户偏好和模板选择的边界

- **学校已核实关键条款**：中文正文字体字号、普通行距、段落缩进与间距、主要页边距，以及上述页眉页码要求。
- **用户明确要求**：以给定封面为基础，ctex，biblatex + Biber，接近 REVTeX 4.2 PRL 的文献外观。
- **模板实现选择**：Times New Roman 作为拉丁正文字体；XITS Math 数学字体；部分标题的具体段间距；图表题注与参考文献的字号 / 间距；可编辑封面的绝对定位；默认 openany；可选匿名辅助开关。未逐项核实的选择不能写成学校强制条款。
- **提交前仍需确认**：培养单位当批次规范、参考文献标准及版本、是否允许不显示文章题名、声明与签名形式、封面与扉页关系、表格顺序、双面装订细节。`gb2015` 只是备用技术实现，不意味着该版本必然是当前适用标准。


## v1.1 独立文章目录的实现依据

biblatex 官方手册的 Bibliography Sections 及 Bibliography Segments：`refsection` 的引用标签局部独立；`refsegment` 只分段筛选，不重置全局标签。可选资源参数替换当前节的数据源；环境外引用属于 section 0。

手册源文件：<https://raw.githubusercontent.com/plk/biblatex/dev/doc/latex/biblatex/biblatex.tex>

本次实现与测试：见 `BUILD-REPORT.md` 的 v1.1 部分。
