module sdl2.c.types;
import core.stdc.config;

enum SDLInit 
{ 	
	TIMER = 0x_0000_0001, 
	AUDIO = 0x_0000_0010, 
	VIDEO = 0x_0000_0020, 
	JOYSTICK = 0x_0000_0200,
	HAPTIC = 0x_0000_1000,  
	GAMECONTROLLER = 0x_0000_2000, 
	EVENTS = 0x_0000_4000,  
	NOPARASCHUTE = 0x_0010_0000,
	EVERYTHING = TIMER | AUDIO | VIDEO | EVENTS | JOYSTICK | HAPTIC | GAMECONTROLLER 
}

enum SDL_AssertState
{
    RETRY = 0,
    BREAK = 1,
    ABORT = 2,
    IGNORE = 3,
    ALWAYS_IGNORE = 4,
}

struct SDL_AssertData
{
    int always_ignore;
    uint trigger_count;
    const(char)* condition;
    const(char)* filename;
    int linenum;
    const(char)* function_;
    const(SDL_AssertData)* next;
}

alias SDL_AssertionHandler = SDL_AssertState function(const(SDL_AssertData)*, void*);

alias SDL_Spinlock = int;

struct SDL_atomic_t
{
    int value;
}

alias SDL_AudioCallback = void function(void*, ubyte*, int);
struct SDL_AudioSpec
{
    int freq;
    ushort format;
    ubyte channels;
    ubyte silence;
    ushort samples;
    ushort padding;
    uint size;
    void function(void*, ubyte*, int) callback;
    void* userdata;
}
struct SDL_AudioCVT
{
align(1):
    int needed;
    ushort src_format;
    ushort dst_format;
    double rate_incr;
    ubyte* buf;
    int len;
    int len_cvt;
    int len_mult;
    double len_ratio;
    void function(SDL_AudioCVT*, ushort)[10] filters;
    int filter_index;
}
alias SDL_AudioDeviceID = uint;
alias SDL_AudioFilter = void function(SDL_AudioCVT*, ushort);

enum SDL_AudioStatus
{ 
    STOPPED = 0,
    PLAYING = 1,
    PAUSED = 2,
}


enum SDL_BlendMode
{
    NONE = 0,
    BLEND = 1,
    ADD = 2,
    MOD = 4,
    INVALID = 2147483647,
}

enum SDL_BlendOperation
{
    ADD = 1,
    SUBTRACT = 2,
    REV_SUBTRACT = 3,
    MINIMUM = 4,
    MAXIMUM = 5,
}

enum  SDL_BlendFactor
{
    ZERO = 1,
    ONE = 2,
    SRC_COLOR = 3,
    ONE_MINUS_SRC_COLOR = 4,
    SRC_ALPHA = 5,
    ONE_MINUS_SRC_ALPHA = 6,
    DST_COLOR = 7,
    ONE_MINUS_DST_COLOR = 8,
    DST_ALPHA = 9,
    ONE_MINUS_DST_ALPHA = 10,
}

enum SDL_errorcode 
{
   ENOMEM = 0,
   EFREAD = 1,
   EFWRITE = 2,
   EFSEEK = 3,
   UNSUPPORTED = 4,
   LASTERROR = 5,
}

enum SDL_EventType
{
    FIRSTEVENT = 0,
    QUIT = 256,
    APP_TERMINATING = 257,
    APP_LOWMEMORY = 258,
    APP_WILLENTERBACKGROUND = 259,
    APP_DIDENTERBACKGROUND = 260,
    APP_WILLENTERFOREGROUND = 261,
    APP_DIDENTERFOREGROUND = 262,
    DISPLAYEVENT = 336,
    WINDOWEVENT = 512,
    SYSWMEVENT = 513,
    KEYDOWN = 768,
    KEYUP = 769,
    TEXTEDITING = 770,
    TEXTINPUT = 771,
    KEYMAPCHANGED = 772,
    MOUSEMOTION = 1024,
    MOUSEBUTTONDOWN = 1025,
    MOUSEBUTTONUP = 1026,
    MOUSEWHEEL = 1027,
    JOYAXISMOTION = 1536,
    JOYBALLMOTION = 1537,
    JOYHATMOTION = 1538,
    JOYBUTTONDOWN = 1539,
    JOYBUTTONUP = 1540,
    JOYDEVICEADDED = 1541,
    JOYDEVICEREMOVED = 1542,
    CONTROLLERAXISMOTION = 1616,
    CONTROLLERBUTTONDOWN = 1617,
    CONTROLLERBUTTONUP = 1618,
    CONTROLLERDEVICEADDED = 1619,
    CONTROLLERDEVICEREMOVED = 1620,
    CONTROLLERDEVICEREMAPPED = 1621,
    FINGERDOWN = 1792,
    FINGERUP = 1793,
    FINGERMOTION = 1794,
    DOLLARGESTURE = 2048,
    DOLLARRECORD = 2049,
    MULTIGESTURE = 2050,
    CLIPBOARDUPDATE = 2304,
    DROPFILE = 4096,
    DROPTEXT = 4097,
    DROPBEGIN = 4098,
    DROPCOMPLETE = 4099,
    AUDIODEVICEADDED = 4352,
    AUDIODEVICEREMOVED = 4353,
    SENSORUPDATE = 4608,
    RENDER_TARGETS_RESET = 8192,
    RENDER_DEVICE_RESET = 8193,
    USEREVENT = 32768,
    LASTEVENT = 65535,
}
  
