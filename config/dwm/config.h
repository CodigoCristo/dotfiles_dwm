/* dwm config.h — versión final, adaptada desde i3 config
 * Incluye: movestack, fullscreen real, scratchpad
 * MOD = tecla Windows (Mod4Mask), igual que tu $mod en i3
 */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx = 3; 
static const unsigned int cornerrad = 6; /* radio de las esquinas */
static const unsigned int gappih = 12; /* gap horizontal interno entre ventanas */
static const unsigned int gappiv = 12; /* gap vertical interno entre ventanas */
static const unsigned int gappoh = 12; /* gap horizontal externo (borde de pantalla) */
static const unsigned int gappov = 12; /* gap vertical externo (borde de pantalla) */
static const int smartgaps = 1;        /* si solo hay 1 ventana, quita el gap externo */

static const unsigned int barpadv	= 50;		/* bar vertical padding (from top)*/
static const unsigned int barpadh	= 20;		/* bar vertical padding (from top)*/
static const unsigned int barheight	= 10;		/* bar vertical padding (from top)*/
static const unsigned int barborder	= 10;		/* bar vertical padding (from top)*/
static const unsigned int floatbar	= 1;		/* 0 means bar won't float; float or dock the bar */
static const unsigned int snap      = 32;
static const int showbar            = 1;
static const unsigned int systraypinning = 0;   /* 0: seguir el monitor con foco */
static const unsigned int systrayonleft  = 0;   /* 0: a la derecha de la barra */
static const unsigned int systrayspacing = 4;   /* píxeles entre iconos */
static const int systraypinningfailfirst = 1;
static const int showsystray             = 1;
static const int topbar             = 1;
static const char *fonts[]          = { "JetBrainsMono Nerd Font Mono:size=11" };
static const char dmenufont[]       = "JetBrainsMono Nerd Font Mono:size=11";
/* colores tomados de tu i3 config (cian #1793d1, fondo #0d1117) */
static const char col_bg[]          = "#0d1117";
static const char col_border[]      = "#4a5568";
static const char col_fg[]          = "#ffffff";
static const char col_cyan[]        = "#1793d1";
static const char col_urgent[]      = "#e53e3e";


static const char *colors[][3]      = {
	/*               fg        bg        border   */
	[SchemeNorm] = { col_fg,   col_bg,   col_border },
	[SchemeSel]  = { col_fg,   col_cyan, col_cyan   },
};

/* tags — equivalentes a tus workspaces 1-9 */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

/* scratchpad — terminal flotante tipo i3, Mod+` */
static const unsigned int refreshrate = 60;
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "alacritty", "-t", scratchpadname, "-o", "window.dimensions.columns=120", "-o", "window.dimensions.lines=34", NULL };

/* reglas de ventanas — equivalentes a tus "for_window" de i3 */
static const Rule rules[] = {
	/* class          instance    title             tags mask   isfloating   monitor */
	{ "Rofi",         NULL,       NULL,             0,           1,          -1 },
	{ "MPlayer",      NULL,       NULL,             0,           1,          -1 },
	{ "Gimp",         NULL,       NULL,             0,           1,          -1 },
	{ "DockApp",   "wmsystemtray", NULL,  ~0,  1,  -1 },
	{ "Steam",        NULL,       NULL,             0,           1,          -1 },
	{ "Pavucontrol",  NULL,       NULL,             0,           1,          -1 },
	{ "Arandr",       NULL,       NULL,             0,           1,          -1 },
	{ NULL,           NULL,       scratchpadname,   0,           1,          -1 },
};

