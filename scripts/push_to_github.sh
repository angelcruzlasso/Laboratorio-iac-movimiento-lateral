#!/bin/bash
# Script to push the repository to GitHub
# Run this after creating the GitHub repository

REPO_NAME="Lab-movimiento-lateral"
GITHUB_USER="angel"  # Change this to your GitHub username

echo "Setting up remote origin..."
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo "Pushing to GitHub main branch..."
git push -u origin main

echo ""
echo "✅ Repository pushed successfully!"
echo ""
echo "Next steps:"
echo "1. Go to https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo "2. Verify all files are present"
echo "3. Set up repository secrets if needed"
echo "4. Enable GitHub Actions for CI/CD"