-- tab size is 4
-- registrations for media from the client itself belongs in LibSharedMedia-3.0

local LSM = LibStub("LibSharedMedia-3.0")
local koKR, ruRU, zhCN, zhTW, western = LSM.LOCALE_BIT_koKR, LSM.LOCALE_BIT_ruRU, LSM.LOCALE_BIT_zhCN, LSM.LOCALE_BIT_zhTW, LSM.LOCALE_BIT_western

local MediaType_BACKGROUND = LSM.MediaType.BACKGROUND
local MediaType_BORDER = LSM.MediaType.BORDER
local MediaType_FONT = LSM.MediaType.FONT
local MediaType_STATUSBAR = LSM.MediaType.STATUSBAR

-- -----
--   SOUND
-- -----
LSM:Register("sound", "|cffee6730First Blood -NBA|r",                 [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_1stblood_01.mp3]])
LSM:Register("sound", "|cffee6730Heating Up -NBA|r",                  [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_double_01.mp3]])
LSM:Register("sound", "|cffee6730Spectacular Dunk -NBA|r",            [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_dominate_01.mp3]])
LSM:Register("sound", "|cffee6730Is it the Shoes -NBA|r",             [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_godlike_01.mp3]])
LSM:Register("sound", "|cffee6730Boom-shaka-laka -NBA|r",             [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_holy_01.mp3]])
LSM:Register("sound", "|cffee6730Monsterjam -NBA|r",                  [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_mega_01.mp3]])
LSM:Register("sound", "|cffee6730Jams it In -NBA|r",                  [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_spree_01.mp3]])
LSM:Register("sound", "|cffee6730He's on Fire -NBA|r",                [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_triple_01.mp3]])
LSM:Register("sound", "|cffee6730Knock Knock -NBA|r",                 [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_ultra_01.mp3]])
LSM:Register("sound", "|cffee6730From Downtown -NBA|r",              [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_unstop_01.mp3]])
LSM:Register("sound", "|cffee6730Serves up the Facial -NBA|r",       [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_wicked_01.mp3]])
LSM:Register("sound", "|cffee6730Too Big -NBA|r",                    [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_ownage_01.mp3]])
LSM:Register("sound", "|cffee6730Retirement -NBA|r",                 [[Interface\Addons\SharedMedia_NBAAnnouncer\sound\announcer_kill_rampage_01.mp3]])
