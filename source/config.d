module config;

enum xml;
string configDir = "./config";

/// string list of suffixes for stereo audio streams
enum string[2] stereoChannelNames = ["l","r"];
/// ... 5.1 surround audio streams
enum string[6] surround5_1ChannelNames = ["c","l","r","sw","fl","fr"];
/// ... 5.1 surround audio streams
enum string[8] surround7_1ChannelNames = ["c","l","r","sw","fl","fr","bl","br"];

/// currently mono and stereo are implemented
enum StreamConfigType  
{
    MONO,
    STEREO,
    QUADROPHONIC,
    SURROUND_5_1,
    SURROUND_7_1,
    AMBISONIC
}

/// tells us the configuration of input and output audio ports
struct StreamConfig
{
    /// this is a unique identifier for the ports that make up this stream
    string name;
    /// number of ports needed to represent this logical grouping 
    int numChannels;
    /// because streams with the same number of ports can be used 
    /// in different ways we need to know more than just the 
    /// number of channels
    StreamConfigType type;
}

/// eventually this will be loaded from a configuration file
/// currently this is just a test
StreamConfig[] inputs = [StreamConfig("1",1,StreamConfigType.MONO)];
/// in our test we are going out to stereo speakers / headphones
StreamConfig[] outputs = [{"",2,StreamConfigType.STEREO}];

immutable float OCX,OCY;
float appWidth = 1920;
float appHeight = 1080;

shared static this ()
{
    OCX = 1920.0/appWidth;
    OCY = 1080.0/appHeight;
}

import std.variant : Algebraic;
Algebraic!(int,bool,short[2],float)[string] variables;

@xml int numloopids;
@xml int maxsnapshots;
@xml string librarypath;
@xml int midiouts;
@xml int midisyncouts;
@xml float maxplayvol;
@xml float maxlimitergain;
@xml float limiterthreshhold;
@xml float limiterreleaserate;
@xml float fadermaxdb;
@xml string loopoutformat;
@xml string streamoutformat;
@xml float oggquality;
@xml bool streamfinalmix;
@xml bool streamloopmix;

// alias helper(alias config) = config;
void parseVariable(string var, string value)
{
    import std.traits : getSymbolsByUDA;
    import std.conv : to;
    checkvar: switch(var)
    {

        static foreach (member; getSymbolsByUDA!(config,xml))
        {
            static if (is(typeof(member) == string))
            {
                mixin("case \""~member.stringof~"\": "~member.stringof~" = value; break checkvar;");
            }
            else static if (is(typeof(member) == bool))
            {
                mixin( "case \""~member.stringof~"\": "~member.stringof~" = (value == \"Y\" || value == \"y\" || value == \"true\" || value == \"1\") ? true : false; break checkvar;");
            }
            else static if ( is(typeof(member) == typeof(member.init)) )
            {
                // pragma(msg,"case \""~member.stringof~"\": "~member.stringof~" = to!"~typeof(member).stringof~"(value); break checkvar;");
                mixin("case \""~member.stringof~"\": "~member.stringof~" = to!"~typeof(member).stringof~"(value); break checkvar;");
            }

        }
        default: break;
    }
}

void createStartInterfaceBinding (string conditions, ref string[] outputs, ref string[] parameters)
{

}
void createKeyBinding (string conditions, ref string[] outputs, ref string[] parameters)
{
    
}
void createLoopClickedBinding (string conditions, ref string[] outputs, ref string[] parameters)
{

}

void createSubroutineBinding (string conditions, ref string[] outputs, ref string[] parameters)
{

}
void createJoyButtonBinding (string conditions, ref string[] outputs, ref string[] parameters)
{

}
void createJoyAxisBinding (string conditions, ref string[] outputs, ref string[] parameters)
{

}
void createMidiControllerBinding (string conditions, ref string[] outputs, ref string[] parameters)
{

}
void createMidiProgramChangeBinding (string conditions, ref string[] outputs, ref string[] parameters)
{

}
void createMidiKeyBinding (string conditions, ref string[] outputs, ref string[] parameters)
{

}

void setupInterface(string name)
{
    import std.file : readText;
    import dxml.parser : parseXML,EntityType;
    import std.conv : to;
    import std.array : split;
    import std.algorithm.comparison : min;

    string xml = readText(configDir~"/"~name);
    auto iface = parseXML(xml);
    foreach(ref element; iface)
    {
        if (element.type == EntityType.elementEmpty && element.name == "declare")
        {
            string var;
            string type;
            string init;
            foreach(attr; element.attributes)
            {
                switch (attr.name) 
                {
                    case "var": var = attr.value; break;
                    case "type": type = attr.value; break;
                    case "init": init = attr.value; break;
                    default: break;
                }
            }
            assert(var != "" && type != "" && init != "","ill formed declare element");
            switch (type)
            {
                case "int": variables[var] = to!int(init); break;
                case "char": variables[var] = to!bool(init); break;
                case "float": variables[var] = to!float(init); break;
                case "range": 
                    auto n = init.split(">");
                    assert (n.length == 2,"not a viable range");
                    short[2] r = [to!short(n[0]),to!short(n[1])];
                    variables[var] = r;
                    break;
                default: break;                   
            }
        }
        else if (element.type == EntityType.elementEmpty && element.name == "binding")
        {
            string input;
            string conditions;
            string[] parameters;
            string[] outputs;
            foreach(attr; element.attributes)
            {
                if(attr.name == "input") input = attr.value;
                else if (attr.name == "conditions") configDir = attr.value;
                else if (attr.name[0..min(10,$)] == "parameters") parameters ~= attr.value;
                else if (attr.name[0..min(6,$)] == "output") outputs ~= attr.value;
            }
            switch(input)
            {
                case "start-interface": createStartInterfaceBinding(conditions,outputs,parameters); break;
                case "key": createKeyBinding(conditions,outputs,parameters); break;
                case "loop-clicked": createLoopClickedBinding(conditions,outputs,parameters); break;
                case "go-sub": createSubroutineBinding(conditions,outputs,parameters); break;
                case "joyaxis": createJoyAxisBinding(conditions,outputs,parameters); break;
                case "joybutton": createJoyButtonBinding(conditions,outputs,parameters); break;
                case "midicontroller": createMidiControllerBinding(conditions,outputs,parameters); break;
                case "midiprogramchange" : createMidiProgramChangeBinding(conditions,outputs,parameters); break;
                case "midikey": createMidiKeyBinding(conditions,outputs,parameters); break;
                default: break;
            }
        }
    }

}


shared static this()
{
    import std.file : readText;
    import std.stdio : writeln;
    import dxml.parser : parseXML,EntityType;
    

    string xml = readText(configDir~"/basics.xml");
    auto basics = parseXML(xml);

    foreach(ref element; basics)
    {
        switch (element.type) with (EntityType)
        {
            case elementEmpty:
                if (element.name == "var")
                {
                    auto attribute = element.attributes.front;      
                    parseVariable(attribute.name,attribute.value);              
                }
                break;
            default: break;
        }
    }
    xml = readText(configDir~"/interfaces.xml");
    auto interfaces = parseXML(xml);
    foreach(ref element; interfaces)
    {
        if (element.type == EntityType.elementEmpty && element.name == "interface")
        {
            foreach(attribute; element.attributes)
            {
                if (attribute.name == "setup") setupInterface(attribute.value);
            }
        }
    }

    assert(numloopids == 1024,"init from file not working");
}