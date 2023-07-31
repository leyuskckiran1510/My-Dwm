/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "MesloLGM Nerd Font:style=Regular:size=11","monospace:size=11","Noto Color Emoji:style=Regular:pixelsize=11:antialias=true:autohint=true","Noto Emoji:style=Regular:pixelsize=11:antialias=true:autohint=true"};
static const char dmenufont[]       = "MesloLGM Nerd Font:style=Regular:size=11";
static const char norm_fg[] = "#f0bc92";
static const char norm_bg[] = "#070d16";
static const char norm_border[] = "#3dff00";
static const char sel_fg[] = "#f0bc92";
static const char sel_bg[] = "#182c4b";
static const char sel_border[] = "#cfcfcf";
static const char urg_fg[] = "#8dced7";
static const char urg_bg[] = "#565F63";
static const char urg_border[] = "#565F63";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};

// #include "/home/tester/.cache/wal/colors-wal-dwm.h"

/* tagging */				//Browsing0       Coding1   files2     terminal3   hacking/ctfs4  
static const char *tags[] = { " \ue745 ", " \uf109 " , " \uf07b ", " \uf489 ", " \uf09c "," \ue23f ", " 📺 " };
//                                                                                          private5     vlc/video/audios6
static const Rule rules[] = {
	// xprop | awk '
    //     /^WM_CLASS/{sub(/.* =/, "instance:"); sub(/,/, "\nclass:"); print}
    //     /^WM_NAME/{sub(/.* =/, "title:"); print}'

	/* class             instance          title                      tags mask     isfloating   monitor */
	{ "firefox",         NULL,             NULL,                      1,       		0,           -1 },
	{ "Brave-browser",  "brave-browser",  "New Tab - Brave",          1,            1,           -1 },
	{ "Brave-browser",  "brave-browser",  "New Private Tab - Brave",  1<<5,         0,           -1 },
	{ "Sublime_text",   "sublime_text",    NULL,                      1<<1,         1,           -1 },
	{"Org.gnome.Nautilus","org.gnome.Nautilus", NULL,                 1<<2,         0,           -1 },
	{"Nemo",			  "nemo",          NULL,                      1<<2,         0,           -1 },
	{"vlc",               "vlc",           NULL,                      1<<6,         0,           -1 },
	{"Insomnia",        "insomnia",        NULL,                      1<<4,         0,           -1 },
	{"St",              "st",              "terminal",                1<<3,         0,           -1 },
	{"XClock",          "xclock",			NULL,				      127, 			1 , 		 -1 },
	{"Upwork",           NULL,				NULL,                     1<<3,         0,           -1 },

};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[][+]",      tile },    /* first entry is default */
	{ "|<>-|",      NULL },    /* no layout function means floating behavior */
	{ "[[]]]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */ 
static const char *dmenucmd[] = { "dmenu_run", "-fn", dmenufont, "-nb", norm_bg, "-nf", norm_fg, "-sb", sel_bg, "-sf", sel_fg, NULL };
static const char *termcmd[]  = { "st","-t","terminal", NULL };
static const char *brave[] = {"brave-browser",NULL};
static const char *fileexp[] = {"nautilus",NULL};
//static const char *screenshot[] = {"gnome-screenshot","--interactive",NULL};
static const char *clipboard[] = {"copyq","toggle",NULL};


static const char *transparency_dec[] = {"picom-trans","-co","-5",NULL};
static const char *transparency_inc[] = {"picom-trans","-co","+5",NULL};

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ Mod4Mask,                     XK_a,      spawn,          {.v = dmenucmd } },
	{ Mod4Mask,                     		0,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ControlMask,           XK_t, 	   spawn,          {.v = termcmd } },
	{ MODKEY|ControlMask,           XK_w, 	   spawn,          {.v = brave } },
	{ Mod4Mask,           			XK_e, 	   spawn,          {.v = fileexp } },
	//{ Mod4Mask|ShiftMask,     		XK_s, 	   spawn,          {.v = screenshot } },
	
	{ Mod4Mask,     				XK_c, 	   spawn,          {.v = clipboard } },

	
	
	{ MODKEY,			            XK_z, 	   spawn,          {.v = transparency_inc } },
	{ MODKEY|ControlMask,          	XK_z, 	   spawn,          {.v = transparency_dec } },


	{ Mod4Mask|ShiftMask,     		XK_s, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/scrsht", NULL } }},
	{ MODKEY|ControlMask,          	XK_b, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/bgchange", NULL } }},
	{ Mod4Mask,          	        XK_period,  spawn,         {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/emoji_chooser.bash", NULL } }},
	{ MODKEY|ControlMask,          	XK_s, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/allscript", NULL } }},

	// Volume
	{ MODKEY|ControlMask,          	XK_Down, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/change vdown",NULL } }},
	{ MODKEY|ControlMask,          	XK_Up, 	       spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/change vup",NULL } }},

	// brigtness
	{ MODKEY|ControlMask,          	XK_Right, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/change bup",NULL } }},
	{ MODKEY|ControlMask,          	XK_Left, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/change bdown",NULL } }},

	// ScreenRecording .. 
	{ MODKEY|ControlMask,          	XK_r, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/screenrec",NULL } }},

	// AudioRecording .. 
	{ MODKEY|ControlMask,          	XK_v, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/voicerec",NULL } }},
	
	//Audio Handler
	//mute/unmute
	{ MODKEY|ControlMask,          	XK_l, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/audioch m",NULL } }},
	//Audio Port/Device Selection
	{ MODKEY|ControlMask,          	XK_p, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/audioch p",NULL } }},
	//Audio Channel/Profiles Selection
	{ MODKEY|ControlMask,          	XK_c, 	   spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/audioch c",NULL } }},


	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },

	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },

	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ Mod4Mask,                     XK_Tab,    view,           {0} },

	{ Mod4Mask|ShiftMask,           XK_Tab,    rotateview,           {.i = +1} },
	{ Mod4Mask|ControlMask,         XK_Tab,    rotateview,           {.i = -1} },

	{ MODKEY,                       XK_Tab,    focusstack,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_Tab,    focusstack,     {.i = -1 } },

	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },


	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,             XK_m,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ControlMask,           XK_m,      setlayout,      {.v = &layouts[2]} },

	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },


	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkStatusText,        ControlMask,    Button1,        spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","~/scripts/wifiselect", NULL } }},
	{ ClkStatusText,        ShiftMask,      Button1,        spawn,          {.v = (const char*[]){ "/usr/bin/bash", "-c","gnome-system-monitor", NULL } }},
	{ ClkClientWin,         Mod4Mask,       Button1,        movemouse,      {0} },
	{ ClkClientWin,         Mod4Mask,       Button2,        togglefloating, {0} },
	{ ClkClientWin,         Mod4Mask,       Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

