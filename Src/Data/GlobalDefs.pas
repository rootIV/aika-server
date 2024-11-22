﻿unit GlobalDefs;
interface
uses
  Log,
  ServerSocket, LoginSocket, TokenSocket,
  PlayerData, MiscData, FilesData, Windows, NPC,
  Generics.Collections, GuildData, Nation, Dungeon, Player;
var
  Logger: TLog;
  WebServerClosed: Boolean;
  Servers: ARRAY OF TServerSocket;
  Nations: Array [0..2] of TNationData;
  LoginServer: TLoginSocket;
  TokenServer: TTokenServer;
  TokenServerAdmin: TTokenServerAdmin;
  PointerPlayer: PPlayer;
  ActivePlayersNow: Integer;
  DungeonInstances: Array [1 .. 1] of TDungeonInstance;
  xServerClosed: Boolean;
{$REGION 'Files defs'}
  ItemList: TItemList;
  SkillData: TSkillData;
  SetItem: TSetItem;
  Conjuntos: TConjunts;
  ExpList: TExpList;
  PranExpList: TPranExpList;
  ServerList: TServerList;
  Quests: TQuestList;
  _Quests: TQuestMiscArray;
  Titles: TitleList;
  Drops: TMobDrops;
  Recipes: TRecipes;
  MakeItems: TMakeItems;
  MakeItemsIngredients: TMakeItemsIngredients;
  PremiumItems: TPremiumList;
  MobPos: TMobPosFile;
  MapsData: TFileMapsData;
  ScrollTeleportPosition: TScrollTeleportFile;
  ServerHasClosed: Boolean;
{$ENDREGION}
  InstantiatedNPCs, InstantiatedChannels, InstantiatedGuilds,
    PlayersThreads: Integer;
  Guilds: ARRAY [1 .. 50] OF TGuild;
  TimeTick: Cardinal;
  InitialAccounts: ARRAY [0 .. 5] OF TCharacterDB;
  MAX_CONNECTIONS: WORD;
  SERVER_VERSION: WORD; //290
  SERVER_COUNT: WORD;
  MYSQL_SERVER: String;
  MYSQL_PORT: WORD;
  MYSQL_DATABASE: String;
  MYSQL_USERNAME: String;
  MYSQL_PASSWORD: String;
  MYSQL_USERNAMEGM: String;
  MYSQL_PASSWORDGM: String;
  MYSQL_SERVERGM: String;
  ASAAS_LINK_GATEWAY: String;
  ASAAS_TOKEN_PINGBACK: String;
  Neighbors: array [0 .. 6] of TPosition;
  HeightGrid: THeightMap;
  NPCOptionsText: TNPCFileOptions;
  { Reinforce }
  ReinforceW01: ARRAY OF TItemChanceReinforce; // Weapon
  ReinforceA01: ARRAY OF TItemChanceReinforce; // Armor
  Reinforce2: ARRAY OF TItemAttributeReinforce;
  Reinforce3: ARRAY OF ArmorAttributeReinforce;
  { Outros }
  LogPackets: Boolean;
  DATABASE_PATH: string = 'C:\Database\';
  BASE_DATETIME: string = '31/12/1969 22:00';
  { Run Var }
  SERVER_TYPE: string;
  ChangeChannelList: TDictionary<DWORD, TChangeChannelToken>;
  LEVEL_CAP: WORD = 50;
  MAX_PRAN_LEVEL: WORD = 30;
  DELETE_DAYS_INC: WORD = 1;
  DamageType: BYTE;
  DAYS_BACKUP_ACCOUNT_DELETE: WORD  = 14;
  MOB_ESQUIVA: WORD = 5;
  MOB_CRIT_RES: WORD = 20;
  MOB_DUPLO_RES: WORD = 40;
  MOB_GUARD_PATK: WORD = 2400;
  MOB_GUARD_MATK: WORD = 2400;
  MOB_GUARD_PDEF: WORD = 5500;
  MOB_GUARD_MDEF: WORD = 5500;
  MOB_GUARD_DEVIR_ATK: WORD = 800;
  MOB_GUARD_DEVIR_DEF: WORD = 3000;
  MOB_STONE_DEVIR_ATK: WORD = 900;
  MOB_STONE_DEVIR_DEF: WORD = 6000;
  MOB_STONE_HP: WORD = 60000;
  MOB_GUARD_HP: WORD = 30000;
  EXP_MULTIPLIER: WORD = 2;
  HONOR_PER_KILL: WORD = 120;
  PVP_ITEM_DROP_TAX: WORD = 100;
  SKULL_MULTIPLIER: WORD = 1;
  DUEL_TIME_WAIT: WORD = 15;
  RELIQ_EST_TIME: WORD = 2;
  INC_HONOR_RELIQ_LEVEL: WORD = 250;
  RATE_EFFECT5: WORD = 10;
  DISTANCE_TO_WATCH: WORD = 50;
  DISTANCE_TO_FORGET: WORD = 60;