struct SDL_CommonEvent
{
    uint type;
    uint timestamp;
}
struct SDL_DisplayEvent
{
    uint type;
    uint timestamp;
    uint display;
    ubyte event;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    int data1;
}
struct SDL_WindowEvent
{
    uint type;
    uint timestamp;
    uint windowID;
    ubyte event;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    int data1;
    int data2;
}
struct SDL_KeyboardEvent
{
    uint type;
    uint timestamp;
    uint windowID;
    ubyte state;
    ubyte repeat;
    ubyte padding2;
    ubyte padding3;
    SDL_Keysym keysym;
}
struct SDL_TextEditingEvent
{
    uint type;
    uint timestamp;
    uint windowID;
    char[32] text;
    int start;
    int length;
}
struct SDL_TextInputEvent
{
    uint type;
    uint timestamp;
    uint windowID;
    char[32] text;
}
struct SDL_MouseMotionEvent
{
    uint type;
    uint timestamp;
    uint windowID;
    uint which;
    uint state;
    int x;
    int y;
    int xrel;
    int yrel;
}
struct SDL_MouseButtonEvent
{
    uint type;
    uint timestamp;
    uint windowID;
    uint which;
    ubyte button;
    ubyte state;
    ubyte clicks;
    ubyte padding1;
    int x;
    int y;
}
struct SDL_MouseWheelEvent
{
    uint type;
    uint timestamp;
    uint windowID;
    uint which;
    int x;
    int y;
    uint direction;
}
struct SDL_JoyAxisEvent
{
    uint type;
    uint timestamp;
    int which;
    ubyte axis;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short value;
    ushort padding4;
}
struct SDL_JoyBallEvent
{
    uint type;
    uint timestamp;
    int which;
    ubyte ball;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short xrel;
    short yrel;
}
struct SDL_JoyHatEvent
{
    uint type;
    uint timestamp;
    int which;
    ubyte hat;
    ubyte value;
    ubyte padding1;
    ubyte padding2;
}
struct SDL_JoyButtonEvent
{
    uint type;
    uint timestamp;
    int which;
    ubyte button;
    ubyte state;
    ubyte padding1;
    ubyte padding2;
}
struct SDL_JoyDeviceEvent
{
    uint type;
    uint timestamp;
    int which;
}
struct SDL_ControllerAxisEvent
{
    uint type;
    uint timestamp;
    int which;
    ubyte axis;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short value;
    ushort padding4;
}
struct SDL_ControllerButtonEvent
{
    uint type;
    uint timestamp;
    int which;
    ubyte button;
    ubyte state;
    ubyte padding1;
    ubyte padding2;
}
struct SDL_ControllerDeviceEvent
{
    uint type;
    uint timestamp;
    int which;
}
struct SDL_AudioDeviceEvent
{
    uint type;
    uint timestamp;
    uint which;
    ubyte iscapture;
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
}
struct SDL_TouchFingerEvent
{
    uint type;
    uint timestamp;
    c_long touchId;
    c_long fingerId;
    float x;
    float y;
    float dx;
    float dy;
    float pressure;
}
struct SDL_MultiGestureEvent
{
    uint type;
    uint timestamp;
    c_long touchId;
    float dTheta;
    float dDist;
    float x;
    float y;
    ushort numFingers;
    ushort padding;
}
struct SDL_DollarGestureEvent
{
    uint type;
    uint timestamp;
    c_long touchId;
    c_long gestureId;
    uint numFingers;
    float error;
    float x;
    float y;
}
struct SDL_DropEvent
{
    uint type;
    uint timestamp;
    char* file;
    uint windowID;
}
struct SDL_SensorEvent
{
    uint type;
    uint timestamp;
    int which;
    float[6] data;
}
struct SDL_QuitEvent
{
    uint type;
    uint timestamp;
}
struct SDL_OSEvent
{
    uint type;
    uint timestamp;
}
struct SDL_UserEvent
{
    uint type;
    uint timestamp;
    uint windowID;
    int code;
    void* data1;
    void* data2;
}
struct SDL_SysWMmsg;
struct SDL_SysWMEvent
{
    uint type;
    uint timestamp;
    SDL_SysWMmsg* msg;
}
union SDL_Event
{
    uint type;
    SDL_CommonEvent common;
    SDL_DisplayEvent display;
    SDL_WindowEvent window;
    SDL_KeyboardEvent key;
    SDL_TextEditingEvent edit;
    SDL_TextInputEvent text;
    SDL_MouseMotionEvent motion;
    SDL_MouseButtonEvent button;
    SDL_MouseWheelEvent wheel;
    SDL_JoyAxisEvent jaxis;
    SDL_JoyBallEvent jball;
    SDL_JoyHatEvent jhat;
    SDL_JoyButtonEvent jbutton;
    SDL_JoyDeviceEvent jdevice;
    SDL_ControllerAxisEvent caxis;
    SDL_ControllerButtonEvent cbutton;
    SDL_ControllerDeviceEvent cdevice;
    SDL_AudioDeviceEvent adevice;
    SDL_SensorEvent sensor;
    SDL_QuitEvent quit;
    SDL_UserEvent user;
    SDL_SysWMEvent syswm;
    SDL_TouchFingerEvent tfinger;
    SDL_MultiGestureEvent mgesture;
    SDL_DollarGestureEvent dgesture;
    SDL_DropEvent drop;
    ubyte[56] padding;


}


alias SDL_compile_time_assert_SDL_Event = int[1];

enum SDL_eventaction
{
    ADDEVENT = 0,
    PEEKEVENT = 1,
    GETEVENT = 2,
}

struct _SDL_GameController;
alias SDL_GameController = _SDL_GameController;

enum SDL_GameControllerBindType
{
    NONE = 0,
    BUTTON = 1,
    AXIS = 2,
    HAT = 3,
}

struct SDL_GameControllerButtonBind
{
    SDL_GameControllerBindType bindType;
    static union _Anonymous_9
    {
        int button;
        int axis;
        static struct _Anonymous_10
        {
            int hat;
            int hat_mask;
        }
        _Anonymous_10 hat;
    }
    _Anonymous_9 value;
}

enum SDL_GameControllerAxis 
{
    INVALID = -1,
    LEFTX = 0,
    LEFTY = 1,
    RIGHTX = 2,
    RIGHTY = 3,
    TRIGGERLEFT = 4,
    TRIGGERRIGHT = 5,
    MAX = 6,
}

enum SDL_GameControllerButton
{
    INVALID = -1,
    A = 0,
    B = 1,
    X = 2,
    Y = 3,
    BACK = 4,
    GUIDE = 5,
    START = 6,
    LEFTSTICK = 7,
    RIGHTSTICK = 8,
    LEFTSHOULDER = 9,
    RIGHTSHOULDER = 10,
    DPAD_UP = 11,
    DPAD_DOWN = 12,
    DPAD_LEFT = 13,
    DPAD_RIGHT = 14,
    MAX = 15,
}

alias SDL_GestureID = c_long;
struct _SDL_Haptic;
alias SDL_Haptic = _SDL_Haptic;

struct SDL_HapticDirection
{
    ubyte type;
    int[3] dir;
}
struct SDL_HapticConstant
{
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    short level;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}
struct SDL_HapticPeriodic
{
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    ushort period;
    short magnitude;
    short offset;
    ushort phase;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}
struct SDL_HapticCondition
{
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    ushort[3] right_sat;
    ushort[3] left_sat;
    short[3] right_coeff;
    short[3] left_coeff;
    ushort[3] deadband;
    short[3] center;
}
struct SDL_HapticRamp
{
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    short start;
    short end;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}
