module jack.port;
import core.stdc.config;

import jack.types : _jack_port, JackLatencyRange, JackLatencyCallbackMode, JackStringList;
import jack.c.jack : jack_port_get_buffer, jack_port_uuid, jack_port_name,
                     jack_port_short_name, jack_port_flags, jack_port_type,
                     jack_port_type_id, jack_port_connected, jack_port_connected_to,
                     jack_port_set_alias, jack_port_unset_alias, jack_port_get_aliases,
                     jack_port_get_latency_range, jack_port_set_latency_range;   

enum BUFFER_SIZE_MAX = 8192;

struct JackPort
{
    import core.stdc.string : strlen;
    @nogc this (_jack_port * port)
    {
        ptr = port;
    }
    @nogc ~this ()
    {
    }
    @property @nogc T[] buffer(T)()
    {
        auto tmp = jack_port_get_buffer(ptr,BUFFER_SIZE_MAX);
        return cast(T[]) tmp[0..BUFFER_SIZE_MAX];
    }
    @property @nogc c_ulong uuid () { return jack_port_uuid(ptr); }
    @property @nogc string name ()
    {
        auto tmp = jack_port_name(ptr);
        return cast(string) tmp[0..strlen(tmp)];
    }
    @property @nogc string shortName ()
    {
        auto tmp = jack_port_short_name(ptr);
        return cast(string) tmp[0..strlen(tmp)];
    }
    @property @nogc int flags() { return jack_port_flags(ptr); }
    @property @nogc string type() 
    {
        auto tmp = jack_port_type(ptr);
        return cast(string) tmp[0..strlen(tmp)];
    }
    @property @nogc uint typeID () { return jack_port_type_id(ptr); }
    @property @nogc int numConnected() { return jack_port_connected(ptr); }
    @nogc bool isConnectedTo(string name) {return cast(bool) jack_port_connected_to(ptr,name.ptr); }
    @nogc void setAlias (string a)
    {
        jack_port_set_alias(ptr,a.ptr);
    }
    @nogc void unsetAlias (string a)
    {
        jack_port_unset_alias(ptr,a.ptr);
    }
    // @property @nogc JackStringList aliases ()
    // {
    //     return JackStringList(jack_port_get_aliases(ptr));
    // }
    
    @property @nogc JackLatencyRange playbackLatency() 
    {
        JackLatencyRange r;
        jack_port_get_latency_range(ptr,JackLatencyCallbackMode.Playback,&r);
        return r;
    }
    @property @nogc void playbackLatency (JackLatencyRange r)
    {
        jack_port_set_latency_range(ptr,JackLatencyCallbackMode.Playback,&r);
    }
    @property @nogc JackLatencyRange recordLatency()
    {
        JackLatencyRange r;
        jack_port_get_latency_range(ptr,JackLatencyCallbackMode.Capture,&r);
        return r;
    }
    @property @nogc void recordLatency(JackLatencyRange r)
    {
        jack_port_set_latency_range(ptr,JackLatencyCallbackMode.Capture, &r);
    }

    package _jack_port * ptr;
}