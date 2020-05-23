module jack.c.types;
import core.stdc.config;
extern (C):

enum string JACK_DEFAULT_AUDIO_TYPE = "32 bit float mono audio";
enum string JACK_DEFAULT_MIDI_TYPE = "8 bit raw midi"; 

struct jack_transport_info_t
{
    uint frame_rate;
    c_ulong usecs;
    jack_transport_bits_t valid;
    jack_transport_state_t transport_state;
    uint frame;
    uint loop_start;
    uint loop_end;
    c_long smpte_offset;
    float smpte_frame_rate;
    int bar;
    int beat;
    int tick;
    double bar_start_tick;
    float beats_per_bar;
    float beat_type;
    double ticks_per_beat;
    double beats_per_minute;
}
alias JackTransportInfo = jack_transport_info_t;

alias jack_transport_bits_t = JackTransportBits;
enum JackTransportBits
{
    State = 1,
    Position = 2,
    Loop = 4,
    SMPTE = 8,
    BBT = 16,
}

alias JackTimebaseCallback = void function(jack_transport_state_t, uint, _jack_position*, int, void*);
alias JackSyncCallback = int function(jack_transport_state_t, _jack_position*, void*);

struct _jack_position
{
align(1):
    c_ulong unique_1;
    c_ulong usecs;
    uint frame_rate;
    uint frame;
    jack_position_bits_t valid;
    int bar;
    int beat;
    int tick;
    double bar_start_tick;
    float beats_per_bar;
    float beat_type;
    double ticks_per_beat;
    double beats_per_minute;
    double frame_time;
    double next_time;
    uint bbt_offset;
    float audio_frames_per_video_frame;
    uint video_offset;
    int[7] padding;
    c_ulong unique_2;
}

enum JackPositionBits
{
    BBT = 16,
    Timecode = 32,
    FrameOffset = 64,
    AudioVideoRatio = 128,
    VideoFrameOffset = 256,
}
alias jack_position_bits_t = JackPositionBits;
alias jack_unique_t = c_ulong;

alias jack_transport_state_t = JackTransportState;
enum JackTransportState
{
        Stopped = 0,
        Rolling = 1,
        Looping = 2,
        Starting = 3,
        NetStarting = 4,
}

enum JackPortFlags
{
    IsInput = 1,
    IsOutput = 2,
    IsPhysical = 4,
    CanMonitor = 8,
    IsTerminal = 16,
}

alias jack_default_audio_sample_t = float;
alias JackInfoShutdownCallback = void function(JackStatus, const(char)*, void*);
alias JackShutdownCallback = void function(void*);
alias JackFreewheelCallback = void function(int, void*);
alias JackPortRenameCallback = void function(uint, const(char)*, const(char)*, void*);
alias JackPortConnectCallback = void function(uint, uint, int, void*);
alias JackClientRegistrationCallback = void function(const(char)*, int, void*);
alias JackPortRegistrationCallback = void function(uint, int, void*);
alias JackSampleRateCallback = int function(uint, void*);
alias JackBufferSizeCallback = int function(uint, void*);
alias JackXRunCallback = int function(void*);
alias JackGraphOrderCallback = int function(void*);
alias JackThreadInitCallback = void function(void*);
alias JackThreadCallback = void* function(void*);
alias JackProcessCallback = int function(uint, void*);

struct JackLatencyRange
{
align(1):
    uint min;
    uint max;
}

 alias JackLatencyCallback = void function(JackLatencyCallbackMode, void*);
 alias jack_latency_callback_mode_t = JackLatencyCallbackMode;

enum JackLatencyCallbackMode
{
    Capture = 0,
    Playback = 1,
}

alias jack_status_t = JackStatus;
enum JackStatus
{
    Failure = 1,
    InvalidOption = 2,
    NameNotUnique = 4,
    ServerStarted = 8,
    ServerFailed = 16,
    ServerError = 32,
    NoSuchClient = 64,
    LoadFailure = 128,
    InitFailure = 256,
    ShmFailure = 512,
    VersionError = 1024,
    BackendError = 2048,
    ClientZombie = 4096,
}

alias jack_options_t = JackOptions;
enum JackOptions
{
    NullOption = 0,
    NoStartServer = 1,
    UseExactName = 2,
    ServerName = 4,
    LoadName = 8,
    LoadInit = 16,
    SessionID = 32,
}

alias jack_port_type_id_t = uint;
alias jack_port_id_t = uint;
struct _jack_client;
alias jack_client_t = _jack_client;
struct _jack_port;

alias jack_port_t = _jack_port;
alias jack_intclient_t = c_ulong;
alias jack_time_t = c_ulong;
alias jack_nframes_t = uint;
alias jack_shmsize_t = int;
alias jack_uuid_t = c_ulong;

struct imaxdiv_t
{
    c_long quot;
    c_long rem;
}

alias jack_native_thread_t = c_ulong;
