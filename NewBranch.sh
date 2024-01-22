#!/bin/bash

# 定义你的远程仓库 URL
OFFCIAL_REMOTE_PREFIX_URL="https://github.com/ONLYOFFICE/"
KKK_REMOTE_PREFIX_URL="https://github.com/fernfei/"

# 定义你的远程仓库名称
REMOTE1_NAME="onlyoffice"
REMOTE2_NAME="fernfei"

# 定义你想要拉取的分支名
BRANCH_NAME="release/v8.0.0"

# 获取当前目录的名称
DIR_NAME=$(basename `pwd`)

# 构建远程仓库的 URL
REMOTE1_URL="${OFFCIAL_REMOTE_PREFIX_URL}${DIR_NAME}.git"
REMOTE2_URL="${KKK_REMOTE_PREFIX_URL}${DIR_NAME}.git"

# 检查并删除已经存在的远程仓库
if git remote | grep -q $REMOTE1_NAME; then
    git remote remove $REMOTE1_NAME
    echo "Existing remote $REMOTE1_NAME removed."
fi

if git remote | grep -q $REMOTE2_NAME; then
    git remote remove $REMOTE2_NAME
    echo "Existing remote $REMOTE2_NAME removed."
fi

# 添加远程仓库
git remote add $REMOTE1_NAME $REMOTE1_URL
git remote add $REMOTE2_NAME $REMOTE2_URL
echo "Added new remotes $REMOTE1_NAME and $REMOTE2_NAME."

# 检查分支是否存在
if git ls-remote --heads $REMOTE1_NAME $BRANCH_NAME | grep -q $BRANCH_NAME; then
  # 从 onlyoffice 远程仓库拉取你指定的分支
  git fetch $REMOTE1_NAME $BRANCH_NAME
  echo "Fetched branch $BRANCH_NAME from $REMOTE1_NAME."

  # 创建并检出一个新的本地分支，这个新的分支的名称与你拉取的远程分支的名称相同
  git checkout -b $BRANCH_NAME $REMOTE1_NAME/$BRANCH_NAME
  echo "Checked out branch $BRANCH_NAME."

  # 推送到 fernfei 仓库
  git push $REMOTE2_NAME $BRANCH_NAME
  echo "Pushed branch $BRANCH_NAME to $REMOTE2_NAME."
else
  echo "Branch $BRANCH_NAME does not exist in $REMOTE1_NAME. Skipping fetch."
fi

# 获取子模块的列表
SUBMODULES=$(git submodule status | awk '{ print $2 }')

# 对每个子模块执行相同的操作
for SUBMODULE in $SUBMODULES
do
  # 进入子模块目录
  cd $SUBMODULE

  # 获取当前目录的名称
  DIR_NAME=$(basename `pwd`)

  # 构建远程仓库的 URL
  REMOTE1_URL="${OFFCIAL_REMOTE_PREFIX_URL}${DIR_NAME}.git"
  REMOTE2_URL="${KKK_REMOTE_PREFIX_URL}${DIR_NAME}.git"

  # 检查并删除已经存在的远程仓库
  if git remote | grep -q $REMOTE1_NAME; then
      git remote remove $REMOTE1_NAME
      echo "Existing remote $REMOTE1_NAME removed."
  fi

  if git remote | grep -q $REMOTE2_NAME; then
      git remote remove $REMOTE2_NAME
      echo "Existing remote $REMOTE2_NAME removed."
  fi

  # 添加远程仓库
  git remote add $REMOTE1_NAME $REMOTE1_URL
  git remote add $REMOTE2_NAME $REMOTE2_URL
  echo "Added new remotes $REMOTE1_NAME and $REMOTE2_NAME for submodule $SUBMODULE."

  # 检查分支是否存在
  if git ls-remote --heads $REMOTE1_NAME $BRANCH_NAME | grep -q $BRANCH_NAME; then
    # 从 onlyoffice 远程仓库拉取你指定的分支
    git fetch $REMOTE1_NAME $BRANCH_NAME
    echo "Fetched branch $BRANCH_NAME from $REMOTE1_NAME for submodule $SUBMODULE."

    # 创建并检出一个新的本地分支，这个新的分支的名称与你拉取的远程分支的名称相同
    git checkout -b $BRANCH_NAME $REMOTE1_NAME/$BRANCH_NAME
    echo "Checked out branch $BRANCH_NAME for submodule $SUBMODULE."

    # 推送到 fernfei 仓库
    git push $REMOTE2_NAME $BRANCH_NAME
    echo "Pushed branch $BRANCH_NAME to $REMOTE2_NAME for submodule $SUBMODULE."
  else
    echo "Branch $BRANCH_NAME does not exist in $REMOTE1_NAME for submodule $SUBMODULE. Skipping fetch."
  fi

  # 返回到上一级目录
  cd ..
done