struct SDL_HapticLeftRight
{
    ushort type;
    uint length;
    ushort large_magnitude;
    ushort small_magnitude;
}
struct SDL_HapticCustom
{
    ushort type;
    SDL_HapticDirection direction;
    uint length;
    ushort delay;
    ushort button;
    ushort interval;
    ubyte channels;
    ushort period;
    ushort samples;
    ushort* data;
    ushort attack_length;
    ushort attack_level;
    ushort fade_length;
    ushort fade_level;
}
union SDL_HapticEffect
{
    ushort type;
    SDL_HapticConstant constant;
    SDL_HapticPeriodic periodic;
    SDL_HapticCondition condition;
    SDL_HapticRamp ramp;
    SDL_HapticLeftRight leftright;
    SDL_HapticCustom custom;
}

enum SDL_HintPriority
{
    DEFAULT = 0,
    NORMAL = 1,
    OVERRIDE = 2,
}

    struct _SDL_Joystick;
alias SDL_Joystick = _SDL_Joystick;
struct SDL_JoystickGUID
{
    ubyte[16] data;
}
alias SDL_JoystickID = int;
enum  SDL_JoystickType
{
    UNKNOWN = 0,
    GAMECONTROLLER = 1,
    WHEEL = 2,
    ARCADE_STICK = 3,
    FLIGHT_STICK = 4,
    DANCE_PAD = 5,
    GUITAR = 6,
    DRUM_KIT = 7,
    ARCADE_PAD = 8,
    THROTTLE = 9,
}

enum SDL_JoystickPowerLevel
{
    UNKNOWN = -1,
    EMPTY = 0,
    LOW = 1,
    MEDIUM = 2,
    FULL = 3,
    WIRED = 4,
    MAX = 5,
}

struct SDL_Keysym
{
    SDL_Scancode scancode;
    int sym;
    ushort mod;
    uint unused;
}

alias SDL_Keycode = int;

enum SDLK
    {
        UNKNOWN = 0,
        RETURN = 13,
        ESCAPE = 27,
        BACKSPACE = 8,
        TAB = 9,
        SPACE = 32,
        EXCLAIM = 33,
        QUOTEDBL = 34,
        HASH = 35,
        PERCENT = 37,
        DOLLAR = 36,
        AMPERSAND = 38,
        QUOTE = 39,
        LEFTPAREN = 40,
        RIGHTPAREN = 41,
        ASTERISK = 42,
        PLUS = 43,
        COMMA = 44,
        MINUS = 45,
        PERIOD = 46,
        SLASH = 47,
        _0 = 48,
        _1 = 49,
        _2 = 50,
        _3 = 51,
        _4 = 52,
        _5 = 53,
        _6 = 54,
        _7 = 55,
        _8 = 56,
        _9 = 57,
        COLON = 58,
        SEMICOLON = 59,
        LESS = 60,
        EQUALS = 61,
        GREATER = 62,
        QUESTION = 63,
        AT = 64,
        LEFTBRACKET = 91,
        BACKSLASH = 92,
        RIGHTBRACKET = 93,
        CARET = 94,
        UNDERSCORE = 95,
        BACKQUOTE = 96,
        a = 97,
        b = 98,
        c = 99,
        d = 100,
        e = 101,
        f = 102,
        g = 103,
        h = 104,
        i = 105,
        j = 106,
        k = 107,
        l = 108,
        m = 109,
        n = 110,
        o = 111,
        p = 112,
        q = 113,
        r = 114,
        s = 115,
        t = 116,
        u = 117,
        v = 118,
        w = 119,
        x = 120,
        y = 121,
        z = 122,
        CAPSLOCK = 1073741881,
        F1 = 1073741882,
        F2 = 1073741883,
        F3 = 1073741884,
        F4 = 1073741885,
        F5 = 1073741886,
        F6 = 1073741887,
        F7 = 1073741888,
        F8 = 1073741889,
        F9 = 1073741890,
        F10 = 1073741891,
        F11 = 1073741892,
        F12 = 1073741893,
        PRINTSCREEN = 1073741894,
        SCROLLLOCK = 1073741895,
        PAUSE = 1073741896,
        INSERT = 1073741897,
        HOME = 1073741898,
        PAGEUP = 1073741899,
        DELETE = 127,
        END = 1073741901,
        PAGEDOWN = 1073741902,
        RIGHT = 1073741903,
        LEFT = 1073741904,
        DOWN = 1073741905,
        UP = 1073741906,
        NUMLOCKCLEAR = 1073741907,
        KP_DIVIDE = 1073741908,
        KP_MULTIPLY = 1073741909,
        KP_MINUS = 1073741910,
        KP_PLUS = 1073741911,
        KP_ENTER = 1073741912,
        KP_1 = 1073741913,
        KP_2 = 1073741914,
        KP_3 = 1073741915,
        KP_4 = 1073741916,
        KP_5 = 1073741917,
        KP_6 = 1073741918,
        KP_7 = 1073741919,
        KP_8 = 1073741920,
        KP_9 = 1073741921,
        KP_0 = 1073741922,
        KP_PERIOD = 1073741923,
        APPLICATION = 1073741925,
        POWER = 1073741926,
        KP_EQUALS = 1073741927,
        F13 = 1073741928,
        F14 = 1073741929,
        F15 = 1073741930,
        F16 = 1073741931,
        F17 = 1073741932,
        F18 = 1073741933,
        F19 = 1073741934,
        F20 = 1073741935,
        F21 = 1073741936,
        F22 = 1073741937,
        F23 = 1073741938,
        F24 = 1073741939,
        EXECUTE = 1073741940,
        HELP = 1073741941,
        MENU = 1073741942,
        SELECT = 1073741943,
        STOP = 1073741944,
        AGAIN = 1073741945,
        UNDO = 1073741946,
        CUT = 1073741947,
        COPY = 1073741948,
        PASTE = 1073741949,
        FIND = 1073741950,
        MUTE = 1073741951,
        VOLUMEUP = 1073741952,
        VOLUMEDOWN = 1073741953,
        KP_COMMA = 1073741957,
        KP_EQUALSAS400 = 1073741958,
        ALTERASE = 1073741977,
        SYSREQ = 1073741978,
        CANCEL = 1073741979,
        CLEAR = 1073741980,
        PRIOR = 1073741981,
        RETURN2 = 1073741982,
        SEPARATOR = 1073741983,
        OUT = 1073741984,
        OPER = 1073741985,
        CLEARAGAIN = 1073741986,
        CRSEL = 1073741987,
        EXSEL = 1073741988,
        KP_00 = 1073742000,
        KP_000 = 1073742001,
        THOUSANDSSEPARATOR = 1073742002,
        DECIMALSEPARATOR = 1073742003,
        CURRENCYUNIT = 1073742004,
        CURRENCYSUBUNIT = 1073742005,
        KP_LEFTPAREN = 1073742006,
        KP_RIGHTPAREN = 1073742007,
        KP_LEFTBRACE = 1073742008,
        KP_RIGHTBRACE = 1073742009,
        KP_TAB = 1073742010,
        KP_BACKSPACE = 1073742011,
        KP_A = 1073742012,
        KP_B = 1073742013,
        KP_C = 1073742014,
        KP_D = 1073742015,
        KP_E = 1073742016,
        KP_F = 1073742017,
        KP_XOR = 1073742018,
        KP_POWER = 1073742019,
        KP_PERCENT = 1073742020,
        KP_LESS = 1073742021,
        KP_GREATER = 1073742022,
        KP_AMPERSAND = 1073742023,
        KP_DBLAMPERSAND = 1073742024,
        KP_VERTICALBAR = 1073742025,
        KP_DBLVERTICALBAR = 1073742026,
        KP_COLON = 1073742027,
        KP_HASH = 1073742028,
        KP_SPACE = 1073742029,
        KP_AT = 1073742030,
        KP_EXCLAM = 1073742031,
        KP_MEMSTORE = 1073742032,
        KP_MEMRECALL = 1073742033,
        KP_MEMCLEAR = 1073742034,
        KP_MEMADD = 1073742035,
        KP_MEMSUBTRACT = 1073742036,
        KP_MEMMULTIPLY = 1073742037,
        KP_MEMDIVIDE = 1073742038,
        KP_PLUSMINUS = 1073742039,
        KP_CLEAR = 1073742040,
        KP_CLEARENTRY = 1073742041,
        KP_BINARY = 1073742042,
        KP_OCTAL = 1073742043,
        KP_DECIMAL = 1073742044,
        KP_HEXADECIMAL = 1073742045,
        LCTRL = 1073742048,
        LSHIFT = 1073742049,
        LALT = 1073742050,
        LGUI = 1073742051,
        RCTRL = 1073742052,
        RSHIFT = 1073742053,
        RALT = 1073742054,
        RGUI = 1073742055,
        MODE = 1073742081,
        AUDIONEXT = 1073742082,
        AUDIOPREV = 1073742083,
        AUDIOSTOP = 1073742084,
        AUDIOPLAY = 1073742085,
        AUDIOMUTE = 1073742086,
        MEDIASELECT = 1073742087,
        WWW = 1073742088,
        MAIL = 1073742089,
        CALCULATOR = 1073742090,
        COMPUTER = 1073742091,
        AC_SEARCH = 1073742092,
        AC_HOME = 1073742093,
        AC_BACK = 1073742094,
        AC_FORWARD = 1073742095,
        AC_STOP = 1073742096,
        AC_REFRESH = 1073742097,
        AC_BOOKMARKS = 1073742098,
        BRIGHTNESSDOWN = 1073742099,
        BRIGHTNESSUP = 1073742100,
        DISPLAYSWITCH = 1073742101,
        KBDILLUMTOGGLE = 1073742102,
        KBDILLUMDOWN = 1073742103,
        KBDILLUMUP = 1073742104,
        EJECT = 1073742105,
        SLEEP = 1073742106,
        APP1 = 1073742107,
        APP2 = 1073742108,
        AUDIOREWIND = 1073742109,
        AUDIOFASTFORWARD = 1073742110,
    }
    
    enum SDL_Keymod 
    {
        NONE = 0,
        LSHIFT = 1,
        RSHIFT = 2,
        LCTRL = 64,
        RCTRL = 128,
        LALT = 256,
        RALT = 512,
        LGUI = 1024,
        RGUI = 2048,
        NUM = 4096,
        CAPS = 8192,
        MODE = 16384,
        RESERVED = 32768,
    }

