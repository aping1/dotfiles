#require test-repo

  $ check_code="$TESTDIR"/../contrib/check-code.py
  $ cd "$TESTDIR"/..

New errors are not allowed. Warnings are strongly discouraged.
(The writing "no-che?k-code" is for not skipping this file when checking.)

  $ hg locate | sed 's-\\-/-g' |
  >   xargs "$check_code" --warnings --per-file=0 || false