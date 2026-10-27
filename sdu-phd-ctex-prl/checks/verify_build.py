#!/usr/bin/env python3
"""Check a compiled job's logs; not an institutional-format certification.
Usage, from project root: python checks/verify_build.py preview
Only the Python standard library is required.
"""
from __future__ import annotations
import argparse
from pathlib import Path
import re
import sys

def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('job', nargs='?', default='preview', help='Job name without extension')
    args = parser.parse_args()
    job = Path(args.job)
    files = {ext: job.with_suffix('.' + ext) for ext in ('log', 'blg', 'bbl', 'pdf')}
    missing = [str(p) for p in files.values() if not p.is_file()]
    if missing:
        print('FAIL: missing output: ' + ', '.join(missing))
        return 1
    log = files['log'].read_text(encoding='utf-8', errors='replace')
    blg = files['blg'].read_text(encoding='utf-8', errors='replace')
    patterns = [r'^! ', r'^Missing character:', r'Overfull \\[hv]box',
                r'There were undefined references', r'Citation .+ undefined',
                r'Reference .+ undefined', r'Please \(re\)run Biber',
                r'Rerun to get cross-references right']
    problems = [line for line in log.splitlines()
                if any(re.search(pattern, line) for pattern in patterns)]
    problems += [line for line in blg.splitlines() if re.search(r'\b(?:ERROR|FATAL)\b', line)]
    if problems:
        print('FAIL: output needs attention:\n' + '\n'.join(problems))
        return 1
    print('PASS: PDF and Biber outputs exist; no detected errors, unresolved references,')
    print('      missing glyphs or overfull boxes in the final log.')
    for line in log.splitlines():
        if 'SDU-CHECK:' in line:
            print(line)
    warnings = [line for line in log.splitlines() if 'Warning' in line]
    if warnings:
        print('Warnings to review:\n' + '\n'.join(warnings))
    print('This does not check university approval, actual licensed fonts, or placeholder removal.')
    return 0

if __name__ == '__main__':
    sys.exit(main())
