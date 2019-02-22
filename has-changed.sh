#!/usr/bin/env bash

while getopts ":e:d:" opt; do
  case $opt in
    e) EXCLUDE="$OPTARG"
    ;;
    d) DIRS="$OPTARG"
    ;;
    \?) echo "${RED}Invalid option -$OPTARG${NO_COLOR}" >&2
    ;;
  esac
done
BRANCH_NAME="$(git rev-parse --abbrev-ref HEAD)"

if [ "${EXCLUDE}" ];
then
    if [ "${BRANCH_NAME}" == "master" ];
    then
        CHANGED_FILES="$(git diff $(git log --first-parent -n 1 --skip=1 --pretty=format:"%H") --name-only --diff-filter=ACMRT $DIRS | sed 's/ /\
    /g' | grep -v $EXCLUDE | tr '\n' ' ')";
    else
        CHANGED_FILES="$(git diff origin/master...$(git symbolic-ref --short -q HEAD) --name-only --diff-filter=ACMRT $DIRS | sed 's/ /\
    /g' | grep -v $EXCLUDE | tr '\n' ' ')";
    fi
else
    if [ "${BRANCH_NAME}" == "master" ];
then
    CHANGED_FILES="$(git diff $(git log --first-parent -n 1 --skip=1 --pretty=format:"%H") --name-only --diff-filter=ACMRT $DIRS)";
else
    CHANGED_FILES="$(git diff origin/master...$(git symbolic-ref --short -q HEAD) --name-only --diff-filter=ACMRT $DIRS)";
fi
fi



if [ ! -z "${CHANGED_FILES}" ];
then
    echo >&2 $DIRS "has changes, changed files:"
    echo >&2 $CHANGED_FILES
    exit 0;
fi

echo >&2 $DIRS "has no changes"
exit 1;