enum SDL_LOG_CATEGORY
{
    APPLICATION = 0,
    ERROR = 1,
    ASSERT = 2,
    SYSTEM = 3,
    AUDIO = 4,
    VIDEO = 5,
    RENDER = 6,
    INPUT = 7,
    TEST = 8,
    RESERVED1 = 9,
    RESERVED2 = 10,
    RESERVED3 = 11,
    RESERVED4 = 12,
    RESERVED5 = 13,
    RESERVED6 = 14,
    RESERVED7 = 15,
    RESERVED8 = 16,
    RESERVED9 = 17,
    RESERVED10 = 18,
    CUSTOM = 19,
}

enum SDL_LogPriority
{
    VERBOSE = 1,
    DEBUG = 2,
    INFO = 3,
    WARN = 4,
    ERROR = 5,
    CRITICAL = 6,
    SDL_NUM_LOG_PRIORITIES = 7,
}

enum SDL_MessageBoxFlags
{
    ERROR = 16,
    WARNING = 32,
    INFORMATION = 64,
}

enum SDL_MessageBoxButtonFlags 
{
    RETURNKEY_DEFAULT = 1,
    ESCAPEKEY_DEFAULT = 2,
}
struct SDL_MessageBoxButtonData
{
    uint flags;
    int buttonid;
    const(char)* text;
}
struct SDL_MessageBoxColor
{
    ubyte r;
    ubyte g;
    ubyte b;
}

enum SDL_MessageBoxColorType
{
    BACKGROUND = 0,
    TEXT = 1,
    BUTTON_BORDER = 2,
    BUTTON_BACKGROUND = 3,
    BUTTON_SELECTED = 4,
    MAX = 5,
}

struct SDL_MessageBoxColorScheme
{
    SDL_MessageBoxColor[5] colors;
}
struct SDL_MessageBoxData
{
    uint flags;
    SDL_Window* window;
    const(char)* title;
    const(char)* message;
    int numbuttons;
    const(SDL_MessageBoxButtonData)* buttons;
    const(SDL_MessageBoxColorScheme)* colorScheme;
}

