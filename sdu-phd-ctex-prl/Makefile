# 山东大学博士论文模板 — Linux / GNU Make / TeX Live
# 在项目根目录运行。默认正式字体；预览字体必须显式使用 make preview。
# 所有输出保持原路径：main.pdf / preview.pdf；无需修改任何 .tex 或 .bib。
SHELL := /bin/sh
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
# 两个入口的 \include 会写入相同章节 .aux，禁止单次 make -j 并行构建。
.NOTPARALLEL:

# TeX Live 已在 PATH 中时无须设置。可运行：make TEXBIN=/实际路径/bin/x86_64-linux
TEXBIN ?=
ifneq ($(strip $(TEXBIN)),)
export PATH := $(TEXBIN):$(PATH)
endif

LATEXMK ?= latexmk
PYTHON ?= python3
# 可追加选项，例如 make preview LATEXMKFLAGS=-quiet；不要在此更换输出目录。
LATEXMKFLAGS ?=
# 仅加载本项目配置一次，避免全局 latexmk 配置改变引擎或输出位置。
MKFLAGS = -norc -r latexmkrc -xelatex -synctex=1 $(LATEXMKFLAGS)
TEXFLAGS = -interaction=nonstopmode -halt-on-error -file-line-error -synctex=1
TESTJOB := check-publications
TESTSRC := checks/publications-regression.tex

.PHONY: all main pdf preview rebuild rebuild-preview watch watch-preview \
        check check-tex check-latexmk check-python check-preview test \
        test-publications manual manual-preview clean distclean cleanall help

all: main
pdf: main
main: check
	"$(LATEXMK)" $(MKFLAGS) main.tex

preview: check
	"$(LATEXMK)" $(MKFLAGS) preview.tex

# 强制执行编译规则；失败立即停止，不以 -f 掩盖错误。
rebuild: check
	"$(LATEXMK)" $(MKFLAGS) -g main.tex

rebuild-preview: check
	"$(LATEXMK)" $(MKFLAGS) -g preview.tex

# 监视源文件并持续重编译；不自动打开图形查看器，Ctrl-C 结束。
watch: check
	"$(LATEXMK)" $(MKFLAGS) -pvc -view=none main.tex

watch-preview: check
	"$(LATEXMK)" $(MKFLAGS) -pvc -view=none preview.tex

# 这里只检查工具和主要宏包；正式字体由模板的 strict 模式另行检查。
check: check-tex check-latexmk
	@printf '%s\n' 'OK: XeLaTeX / Biber / latexmk 和主要宏包可用（未验证正式字体）。'

check-tex:
	@set -eu; \
	for tool in xelatex biber kpsewhich; do \
		command -v "$$tool" >/dev/null 2>&1 || { \
			printf 'ERROR: 找不到 %s，请检查 TeX Live 安装及 PATH / TEXBIN。\n' "$$tool" >&2; exit 1; \
		}; \
	done; \
	for pkg in ctexbook.cls fontspec.sty unicode-math.sty biblatex.sty phys.bbx \
	           geometry.sty tikz.sty fancyhdr.sty tocloft.sty subcaption.sty \
	           pdfpages.sty xurl.sty csquotes.sty bookmark.sty XITSMath-Regular.otf; do \
		kpsewhich "$$pkg" >/dev/null 2>&1 || { \
			printf 'ERROR: TeX Live 找不到 %s，请补装对应宏包或字体包。\n' "$$pkg" >&2; exit 1; \
		}; \
	done

check-latexmk:
	@command -v "$(LATEXMK)" >/dev/null 2>&1 || { \
		printf '%s\n' 'ERROR: 找不到 latexmk。请安装，或使用 make manual / make manual-preview。' >&2; exit 1; \
	}

check-python:
	@command -v "$(PYTHON)" >/dev/null 2>&1 || { \
		printf '%s\n' 'ERROR: 日志检查需要 Python 3；普通编译不需要 Python。' >&2; exit 1; \
	}

check-preview: check-python preview
	"$(PYTHON)" checks/verify_build.py preview

test: test-publications
test-publications: check check-python
	"$(LATEXMK)" $(MKFLAGS) -jobname=$(TESTJOB) $(TESTSRC)
	"$(PYTHON)" checks/verify_build.py $(TESTJOB)

# 未安装 latexmk 时的备用固定四步流程；编译器报错会中止后续步骤。
# 若最后仍提示 rerun，再执行一次 xelatex；日常推荐上面的 latexmk 目标。
manual: check-tex
	xelatex $(TEXFLAGS) main.tex
	biber main
	xelatex $(TEXFLAGS) main.tex
	xelatex $(TEXFLAGS) main.tex

manual-preview: check-tex
	xelatex $(TEXFLAGS) preview.tex
	biber preview
	xelatex $(TEXFLAGS) preview.tex
	xelatex $(TEXFLAGS) preview.tex

# clean 保留生成的 PDF；distclean 连生成的 PDF 一并清理。
# 只清理这些编译入口，不遍历删除 assets/、front/、back/ 中的源 PDF。
clean: check-latexmk
	"$(LATEXMK)" -norc -r latexmkrc -c main.tex preview.tex
	"$(LATEXMK)" -norc -r latexmkrc -c -jobname=$(TESTJOB) $(TESTSRC)

distclean: check-latexmk
	"$(LATEXMK)" -norc -r latexmkrc -C main.tex preview.tex
	"$(LATEXMK)" -norc -r latexmkrc -C -jobname=$(TESTJOB) $(TESTSRC)

cleanall: distclean

help:
	@printf '%s\n' \
	  'make / make main      正式版 -> main.pdf（需要正式字体）' \
	  'make preview          预览版 -> preview.pdf（Fandol / XITS）' \
	  'make check            检查编译工具和主要宏包，不检查正式字体' \
	  'make rebuild          强制重编译正式版' \
	  'make rebuild-preview  强制重编译预览版' \
	  'make watch[-preview]  监视源文件，不启动查看器；Ctrl-C 结束' \
	  'make check-preview    编译预览版并检查日志（需要 Python 3）' \
	  'make test             编译发表文章目录的隔离回归示例并检查日志' \
	  'make manual[-preview] 不使用 latexmk 的固定四步备用编译' \
	  'make clean            删除辅助文件，保留 PDF' \
	  'make distclean        删除辅助文件及生成的 PDF，不删除源 PDF' \
	  '可选：make preview TEXBIN=/实际路径/bin/x86_64-linux' \
	  '正式版仍须安装 SimSun、SimHei、Times New Roman；不会自动替换。'
