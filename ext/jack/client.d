module jack.client;

import core.stdc.config;
import core.stdc.stdarg;

import nogc.exception: enforce;

import jack.types : _jack_client, _jack_port, jack_transport_info_t, JackOptions, JackStatus, JackThreadCallback,
                      JackThreadInitCallback, JackShutdownCallback, JackInfoShutdownCallback,
                      JackProcessCallback, JackFreewheelCallback, JackBufferSizeCallback, 
                      JackSampleRateCallback, JackPortConnectCallback, JackPortRenameCallback, 
                      JackXRunCallback, JackLatencyCallback, JackClientRegistrationCallback,
                      JackPortRegistrationCallback, JackGraphOrderCallback,JackTimebaseCallback,
                      JackTransportInfo,JackStringList;
import jack.c.jack : jack_set_transport_info, jack_transport_start, jack_transport_stop, jack_set_sync_timeout,
                     jack_client_open, jack_client_close, jack_get_client_name, jack_client_name_size,
                     jack_client_thread_id, jack_is_realtime, jack_set_freewheel, jack_set_buffer_size,
                     jack_get_buffer_size, jack_get_sample_rate, jack_cpu_load, jack_activate,
                     jack_deactivate, jack_cycle_wait, jack_cycle_signal, jack_set_process_thread,
                     jack_set_thread_init_callback, jack_on_shutdown, jack_on_info_shutdown, 
                     jack_set_process_thread, jack_set_freewheel_callback, jack_set_buffer_size_callback,
                     jack_set_sample_rate_callback, jack_set_client_registration_callback, 
                     jack_set_port_registration_callback, jack_set_port_connect_callback, jack_set_port_rename_callback,
                     jack_set_graph_order_callback, jack_set_xrun_callback, jack_set_latency_callback,
                     jack_set_timebase_callback, jack_port_register, jack_port_unregister, jack_port_by_id,
                     jack_connect, jack_disconnect, jack_port_disconnect, jack_get_ports, jack_frames_since_cycle_start,
                     jack_frame_time, jack_last_frame_time, jack_get_cycle_times, jack_set_process_callback,
                     jack_port_by_name, jack_recompute_total_latencies, jack_frames_to_time, jack_time_to_frames;
import jack.port : JackPort;

@trusted @nogc:
/// wraps a _jack_client pointer - to give a much more 
/// D like experience using libjack.
/// this one is the main entry point for most of the basic functions
/// in libjack. Readabilty of code using this is a priority
 struct JackClient
{
    @disable this(this);
    struct JackTransport 
    {
        package JackTransportInfo info_; 
        // @property void info (ref jack_transport_info_t i) {jack_set_transport_info(ptr,&info_);}
        // @property jack_transport_info_t info() { }
        // void stop() {jack_transport_stop(ptr);}
        // void start() {jack_transport_start(ptr);}
        // int reposition() {}
        // @property currentFrame() {}
        // void query() {}
        // void locate() {}
        // @property void syncTimeout(c_ulong t) {jack_set_sync_timeout(t);}
        // @property syncCallback() {}
    }
    JackTransport transport;

    /// call jack_client_open and collect the pointer
    this(string name, JackOptions options, ref JackStatus status) @nogc
    {
        ptr = jack_client_open(&name[0], options, null);
        // enforce(ptr != null, "could not open jack client");
    }
    ~this() @nogc
    {
        jack_client_close(ptr);
    }
    /// sanity check to see if actually points to a valid 
    ///  
    @property empty() @nogc { return (ptr != null); }
    
    @property string name() @nogc
    {
        auto tmp = jack_get_client_name(ptr);
        return cast(string) tmp[0..jack_client_name_size()];
    }
    @property c_ulong threadID() { return jack_client_thread_id(ptr); }
    @property bool isRealtime() { return cast(bool) jack_is_realtime(ptr); }
    @property void freewheel(int i) {jack_set_freewheel(ptr,i); }
    @property void bufferSize(uint i) { jack_set_buffer_size(ptr,i); }
    @property uint bufferSize() { return jack_get_buffer_size(ptr); }
    @property uint sampleRate() { return jack_get_sample_rate(ptr); }
    @property float cpuLoad() { return jack_cpu_load(ptr); }

    @nogc void activate() {jack_activate(ptr);}
    @nogc void deactivate() {jack_deactivate(ptr);}

    @nogc void cycleWait() { jack_cycle_wait(ptr); }
    @nogc void cycleSignal( int sig) { jack_cycle_signal(ptr,sig); }
    
