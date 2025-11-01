
function varargout = RSSprint(varargin)


% initialization starts and GUI Main
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RSSprint_OpeningFcn, ...
                   'gui_OutputFcn',  @RSSprint_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% initialization ends here

%Main Function
function RSSprint_OpeningFcn(hObject, eventdata, handles, varargin)

Image = imread('transback.jpg');
axes(handles.back);
imshow(Image);

handles.output = hObject;


%making icon in our GUI for various features
global backg_image;
backg_image = imresize(imread('play.png'),1);
set(handles.play_with_bg, 'CData', backg_image);
global backg_image2;
backg_image2 = imresize(imread('pause.png'),1);
set(handles.pause_with_bg,'CData',backg_image2);

global backg_image1;
backg_image1=imresize(imread('stop.png'),0.8);
set(handles.stop_with_bg,'CData',backg_image1);

global backg_image3;
backg_image3 = imresize(imread('mute.png'),0.8);
set(handles.mute_with_bg,'CData',backg_image3);
%making album art
music_art = imread('google.jpg');
axes(handles.music_art_bg);
imshow(music_art);
 global backg_image4;
 backg_image4 = imresize(imread('close.png'),0.5);
set(handles.close_music,'CData',backg_image4);
% Update handles structure
guidata(hObject, handles);
function varargout = RSSprint_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%adding feature to play button when pressed
function play_with_bg_Callback(hObject, eventdata, handles)
global slength;
global sminus;
global ssecx;
slength=0;
if(handles.aX == 0)
    play(handles.wav_player);
else
    resume(handles.wav_player);
end
global stimer;
stimer=1;
%REFERENCE CODE 2 STARTS
%REFERENCE URL https://www.mathworks.com/matlabcentral/fileexchange/34455-mp3-player-gui

while(1)
    pause(1);
    if(stimer == 0)
        break;
    end
    if (slength == 1)
        handles.aM = ssecx;
        handles.aN= sminus;
        slength=0;
    end
    handles.aM =  handles.aM + 1;
    if(handles.aM == 60)
            handles.aM = 0;
            handles.aN = handles.aN + 1;
    end
    stop=strcat(num2str(handles.aN),':',num2str(handles.aM));
    set(handles.start_text,'String',stop);
    ssecx = handles.aN*60 + handles.aM;
    if(ssecx >= get(handles.progress_bar,'max'))
        break;
    end
    set(handles.progress_bar,'value',ssecx);
end
%REFERENCE CODE 2 STOP
guidata(hObject, handles);
%adding feature to stop button when pressed
function stop_with_bg_Callback(hObject, eventdata, handles)
stop(handles.wav_player);
handles.aX=0;
global stimer;
stimer=0;
handles.aM=0;
handles.aN=0;
set(handles.start_text,'String','0.00');
set(handles.progress_bar,'value',0);
guidata(hObject, handles);
%adding feature to pause button when pressed
function pause_with_bg_Callback(hObject, eventdata, handles)
pause(handles.wav_player);
handles.aX=1;
global stimer;
stimer=0;
guidata(hObject, handles);

function vol_change_Callback(hObject, eventdata, handles)


function vol_change_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function mute_with_bg_Callback(hObject, eventdata, handles)
guidata(hObject, handles);

function music_list_Callback(hObject, eventdata, handles)

function music_list_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','Black');
end

%this add music button will import music and list to the playlist
function Add_music_Callback(hObject, eventdata, handles)
[filename,path] = uigetfile('*.wav;*.aiff;*.mp3;*.aac;*.ogg;*.pcm','Add Music to music_list','MultiSelect', 'on');
filePath = strcat(path,filename);
[a,b] = audioread(filePath);
wav_player=audioplayer(a,b);
%REFERENCE CODE 1 BEGINS
%ref url https://github.com/andrewda/matlab-audio-player

set(handles.music_list,'String',filename);
aM=get(wav_player,'CurrentSample');
aX=get(wav_player,'TotalSamples');
kprogress=aM/aX;
s=aX/b;
handles.b=b;
set(handles.progress_bar,'max',s);
sminus=fix(s/60);
ssecx=rem(s,60);
stop=strcat(num2str(int8(sminus)),':',num2str(int8(ssecx)));
set(handles.end_text,'String',stop);
global stimer;
stimer=1;
handles.aN=0;
handles.aM=0;
handles.wav_player = wav_player;
handles.aX=0;
guidata(hObject, handles);
%making real time progress bar for real audio player
function progress_bar_Callback(hObject, eventdata, handles)
global sminus;
global ssecx;
global slength;
time_val=get(hObject,'value');
sminus=fix(time_val/60);
ssecx=fix(rem(time_val,60));
slength=1;
s=time_val*handles.b;
stop(handles.wav_player);
play(handles.wav_player,fix(s));
    guidata(hObject, handles);

	%REFERENCE CODE 1 stops
function progress_bar_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function close_music_Callback(hObject, eventdata, handles)
close();
guidata(hObject, handles);
%function for end time timer count
function end_text_Callback(hObject, eventdata, handles)

function end_text_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%function for starting timer count
function start_text_Callback(hObject, eventdata, handles)



function start_text_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function volume_ch_Callback(hObject, eventdata, handles)


function volume_ch_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
