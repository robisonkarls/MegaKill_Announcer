# CurseForge Deployment Setup Guide

## What I've Created

✅ **GitHub Actions Workflow** (`.github/workflows/release.yml`)
- Auto-deploys to CurseForge on git tag push
- Creates GitHub release with downloadable zip
- Extracts changelog from CHANGELOG.md

✅ **CHANGELOG.md** - Version history (v1.0.0 ready)

✅ **.pkgmeta** - CurseForge packager config

---

## What You Need To Do

### 1. Create CurseForge Project (One-time setup)

1. Go to https://www.curseforge.com/signup and create account
2. Visit https://authors.curseforge.com/
3. Click **"Create Project"** → Select **"World of Warcraft"**
4. Fill in project details:
   - **Name:** MegaKill Announcer
   - **Summary:** Announces multi-kills and killing sprees with on-screen text, sounds, and chat messages — inspired by classic arena shooter callouts
   - **Category:** PvP, Combat
   - **Description:** (Copy from README.md)
   - **License:** MIT
   
5. After creation, note your **Project ID** from the URL:
   ```
   https://www.curseforge.com/wow/addons/YOUR-PROJECT-NAME
   Settings tab → Project ID (e.g., 123456)
   ```

---

### 2. Get CurseForge API Token

1. Go to https://authors.curseforge.com/account/api-tokens
2. Click **"Generate Token"**
3. Give it a name: "GitHub Actions Deploy"
4. Copy the token (you won't see it again!)

---

### 3. Add Secrets to GitHub Repository

1. Go to your GitHub repo: https://github.com/robisonkarls/MegaKill_Announcer
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Add two secrets:

**Secret 1:**
- Name: `CF_API_TOKEN`
- Value: (paste the token from step 2)

**Secret 2:**
- Name: `CF_PROJECT_ID`
- Value: (your project ID from step 1, just the numbers)

---

### 4. First Release (Manual Validation)

Before automating, do one manual upload to validate everything:

1. **Package the addon manually:**
   ```bash
   cd /Users/bot/.openclaw/workspace/agents/addonis/MegaKill_Announcer
   zip -r MegaKill_Announcer-v1.0.zip . \
     -x "*.git*" \
     -x ".github/*" \
     -x "PUBLISHING.md" \
     -x "DEPLOYMENT.md"
   ```

2. **Upload to CurseForge manually:**
   - Go to your project page
   - Click **"Files"** tab → **"Upload File"**
   - Upload `MegaKill_Announcer-v1.0.zip`
   - Set **Game Versions:**
     - ☑ Classic Era (1.14.3)
     - ☑ Retail (12.0.0.1 / The War Within)
   - Set **Release Type:** Release
   - **Changelog:** Copy from CHANGELOG.md v1.0.0 section
   - Click **Submit**

3. **Wait for approval** (~24 hours, usually faster)

---

### 5. Automated Releases (After Manual Validation)

Once the manual release is approved, future releases are automatic:

```bash
# 1. Update CHANGELOG.md with new version
# 2. Commit changes
git add .
git commit -m "Prepare v1.1.0 release"
git push

# 3. Create and push tag
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin v1.1.0
```

**What happens automatically:**
1. GitHub Actions triggers on tag push
2. Creates addon package zip
3. Uploads to CurseForge
4. Creates GitHub release with zip attachment
5. Extracts changelog from CHANGELOG.md

---

### 6. Monitoring Releases

- **GitHub Actions:** https://github.com/robisonkarls/MegaKill_Announcer/actions
- **CurseForge Files:** Your project page → Files tab
- **GitHub Releases:** https://github.com/robisonkarls/MegaKill_Announcer/releases

---

## Troubleshooting

### "Invalid API token"
- Regenerate token at https://authors.curseforge.com/account/api-tokens
- Update `CF_API_TOKEN` secret in GitHub

### "Invalid project ID"
- Check project ID in CurseForge project settings
- Update `CF_PROJECT_ID` secret in GitHub

### "Game version not found"
- Update `game_versions` in `.github/workflows/release.yml`
- Check valid IDs at: https://www.curseforge.com/api/game/versions

### Workflow fails
- Check GitHub Actions logs
- Verify secrets are set correctly
- Ensure tag format is `v*` (e.g., `v1.0.0`)

---

## Game Version IDs (for .github/workflows/release.yml)

Update these as WoW patches release:

```yaml
game_versions: 11403,120001  # Current: Classic Era 1.14.3, Retail 12.0.0.1
```

Find current IDs:
- https://www.curseforge.com/api/game/versions
- Or check another addon's API response

---

## Next Steps

1. ✅ Complete CurseForge project creation
2. ✅ Get API token
3. ✅ Add GitHub secrets
4. ✅ Manual first upload for validation
5. ⏳ Wait for approval
6. 🚀 Test automated release with v1.0.1 or v1.1.0