    @nogc void setProcessThread (JackThreadCallback fun, void * arg) { jack_set_process_thread(ptr,fun,arg=null);}
    @nogc @property void threadInitCallback(JackThreadInitCallback fn) { jack_set_thread_init_callback(ptr,fn,null); }
    @nogc void setThreadInitCallback(JackThreadInitCallback fn, void * arg ) { jack_set_thread_init_callback(ptr,fn,arg); }
    @nogc @property void onShutdownCallback(JackShutdownCallback fn) { jack_on_shutdown(ptr,fn,null); }
    @nogc void setOnShutdownCallback (JackShutdownCallback fn, void * arg) { jack_on_shutdown(ptr,fn,arg); }
    @property @nogc void onInfoShutdownCallback(JackInfoShutdownCallback fn) { jack_on_info_shutdown(ptr,fn,null);}
    @nogc void setOnInfoShutdownCallback (JackInfoShutdownCallback fn, void * arg ) { jack_on_info_shutdown(ptr,fn,arg);}
    @property @nogc void processCallback(JackProcessCallback fn) { jack_set_process_callback(ptr,fn,null); }
    @nogc void setProcessCallback(JackProcessCallback fn, void * arg ) { jack_set_process_callback(ptr,fn,arg); }
    @property @nogc void freewheelCallback(JackFreewheelCallback fn) { jack_set_freewheel_callback(ptr,fn,null); }
    @nogc void setFreewheelCallback(JackFreewheelCallback fn, void * arg ) { jack_set_freewheel_callback(ptr,fn,arg); }
    @property @nogc void bufferSizeCallback(JackBufferSizeCallback fn) { jack_set_buffer_size_callback(ptr,fn,null); }
    @nogc void setBufferSizeCallback(JackBufferSizeCallback fn, void * arg) { jack_set_buffer_size_callback(ptr,fn,arg); }
    @property  @nogc void sampleRateCallback(JackSampleRateCallback fn) { jack_set_sample_rate_callback(ptr,fn,null); }
    @nogc void setSampleRateCallback(JackSampleRateCallback fn, void * arg) { jack_set_sample_rate_callback(ptr,fn,arg); }
    @property @nogc void clientRegistrationCallback(JackClientRegistrationCallback fn) { jack_set_client_registration_callback(ptr,fn,null); }
    @nogc void setClientRegistrationCallback(JackClientRegistrationCallback fn, void * arg ) { jack_set_client_registration_callback(ptr,fn,arg); }
    @property @nogc void portRegistrationCallback(JackPortRegistrationCallback fn) { jack_set_port_registration_callback(ptr,fn,null); }
    @nogc void setPortRegistrationCallback(JackPortRegistrationCallback fn, void * arg) { jack_set_port_registration_callback(ptr,fn,arg); }
    @property @nogc void portConnectCallback(JackPortConnectCallback fn) { jack_set_port_connect_callback(ptr,fn,null); }
    @nogc void setPortConnectCallback(JackPortConnectCallback fn, void * arg ) { jack_set_port_connect_callback(ptr,fn,arg); }
    @property @nogc void portRenameCallback(JackPortRenameCallback fn) { jack_set_port_rename_callback(ptr,fn,null); }
    @nogc void setPortRenameCallback(JackPortRenameCallback fn, void * arg) { jack_set_port_rename_callback(ptr,fn,arg); }
    @property @nogc void graphOrderCallback(JackGraphOrderCallback fn) { jack_set_graph_order_callback(ptr,fn,null); }
    @nogc void setGraphOrderCallback(JackGraphOrderCallback fn, void * arg = null) { jack_set_graph_order_callback(ptr,fn,arg); }
    @property @nogc void xRunCallback(JackXRunCallback fn)  { jack_set_xrun_callback(ptr,fn,null); }
    @nogc void setXRunCallback(JackXRunCallback fn, void * arg = null)  { jack_set_xrun_callback(ptr,fn,arg); }
    @property @nogc void latencyCallback(JackLatencyCallback fn) { jack_set_latency_callback(ptr,fn,null); }
    @nogc void setLatencyCallback(JackLatencyCallback fn, void * arg = null) { jack_set_latency_callback(ptr,fn,arg); }
    @property @nogc void timebaseCallback(JackTimebaseCallback fn) { jack_set_timebase_callback(ptr,false,fn,null);}
    @property @nogc void conditionalTimebaseCallback(JackTimebaseCallback fn) {jack_set_timebase_callback(ptr,true,fn,null); }
    @nogc void setTimebaseCallback(bool conditional, JackTimebaseCallback fn,void * arg) { jack_set_timebase_callback(ptr,conditional,fn,arg);}

    @nogc JackPort registerPort ( string portName, string portType, ulong flags, ulong bufferSize=0)
    {
        return JackPort(jack_port_register(ptr,portName.ptr, portType.ptr, flags, bufferSize));
    }

    @nogc void unregisterPort (JackPort port)
    {
        jack_port_unregister(ptr, port.ptr);
    }

    @nogc JackPort getPort(string name)
    {
        return JackPort(jack_port_by_name(ptr,name.ptr));
    }   

    @nogc JackPort getPort(uint id)
    {
        return JackPort(jack_port_by_id(ptr,id));
    }

    @nogc void connect(string srcPort, string dstPort)
    {
        jack_connect(ptr,srcPort.ptr,dstPort.ptr);
    }
    @nogc void disconnect(string srcPort, string dstPort)
    {
        jack_disconnect(ptr,srcPort.ptr, dstPort.ptr);
    }
    @nogc void disconnect(JackPort port)
    {
        jack_port_disconnect(ptr,port.ptr);
    }

    @nogc void recomputeTotalLatencies() { jack_recompute_total_latencies(ptr); }

    @nogc JackStringList getPorts(string portNamePattern, string typeNamePattern, c_ulong flags)
    {
        return JackStringList(jack_get_ports(ptr,portNamePattern.ptr,typeNamePattern.ptr,flags));
    }
    @nogc @property uint framesSinceCycleStart() { return jack_frames_since_cycle_start(ptr); }
    @nogc @property uint frameTime() { return jack_frame_time(ptr); }
    @nogc @property uint lastFrametime() {return jack_last_frame_time(ptr); }

    @nogc c_ulong toTime(uint frames) { return jack_frames_to_time(ptr,frames); }
    @nogc uint toFrames(c_ulong time) { return jack_time_to_frames(ptr,time); }

    @nogc void cycleTimes( ref uint currentFrames, ref c_ulong currentUSecs, ref c_ulong nextUSecs, ref float periodUSecs)
    {
        jack_get_cycle_times(ptr, &currentFrames, &currentUSecs, &nextUSecs, &periodUSecs);
    }

    package _jack_client * ptr;
}