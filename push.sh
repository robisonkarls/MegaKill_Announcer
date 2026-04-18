#!/bin/bash
# Quick push script for MegaKill_Announcer

cd "$(dirname "$0")"

echo "Pushing to GitHub..."
git push -u origin main

echo ""
echo "Creating v1.0.0 tag..."
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

echo ""
echo "✓ Done! Check GitHub Actions at:"
echo "  https://github.com/robisonkarls/MegaKill_Announcer/actions"