struct SDL_Cursor;
enum SDL_SystemCursor 
{
    ARROW = 0,
    IBEAM = 1,
    WAIT = 2,
    CROSSHAIR = 3,
    WAITARROW = 4,
    SIZENWSE = 5,
    SIZENESW = 6,
    SIZEWE = 7,
    SIZENS = 8,
    SIZEALL = 9,
    NO = 10,
    HAND = 11,
    NUM_SYSTEM_CURSORS = 12,
}

enum SDL_MouseWheelDirection 
{
    NORMAL = 0,
    FLIPPED = 1,
}
struct SDL_mutex;
struct SDL_semaphore;
alias SDL_sem = SDL_semaphore;
struct SDL_cond;

enum SDL_PIXELTYPE
{
    UNKNOWN = 0,
    INDEX1 = 1,
    INDEX4 = 2,
    INDEX8 = 3,
    PACKED8 = 4,
    PACKED16 = 5,
    PACKED32 = 6,
    ARRAYU8 = 7,
    ARRAYU16 = 8,
    ARRAYU32 = 9,
    ARRAYF16 = 10,
    ARRAYF32 = 11,
}

enum SDL_BITMAPORDER
{
    NONE = 0,
    _4321 = 1,
    _1234 = 2,
}

enum SDL_PACKEDORDER
{
    NONE = 0,
    XRGB = 1,
    RGBX = 2,
    ARGB = 3,
    RGBA = 4,
    XBGR = 5,
    BGRX = 6,
    ABGR = 7,
    BGRA = 8,
}

enum SDL_ARRAYORDER
{
    NONE = 0,
    RGB = 1,
    RGBA = 2,
    ARGB = 3,
    BGR = 4,
    BGRA = 5,
    ABGR = 6,
}

enum SDL_PACKEDLAYOUT
{
    NONE = 0,
    _332 = 1,
    _4444 = 2,
    _1555 = 3,
    _5551 = 4,
    _565 = 5,
    _8888 = 6,
    _2101010 = 7,
    _1010102 = 8,
}

    enum SDL_PixelFormatEnum
    {
        UNKNOWN = 0,
        INDEX1LSB = 286261504,
        INDEX1MSB = 287310080,
        INDEX4LSB = 303039488,
        INDEX4MSB = 304088064,
        INDEX8 = 318769153,
        RGB332 = 336660481,
        RGB444 = 353504258,
        RGB555 = 353570562,
        BGR555 = 357764866,
        ARGB4444 = 355602434,
        RGBA4444 = 356651010,
        ABGR4444 = 359796738,
        BGRA4444 = 360845314,
        ARGB1555 = 355667970,
        RGBA5551 = 356782082,
        ABGR1555 = 359862274,
        BGRA5551 = 360976386,
        RGB565 = 353701890,
        BGR565 = 357896194,
        RGB24 = 386930691,
        BGR24 = 390076419,
        RGB888 = 370546692,
        RGBX8888 = 371595268,
        BGR888 = 374740996,
        BGRX8888 = 375789572,
        ARGB8888 = 372645892,
        RGBA8888 = 373694468,
        ABGR8888 = 376840196,
        BGRA8888 = 377888772,
        ARGB2101010 = 372711428,
        RGBA32 = 376840196,
        ARGB32 = 377888772,
        BGRA32 = 372645892,
        ABGR32 = 373694468,
        YV12 = 842094169,
        IYUV = 1448433993,
        YUY2 = 844715353,
        UYVY = 1498831189,
        YVYU = 1431918169,
        NV12 = 842094158,
        NV21 = 825382478,
        EXTERNAL_OES = 542328143,
    }
    struct SDL_Color
    {
        union
        {
            struct {ubyte r; ubyte g; ubyte b; ubyte a;} 
            uint packed;
            ubyte[4] rgba; 
        }
        alias rgba this;
        void opAssign(ubyte[4] c) { rgba = c; }
        void opAssign(uint c) { this.packed = c; }
        auto opBinary(string op)(float rhs)
        {
            SDL_Color ret;
            mixin("ret.r = cast(ubyte)(cast(float)r"~op~"rhs);");
            mixin("ret.g = cast(ubyte)(cast(float)g"~op~"rhs);");
            mixin("ret.b = cast(ubyte)(cast(float)b"~op~"rhs);");
            mixin("ret.a = cast(ubyte)(cast(float)a"~op~"rhs);");
            return ret;
        }
        auto opBinary(string op)(ubyte rhs)
        {
            static if (op == "*") 
            {
                SDL_Color ret;
                int tmp = min(((cast(int)ret.r*rhs) >> 8),255);
                ret.r = cast(ubyte)(tmp & 0x000000ff);
                tmp = min(((cast(int)ret.g*rhs) >> 8),255);
                ret.g = cast(ubyte)(tmp & 0x000000ff);
                tmp = min(((cast(int)ret.b*rhs) >> 8),255);
                ret.b = cast(ubyte)(tmp & 0x000000ff);
                tmp = min(((cast(int)ret.a*rhs) >> 8),255);
                ret.a = cast(ubyte)(tmp & 0x000000ff);
                return ret;
            }
            else
            {
                assert(0,"op not implemented");
            }
        }
        auto opBinary(string op)(const float f) const
        {
            mixin("return SDL_Color(cast(ubyte)(r"~op~"f), cast(ubyte)(g"~op~"f), cast(ubyte)(b"~op~"f),cast(ubyte)(a"~op~"f));");
        }

    }

    struct SDL_Palette
    {
        int ncolors;
        SDL_Color* colors;
        uint version_;
        int refcount;
    }
    struct SDL_PixelFormat
    {
        uint format;
        SDL_Palette* palette;
        ubyte BitsPerPixel;
        ubyte BytesPerPixel;
        ubyte[2] padding;
        uint Rmask;
        uint Gmask;
        uint Bmask;
        uint Amask;
        ubyte Rloss;
        ubyte Gloss;
        ubyte Bloss;
        ubyte Aloss;
        ubyte Rshift;
        ubyte Gshift;
        ubyte Bshift;
        ubyte Ashift;
        int refcount;
        SDL_PixelFormat* next;
    }

enum SDL_PowerState
{
    UNKNOWN = 0,
    ON_BATTERY = 1,
    NO_BATTERY = 2,
    CHARGING = 3,
    CHARGED = 4,
}


