#!/bin/sh -l

LINES_PER_MSG=$1
count_lines() {
  find . -type f -name '*.c*' -exec wc -l {} \;
}

TOT_LINES=$(count_lines | awk '{sum+=$1;} END{print sum;}')

CCLOG=$(cppcheck -q . 2>&1)
CCRES=$?

TOT_MSGS=$(echo $CCLOG | wc -l | xargs)

echo '==========================='
echo cppcheck report:
echo $CCLOG
echo cppcheck status:
echo $CCRES
echo '==========================='
echo Penalty: $TOT_MSGS / $TOT_LINES

echo "::set-output name=c-tot-lines::$TOT_LINES"
echo "::set-output name=c-tot-msgs::$TOT_MSGS"

if [[ $CCRES == 0 ]]
then
  exit $(( $LINES_PER_MSG * $TOT_MSGS > $TOT_LINES ))
else
  exit $CCRES
fi