/* layout(s) */
static const float floatcenterwfact = 0.4;  /* ancho del flotante al centrar */
static const float floatcenterhfact = 0.4;  /* alto del flotante al centrar */
#include "togglefloatcenter.c"
#include "dragmfact.c"
static const float mfact     = 0.55;
static const int nmaster     = 1;
static const int resizehints = 1;
static const int lockfullscreen = 1;

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },
	{ "><>",      NULL },
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* comandos */
static const char *termcmd[]     = { "st", NULL };
static const char *rofidrun[] = { "/bin/sh", "-c", "rofi -show apps -modi \"apps:$HOME/.config/rofi/scripts/apps.sh,run\"", NULL };
// rofi -show apps -modi "apps:$HOME/.config/rofi/scripts/apps.sh,run"
static const char *browsercmd[]  = { "firefox", NULL };
static const char *filemgrcmd[]  = { "pcmanfm", NULL };
static const char *xkillcmd[]    = { "xkill", NULL };
//static const char *powermenucmd[]= { "/home/cristo/.config/dwm/powermenu.sh", NULL };
static const char *powermenucmd[] = { "/bin/sh", "-c", "$HOME/.config/rofi/scripts/powermenu.sh", NULL };
static char dmenumon[2] = "0"; /* dwm.c la necesita internamente, aunque uses rofi */
static const char *dmenucmd[] = { "rofi", "-show", "drun", "-modi", "drun,run,window", NULL };

