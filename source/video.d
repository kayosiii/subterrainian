module video;
import vectortype;
import core.thread : Thread;
import core.sync.mutex : Mutex;
import core.time : msecs, Duration;

import std.conv : emplace;

import sdl2.core, sdl2.window, sdl2.renderer;
import memory;

import sdl2.c.types: SDL_Color;

void start() @trusted nothrow
{
    thread.start();
}

void stop() @nogc @trusted nothrow
{
    _running = false;
    while(thread.isRunning) Thread.sleep(msecs(10));
}

// int drawText (ref SDLSurface outSurface, ref SDLFont font, 
//               string str, vec2!int pos, SDL_Color c, 
//               vec2!byte justify, ref vec2!int s)
// {
    
//     SDL_Color black = {0,0,0,0};
//     SDLSurface text = font.renderTextShaded(str,c,black);
//     SDL_Rect dsrect = {pos.x,pos.y,text.w,text.h};
//     if (s.x != 0) s.x = pos.x;
//     if (s.y != 0) s.y = pos.y;
//     if (justify.x) dsrect.x -= (justify.x == 1 ? dsrect.w/2 : dsrect.w);
//     if (justify.y) dsrect.y -= (justify.y == 1 ? dsrect.h/2 : dsrect.h);
//     text.colorKey = SDL_SRCCOLORKEY|SDL_RLEACCEL;
//     text.Blit(outSurface,dsrect);
//     destroy(text);
// }

// pragma(inline, true)
// vec2!int Convert(vec2!float p) pure nothrow @safe @nogc 
// {
//     return  vec2!int(cast(int)(p.x*screen.w),cast(int)(p.y*screen.h));
// }

// vec2!int OConvert( vec2!int p)
// {
//     return Convert(vec2!float(cast(float)(p.x/screen.w),cast(float)(p.y/screen.h)));
// }



