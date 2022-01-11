#!/bin/sh -l

echo "::group::Кибердядька работает"

LINES_PER_MSG=$1

count_lines() {
  find . -type f -name $1 -exec wc -l {} \;
}

CPPCHECK_OPTS='-q --enable=warning,style,portability,missingInclude'

CC_LINES=$(count_lines '*.c*' | awk '{sum+=$1;} END{print sum;}')
cppcheck $CPPCHECK_OPTS       --output-file=cppcheck.log .
cppcheck $CPPCHECK_OPTS --xml --output-file=cppcheck.xml .
CCRES=$?

echo "::endgroup::"

echo $CCXML | $(dirname "$0")/c-check.py quality-check $CC_LINES $LINES_PER_MSG cppcheck.xml cppcheck.log

echo "::group::Кибердядька сообщает"
echo cppcheck status:
echo $CCRES
echo cppcheck report:
cat  cppcheck.log
echo "::endgroup::"
