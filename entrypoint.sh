#!/bin/sh -l

LINES_PER_MSG=$1
count_lines() {
  find . -type f -name '*.c*' -exec wc -l {} \;
}

TOT_LINES=$(count_lines | awk '{sum+=$1;} END{print sum;}')

CCLOG=$(cppcheck -q --xml . 2>&1 | dos2unix)
CCRES=$?

echo $CCLOG |  wc -l

TOT_MSGS=$(echo $CCLOG | egrep -o '</(error|warning|style)>' | wc -l | xargs)

PENALTY=$(echo "scale=2; $LINES_PER_MSG * $TOT_MSGS / $TOT_LINES" | bc)
SCORE=$(echo "scale=2; 1 - $PENALTY" | bc)

echo '==========================='
echo cppcheck report:
echo $CCLOG
echo cppcheck status:
echo $CCRES
echo '==========================='

echo Penalty: $TOT_MSGS \* $LINES_PER_MSG / $TOT_LINES is $PENALTY
echo Score: $SCORE

echo "::set-output name=c-tot-lines::$TOT_LINES"
echo "::set-output name=c-tot-msgs::$TOT_MSGS"
echo "::set-output name=c-tot-score::$SCORE"

# -----------------------------
BRANCH_NAME=cyber-under-tutor
git config --global user.email "CYBER@DRDbKA.github.com"
git config --global user.name "Кибердядька"
git checkout $BRANCH_NAME
echo $CCLOG | $(dirname "$0")/c-check.rb $SCORE quality-check.yml
git add quality-check.yml
git commit -m "Кибердядька сообщает"
git push origin $BRANCH_NAME
# -----------------------------

if [[ $CCRES == 0 ]]
then
  if [ $(echo "$SCORE > 0" | bc) -eq 0 ]
  then
    exit 1
  else
    exit 0
  fi
else
  exit $CCRES
fi