#include "movestack.c"
static const Key keys[] = {
	/* modifier                 key             function        argument */

	/* ── Aplicaciones básicas ────────────────────────────────────── */
	{ MODKEY,                   XK_Return,      spawn,          {.v = termcmd } },       /* Mod+Enter → terminal */
	{ MODKEY,                   XK_d,           spawn,          {.v = rofidrun } },      /* Mod+D → rofi */
	{ MODKEY,                   XK_w,           spawn,          {.v = browsercmd } },    /* Mod+W → firefox */
	{ MODKEY,                   XK_e,           spawn,          {.v = filemgrcmd } },    /* Mod+E → pcmanfm */
	{ MODKEY,                   XK_x,           spawn,          {.v = xkillcmd } },      /* Mod+X → xkill */
	{ MODKEY|ShiftMask,         XK_p,           spawn,          {.v = powermenucmd } },  /* Mod+Shift+P → powermenu */
	{ MODKEY,                   XK_grave,       togglescratch,  {.v = scratchpadcmd } }, /* Mod+` → terminal scratchpad */

	/* ── Control de ventanas ─────────────────────────────────────── */
	{ MODKEY,                   XK_q,           killclient,     {0} },                   /* Mod+Q → cerrar ventana */
	{ MODKEY|ControlMask,       XK_q,           quit,           {0} },                   /* Mod+Ctrl+Q → salir de dwm */
	{ MODKEY,                   XK_f,           togglefloatcenter, {0} },        /* Mod+F → flotante, pequeño y centrado */ 
	{ MODKEY|ShiftMask,         XK_f,           togglefullscr,  {0} },                   /* Mod+Shift+F → fullscreen real */
	{ MODKEY,                   XK_b,           togglebar,      {0} },                   /* Mod+B → mostrar/ocultar barra */

	/* ── Navegación (foco por orden de pila) ─────────────────────── */
	{ MODKEY,                   XK_j,           focusstack,     {.i = +1 } },            /* Mod+J → foco siguiente */
	{ MODKEY,                   XK_k,           focusstack,     {.i = -1 } },            /* Mod+K → foco anterior */
	{ MODKEY,                   XK_Tab,         view,           {0} },                   /* Mod+Tab → tag anterior */

	/* ── Mover ventanas en la pila (movestack) ──────────────────────── */
	{ MODKEY|ShiftMask,         XK_j,           movestack,      {.i = +1 } },            /* Mod+Shift+J → mover abajo */
	{ MODKEY|ShiftMask,         XK_k,           movestack,      {.i = -1 } },            /* Mod+Shift+K → mover arriba */
	{ MODKEY|ShiftMask,         XK_Return,      zoom,           {0} },                   /* Mod+Shift+Enter → mover a master */

	/* ── Layouts ──────────────────────────────────────────────────── */
	{ MODKEY,                   XK_space,       setlayout,      {0} },                   /* Mod+Space → alternar layout */
	{ MODKEY|ShiftMask,         XK_e,           setlayout,      {.v = &layouts[0]} },    /* Mod+Shift+E → reset a tile */
	{ MODKEY,                   XK_v,           setlayout,      {.v = &layouts[0]} },    /* Mod+V → forzar tile */
	{ MODKEY,                   XK_m,           setlayout,      {.v = &layouts[2]} },    /* Mod+M → monocle */

	/* ── Redimensionar (mfact / nmaster) ────────────────────────────── */
	{ MODKEY,                   XK_h,           setmfact,       {.f = -0.05} },          /* Mod+H → encoger master */
	{ MODKEY,                   XK_l,           setmfact,       {.f = +0.05} },          /* Mod+L → expandir master */
	{ MODKEY,                   XK_comma,       incnmaster,     {.i = +1 } },            /* Mod+, → +1 ventana en master */
	{ MODKEY,                   XK_period,      incnmaster,     {.i = -1 } },            /* Mod+. → -1 ventana en master */

	/* ── Workspaces (tags 1-9) ─────────────────────────────────────── */
	TAGKEYS(                    XK_1,                           0)
	TAGKEYS(                    XK_2,                           1)
	TAGKEYS(                    XK_3,                           2)
	TAGKEYS(                    XK_4,                           3)
	TAGKEYS(                    XK_5,                           4)
	TAGKEYS(                    XK_6,                           5)
	TAGKEYS(                    XK_7,                           6)
	TAGKEYS(                    XK_8,                           7)
	TAGKEYS(                    XK_9,                           8)

	/* ── Multimedia ──────────────────────────────────────────────── */
	{ 0, XF86XK_AudioRaiseVolume,  spawn, SHCMD("pactl set-sink-volume @DEFAULT_SINK@ +5%") },
	{ 0, XF86XK_AudioLowerVolume,  spawn, SHCMD("pactl set-sink-volume @DEFAULT_SINK@ -5%") },
	{ 0, XF86XK_AudioMute,         spawn, SHCMD("pactl set-sink-mute @DEFAULT_SINK@ toggle") },
	{ 0, XF86XK_AudioMicMute,      spawn, SHCMD("pactl set-source-mute @DEFAULT_SOURCE@ toggle") },
	{ 0, XF86XK_MonBrightnessUp,   spawn, SHCMD("brightnessctl set +10%") },
	{ 0, XF86XK_MonBrightnessDown, spawn, SHCMD("brightnessctl set 10%-") },

	/* ── Capturas de pantalla (requiere maim + xdotool) ──────────────── */
	{ 0,                         XK_Print,       spawn, SHCMD("mkdir -p ~/'Capturas de pantalla' && FILE=~/'Capturas de pantalla'/captura_$(date +%Y%m%d_%H%M%S).png && maim --hidecursor -s --nokeyboard \"$FILE\" && notify-send 'Captura tomada' \"$FILE\" -i accessories-screenshot") },
	{ MODKEY,                    XK_Print,       spawn, SHCMD("mkdir -p ~/'Capturas de pantalla' && FILE=~/'Capturas de pantalla'/captura_$(date +%Y%m%d_%H%M%S).png && maim --hidecursor \"$FILE\" && notify-send 'Captura tomada' \"$FILE\" -i accessories-screenshot") },
	{ MODKEY|ShiftMask,          XK_Print,       spawn, SHCMD("mkdir -p ~/'Capturas de pantalla' && FILE=~/'Capturas de pantalla'/captura_$(date +%Y%m%d_%H%M%S).png && maim --hidecursor -i $(xdotool getactivewindow) \"$FILE\" && notify-send 'Captura tomada' \"$FILE\" -i accessories-screenshot") },

};

/* button definitions */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },   /* Mod+clic izq → mover flotante */
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },   /* Mod+clic rueda → toggle flotante */
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },   /* Mod+clic der → redimensionar (esquinas) */
	{ ClkClientWin,         MODKEY|ShiftMask, Button1,      dragmfact,      {0} },   /* Mod+Shift+clic izq → arrastrar para redimensionar (mfact) */
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