struct SDLPoint(T)
    if (is(T == float) || is(T == int))
{
    union
    {
        struct { T x; T y;}
        T[2] xy;
    }
    alias xy this;
    void opAssign(T[2] v) { xy = v; }
    void opAssign(SDLRect!T r) { this.xy = r.xy; }
    void opAssign(SDLPoint!T p) { this.xy = p.xy; }

    void opAssign(U)(U value)
        if (is(U==T) || is(U==T[2]) || is(U==SDLRect!T) || is(U==SDLPoint!T))
    {
        static if (is(U==T)) 
            xy[] = value;
        else static if (is(U==SDLRect!T)) 
            xy[] = value.xy[];
        else
            xy[] = value[];
    }
    auto opOpAssign(string op, U)(const U value)
        if (is(U==T) || is(U==T[2]) || is(U==SDLRect!T) || is(U==SDLPoint!T))
    {
        static if (is(U==T)) 
            mixin("xy[] "~op~"= value;");
        else static if (is(U==SDLRect!T)) 
            mixin("xy[] "~op~"= value.xy[];");
        else 
            mixin("xy[] "~op~"= value[];");

        return this;
    }
    SDLPoint!T opBinary(string op)(const T rhs)
    {
        SDLPoint!T r;
        mixin("r[] = xy[]"~op~" rhs;");
        return r;
    }
    inout SDLPoint!T opBinary(string op)(inout const SDLPoint!T rhs)
    {
        SDLPoint!T r;
        mixin("r[] = xy[] "~op~" rhs[];");
        return r;
    }
}
alias SDL_Point = SDLPoint!int;
alias SDL_FPoint = SDLPoint!float;
// sometimes you have a pair of variables 
// that logically have an x and a y value

alias SDLPair = SDLPoint;
alias SDL_Pair = SDLPoint!int;
alias SDL_FPair = SDLPoint!float;

struct SDLRect(T)
    if (is(T == float) || is(T == int))
{
    union
    {
        struct { T x; T y; T w; T h; }
        struct { SDLPoint!T xy; SDLPair!T wh;}
        T[4] xywh;
    }
    alias xywh this;

    void opAssign(T[4] v) { xywh = v; }
    inout SDLRect!T opBinary(string op)(inout const SDLPoint!T rhs)
    {
        rect!T r;
        mixin("r[] = xy[] "~op~" rhs[];");
        return r;
    }
}
alias SDL_Rect = SDLRect!int;
alias SDL_FRect = SDLRect!float;

enum SDL_RendererFlags
{
    SOFTWARE = 1,
    ACCELERATED = 2,
    PRESENTVSYNC = 4,
    TARGETTEXTURE = 8,
}
struct SDL_RendererInfo
{
    const(char)* name;
    uint flags;
    uint num_texture_formats;
    uint[16] texture_formats;
    int max_texture_width;
    int max_texture_height;
}
enum SDL_TextureAccess
{
    STATIC = 0,
    STREAMING = 1,
    TARGET = 2,
}

enum SDL_TextureModulate
{
    NONE = 0,
    COLOR = 1,
    ALPHA = 2,
}

