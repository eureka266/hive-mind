#!/bin/bash

# HiveMind Setup Verification Script
# Run this to verify both Repo A and Repo B are configured correctly

echo "🔍 HiveMind Setup Verification"
echo "=================================="
echo

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track failures
FAILURES=0

# Helper function
check() {
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} $1"
  else
    echo -e "${RED}✗${NC} $1"
    FAILURES=$((FAILURES + 1))
  fi
}

# Helper function for warnings
warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

echo "1. Checking Repo A (Skill)..."
echo

# Check Repo A files exist
[ -f PACKAGE.md ] && check "PACKAGE.md exists" || check "PACKAGE.md missing"
[ -f README.md ] && check "README.md exists" || check "README.md missing"
[ -f DEPLOY.md ] && check "DEPLOY.md exists" || check "DEPLOY.md missing"
[ -d agents ] && check "agents/ directory exists" || check "agents/ missing"
[ -d references ] && check "references/ directory exists" || check "references/ missing"
[ -f references/knowledge-repo-url ] && check "knowledge-repo-url file exists" || check "knowledge-repo-url missing"

echo
echo "2. Checking Repo B (Knowledge)..."
echo

REPO_B=$(cat references/knowledge-repo-url 2>/dev/null)

if [ -z "$REPO_B" ]; then
  echo -e "${RED}✗${NC} references/knowledge-repo-url is empty"
  FAILURES=$((FAILURES + 1))
else
  echo -e "${GREEN}✓${NC} Knowledge repo URL: $REPO_B"

  # Try to clone/verify repo is accessible
  git ls-remote "$REPO_B" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    check "Knowledge repo is accessible via git"
  else
    warn "Could not verify knowledge repo (might need SSH key or GitHub token)"
  fi
fi

# Check if Repo B directory exists locally
if [ -d ~/team-knowledge ]; then
  check "Repo B directory exists at ~/team-knowledge"

  # Check Repo B structure
  cd ~/team-knowledge

  [ -d facts ] && check "facts/ directory exists" || check "facts/ missing"
  [ -d workflows ] && check "workflows/ directory exists" || check "workflows/ missing"
  [ -d decisions ] && check "decisions/ directory exists" || check "decisions/ missing"
  [ -d approved-prds ] && check "approved-prds/ directory exists" || check "approved-prds/ missing"
  [ -f CLAUDE.md ] && check "CLAUDE.md exists" || check "CLAUDE.md missing"
  [ -d memory/journal ] && check "memory/journal/ directory exists" || check "memory/journal/ missing"
  [ -d memory/research ] && check "memory/research/ directory exists" || check "memory/research/ missing"
  [ -f facts/your-product.md ] && check "facts/your-product.md exists" || check "facts/your-product.md missing"

  # Check git status
  git status > /dev/null 2>&1 && check "Repo B is a git repository" || check "Repo B is not a git repository"
else
  echo -e "${RED}✗${NC} Repo B not found at ~/team-knowledge"
  FAILURES=$((FAILURES + 1))
fi

echo
echo "3. Checking Git Configuration..."
echo

git config user.email > /dev/null 2>&1 && check "Git user.email is configured" || warn "Git user.email not configured (needed for commits)"
git config user.name > /dev/null 2>&1 && check "Git user.name is configured" || warn "Git user.name not configured (needed for commits)"

# Check SSH or HTTPS access
ssh -T git@github.com > /dev/null 2>&1
if [ $? -eq 1 ]; then
  check "GitHub SSH access working"
else
  warn "GitHub SSH access might not be configured (can use HTTPS with token instead)"
fi

echo
echo "4. Checking Python/Scripts..."
echo

if command -v python3 &> /dev/null; then
  check "Python 3 is installed"
else
  warn "Python 3 not found (optional, for future scripts)"
fi

echo
echo "=================================="
if [ $FAILURES -eq 0 ]; then
  echo -e "${GREEN}✅ All checks passed! Setup is ready.${NC}"
  echo
  echo "Next step: Run /prd-write to test the workflow"
  exit 0
else
  echo -e "${RED}❌ $FAILURES check(s) failed.${NC}"
  echo
  echo "Common fixes:"
  echo "1. Make sure both repos are on GitHub"
  echo "2. Update references/knowledge-repo-url with correct GitHub URL"
  echo "3. Configure git: git config --global user.email 'you@example.com'"
  echo "4. Set up GitHub SSH: https://docs.github.com/en/authentication/connecting-to-github-with-ssh"
  exit 1
fi
