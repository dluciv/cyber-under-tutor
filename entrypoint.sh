#!/bin/sh -l

UNDERTUTOR_BRANCH=cyber-under-tutor

LINES_PER_MSG=$1
count_lines() {
  find . -type f -name $1 -exec wc -l {} \;
}

CC_LINES=$(count_lines '*.c*' | awk '{sum+=$1;} END{print sum;}')
CCLOG=$(cppcheck -q --enable=error,warning,style,portability,missingInclude --xml . 2>&1)
CCRES=$?

echo '==========================='
echo cppcheck report:
echo $CCLOG
echo cppcheck status:
echo $CCRES
echo '==========================='

# -----------------------------
MAIN_BRANCH=$(git rev-parse --abbrev-ref HEAD)
git config pull.rebase false
git config user.email "CYBER@DRDbKA.github.com"
git config user.name "Кибердядька"
git switch $UNDERTUTOR_BRANCH
git pull origin $UNDERTUTOR_BRANCH

echo $CCLOG | $(dirname "$0")/c-check.py quality-check $CC_LINES $LINES_PER_MSG

git add quality-check.yml quality-check.svg
git commit -m "Кибердядька сообщает"
git push origin $UNDERTUTOR_BRANCH
git switch $MAIN_BRANCH
# -----------------------------
