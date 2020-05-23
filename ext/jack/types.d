module jack.types;

public import jack.c.types;

/// wrap the char** null terminated string list that 
/// some jack functions return and make sure
/// that the memory gets returned when this 
/// object goes out of scope.
struct JackStringList 
{
    import core.stdc.string : strlen;
    /// stores the strings in a way that is D friendly
    string[] list;
    alias list this;

    @disable this(this);

    /// wrap null terminated list of char pointers
    /// calculate string lengths, add slices
     this(const(char) ** chrs ) @nogc @trusted
     {
        import core.stdc.stdlib : malloc;
        import core.stdc.string : strlen;
        
        size_t n = 0;
        for(auto c = chrs; (c != null) && (*c != null); *c++) n++;

        list = cast(string[]) malloc(n*string.sizeof)[0..n];

        auto ch = chrs;
        foreach (ref item; list)
        {
            item = cast(string) (*ch)[0..strlen(*ch)];
            (*ch)++;
        }
    }    
    ~this() @nogc @trusted
     {
        import jack.c.jack : jack_free;
        import core.stdc.stdlib: free;
        
        jack_free(cast(char**) &list[0][0]);
        free(cast(void*)list);
     }
}