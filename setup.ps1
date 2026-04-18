# ============================================================
# AI Harness Template — Setup Script (PowerShell)
# ============================================================
# Chạy script này SAU KHI clone template về project mới.
# Script sẽ hỏi thông tin dự án → tự điền vào tất cả file.
#
# CÁCH CHẠY:
#   .\setup.ps1
# ============================================================

Write-Host ""
Write-Host "🚀 AI Harness Template — Project Setup" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# ─── Thu thập thông tin ──────────────────────────────────────
$PROJECT_NAME   = Read-Host "Tên project (hiển thị, VD: ShopEase)"
$PROJECT_SLUG   = Read-Host "Slug project (dùng cho package.json, VD: shopease)"
$GITHUB_OWNER   = Read-Host "GitHub username/org (VD: min2hi)"
$GITHUB_REPO    = Read-Host "Tên GitHub repo (VD: shopease)"
$BACKEND_DIR    = Read-Host "Thư mục Backend [nhấn Enter để dùng 'backend']"
$FRONTEND_DIR   = Read-Host "Thư mục Frontend [nhấn Enter để dùng 'frontend']"

if (-not $BACKEND_DIR)  { $BACKEND_DIR  = "backend" }
if (-not $FRONTEND_DIR) { $FRONTEND_DIR = "frontend" }

Write-Host ""
Write-Host "📋 Xác nhận thông tin:" -ForegroundColor Yellow
Write-Host "  Project Name  : $PROJECT_NAME"
Write-Host "  Project Slug  : $PROJECT_SLUG"
Write-Host "  GitHub Owner  : $GITHUB_OWNER"
Write-Host "  GitHub Repo   : $GITHUB_REPO"
Write-Host "  Backend Dir   : $BACKEND_DIR"
Write-Host "  Frontend Dir  : $FRONTEND_DIR"
Write-Host ""
$confirm = Read-Host "Tiếp tục? (y/n)"
if ($confirm -ne "y") { Write-Host "Đã hủy." -ForegroundColor Red; exit 0 }

# ─── Thay thế placeholder trong tất cả file ─────────────────
Write-Host ""
Write-Host "⚙️  Đang điền thông tin vào các file..." -ForegroundColor Cyan

$files = Get-ChildItem -Recurse -File | Where-Object {
    $_.FullName -notmatch '\\\.git\\' -and
    $_.FullName -notmatch '\\node_modules\\' -and
    $_.Extension -in @('.md', '.yml', '.yaml', '.json', '.ts', '.cjs', '.toml', '.sh', '.ps1')
}

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if ($content -match '\{\{') {
        $content = $content `
            -replace '\{\{PROJECT_NAME\}\}',  $PROJECT_NAME `
            -replace '\{\{PROJECT_SLUG\}\}',  $PROJECT_SLUG `
            -replace '\{\{GITHUB_OWNER\}\}',  $GITHUB_OWNER `
            -replace '\{\{GITHUB_REPO\}\}',   $GITHUB_REPO `
            -replace '\{\{BACKEND_DIR\}\}',   $BACKEND_DIR `
            -replace '\{\{FRONTEND_DIR\}\}',  $FRONTEND_DIR
        Set-Content $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "  ✅ $($file.Name)" -ForegroundColor Green
    }
}

# ─── Cài npm dependencies ────────────────────────────────────
Write-Host ""
Write-Host "📦 Cài npm dependencies (husky, commitlint, lint-staged)..." -ForegroundColor Cyan
npm install

# ─── Init Husky ──────────────────────────────────────────────
Write-Host ""
Write-Host "🐶 Khởi tạo Husky hooks..." -ForegroundColor Cyan
npx husky init
# Ghi đè file mặc định của husky bằng hooks của template
Copy-Item ".husky\pre-commit.template" ".husky\pre-commit" -Force -ErrorAction SilentlyContinue
Copy-Item ".husky\commit-msg.template" ".husky\commit-msg" -Force -ErrorAction SilentlyContinue

# ─── Thông báo hoàn thành ────────────────────────────────────
Write-Host ""
Write-Host "✅ Setup hoàn tất!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Việc cần làm tiếp theo:" -ForegroundColor Yellow
Write-Host "  1. Cập nhật .claude/skills/architecture/SKILL.md  (TODO markers)"
Write-Host "  2. Xóa file setup.ps1 và setup.sh khỏi project"
Write-Host "  3. Tạo GitHub repo: gh repo create $GITHUB_OWNER/$GITHUB_REPO --private"
Write-Host "  4. Push lên GitHub: git push -u origin main"
Write-Host "  5. Bật Branch Protection: bash docs/setup-branch-protection.sh"
Write-Host ""
Write-Host "🔗 Docs: docs/README.md" -ForegroundColor Cyan
