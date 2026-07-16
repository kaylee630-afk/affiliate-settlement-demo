#!/bin/bash
# PayFlash 版本回滚工具
# 用法: bash rollback.sh           → 回到 v1-glass-jelly-working
#       bash rollback.sh list      → 查看所有版本
#       bash rollback.sh <tag名>   → 回到指定版本

TAG="${1:-v1-glass-jelly-working}"

if [ "$TAG" = "list" ]; then
  echo "=== 可用版本 ==="
  git tag -l --sort=-creatordate | head -20
  echo ""
  echo "回滚命令: bash rollback.sh <版本名>"
  exit 0
fi

echo "⏪ 正在回滚到: $TAG ..."
git checkout "$TAG" -- index.html brand.html affiliate.html manifest.json sw.js sw-register.js 2>/dev/null
git add -A
git commit -m "Rollback to $TAG

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
git push
echo "✅ 已回滚并推送到 GitHub，Vercel 会自动部署"