void drawLoop ()
{
    // background
    // fill the surface texture with a background color;
    // the whole thing
    //renderer.fillRect()

    // compute current peak
    // index = loop.current_sample / peak_chunk_size; // find the peak or average corresponding 
    // // to current playback frame
    // currentpeakIndex[currentLoop] = index;
    // //check to see if nothing has changed


    // // Write into the buffer on sliding position to give animated
    // // scope effect 
    // // ispeed = surface.width / number of_peak_samples;
    // // index = number of audio samples in loop;
    // auto Δ = -cast(float)loop.length*incrementSpeed;
    // pos = pos - Δ > 0.0 ? pos - Δ : pos - Δ + surface.w;
    // foreach(j, peak; peaks)
    // {
    //     pos += incrementSpeed;
    //     if (incrementSpeed > 1.0)
    //         fillRect 
    //             pos, midpoint - peak*magnication,
    //             pos + incrementSpeed, midpoint + peak*magnification
    //             color;
    //     else 
    //         drawVLine pos midpoint - peak*magnification,
    //         midpoint + peak*magnification 
    //         color
    //     // magnifaction = loop_volume called from function * loop.volume * lscopeMag(OCY20) * current peak
    // }
    // loopMap.map(output_memory,direct.x,direct.y);
    //     half = loopMap.size[]/2;
    //     circle(output_memory,direct[]+half[],half.x,color);
    //     pieRadius = min(lvol*looppiemag*currentPeak,70);
    //     pie(output_memory,direct[]+half[],pieRadius,0,360*loop.pos,color);
    // // draw box for volume and Δvolume 
    // draw overdub marker
    // draw text
}
// bool drawLoop (ref SDLRenderer renderer, ref SDLSurface lscopepic, ref SDL_Color[] loopColors,
//                float colorMag, CircularMap directMap, vec2!int direct_pos, float lvol, bool drawText)
// {
    // immutable static SDL_Color textColor = {0xFF, 0x50, 0x20, 0};
    // immutable static SDL_Color cursorColor = {0xEF, 0x11, 0x11, 0};
    // immutable static SDL_Color textColor2 = { 0xEF, 0xAF, 0xFF, 0};
    // immutable static SDL_Color[4] selColor = [ {0xF9,0xE6,0x13,0},
    //                                  {0x62,0x62,0x62,0},
    //                                  {0xFF,0xFF,0xFF,0},
    //                                  {0xE0,0xDA,0xD5,0} ];    
    // immutable float cPeakMul = 2.0, cPeakBase = 0.5;
    // const int lScopeMaxMagnification = 0;

    // float currentPeak = 1.0;
    // float ispd;
    // jack_sample_t[] peakBuffer, averagesBuffer;
    // static int lineY = -1;

    // loops.lock();
    // Loop loop;
    // if (loops.status == LoopStatus.RECORDING)
    // {
    //     LoopRecorder rec = loops.getRecorder(i);
    //     peaksBuffer = rec.peaks;
    //     averagesBuffer = rec.averages;
    // }
    // else
    // {
    //     loop = loops.getLoop(i);
    //     if (!loop.empty) 
    //     {
    //         peaksBuffer = loop.peaks;
    //         averagesBuffer = loop.averages;
    //     }
    // }
    // bool selected = false;
    // if(!loop.empty && loop.selectionCount > 0)
    // {
    //     selected = true;
    //     loopColors = selectedcolor;
    // }
    // float loopVolume = 1.0;
    // float ΔLoopVolume = 1.0;
    // if (peaksBuffer.length > 0)
    // {
    //     loopVolume = 
    //     // renderer.fillRect(mapRGB);

    //     currentPeakIndex[i] = index;
    //     if (currentPeakIndex[i] == lastPeakIndex[i]) 
    //     {
    //         currentPeak = oldPeak;
    //     }
    //     else 
    //     {
    //         jack_nframes_t j = lastPeakIndex[i];
    //         if (currentPeakIndex[i] < lastPeakIndex[i]) j = 0;
    //         currentPeak = 0;
    //         foreach(k;j..currentPeakIndex[i])
    //             currentPeak = max(currentPeak,peakBuffer[k]*loopVolume);
    //         currentPeak = currentpeak * currentPeakMultiplier + currentPeakBase;
    //         oldPeak[i] = currentPeak;
    //         lastPeakIndex[i] = currentPeakIndex[i];
    //     }
    //     float cMag = lvol*loopvol*lscopemag*currentPeak;
    //     vec3!float v1 = loopColors[1][]*colorMag;
    //     vec3!float v2 = loopColors[2][]*colorMag;
    //     int midpoint = lScopePic.h/2;
    //     ispd = cast(float) lScopePic.w * peakBuffer.length;

    //     float pos = (cast(float)index)*ispd*-1.0;
    //     if (pos < 0.0f) pos += cast(float)lScopePic.w;
    //     for (jack_nframes_t j = 0; j < peakBuffer.length; j++, pos+=ispd)
    //     {
    //         float peak = peakBuffer[j];
    //         int peakd = min( cast(int)(cmag*peak), lScopeMaxMagnification);
    //         if (pos >= lScopePic.w) pos = 0.0;
    //         float peaky = min(averagesBuffer[j]/(peak*peak + 0.000_000_01)*2.0,1.0);
    //         vec3!float v; 
    //         v[] = v1[]*peaky + v2[]*(1.0-peaky);
    //         if (ispd >= 1.0)
    //         {
    //             int pos1 = cast(int) pos;
    //             int pos2 = cast(int) (pos+ispd);
    //             // renderer.fillRect({pos1,midpoint-peakd},{pos2,midpoint+peakd},)
    //         }
    //         else 
    //         {
    //             // renderer.drawVLine({cast(int) pos, midpoint - peakd }, midpoint + peakd)
    //         }

    //     }
    // } 
    // CircularMap loopMap;
    // vec2!int diplay;
    // if (curEl != 0)
    // {
    //     loopMap = curEl.loopMap;
    //     display = curEl.position;
    // }       
    // else 
    // {
    //     loopMap = directMap;
    //     display = directPosition;
    // }
    // vec2!int full = loopMap.mapSize;
    // vec2!int half; 
    // half[] = full[] / 2;
    // if (currentElement) diplay[] -= half[];

    // loopMap.createMap();
    // // renderer.drawCircle(display[]+half[],half.x,{0,0,0,255});
    // int pieRadius = min(cast(int)(lvol*loopPieMagnification*currentPeak),70);
    // // renderer.fillPie(display[]+half[],pieRadius,0,);

    // float loopVolumeMagnification = full.x*0.9/2.0;
    // float loopΔVolumeMagnification = full.x*250.0;
    // int magBar = cast(int) (loopVolumeMagnification*loops.getTriggerVolume(i));
    // // renderer.fillRect(
    // //     {display.x+half.x-magBar, display.y+(4/5*half.y)},
    // //     {display.x+half.x+magBar, display.y+(3/2*half.y)},
    // //     SDL_Color(cast(int)loopColors[3].r*colorMag,0,0,127)
    // //     );
    // magBar = cast(int) ((loopΔVolume-1.0)*loopΔVolumeMagnification);
    // // renderer.fillRect(

    // // );
    // // if (loops.status == LoopStatus.OVERDUBBING) draw text 0;
    // if (drawText)
    // {
    //     ItemRenamer renamer = loops.renamer;
    //     if (loop = loops.renameLoop)
    //     {
    //         RenameUIVars rui = renamer.updateUIVars();
    //         if (lineY == -1) smallfont.sizeText(VERSION,0,lineY);
    //         vec2!int s;
    //         int textY = display.y + full.y;
    //         if (renamer.currentName.length > 0)
    //             drawText(smallfont,renamer.currentName,vec2!int(display.x,display.y+full.y),textColor2,0,2,s);
    //         else 
    //             s[] = [0,lineY];
            
    //         if(rui.renameCursorToggle)
    //         {
    //             renderer.fillRect(vec2!int(disp.x+s.x,textY),vec2!int(disp.x+s.x+s.y/2,textY-s.y),cursorColor);

    //         } 
    //     }
    //     else if (loop.name.length > 0)
    //     {
    //         drawText(smallfont,loop.name,vec2!int(disp.x,disp.y+full.y,textColor2,0,2));
    //         int count = 0;
    //         // show last recorded loop
    //     }
    //     loops.unlock();
    //     return RET.success;
    // }
    // loops.unlock();
    // return RET.failure;     
// }

shared static this()
{
    lock = memory.allocator.make!Mutex();
    thread = memory.allocator.make!Thread(&run_thread,128*1024);
    //thread.priority = Thread.PRIORITY_MIN;
    thread.name = "Video";
}

shared static ~this()
{
    memory.allocator.dispose(thread);
    memory.allocator.dispose(lock);
}

Thread thread;
__gshared Mutex lock;
__gshared bool _running;
SDLRect!int screen = {100,100,100,100};
immutable delay = msecs(40);

SDLWindow window = void;
SDLRenderer renderer = void;

void run_thread() @nogc @trusted
{
    video._running = true;

    synchronized (lock)
    {
        emplace(&window,"subterrainian",screen,SDL_WindowFlags.SHOWN);
        renderer = window.createRenderer(0,SDL_RendererFlags.ACCELERATED);
    }

    while (_running)
    {
        synchronized (lock)
        {
            renderer.clear();
            renderer.present();
            renderer.color = SDL_Color(0,0,0,255);
            Thread.sleep(delay);
        }
    }
}
