module vectortype;

struct vec2(T)
{
    this(T[2] d)
    {
        data = d;
    }
    this (T x, T y)
    {
        this.x = x;
        this.y = y;
    }
    union
    {
        struct {T x; T y;}
        struct {T w; T h;}
        T[2] data;
    }
    alias data this;
    void opAssign (T[2] v)
    {
        data = v;
    }
    auto opBinary(string op)(const (T) rhs) const
    {
        mixin("return vec2!T(x"~op~"rhs,y"~op~"rhs);");
    }
}

struct vec3(T)
{
    union
    {
        struct {T x; T y; T z;}
        struct {T r; T g; T b;}
        T[3] data;
    }
    alias data this;
    void opAssign (T[3] v)
    {
        data = v;
    }
}

struct vec4(T)
{
    union
    {
        struct {T x; T y; T z; T w; }
        struct {T r; T g; T b; T a; }
        T[4] data;
    }
    alias data this;
    void opAssign (T[4] v)
    {
        data = v;
    }
}