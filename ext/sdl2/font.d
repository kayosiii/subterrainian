module sdl2.font;
import core.stdc.config;

int init()
{
    import sdl2.c.sdl : TTF_Init;
    return TTF_Init();
}

@property bool initialised ()
{
    import sdl2.c.sdl : TTF_WasInit;
    return cast(bool) TTF_WasInit();
}

void quit()
{
    import sdl2.c.sdl :TTF_Quit;
    TTF_Quit();
}

struct SDLFont 
{
    this(string name, int ptSize)
    {
        ptr = TTF_OpenFont(name.ptr, ptSize);
    }   
    this(string name, int ptSize, c_ulong index)
    {
        ptr = TTF_OpenFontIndex(name.ptr,ptSize,index);
    } 
    this(ref SDL_RWops rw, bool freesrc, int ptSize)
    {
        ptr = TTF_OpenFontRW(&rw,freesrc,ptSize);
    }
    this(ref SDL_RWops rw, int freesrc, int ptSize, c_ulong index)
    {
        ptr = TTF_OpenFontIndexRW(&rw,freesrc,ptSize,index);
    }
    ~this()
    {
        TTF_CloseFont(ptr);
    }

    @property int style()
    {
        return TTF_GetFontStyle(ptr);
    }
    @property void style(int st)
    {
        TTF_SetFontStyle(ptr,st);
    }
    @property int outlineSize()
    {
        return TTF_GetFontOutline(ptr);
    }
    @property void outlineSize(int sz)
    {
        TTF_SetFontOutline(ptr,sz);
    }
    @property int hinting()
    {
        return TTF_GetFontHinting(ptr);
    } 
    @property void hinting(int h)
    {
        TTF_SetFontHinting(ptr,h);
    }
    @property int kerning()
    {
        return TTF_GetFontKerning(ptr);
    }
    @property void kerning(int k)
    {
        return TTF_SetFontKerning(ptr,k);
    }
    @property int height()
    {
        return TTF_FontHeight(ptr);
    }
    @property int ascent()
    {
        return TTF_FontAscent(ptr);
    }
    @property int descent()
    {
        return TTF_FontDescent(ptr);
    }
    @property int lineSkip()
    {
        return TTF_FontLineSkip(ptr);
    }
    @property c_ulong numFaces()
    {
        return TTF_FontFaces(ptr);
    }
    @property bool isFixedwidth()
    {
        return cast(bool)TTF_FontFaceIsFixedWidth(ptr);
    }
    @property string familyName ()
    {
        auto tmp = TTF_FontFaceFamilyName(ptr);
        return cast(string) tmp[0..strlen(tmp)];
    }
    @property string styleName ()
    {
        auto tmp = TTF_FontFaceStyleName(ptr);
        return cast(string) tmp[0..strlen(tmp)];
    }
    int kerningSize (int prevIdx , int idx)
    {
        return TTF_GetFontKerningSize(ptr,prevIdx,idx);
    }
    int kerningsizeGlyphs (ushort a, ushort b)
    {
        return TTF_GetFontKerningSizeGlyphs(ptr,a,b);
    }
    int glyphIndex(ushort ch)
    {
        return TTF_GlyphIsProvided(ptr,ch);
    }
    int glyphMetrics(ushort ch, ref int minx, ref int miny, ref int maxx, ref int maxy, ref int advance)
    {
        return TTF_GlyphMetrics(ptr,ch,&minx,&miny,&maxx,&maxy,&advance);
    }
    vec2!int sizeText(string text)
    {
        vec2!int r;
        TTF_SizeText(ptr,text.ptr,&r.x,&r.y);
        return r;
    }
    vec2!int sizeUTF8(string text)
    {
        vec2!int r;
        TTF_SizeUTF8(ptr,text.ptr,&r.x,&r.y);
        return r;
    }
    // SDLSurface renderTextSolid(string s,SDL_Color c)
    // {
    //     return SDLSurface(TTF_RenderText_Solid(ptr,s.ptr,c));
    // }

    // SDLSurface renderUTF8Solid(string s, SDL_Color c)
    // {
    //     return SDLSurface(TTF_RenderUTF8_Solid(ptr,s.ptr,c));
    // }
    // SDLSurface renderGlyphSolid(ushort glyph, SDL_Color c)
    // {
    //     return SDLSurface(TTF_RenderGlyph_Solid(ptr,glyph,c));
    // }
    // SDLSurface renderTextShaded(string s, SDL_Color c1, SDL_Color c2)
    // {
    //     return SDLSurface(TTF_RenderText_Shaded(ptr,s.ptr,c1,c2));
    // }
    // SDLSurface renderUTF8Shaded (string s, SDL_Color c1, SDL_Color c2)
    // {
    //     return SDLSurface(TTF_RenderUTF8_Shaded(ptr,s.ptr,c1,c2));
    // }
    // SDLSurface renderGlyphShaded (ushort glyph, SDL_Color c1, SDL_Color c2)
    // {
    //     return SDLSurface(TTF_RenderGlyph_Shaded(ptr,glyph,c1,c2));
    // }
    // SDLSurface renderTextBlended (string s, SDL_Color c)
    // {
    //     return SDLSurface(TTF_RenderText_Blended(ptr,s.ptr,c));
    // }
    // SDLSurface renderUTF8Blended (string s, SDL_Color c)
    // {
    //     return SDLSurface(TTF_RenderUTF8_Blended(ptr,s.ptr,c));
    // }
    // SDLSurface renderGlyphBlended (ushort glyph, SDL_Color c)
    // {
    //     return SDLSurface(TTF_RenderGlyph_Blended(ptr,glyph,c));
    // }
    _TTF_Font * ptr;

    import core.stdc.string : strlen;
    import vectortype;
    import sdl2.c.sdl : TTF_OpenFont, TTF_OpenFontIndex, TTF_OpenFontRW, 
                        TTF_OpenFontIndexRW, TTF_GetFontStyle, TTF_SetFontStyle,
                        TTF_GetFontOutline, TTF_SetFontOutline, TTF_GetFontHinting,
                        TTF_SetFontHinting, TTF_FontHeight, TTF_FontAscent,
                        TTF_FontDescent, TTF_FontLineSkip, TTF_GetFontKerning,
                        TTF_SetFontKerning, TTF_FontFaces, TTF_FontFaceIsFixedWidth,
                        TTF_FontFaceFamilyName, TTF_FontFaceStyleName, TTF_GlyphIsProvided, 
                        TTF_GlyphMetrics, TTF_SizeText, TTF_SizeUTF8, TTF_SizeUNICODE,
                        TTF_RenderText_Solid, TTF_RenderUTF8_Solid, TTF_RenderUNICODE_Solid,
                        TTF_RenderGlyph_Solid, TTF_RenderText_Shaded, TTF_RenderUTF8_Shaded,
                        TTF_RenderUNICODE_Shaded, TTF_RenderGlyph_Shaded, TTF_RenderText_Blended,
                        TTF_RenderUTF8_Blended, TTF_RenderUNICODE_Blended, TTF_RenderText_Blended_Wrapped,
                        TTF_RenderUTF8_Blended_Wrapped, TTF_RenderUNICODE_Blended_Wrapped, 
                        TTF_RenderGlyph_Blended, TTF_CloseFont, TTF_GetFontKerningSize,
                        TTF_GetFontKerningSizeGlyphs;
    import sdl2.c.types : _TTF_Font;
    public import sdl2.c.types : SDL_RWops, SDL_Color;
    import sdl2.surface : SDLSurface;
}