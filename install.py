#!/bin/bash/python
from typing import List
import shlex


def main():
    with open('.dotfiles') as _fp:
        shl: shlex.shlex = shlex.shlex()
        for path in _fp.readlines():
            paths: List = shlex.split(path)
            if paths and paths[0] in shl.commenters:
                continue
            remaining: List = []
            dst: str = ""
            src: str = ""
            if not paths:
                continue
            if len(path) == 1:
                src = path.strip()
                dst = src
            elif len(paths) == 2:
                src, dst = paths
            if len(paths) > 2:
                remaining = paths[2:]
            print(paths)
            print(f'src: {src}, dest: {dst}, remiaing: {remaining}')


main()