const
  MAX_BYTE_SIZE = 255;
  MAX_WORD_SIZE = 65535;
  MIN_BYTE_SIZE = 0;
  MIN_WORD_SIZE = 0;
  ACCEPT_CONNECTIONS_DELAY = 1; // Delay em miliseconds

  MAX_SPAWN_ID = 30000;
  AI_DELAY_MOVIMENTO = 2000;
  MIN_DELAY_ATTACK = 300; // (ms)

  TITEM_SIZE = 20;

  PRICE_HONOR = 1; // Item � vendido por Honra
  PRICE_MEDAL = 2; // Item � vendido por medalhas
  PRICE_GOLD = 3; // Item � vendido por gold
  PRICE_ITEM = 4; // Item � vendido por outro item
  SPAWN_NORMAL = 0; // Somente aparece
  SPAWN_TELEPORT = 1; // Quando Char nasce ou telporta
  SPAWN_BABYGEN = 2; // Efeito de quando uma cria nasce
  DELETE_NORMAL = 0; // Somente desaparece
  DELETE_DEAD = 1; // Animacao da morte do spawn
  DELETE_DISCONNECT = 2; // Efeito de quando o personagem sai do jogo
  DELETE_UNSPAWN = 3; // Efeito quando os monstros ancts somem
  MOVE_NORMAL = 0;
  MOVE_TELEPORT = 1;
  MOVE_GENERATESUMON = 8; // Segundo o Guican
  WORLD_MOB = 0;
  WORLD_ITEM = 1;
  WARRIOR = 0;
  PALADIN = 1;
  RIFLEMAN = 2;
  DUALGUNNER = 3;
  MAGICIAN = 4;
  CLERIC = 5;

  SECURE_DEVIR_TYPE = 1;
  SECURE_TIAMAT_TYPE = 2;
  OBJECT_RELIQUARE = 1;
  OBJECT_BOX_ITEM = 2;
  OBJECT_BOX_GOLD = 3;
  OBJECT_BOX_EVENT = 4;
  EQUIP_TYPE = 0;
  INV_TYPE = 1;
  STORAGE_TYPE = 2;
  GUILDCHEST_TYPE = 3;
  PRAN_EQUIP_TYPE = 5;
  PRAN_INV_TYPE = 6;
  ITEM_USE_TYPE = 9;
  CASH_TYPE = 10;
  EVENT_ITEM = 17;
  AUCTION_ITEM = 20;
  ITEM_UNAGRUPABLE = 0;
  ITEM_QUANT_EXCEDE = 1;
  ITEM_AGRUPABLE = 2;
  MAX_SLOT_AMOUNT = 1000;
  CHANGE_REINFORCE = 0;
  CHANGE_ENCHANTS = 1;
  CHANGE_APP = 2;
  CHANGE_MOUNT_ENCHANTS = 11;
  CHANGE_PRAN_ENCHANTS = 13;
  DROP_NORMAL_ITEM = 1;
  DROP_SUPERIOR_ITEM = 2;
  DROP_RARE_ITEM = 3;
  DROP_LEGENDARY_ITEM = 4;
  MONSTERS_0_20 = 0;
  MONSTERS_21_40 = 1;
  MONSTERS_41_60 = 2;
  MONSTERS_61_80 = 3;
  MONSTERS_81_99 = 4;
  MONSTERS_PLANTA = 5;
  MONSTERS_CROSHU_AZUL = 6;
  MONSTERS_CROSHU_VERM = 7;
  MONSTERS_BUTO = 8;
  MONSTERS_PENZA = 9;
  MONSTERS_VERIT = 10;
  MONSTERS_ADICIONAL1 = 11;
  MONSTERS_ADICIONAL2 = 12;
  DUNGEON_LOST_MINES = 4;
  DUNGEON_KINARY_AVIARY = 5;
  DUNGEON_MARAUDER_HOLD = 2;
  DUNGEON_MARAUDER_CABIN = 3;
  DUNGEON_ZANTORIAN_CITADEL = 1;
  // DUNGEON_MINE_2 = 5;
  DUNGEON_PHELTAS = 10;
  DUNGEON_NPC_PRISON = 2302;
  DUNGEON_NPC_MINA_1 = 2197;
  DUNGEON_NPC_MINA_2 = 2151;
  DUNGEON_NPC_EVG_INF = 2095;
  DUNGEON_NPC_EVG_SUP = 2103;
  DUNGEON_NPC_URSULA = 2109;
  DUNGEON_NPC_KINARY = 2258;
  { Refinamento }
  ChancesOfRefinament: Array [0..11] of Byte = (100, 100, 100, 70, 50, 40, 30,
  15, 6, 2, 1, 0);
  { Vaizan enchant ranges }
  VaizanP_Set: array [0 .. 8] of Integer = (5352, 5355, 5358, 5361, 5364, 5367, 5370, 5373, 5376);

  VaizanM_Set: array [0 .. 8] of Integer = (5351, 5354, 5357, 5360, 5363, 5366, 5369, 5372, 5375);

  VaizanG_Set: array [0 .. 5] of Integer = (5350, 5353, 5356, 5368, 5371, 5374);

  VaizanP_Wep: array [0 .. 5] of Integer = (5331, 5334, 5337, 5340, 5343, 5346);

  VaizanM_Wep: array [0 .. 5] of Integer = (5330, 5333, 5336, 5339, 5342, 5345);

  VaizanG_Wep: array [0 .. 5] of Integer = (5329, 5332, 5335, 5338, 5341, 5344);

  VaizanP_Acc: array [0 .. 14] of Integer = (5397, 5400, 5403, 5406, 5409, 5412, 5415, 5418, 5421, 5424, 5427, 5430, 5433, 5448, 5451);

  VaizanM_Acc: array [0 .. 14] of Integer = (5396, 5399, 5402, 5405, 5408, 5411, 5414, 5417, 5420, 5423, 5426, 5429, 5432, 5447, 5450);

  VaizanG_Acc: array [0 .. 14] of Integer = (5395, 5398, 5401, 5404, 5407, 5410, 5413, 5416, 5419, 5422, 5425, 5428, 5431, 5446, 5449);

  Level_10_Destroy_Range: Array [0 .. 5] of Integer = (5100, 5080, 5081, 5082, 4630, 4631);
  Level_20_Destroy_Range: Array [0 .. 5] of Integer = (5100, 5080, 5081, 5082, 4632, 4633);
  Level_30_Destroy_Range: Array [0 .. 5] of Integer = (5100, 5080, 5081, 5082, 4634, 4635);
  Level_40_Destroy_Range: Array [0 .. 5] of Integer = (5100, 5080, 5081, 5082, 4636, 4638);
  Level_50_Destroy_Range: Array [0 .. 5] of Integer = (5100, 5080, 5081, 5082, 4642, 4644);
  Level_60_Destroy_Range: Array [0 .. 5] of Integer = (5100, 5080, 5081, 5082, 4644, 4636);
  Level_70_Destroy_Range: Array [0 .. 5] of Integer = (5100, 5080, 5081, 5082, 4642, 4645);
  Level_80_Destroy_Range: Array [0 .. 5] of Integer = (5100, 5080, 5081, 5082, 4649, 4647);
  Level_90_Destroy_Range: Array [0 .. 5] of Integer = (5100, 5080, 5081, 5082, 4649, 4647);
  NOT_USE_SLOT = $FFFFFFFF;
  { Troca }
  TRADE_REFUSE = 0;
  TRADE_ACEPT = 1;
  { Bool }
  BOOL_REFUSE = 0;
  BOOL_ACCEPT = 1;
  { Equipar e desequipar item }
  DESEQUIPING_TYPE = 1;
  EQUIPING_TYPE = 2;
  SAME_ITEM_TYPE = 3;
  { Valor de um item quando esta selado }
  ITEM_SELADO = $CCCCCCCC;
  { Local de onde vem o xp adicionado }
  EXP_TYPE_NORMAL = 0;
  EXP_TYPE_MOB = 1;
  EXP_TYPE_QUEST = 2;
  { Chat Type }
  CHAT_TYPE_NORMAL = 0;
  CHAT_TYPE_SUSSURO = 1; { Whisper }
  CHAT_TYPE_GRUPO = 2; { Party }
  CHAT_TYPE_GUILD = 3; { Guild }
  CHAT_TYPE_GRITO = 4; { Grito }
  CHAT_TYPE_ALLY = 5; { Ally }
  CHAT_TYPE_NATION = 6;
  CHAT_TYPE_MEGAFONE = 9; { Megafone }
  STORAGE_TYPE_PLAYER = 1;
  STORAGE_TYPE_PRANS = 2;
  STORAGE_TYPE_GUILD = 3;
  { Status Point DEFS }
  SKILL_POINT_PER_LEVEL = 1;
  STATUS_POINT_PER_LEVEL = 2;
  SKILL_POINT_X = 12;
  STATUS_POINT_X = 10;
  { Conjunt DEF }

  LEVEL_GMCOMMAND = 1;
  ITEM_GMCOMMAND = 2;
  COUPOM_GMCOMMAND = 3;
  FOUNDER_GMCOMMAND = 4;
  STUN_TYPE = 1;
  SILENCE_TYPE = 2;
  FEAR_TYPE = 3;
  LENT_TYPE = 4;
  CHOCK_TYPE = 5;
  PARALISYS_TYPE = 6;
  SemAuxilio = 0;
  AuxilioRed1 = 1; // Both are lv 1 in client
  AuxilioRed2 = 3;
  AuxilioBlue1 = 2; // Both are lv 2 in client
  AuxilioBlue2 = 4;
  MARECHAL_BUFF = 6600;
  ARCHON_BUFF = 6602;
  CAVALEIROS_MARECHAL = 6601;
  CAVALEIROS_ARCHON = 6648;
  ADMIN_BUFF = 6649;
{$REGION 'Auction'}
  // type TAuctionTax = (Hours_6 = 2, Hours_12 = 4, Hours_24 = );
{$ENDREGION}
const
{$REGION 'Effects'}
  // efeito Itens
  EF_NONE = 0;
  EF_BLANK01 = 1;
  EF_DAMAGE1 = 2;
  EF_DAMAGE2 = 3;
  EF_DAMAGE3 = 4;
  EF_DAMAGE4 = 5;
  EF_DAMAGE5 = 6;
  EF_DAMAGE6 = 7;
  EF_RESISTANCE1 = 8;
  EF_RESISTANCE2 = 9;
  EF_RESISTANCE3 = 10;
  EF_RESISTANCE4 = 11;
  EF_RESISTANCE5 = 12;
  EF_HP = 13;
  EF_MP = 14;
  EF_STR = 15;
  EF_DEX = 16;
  EF_INT = 17;
  EF_CON = 18;
  EF_SPI = 19;
  EF_RESISTANCE6 = 20;
  EF_RESISTANCE7 = 21;
  EF_REITERATION = 22;
  EF_DELAY_ATTACK1 = 23;
  EF_REFLECTION1 = 24;
  EF_ANTI_SKILL = 25;
  EF_CHECK_SKILL = 26;
  EF_ADD_DAMAGE1 = 27;
  EF_CAST_RATE = 28;
  EF_AMP_PHYSICAL = 29;
  EF_AMP_MAGIC = 30;
  EF_CRITICAL_POWER = 31;
  EF_MOUNT_CONCENTRATION = 32;
  EF_SKILL_ATIME9 = 33;
  EF_AMP_SKILL_DAMAGE = 34;
  EF_POLLUTION_RESISTANCE = 35;
  EF_SIEGE_LEVEL = 36;
  EF_DRAIN_MP = 37;
  EF_DELAY_ATTACK2 = 38;
  EF_UNIDENTIFIED = 39;
  EF_POLYMORPH1 = 40;
  EF_POLYMORPH2 = 41;
  EF_AWAKEN = 42;
  EF_DOT_TIMER = 43;
  EF_HP_CHECK_PC = 44;
  EF_ATK_MONSTER = 45;
  EF_RUNSPEED = 46;
  EF_RANGE = 47;
  EF_COOLTIME = 48;
  EF_DOUBLE = 49;
  EF_CRITICAL = 50;
  EF_PARRY = 51;
  EF_BLOCKING = 52;
  EF_HIT = 53;
  EF_PER_DAMAGE1 = 54;
  EF_PER_DAMAGE2 = 55;
  EF_PER_DAMAGE3 = 56;
  EF_PER_DAMAGE4 = 57;
  EF_PER_DAMAGE5 = 58;
  EF_PER_RESISTANCE1 = 59;
  EF_PER_RESISTANCE2 = 60;
  EF_PER_RESISTANCE3 = 61;
  EF_PER_RESISTANCE4 = 62;
  EF_PER_RESISTANCE5 = 63;
  EF_REGENHP = 64;
  EF_REGENMP = 65;
  EF_SKILL_DAMAGE = 66;
  EF_SKILL_HP_DAMAGE = 67;
  EF_ATK_NATION2 = 68;
  EF_DEF_NATION2 = 69;
  EF_RECALL = 70;
  // Skills
  EF_SKILL_IMMOVABLE = 71;
  EF_SKILL_INVISIBILITY = 72;
  EF_SKILL_STUN = 73;
  EF_SKILL_PROVOKE = 74;
  EF_SKILL_DEATH = 75;
  EF_SKILL_KNOCKBACK = 76;
  EF_SKILL_DISPEL1 = 77;
  EF_SKILL_DISPEL2 = 78;
  EF_SKILL_ABSORB1 = 79;
  EF_STATE_RESISTANCE = 80;
  EF_DASH = 81;
  EF_SKILL_DIVISION = 82;
  EF_SKILL_DISPEL3 = 83;
  EF_SKILL_DISPEL4 = 84;
  EF_SKILL_DISPEL5 = 85;
  EF_PIERCING_RESISTANCE1 = 86;
  EF_PIERCING_RESISTANCE2 = 87;
  EF_SKILL_UNARMORED = 88;
  EF_CRITICAL_DEFENCE = 89;
  EF_ATK_ALIEN = 90;
  EF_ATK_BEAST = 91;
  EF_ATK_PLANT = 92;
  EF_ATK_INSECT = 93;
  EF_ATK_DEMON = 94;
  EF_ATK_UNDEAD = 95;
  EF_ATK_COMPLEX = 96;
  EF_ATK_STRUCTURE = 97;
  EF_DEF_ALIEN = 98;
  EF_DEF_BEAST = 99;
  EF_DEF_PLANT = 100;
  EF_DEF_INSECT = 101;
  EF_DEF_DEMON = 102;
  EF_DEF_UNDEAD = 103;
  EF_DEF_COMPLEX = 104;
  EF_DEF_STRUCTURE = 105;
  EF_AGGRO1 = 106;
  EF_AGGRO2 = 107;
  EF_AGGRO3 = 108;
  EF_AGGRO4 = 109;
  EF_SKILL_DOT_DAMAGE6 = 110;
  EF_SKILL_DOT_MP = 111;
  EF_REQUIRE_MP = 112;
  EF_REQUIRE_MP0 = 113;
  EF_REQUIRE_MP1 = 114;
  EF_REQUIRE_MP2 = 115;
  EF_REQUIRE_MP3 = 116;
  EF_REQUIRE_MP4 = 117;
  EF_REQUIRE_MP5 = 118;
  EF_REQUIRE_MP6 = 119;
  EF_REQUIRE_MP7 = 120;
  EF_REQUIRE_MP8 = 121;
  EF_SKILL_ATIME6 = 122;
  EF_SKILL_RESURRECTION = 123;
  EF_DUR_RATE = 124;
  EF_DURABILITY = 125;
  EF_UNBREAKABLE = 126;
  EF_RANDOM_MIN = 127;
  EF_RANDOM_MAX = 128;
  EF_STOP_REGEN_HP = 129;
  EF_STOP_REGEN_MP = 130;
  EF_CRITICAL_STUN = 131;
  EF_ATK_DIVINE = 132;
  EF_DRAIN_HP = 133;
  EF_TARGET_FIX = 134;
  EF_ANTI_MAGIC = 135;
  EF_TRANSFER = 136;
  EF_TRANSFER_LIMIT = 137;
  EF_REACTION = 138;
  EF_CHANGE = 139;
  EF_SILENCE1 = 140;
  EF_SILENCE2 = 141;
  EF_HP_CONVERSION = 142;
  EF_MP_EFFICIENCY = 143;
  EF_HP_CHECK = 144;
  EF_REQUIRE_MPA = 145;
  EF_RELIQUE_PER_HP = 146;
  EF_RELIQUE_PER_EXP = 147;
  EF_RELIQUE_PER_MP = 148;
  EF_RELIQUE_PER_DAMAGE1 = 149;
  EF_RELIQUE_PER_DAMAGE2 = 150;
  EF_SKILL_SHOCK = 151;
  EF_SKILL_BLIND = 152;
  EF_SKILL_SLEEP = 153;
  EF_DECURE = 154;
  EF_POINT_DEFENCE = 155;
  EF_REFLECTION2 = 156;
  EF_MPCURE = 157;
  EF_SPLASH = 158;
  EF_UNARMOR = 159;
  EF_HIDE_LIMIT = 160;
  EF_HP_LIMIT = 161;
  EF_SUMMON = 162;
  EF_CAST_SPELL = 163;
  EF_ANTICURE_COUNT = 164;
  EF_ANTICURE = 165;
  EF_MASS_TELEPORT = 166;
  EF_DELAY_DAMAGE6 = 167;
  EF_DISPEL_BUFF = 168;
  EF_BREAK_BUFF = 169;
  EF_DISPEL_ALL = 170;
  EF_REFLECTION3 = 171;
  EF_REFLECTION4 = 172;
  EF_FAIRY_FORM = 173;
  EF_RELIQUE_SKILL_PER_DAMAGE = 174;
  EF_RELIQUE_SKILL_ATIME0 = 175;
  EF_RELIQUE_ATK_NATION = 176;
  EF_RELIQUE_DEF_NATION = 177;
  EF_RELIQUE_ALL_ABILITY = 178;
  EF_SELFHP_LIMIT = 179;
  EF_CALLSKILL = 180;
  EF_INITCOOLTIME = 181;
  EF_PRAN_DAMAGE1 = 182;
  EF_PRAN_DAMAGE2 = 183;
  EF_PRAN_HP = 184;
  EF_PRAN_MP = 185;
  EF_PRAN_RESISTANCE1 = 186;
  EF_PRAN_RESISTANCE2 = 187;
  EF_PRAN_CRITICAL = 188;
  EF_PRAN_SKILL_DAMAGE = 189;
  EF_PRAN_SKILL_ABSORB1 = 190;
  EF_PRAN_REGENHP = 191;
  EF_PRAN_REGENMP = 192;
  EF_PRAN_PARRY = 193;
  EF_PRAN_REQUIRE_MP = 194;
  EF_PRAN_STATE_RESISTANCE = 195;
  EF_CHAOS = 196;
  EF_TYPE45 = 197;
  EF_RELIQUE_CRITICAL = 198;
  EF_RELIQUE_HIT = 199;
  EF_RELIQUE_PARRY = 200;
  EF_RELIQUE_DOUBLE = 201;
  EF_RELIQUE_STATE_RESISTANCE = 202;
  EF_RELIQUE_ATK_MONSTER = 203;
  EF_RELIQUE_DEF_MONSTER = 204;
  EF_RELIQUE_LEVEL_UPGRADE = 205;
  EF_BLANK03 = 206;
  EF_BLANK04 = 207;
  EF_DISPEL_RANDOM = 208;
  EF_RELIQUE_PER_RESISTANCE1 = 209;
  EF_RELIQUE_PER_RESISTANCE2 = 210;
  EF_RELIQUE_DROP_RATE = 211;
  EF_RELIQUE_COOLTIME = 212;
  EF_RELIQUE_RUNSPEED = 213;
  EF_SKILL_DAMAGE6 = 214;
  EF_DAMAGE_SWARM = 215;
  EF_ANTI_SWARM = 216;
  EF_SKILL_CRITICAL = 217;
  EF_AFTEREFFECT = 218;
  EF_PARALYSIS = 219;
  EF_SUMMON_TARGET = 220;
  EF_WEAPON_GUARD = 221;
  EF_BATTLE_REGENHP = 222;
  EF_DAMAGE7 = 223;
  EF_BATTEL_RENEGADE = 224;
  EF_SUICIDE = 225;
  EF_FEAR = 226;
  EF_BATTLE_DAMAGE1 = 227;
  EF_BATTLE_DAMAGE2 = 228;
  EF_BATTLE_HP = 229;
  EF_BATTLE_MP = 230;
  EF_BATTLE_RESISTANCE1 = 231;
  EF_BATTLE_RESISTANCE2 = 232;
  EF_ABSOLUT_DAMAGE6 = 233;
  EF_UPCURE = 234;
  EF_FREEZE = 235;
  EF_PULL_TARGET = 236;
  EF_GUARD = 237;
  EF_GUARD_RATE = 238;
  EF_PROMESSA = 239;
  EF_ULTIMATUM = 240;
  EF_SNIPING_STANCE = 241;
  EF_IM_RUNSPEED = 242;
  EF_IM_SKILL_IMMOVABLE = 243;
  EF_BLOODYROSE = 244;
  EF_DEAD_LINK = 245;
  EF_IM_SILENCE1 = 246;
  EF_IM_FEAR = 247;
  EF_IM_SKILL_STUN = 248;
  EF_IM_SKILL_SHOCK = 249;
  EF_IMMUNITY = 250;
  EF_PROMESSA_LINK = 251;
  EF_MARSHAL_PER_HP = 252;
  EF_MARSHAL_PER_MP = 253;
  EF_MARSHAL_ATK_NATION = 254;
  EF_MARSHAL_DEF_NATION = 255;
  EF_BREAK_ANTI_MAGIC = 256;
  EF_DAMAGE_TO_HP = 257;
  EF_2SEC_RANDOM_COUNT = 258;
  EF_SKILL_CALLSKILL = 259;
  EF_DEATH_LIFE = 260;
  EF_ABSOLUT_DAMAGE = 261;
  EF_SUMMON_MOUNT = 262;
  EF_SUMMON_LOCK = 263;
  EF_LIMIT_HP_UP = 264;
  EF_INITSKILL = 265;
  EF_BUFF_CONSERVATION = 266;
  EF_DOUBLE_HONOR_POINT = 267;
  EF_PER_HP = 268;
  EF_PER_MP = 269;
  EF_REDUCE_AOE = 270;
  EF_BLANK15 = 271;
  EF_BLANK16 = 272;
  EF_SPEND_MANA = 273;
  EF_COUNT_HIT = 274;
  EF_AMP_PARALYSIS_ATTACK = 275;
  EF_SKILL_ABSORB2 = 276;
  EF_AMP_SKILL_DAMAGE6 = 277;
  EF_PREMIUM_PER_EXP = 278;
  EF_HEADSCALE = 279;
  EF_PC_PREMIUM_PER_EXP = 280;
  EF_SKILL_DOT_PER_HPCURE = 281;
  EF_NPC_ACCESS_DENIED = 282;
  EF_PARTY_PER_DROP_RATE = 283;
  EF_SPI_PER_MP = 284;
  EF_ACCELERATION1 = 285;
  EF_ACCELERATION2 = 286;
  EF_ACCELERATION3 = 287;
  EF_IMPACT1 = 288;
  EF_IMPACT2 = 289;
  EF_IMPACT3 = 290;
  EF_LEGION_PER_EXP = 291;
  EF_LEGION_RATE_EXP = 292;
  EF_LEGION_BONUS_EXP = 293;
  EF_HONOR_PLUS = 294;
  EF_RVR_EXP = 295;
  EF_LEGION_DOT_PER_HPCURE = 296;
  EF_LEGION_DOT_PER_MPCURE = 297;
  EF_LEGION_DOT_TIMER = 298;
  EF_LEGION_MEMBER_HP = 299;
  EF_LEGION_MEMBER_LIMITEHP = 300;
  EF_LEGION_MEMBER_MP = 301;
  EF_LEGION_EXPLOITPOINT = 302;
  EF_LEGION_DECREASE = 303;
  EF_SWAP_AGGRO = 304;
  EF_MANABURN = 305;
  EF_REDUCE_CRITICAL_DAMAGE = 306;
  EF_PARTY_PER_DAMAGE6 = 307;
  EF_LEGION_MEMBER_LIMITEMP = 308;
  EF_HP_BASE_DAMAGE = 309;
  EF_IMMUNITY_AFFECT = 310;
  EF_KILLING_RESTORE_HP = 311;
  EF_KILLING_RESTORE_MP = 312;
  EF_INSTANT_DEATH0 = 313;
  EF_INSTANT_DEATH5 = 314;
  EF_HP_MARK = 315;
  EF_MP_MARK = 316;
  EF_DECREASE_HP_DAMAGE = 317;
  EF_DECREASE_HP_DAMAGE_LIMIT = 318;
  EF_DECREASE_PER_DAMAGE1 = 319;
  EF_DECREASE_PER_DAMAGE2 = 320;
  EF_CREATE_ITEM = 321;
  EF_DECREASE_PER_HP = 322;
  EF_DECREASE_PER_MP = 323;
  EF_DECREASE_PER_RESISTANCE1 = 324;
  EF_DECREASE_PER_RESISTANCE2 = 325;
  EF_DOUBLE_DAMAGE_PC = 326;
  EF_LEOPOLD_ATK_NATION = 327;
  EF_LEOPOLD_DEF_NATION = 328;
  EF_DEBUFF_ADD_DAMAGE = 329;
  EF_INITCOOLTIME_AGGRESSIVE = 330;
  EF_SILENCE_CURE = 331;
  EF_SKILL_SELFSKILL = 332;
  EF_CLEAR_DAMAGE = 333;
  EF_VISUAL_EFFECT_LINK = 334;
  EF_MONSTER_SUMMON = 335;
  EF_QUESTEXP_UP = 336;
  EF_FISHING = 337;
  EF_PRAN_EXP_UP = 338;
  EF_IM_SLEEP = 339;
  EF_ABSOLUTE_ZERO = 340;
  EF_PRAN_DOUBLE = 341;
  EF_CHECK_HP_DAMAGE = 342;
  EF_FILTER_HP_DAMAGE = 343;
  EF_ATK_BOSS = 344;
  EF_DEF_BOSS = 345;
  EF_SKILL_DOT_DAMAGE1 = 346;
  EF_SKILL_DOTA_DAMAGE1 = 347;
  EF_SKILL_DOTB_DAMAGE1 = 348;
  EF_SKILL_DOTC_DAMAGE1 = 349;
  EF_SKILL_DOTD_DAMAGE1 = 350;
  EF_SKILL_DOT_DAMAGE2 = 351;
  EF_SKILL_DOTA_DAMAGE2 = 352;
  EF_SKILL_DOTB_DAMAGE2 = 353;
  EF_SKILL_DOTC_DAMAGE2 = 354;
  EF_SKILL_DOTD_DAMAGE2 = 355;
  EF_BODYSCALE = 356;
  EF_BLOOD_SPEND = 357;
  EF_DECEIVE_ATK = 358;
  EF_DECEIVE_DEF = 359;
  EF_MP_BASE_DAMAGE = 360;
  /// ///////
  EF_PER_CURE_PREPARE = 361;
  EF_PER_CURE_ACTIVATE = 362;
  EF_PREMIUM_PER_EXP2 = 363;
  EF_ART_PER_HP = 364;
  EF_ART_HP_PER_DAMAGE1 = 365;
  EF_ART_SKILL_PER_REDUCE = 366;
  EF_ART_RES1_PER_DAMAGE1 = 367;
  EF_ART_DD_SKILL_PER_HEAL = 368;
  EF_ART_AOE_PER_AMP = 369;
  EF_ART_CRITICAL_PER_DOUBLE = 370;
  EF_ART_DEX_TO_DAMAGE1 = 371;
  EF_ART_PER_MP = 372;
  EF_ART_MP_PER_DAMAGE2 = 373;
  EF_ART_MP_PER_SDAMAGE6 = 374;
  EF_ART_INT_TO_DAMAGE2 = 375;
  EF_CONSERVATION_HONOR_POINT = 376;
  EF_PER_RESISTANCE11 = 377;
  EF_PER_DAMAGE11 = 378;
  EF_PER_HP_MP = 379;
  EF_STR_DEX_INT = 380;
  EF_CRITICAL_DROP = 381;
  EF_STANCE_LIMIT = 382;
  EF_TARGETHP_PER_DAMAGE = 383;
  EF_REFLECTION5 = 384;
  EF_REFLECTION6 = 385;
  EF_DUNGEON_BOSS_PER_DROP_RATE = 386;
  EF_MULTIPLE_EXP4 = 387;
  EF_SUMMONGEN = 388;
  EF_PER_HONOR_POINT = 389;
  EF_MENTOR_GUILD = 390;
  EF_REVIVE = 391;
  EF_REVIVEPLUS = 392;
  EF_FEARPLUS = 393;
  EF_DUNGEON_ON = 394;
  EF_HP_ATK_RES = 395;
{$ENDREGION}
{$REGION 'ExpList'}
const
  ExpList1: Array [0 .. 91] of Comp = (0, 200, 538, 1171, 2294, 4142, 6992,
    11164, 17025, 24988, 35514, 49114, 66350, 87839, 114252, 146316, 184816,
    230596, 284563, 347686, 420998, 505598, 602652, 713397, 839140, 981260,
    1141210, 1320518, 1520791, 1743714, 1991052, 2264652, 2566444, 2898445,
    3262758, 3661574, 4097174, 4571930, 5088309, 5648872, 6256276, 6913276,
    7622726, 8387583, 9210906, 10095858, 11045708, 12063832, 13153717, 14318960,
    19427014, 22772422, 26441542, 30726982, 35642566, 41202118, 47419462,
    54607942, 62788294, 71674822, 87169222, 93096262, 99704710, 107010694,
    115647238, 125646598, 138053868, 152927110, 170064723, 189649760, 214930400,
    267008518, 330462924, 407568876, 504140921, 644954086, 754105971, 875837696,
    1010149261, 1157040666, 1347961511, 1679989393, 2045220063, 2446973800,
    2888902911, 3375024933, 4128514067, 4889538092, 5658172357, 6434492964,
    7218576777, 8010501428);