enum SDL_RendererFlip
{
    NONE = 0,
    HORIZONTAL = 1,
    VERTICAL = 2,
}
struct SDL_Renderer;
struct SDL_Texture;

 struct SDL_RWops
{
    // c_long function(SDL_RWops*) size;
    // c_long function(SDL_RWops*, c_long, int) seek;
    // c_ulong function(SDL_RWops*, void*, c_ulong, c_ulong) read;
    // c_ulong function(SDL_RWops*, const(void)*, c_ulong, c_ulong) write;
    // int function(SDL_RWops*) close;
    // uint type;
    // static union _Anonymous_36
    // {
    //     static struct _Anonymous_37
    //     {
    //         SDL_bool autoclose;
    //         _IO_FILE* fp;
    //     }
    //     _Anonymous_37 stdio;
    //     static struct _Anonymous_38
    //     {
    //         ubyte* base;
    //         ubyte* here;
    //         ubyte* stop;
    //     }
    //     _Anonymous_38 mem;
    //     static struct _Anonymous_39
    //     {
    //         void* data1;
    //         void* data2;
    //     }
    //     _Anonymous_39 unknown;
    // }
    // _Anonymous_36 hidden;
}

    enum SDL_Scancode
    {
        UNKNOWN = 0,
        A = 4,
        B = 5,
        C = 6,
        D = 7,
        E = 8,
        F = 9,
        G = 10,
        H = 11,
        I = 12,
        J = 13,
        K = 14,
        L = 15,
        M = 16,
        N = 17,
        O = 18,
        P = 19,
        Q = 20,
        R = 21,
        S = 22,
        T = 23,
        U = 24,
        V = 25,
        W = 26,
        X = 27,
        Y = 28,
        Z = 29,
        _1 = 30,
        _2 = 31,
        _3 = 32,
        _4 = 33,
        _5 = 34,
        _6 = 35,
        _7 = 36,
        _8 = 37,
        _9 = 38,
        _0 = 39,
        RETURN = 40,
        ESCAPE = 41,
        BACKSPACE = 42,
        TAB = 43,
        SPACE = 44,
        MINUS = 45,
        EQUALS = 46,
        LEFTBRACKET = 47,
        RIGHTBRACKET = 48,
        BACKSLASH = 49,
        NONUSHASH = 50,
        SEMICOLON = 51,
        APOSTROPHE = 52,
        GRAVE = 53,
        COMMA = 54,
        PERIOD = 55,
        SLASH = 56,
        CAPSLOCK = 57,
        F1 = 58,
        F2 = 59,
        F3 = 60,
        F4 = 61,
        F5 = 62,
        F6 = 63,
        F7 = 64,
        F8 = 65,
        F9 = 66,
        F10 = 67,
        F11 = 68,
        F12 = 69,
        PRINTSCREEN = 70,
        SCROLLLOCK = 71,
        PAUSE = 72,
        INSERT = 73,
        HOME = 74,
        PAGEUP = 75,
        DELETE = 76,
        END = 77,
        PAGEDOWN = 78,
        RIGHT = 79,
        LEFT = 80,
        DOWN = 81,
        UP = 82,
        NUMLOCKCLEAR = 83,
        KP_DIVIDE = 84,
        KP_MULTIPLY = 85,
        KP_MINUS = 86,
        KP_PLUS = 87,
        KP_ENTER = 88,
        KP_1 = 89,
        KP_2 = 90,
        KP_3 = 91,
        KP_4 = 92,
        KP_5 = 93,
        KP_6 = 94,
        KP_7 = 95,
        KP_8 = 96,
        KP_9 = 97,
        KP_0 = 98,
        KP_PERIOD = 99,
        NONUSBACKSLASH = 100,
        APPLICATION = 101,
        POWER = 102,
        KP_EQUALS = 103,
        F13 = 104,
        F14 = 105,
        F15 = 106,
        F16 = 107,
        F17 = 108,
        F18 = 109,
        F19 = 110,
        F20 = 111,
        F21 = 112,
        F22 = 113,
        F23 = 114,
        F24 = 115,
        EXECUTE = 116,
        HELP = 117,
        MENU = 118,
        SELECT = 119,
        STOP = 120,
        AGAIN = 121,
        UNDO = 122,
        CUT = 123,
        COPY = 124,
        PASTE = 125,
        FIND = 126,
        MUTE = 127,
        VOLUMEUP = 128,
        VOLUMEDOWN = 129,
        KP_COMMA = 133,
        KP_EQUALSAS400 = 134,
        INTERNATIONAL1 = 135,
        INTERNATIONAL2 = 136,
        INTERNATIONAL3 = 137,
        INTERNATIONAL4 = 138,
        INTERNATIONAL5 = 139,
        INTERNATIONAL6 = 140,
        INTERNATIONAL7 = 141,
        INTERNATIONAL8 = 142,
        INTERNATIONAL9 = 143,
        LANG1 = 144,
        LANG2 = 145,
        LANG3 = 146,
        LANG4 = 147,
        LANG5 = 148,
        LANG6 = 149,
        LANG7 = 150,
        LANG8 = 151,
        LANG9 = 152,
        ALTERASE = 153,
        SYSREQ = 154,
        CANCEL = 155,
        CLEAR = 156,
        PRIOR = 157,
        RETURN2 = 158,
        SEPARATOR = 159,
        OUT = 160,
        OPER = 161,
        CLEARAGAIN = 162,
        CRSEL = 163,
        EXSEL = 164,
        KP_00 = 176,
        KP_000 = 177,
        THOUSANDSSEPARATOR = 178,
        DECIMALSEPARATOR = 179,
        CURRENCYUNIT = 180,
        CURRENCYSUBUNIT = 181,
        KP_LEFTPAREN = 182,
        KP_RIGHTPAREN = 183,
        KP_LEFTBRACE = 184,
        KP_RIGHTBRACE = 185,
        KP_TAB = 186,
        KP_BACKSPACE = 187,
        KP_A = 188,
        KP_B = 189,
        KP_C = 190,
        KP_D = 191,
        KP_E = 192,
        KP_F = 193,
        KP_XOR = 194,
        KP_POWER = 195,
        KP_PERCENT = 196,
        KP_LESS = 197,
        KP_GREATER = 198,
        KP_AMPERSAND = 199,
        KP_DBLAMPERSAND = 200,
        KP_VERTICALBAR = 201,
        KP_DBLVERTICALBAR = 202,
        KP_COLON = 203,
        KP_HASH = 204,
        KP_SPACE = 205,
        KP_AT = 206,
        KP_EXCLAM = 207,
        KP_MEMSTORE = 208,
        KP_MEMRECALL = 209,
        KP_MEMCLEAR = 210,
        KP_MEMADD = 211,
        KP_MEMSUBTRACT = 212,
        KP_MEMMULTIPLY = 213,
        KP_MEMDIVIDE = 214,
        KP_PLUSMINUS = 215,
        KP_CLEAR = 216,
        KP_CLEARENTRY = 217,
        KP_BINARY = 218,
        KP_OCTAL = 219,
        KP_DECIMAL = 220,
        KP_HEXADECIMAL = 221,
        LCTRL = 224,
        LSHIFT = 225,
        LALT = 226,
        LGUI = 227,
        RCTRL = 228,
        RSHIFT = 229,
        RALT = 230,
        RGUI = 231,
        MODE = 257,
        AUDIONEXT = 258,
        AUDIOPREV = 259,
        AUDIOSTOP = 260,
        AUDIOPLAY = 261,
        AUDIOMUTE = 262,
        MEDIASELECT = 263,
        WWW = 264,
        MAIL = 265,
        CALCULATOR = 266,
        COMPUTER = 267,
        AC_SEARCH = 268,
        AC_HOME = 269,
        AC_BACK = 270,
        AC_FORWARD = 271,
        AC_STOP = 272,
        AC_REFRESH = 273,
        AC_BOOKMARKS = 274,
        BRIGHTNESSDOWN = 275,
        BRIGHTNESSUP = 276,
        DISPLAYSWITCH = 277,
        KBDILLUMTOGGLE = 278,
        KBDILLUMDOWN = 279,
        KBDILLUMUP = 280,
        EJECT = 281,
        SLEEP = 282,
        APP1 = 283,
        APP2 = 284,
        AUDIOREWIND = 285,
        AUDIOFASTFORWARD = 286,
        NUM_SCANCODES = 512,
    }
 
   struct _SDL_Sensor;
    alias SDL_Sensor = _SDL_Sensor;
    alias SDL_SensorID = int;
    enum SDL_SensorType
    {
    
        INVALID = -1,
        UNKNOWN = 0,
        ACCEL = 1,
        GYRO = 2,
    }

    enum WindowShapeMode
    {
        Default = 0,
        BinarizeAlpha = 1,
        ReverseBinarizeAlpha = 2,
        ColorKey = 3,
    }
    union SDL_WindowShapeParams
    {
        ubyte binarizationCutoff;
        SDL_Color colorKey;
    }
    struct SDL_WindowShapeMode
    {
        WindowShapeMode mode;
        SDL_WindowShapeParams parameters;
    }

    alias SDL_compile_time_assert_enum = int[1];

    enum SDL_bool
    {
        FALSE = 0,
        TRUE = 1,
    }
    enum SDL_FALSE = SDL_bool.FALSE;
    enum SDL_TRUE = SDL_bool.TRUE;


    enum DUMMY_ENUM_VALUE = 0;
    alias SDL_iconv_t = _SDL_iconv_t*;
    struct _SDL_iconv_t;

enum SDL_SurfaceFlags
{
    SWSURFACE =      0 ,          /**< Just here for compatibility */
    PREALLOC  =      0x00000001,  /**< Surface uses preallocated memory */
    RLEACCEL  =      0x00000002,  /**< Surface is RLE encoded */
    DONTFREE  =      0x00000004,  /**< Surface is referenced internally */
    SIMD_ALIGNED =   0x00000008  /**< Surface uses aligned memory */
}
 struct SDL_Surface
{
    uint flags;
    SDL_PixelFormat* format;
    int w;
    int h;
    int pitch;
    void* pixels;
    void* userdata;
    int locked;
    void* lock_data;
    SDL_Rect clip_rect;
    SDL_BlitMap* map;
    int refcount;
}
alias SDL_blit = int function(SDL_Surface*, SDL_Rect*, SDL_Surface*, SDL_Rect*);
enum SDL_YUV_CONVERSION_MODE
{
    JPEG = 0,
    BT601 = 1,
    BT709 = 2,
    AUTOMATIC = 3,
}

