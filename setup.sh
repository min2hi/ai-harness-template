#!/bin/bash
# ============================================================
# AI Harness Template — Setup Script (Bash)
# Dành cho Mac/Linux
# CÁCH CHẠY: bash setup.sh
# ============================================================

echo ""
echo "🚀 AI Harness Template — Project Setup"
echo "======================================"
echo ""

read -p "Tên project (hiển thị, VD: ShopEase): " PROJECT_NAME
read -p "Slug project (package.json, VD: shopease): " PROJECT_SLUG
read -p "GitHub username/org (VD: min2hi): " GITHUB_OWNER
read -p "Tên GitHub repo (VD: shopease): " GITHUB_REPO
read -p "Thư mục Backend [Enter = 'backend']: " BACKEND_DIR
read -p "Thư mục Frontend [Enter = 'frontend']: " FRONTEND_DIR

BACKEND_DIR=${BACKEND_DIR:-backend}
FRONTEND_DIR=${FRONTEND_DIR:-frontend}

echo ""
echo "📋 Xác nhận:"
echo "  Project Name  : $PROJECT_NAME"
echo "  GitHub        : $GITHUB_OWNER/$GITHUB_REPO"
echo "  Backend Dir   : $BACKEND_DIR"
echo "  Frontend Dir  : $FRONTEND_DIR"
echo ""
read -p "Tiếp tục? (y/n): " confirm
[ "$confirm" != "y" ] && echo "Đã hủy." && exit 0

echo ""
echo "⚙️  Đang điền thông tin vào các file..."

find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" \
  -o -name "*.json" -o -name "*.ts" -o -name "*.cjs" \
  -o -name "*.toml" -o -name "*.sh" \) \
  -not -path "./.git/*" -not -path "./node_modules/*" | while read file; do
    if grep -q '{{' "$file" 2>/dev/null; then
        sed -i \
            "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
            "s/{{PROJECT_SLUG}}/$PROJECT_SLUG/g" \
            "s/{{GITHUB_OWNER}}/$GITHUB_OWNER/g" \
            "s/{{GITHUB_REPO}}/$GITHUB_REPO/g" \
            "s/{{BACKEND_DIR}}/$BACKEND_DIR/g" \
            "s/{{FRONTEND_DIR}}/$FRONTEND_DIR/g" \
            "$file"
        echo "  ✅ $file"
    fi
done

echo ""
echo "📦 Cài npm dependencies..."
npm install

echo ""
echo "✅ Setup hoàn tất!"
echo ""
echo "📋 Việc cần làm tiếp theo:"
echo "  1. Cập nhật .claude/skills/architecture/SKILL.md (TODO markers)"
echo "  2. Xóa file setup.ps1 và setup.sh"
echo "  3. gh repo create $GITHUB_OWNER/$GITHUB_REPO --private"
echo "  4. git push -u origin main"
echo "  5. bash docs/setup-branch-protection.sh"