const
  GuildExpList: Array [0..9] of Comp = (0, 22000, 64750, 156500, 496000, 1066400,
    3199200, 6398400, 10664000, 15996000);
{$ENDREGION}
{$REGION 'ItemType'}
  ITEM_TYPE_FACE = 0;
  ITEM_TYPE_HAIR = 1;
  ITEM_TYPE_HEAD = 2;
  ITEM_TYPE_ARMOR = 3;
  ITEM_TYPE_GLOVES = 4;
  ITEM_TYPE_SHOES = 5;
  ITEM_TYPE_PRAN_FOOD = 26;
  ITEM_TYPE_HPMP_LAGRIMAS = 29;
  ITEM_TYPE_PRAN_DIGEST = 230;
  ITEM_TYPE_CITY_SCROLL = 202;
  ITEM_TYPE_LOC_SCROLL = 204;
  ITEM_TYPE_RECIPE = 205;
  ITEM_TYPE_SCROLL_PORTAL = 208;
  ITEM_TYPE_BAG_INV = 217;
  ITEM_TYPE_BAG_STORAGE = 218;
  ITEM_TYPE_BAG_PRAN = 219;
  ITEM_TYPE_SHOP_OPEN = 224;
  ITEM_TYPE_STORAGE_OPEN = 226;
  ITEM_TYPE_USE_GOLD_COIN = 234;
  ITEM_TYPE_USE_CASH_COIN = 239;
  ITEM_TYPE_USE_RICH_GOLD_COIN = 717;
  ITEM_TYPE_SET_ACCOUNT_NATION = 300;
  ITEM_TYPE_ADD_EXP_PERC = 404;
  ITEM_TYPE_HP_POTION = 700;
  ITEM_TYPE_MP_POTION = 701;
  ITEM_TYPE_POTION_BUFF = 702;
  ITEM_TYPE_USE_TO_UP_LVL = 704;
  ITEM_TYPE_RANDOM_BAU = 705;
  ITEM_TYPE_BAU = 714;
  ITEM_TYPE_BUFF = 715;
  ITEM_TYPE_BUFF2 = 716;
  ITEM_TYPE_HPMP_POTION = 800;
{$ENDREGION}
{$REGION 'Type Item'}
  TYPE_ITEM_NORMAL = 0;
  TYPE_ITEM_RARE_SUPERIOR = 1;
  TYPE_ITEM_RARO = 3;
  TYPE_ITEM_SUPERIOR = 5;
  TYPE_ITEM_LEGENDARY = 6;
  TYPE_ITEM_PREMIUM = 7;
{$ENDREGION}
{$REGION 'Type Trade Items'}
  TRADE_TYPE_YES = 0;
  TRADE_TYPE_NO = 1;
  TRADE_TYPE_REVERTIDA = 2;
{$ENDREGION}
{$REGION 'Single Skills Indexers'}
  // [WAR]
  ATAQUE_PODEROSO = 1;
  AVANCO_PODEROSO = 2;
  QUEBRAR_ARMADURA = 3;
  INCITAR = 4;
  RESOLUTO = 8;
  ESTOCADA = 15;
  FERIDA_MORTAL = 17;
  PANCADA = 336;
  // [TEMPLAR]
  STIGMA = 300;
  PROFICIENCIA = 25;
  NEMESIS = 27;
  TRAVAR_ALVO = 31;
  ATRACAO_DIVINA = 148;
  CARGA_DIVINA = 362;
  // [RIFLEMAN]
  ELIMINACAO = 67;
  TIRO_FATAL = 50;
  TIRO_ANGULAR = 51;
  TIRO_NA_PERNA = 52;
  PERSEGUIDOR = 55;
  PRIMEIRO_ENCONTRO = 60;
  ELIMINAR_ALVO = 61;
  PONTO_VITAL = 63;
  MARCA_PERSEGUIDOR = 64;
  CONTRA_GOLPE = 66;
  ATAQUE_ATORDOANTE = 151;
  INSPIRAR_MATANCA = 384;
  SENTENCA = 385;
  POSTURA_FANTASMA = 386;
  DESTINO = 344;
  // [DUALGUNNER]
  MJOLNIR = 73;
  ESPINHO_VENENOSO = 74;
  TIRO_DESCONTROLADO = 78;
  VENENO_LENTIDAO = 79;
  REQUIEM = 80;
  VENENO_MANA = 84;
  CHOQUE_SUBITO = 86;
  NEGAR_CURA = 88;
  ESTRIPADOR = 90;
  VENENO_HIDRA = 154;
  CHOQUE_HIDRA = 94;
  DOR_PREDADOR = 408;
  MORTE_DECIDIDA = 409;
  REACAO_CADEIA = 410;
  BOMBA_MALDITA = 345;
  // [MAGICIAN]
  CHAMA_CAOTICA = 97;
  SOFRIMENTO = 250;
  POLIMORFO = 99;
  ONDA_CHOQUE = 100;
  IMPEDIMENTO = 103;
  CORROER = 104;
  LANCA_RAIO = 225;
  MAO_ESCURIDAO = 226;
  VINCULO = 157;
  CRISTALIZAR_MANA = 435;
  // [CLERIC]
  FLECHA_SAGRADA = 121;
  RESSUREICAO = 126;
  RETORNO_MAGICA = 136;
{$ENDREGION}
{$REGION 'Area Skills Indexers'}
  // WARRIOR
  TEMPESTADE_LAMINA = 6;
  AREA_IMPACTO = 12;
  CANCAO_GUERRA = 13;
  SALTO_IMPACTO = 18;
  GRITO_MEDO = 145;
  LAMINA_CARREGADA = 147;
  INVESTIDA_MORTAL = 22;
  PODER_ABSOLUTO = 340;
  LIMITE_BRUTAL = 341;
  POSTURA_FINAL = 342;
  // TEMPLAR
  INCITAR_MULTIDAO = 28;
  EMISSAO_DIVINA = 37;
  SANTUARIO = 46;
  LAMINA_PROMESSA = 150;
  CRUZ_JULGAMENTO = 360;
  ESCUDO_VINGADOR = 343;
  // RIFLEMAN
  CONTAGEM_REGRESSIVA = 49;
  TIRO_ANGULAR_AREA = 51;
  DETONACAO = 59;
  RAJADA_SONICA = 62;
  DEMOLICAO_X14 = 65;
  GOLPE_FANTASMA = 192;
  NAPALM = 387;
  ARMADILHA_MULTIPLA = 388;
  // DUAL GUNNER
  FUMACA_SANGRENTA = 85;
  EXPLOSAO_RADIANTE = 87;
  DISPARO_DEMOLIDOR = 216;
  PONTO_CEGO = 411;
  FESTIVAL_BALAS = 413;
  // DARK MAGICIAN
  INFERNO_CAOTICO = 102;
  ENXAME_ESCURIDAO = 107;
  ECLATER = 108;
  ESPLENDOR_CAOTICO = 110;
  BRUMA = 111;
  QUEDA_NEGRA = 114;
  PECADOS_MORTAIS = 159;
  PROEMINECIA = 118;
  TEMPESTADE_RAIOS = 166;
  EXPLOSAO_TREVAS = 433;
  TROVAO_RUINOSO = 434;
  TEMPESTADE = 436;
  FURACAO_NEGRO = 437;
  PORTAO_ABISSAL = 346;
  // CLERIC
  SENSOR_MAGICO = 139;
  RAIO_SOLAR = 133;
  UEGENES_LUX = 132;
  CRUZ_PENITENCIAL = 456;
  EDEN_PIEDOSO = 461;
  DIXIT = 347;
{$ENDREGION}
{$REGION 'Quest Consts'}
  QuestKillMob = 1; // Requirement
  QuestItem = 2; // Requirement - Requisite - Reward - Remove - Choice - Misc
  QuestLevelRange = 4; // Requisite
  QuestClass = 5; // Requisite
  QuestExperienceGuild = 7; // Reward
  QuestRequire = 9; // Requisite
  QuestItemChoice = 13; // Reward
  QuestExperience = 14; // Requirement - Reward
  QuestGold = 15; // Requirement - Reward - Remove
  QuestClassChange = 16; // Reward
  QuestTalkTo = 19; // Requirement
  QuestPran = 21; // Reward
  QuestUse = 31; // Requirement
  QuestEquip = 34; // Requirement
  QuestMissionChoice = 37; // Choice
  QuestComeFrom = 38; // Choice
  QuestAfterMission = 48; // Requisite
  QuestBattleFieldVictory = 51; // Requirement
  QuestSkillAcquire = 62; // Reward
  QuestTitleAcquire = 63; // Reward
  QuestCash = 64; // require
  QuestWarrior = 2;
  QuestPaladin = 4;
  QuestDualGunner = 8;
  QuestRifleman = 16;
  QuestWarlock = 32;
  QuestCleric = 64;
  QuestNotAvailable = 0;
  QuestAvailable = 1;
  QuestOnProgress = 2;
  QuestCompleted = 3;
  QuestGotReward = 4;
  QuestDefault = 0;
  QuestReset = 1;
  QuestStartGreen = 2; // quests fora do enredo
  QuestOngoing = 3;
  QuestDone = 4;
  QuestSaveLocation = 5;
  QuestNotEnoughLevel = 7; // aquela quest branca
  QuestStartRed = 8; // quests de enredo
  QuestStartBlue = 9; // quests que podem se repetir
  QuestStartYellow = 11; // quests diarias
{$ENDREGION}
{$REGION 'Pran Consts'}
  { Item Pran State }
  PRAN_NORMAL_STATE = 0;
  PRAN_FAIRY_STATE = 1;
  PRAN_FIRE_STATE = 2;
  PRAN_WATER_STATE = 3;
  PRAN_AIR_STATE = 4;
{$ENDREGION}
implementation
initialization
ChangeChannelList := TDictionary<DWORD, TChangeChannelToken>.Create;
ChangeChannelList.Clear;
end.