struct SDL_Thread;
alias SDL_threadID = c_ulong;
alias SDL_TLSID = uint;
enum SDL_ThreadPriority
{
    LOW = 0,
    NORMAL = 1,
    HIGH = 2,
    TIME_CRITICAL = 3,
}

alias SDL_ThreadFunction = int function(void*);

enum SDL_TouchDeviceType
{
    INVALID = -1,
    DIRECT = 0,
    INDIRECT_ABSOLUTE = 1,
    INDIRECT_RELATIVE = 2,
}
struct SDL_Finger
{
    c_long id;
    float x;
    float y;
    float pressure;
}
struct SDL_version
{
    ubyte major;
    ubyte minor;
    ubyte patch;
}
struct SDL_DisplayMode
    {
        uint format;
        int w;
        int h;
        int refresh_rate;
        void* driverdata;
    }
    struct SDL_Window;
    enum SDL_WindowFlags
    {
        FULLSCREEN = 1,
        OPENGL = 2,
        SHOWN = 4,
        HIDDEN = 8,
        BORDERLESS = 16,
        RESIZABLE = 32,
        MINIMIZED = 64,
        MAXIMIZED = 128,
        INPUT_GRABBED = 256,
        INPUT_FOCUS = 512,
        MOUSE_FOCUS = 1024,
        FULLSCREEN_DESKTOP = 4097,
        FOREIGN = 2048,
        ALLOW_HIGHDPI = 8192,
        MOUSE_CAPTURE = 16384,
        ALWAYS_ON_TOP = 32768,
        SKIP_TASKBAR = 65536,
        UTILITY = 131072,
        TOOLTIP = 262144,
        POPUP_MENU = 524288,
        VULKAN = 268435456,
    }
    enum SDL_FullscreenMode
    {
        NONE = 0,
        FULLSCREEN = 1,
        FULLSCREEN_DESKTOP = 4097
    }

    enum SDL_WindowEventID
    {
        NONE = 0,
        SHOWN = 1,
        HIDDEN = 2,
        EXPOSED = 3,
        MOVED = 4,
        RESIZED = 5,
        SIZE_CHANGED = 6,
        MINIMIZED = 7,
        MAXIMIZED = 8,
        RESTORED = 9,
        ENTER = 10,
        LEAVE = 11,
        FOCUS_GAINED = 12,
        FOCUS_LOST = 13,
        CLOSE = 14,
        TAKE_FOCUS = 15,
        HIT_TEST = 16,
    }
    
    enum SDL_DisplayEventID
    {
        NONE = 0,
        ORIENTATION = 1,
    }
    
    enum SDL_DisplayOrientation
    {
        UNKNOWN = 0,
        LANDSCAPE = 1,
        LANDSCAPE_FLIPPED = 2,
        PORTRAIT = 3,
        PORTRAIT_FLIPPED = 4,
    }
    
    alias SDL_GLContext = void*;
    enum SDL_GLattr
    {
        RED_SIZE = 0,
        GREEN_SIZE = 1,
        BLUE_SIZE = 2,
        ALPHA_SIZE = 3,
        BUFFER_SIZE = 4,
        DOUBLEBUFFER = 5,
        DEPTH_SIZE = 6,
        STENCIL_SIZE = 7,
        ACCUM_RED_SIZE = 8,
        ACCUM_GREEN_SIZE = 9,
        ACCUM_BLUE_SIZE = 10,
        ACCUM_ALPHA_SIZE = 11,
        STEREO = 12,
        MULTISAMPLEBUFFERS = 13,
        MULTISAMPLESAMPLES = 14,
        ACCELERATED_VISUAL = 15,
        RETAINED_BACKING = 16,
        CONTEXT_MAJOR_VERSION = 17,
        CONTEXT_MINOR_VERSION = 18,
        CONTEXT_EGL = 19,
        CONTEXT_FLAGS = 20,
        CONTEXT_PROFILE_MASK = 21,
        SHARE_WITH_CURRENT_CONTEXT = 22,
        FRAMEBUFFER_SRGB_CAPABLE = 23,
        CONTEXT_RELEASE_BEHAVIOR = 24,
        CONTEXT_RESET_NOTIFICATION = 25,
        CONTEXT_NO_ERROR = 26,
    }
    enum SDL_GLprofile
    {
        PROFILE_CORE = 1,
        PROFILE_COMPATIBILITY = 2,
        PROFILE_ES = 4,
    }
    enum SDL_GLcontextFlag
    {
        DEBUG_FLAG = 1,
        FORWARD_COMPATIBLE_FLAG = 2,
        ROBUST_ACCESS_FLAG = 4,
        RESET_ISOLATION_FLAG = 8,
    }
    
    enum SDL_GLcontextReleaseFlag
    {
        BEHAVIOR_NONE = 0,
        BEHAVIOR_FLUSH = 1,
    }
    enum SDL_GLContextResetNotification
    {
        SDL_GL_CONTEXT_RESET_NO_NOTIFICATION = 0,
        SDL_GL_CONTEXT_RESET_LOSE_CONTEXT = 1,
    }
    enum SDL_HitTestResult
    {
        SDL_HITTEST_NORMAL = 0,
        SDL_HITTEST_DRAGGABLE = 1,
        SDL_HITTEST_RESIZE_TOPLEFT = 2,
        SDL_HITTEST_RESIZE_TOP = 3,
        SDL_HITTEST_RESIZE_TOPRIGHT = 4,
        SDL_HITTEST_RESIZE_RIGHT = 5,
        SDL_HITTEST_RESIZE_BOTTOMRIGHT = 6,
        SDL_HITTEST_RESIZE_BOTTOM = 7,
        SDL_HITTEST_RESIZE_BOTTOMLEFT = 8,
        SDL_HITTEST_RESIZE_LEFT = 9,
    }
   
    alias SDL_HitTest = SDL_HitTestResult function(SDL_Window*, const(SDL_Point)*, void*);
 struct __va_list_tag;
struct SDL_BlitMap;
struct _SDL_AudioStream;

alias TTF_Font = _TTF_Font;
struct _TTF_Font;