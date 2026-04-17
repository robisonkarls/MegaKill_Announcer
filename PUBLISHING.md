# Publishing MegaKill Announcer

## Distribution Platforms

### 1. CurseForge (curseforge.com)
**Primary WoW addon distribution platform**

#### Requirements:
- CurseForge account (free)
- Project page creation
- Packaged addon zip file

#### Steps:
1. Create account at https://www.curseforge.com/signup
2. Go to https://authors.curseforge.com/
3. Click "Create Project" → Select "World of Warcraft" game
4. Fill in project details:
   - **Name:** MegaKill Announcer
   - **Summary:** Announces multi-kills and killing sprees with screen text and sounds
   - **Category:** PvP, Combat
   - **Game Version:** Select all supported (Classic Era, Retail)
   - **Description:** (Use README.md content)
   - **Screenshots/Videos:** Recommended but optional for first release

5. Upload addon file:
   - Create `.zip` containing the `MegaKill_Announcer` folder
   - Upload via "Files" tab
   - Set compatible game versions
   - Mark as Release/Beta/Alpha
   - Add changelog

6. Submit for approval (usually < 24 hours)

#### Automation Options:
- **CurseForge Packager:** https://github.com/BigWigsMods/packager
- **GitHub Actions:** Auto-publish on git tags
- **CF API:** https://support.curseforge.com/en/support/solutions/articles/9000197321

---

### 2. WoWInterface (wowinterface.com)
**Alternative/complementary platform**

#### Requirements:
- WoWInterface account (free)
- Manual upload process

#### Steps:
1. Create account at https://www.wowinterface.com/forums/register.php
2. Go to "AddOns" → "Upload AddOn"
3. Fill in details:
   - **Title:** MegaKill Announcer
   - **Category:** PvP, Combat Mods
   - **Compatible Versions:** Classic Era, Retail
   - **Description:** (Use README.md)
   - **Screenshots:** Recommended

4. Upload `.zip` file
5. Submit for moderation (usually 24-48 hours)

#### Notes:
- Requires manual updates (no API)
- Smaller reach than CurseForge
- Good for diversification

---

### 3. Wago Addons (addons.wago.io)
**Newer platform, growing popularity**

#### Requirements:
- Wago account
- GitHub repository (optional but recommended)

#### Steps:
1. Create account at https://addons.wago.io/
2. Link GitHub repository or upload manually
3. Configure project settings
4. Supports auto-updates via GitHub

---

## Packaging Checklist

### Required Files:
- [x] `Core.lua` - Main addon code
- [x] `Config.lua` - UI settings panel
- [x] `MegaKill_Announcer_Classic.toc` - Classic metadata
- [x] `MegaKill_Announcer_Mainline.toc` - Retail metadata
- [x] `README.md` - Documentation
- [x] `LICENSE` - MIT License
- [x] `assets/` - Sound files

### Optional but Recommended:
- [ ] `CHANGELOG.md` - Version history
- [ ] Screenshots - In-game UI examples
- [ ] `.pkgmeta` - CurseForge packager config

### Before Publishing:
1. Test on Classic Era
2. Test on Retail
3. Verify all slash commands work
4. Test UI panel opens correctly
5. Verify sounds play
6. Check for Lua errors (`/console scriptErrors 1`)

---

## Creating Release Package

### Manual Method:
```bash
# From workspace root
cd MegaKill_Announcer
zip -r MegaKill_Announcer-v1.0.zip . \
  -x "*.git*" \
  -x "*.DS_Store" \
  -x "PUBLISHING.md"
```

### Automated Method (GitHub Actions):
Create `.github/workflows/release.yml`:

```yaml
name: Package and Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Create package
        run: |
          zip -r MegaKill_Announcer.zip MegaKill_Announcer/ \
            -x "*.git*" "*.github*"
      
      - name: Upload to CurseForge
        uses: itsmeow/curseforge-upload@v3
        with:
          token: ${{ secrets.CF_API_TOKEN }}
          project_id: YOUR_PROJECT_ID
          game_endpoint: wow
          file_path: MegaKill_Announcer.zip
          changelog: See GitHub releases
          game_versions: 11403,120001  # Classic Era, Retail
          release_type: release
```

---

## .pkgmeta (CurseForge Packager)

Create `.pkgmeta` in repo root:

```yaml
package-as: MegaKill_Announcer

enable-nolib-creation: no

manual-changelog:
  filename: CHANGELOG.md
  markup-type: markdown

ignore:
  - PUBLISHING.md
  - .github
  - .git
  - .gitignore

license-output: LICENSE
```

---

## Version Management

### Semantic Versioning:
- `1.0.0` - Initial release
- `1.1.0` - New features (e.g., more sound effects)
- `1.0.1` - Bug fixes

### TOC Version Updates:
Update `## Version:` in both `.toc` files before each release.

### Git Tagging:
```bash
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

---

## Marketing / Visibility

### Description Best Practices:
- Clear feature list with bullet points
- Screenshots showing UI and in-game text
- Video demo (optional, boosts downloads)
- Comparison to similar addons (if any)

### Keywords/Tags:
- PvP
- Combat
- Announcements
- Killstreaks
- Arena
- Battlegrounds
- Classic
- Retail

### Screenshots to Include:
1. Settings UI panel
2. Multi-kill on-screen announcement
3. Killing spree announcement
4. Slash command help output

---

## Support & Updates

### User Support:
- Monitor CurseForge comments
- GitHub Issues (if repo is public)
- WoWInterface forum thread

### Update Frequency:
- Patch day compatibility checks
- Bug fixes as reported
- Feature requests from community

---

## Legal / Compliance

### Blizzard ToS:
- ✅ No automation of gameplay
- ✅ No protected functions abuse
- ✅ Purely informational/UI
- ✅ No monetization via in-game mechanics

### CurseForge Rules:
- No adult content
- No malicious code
- No copyrighted material (our sounds are custom/public domain)
- Proper licensing (MIT is accepted)

---

## Next Steps

1. **Test thoroughly** on both Classic and Retail
2. **Create screenshots** of UI and announcements
3. **Write CHANGELOG.md** for v1.0.0
4. **Package the addon** as `.zip`
5. **Create CurseForge project**
6. **Upload to CurseForge**
7. **Upload to WoWInterface** (optional)
8. **Promote** on /r/wowaddons, MMO-Champion forums

