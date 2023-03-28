function varargout = Track3DCheck(varargin)
% TRACK3DCHECK MATLAB code for Track3DCheck.fig
%      TRACK3DCHECK, by itself, creates a new TRACK3DCHECK or raises the existing
%      singleton*.
%
%      H = TRACK3DCHECK returns the handle to a new TRACK3DCHECK or the handle to
%      the existing singleton*.
%
%      TRACK3DCHECK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACK3DCHECK.M with the given input arguments.
%
%      TRACK3DCHECK('Property','Value',...) creates a new TRACK3DCHECK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Track3DCheck_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Track3DCheck_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Track3DCheck

% Last Modified by GUIDE v2.5 05-Mar-2019 14:03:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Track3DCheck_OpeningFcn, ...
                   'gui_OutputFcn',  @Track3DCheck_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before Track3DCheck is made visible.
function Track3DCheck_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Track3DCheck (see VARARGIN)

% Choose default command line output for Track3DCheck
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Track3DCheck wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Track3DCheck_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in RightButton.
function RightButton_Callback(hObject, eventdata, handles)
% hObject    handle to RightButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global RightPressed
RightPressed=1;

% --- Executes on button press in WrongButton.
function WrongButton_Callback(hObject, eventdata, handles)
% hObject    handle to WrongButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global WrongPressed
WrongPressed=1;

% --- Executes on button press in LeftLoadButton.
function LeftLoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LeftLoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PathNameLeft
PathNameLeft=uigetfile('*.mp4');
set(handles.TextLoadLeft,'String',PathNameLeft);

% --- Executes on button press in RightLoadButton.
function RightLoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to RightLoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PathNameRight
PathNameRight=uigetfile('*.mp4');
set(handles.TextLoadRight,'String',PathNameRight);


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PathNameLeft
global PathNameRight

load('stereoParams.mat');

obj.readerL = vision.VideoFileReader(PathNameLeft,'ImageColorSpace','Intensity','VideoOutputDataType','uint8');
obj.readerR = vision.VideoFileReader(PathNameRight,'ImageColorSpace','Intensity','VideoOutputDataType','uint8');

 obj.detectorL = vision.ForegroundDetector(...
       'AdaptLearningRate',true,...
       'NumTrainingFrames',10, ... 
       'LearningRate',0.002,...
       'MinimumBackgroundRatio',0.75,...
       'NumGaussians',3,...
       'InitialVariance', 30*30);

 obj.detectorR = vision.ForegroundDetector(...
       'AdaptLearningRate',true,...
       'NumTrainingFrames',10, ... 
       'LearningRate',0.002,...
       'MinimumBackgroundRatio',0.75,...
       'NumGaussians',3,...
       'InitialVariance', 30*30);
   
obj.blobL = vision.BlobAnalysis(...
       'CentroidOutputPort', true, ...
       'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 20);
   
obj.blobR = vision.BlobAnalysis(...
       'CentroidOutputPort', true, ...
       'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 20);
   
shapeInserter = vision.ShapeInserter('Shape','Circles','Fill',true,...
       'FillColor','Custom','CustomFillColor',0);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
radius = 5;

while ~isDone(obj.readerL)
    
        frameL = obj.readerL();
        %frameL = frameL(ceil(rect(2)):ceil(rect(2))+ceil(rect(4)),ceil(rect(1)):ceil(rect(1))+ceil(rect(3)),:);
    
        frameR = obj.readerR();
        %frameR = frameR(ceil(rect(2)):ceil(rect(2))+ceil(rect(4)),ceil(rect(1)):ceil(rect(1))+ceil(rect(3)),:);
    
        %Contrast enhancement
        frameL = imadjust(frameL);
        frameR = imadjust(frameR);
        
        %Rectify stereo images
        [frameLeft,frameRight] = rectifyStereoImages(frameL,frameR,stereoParams,'OutputView','valid');
        
        % Detect foreground.
        maskL = obj.detectorL(frameLeft);
        %maskR = obj.detectorR(frameRight);

        % Apply morphological operations to remove noise and fill in holes.
        maskL = medfilt2(maskL,[5 5]);
        %maskR = medfilt2(maskR,[5 5]);

        % Perform blob analysis to find connected components.
        [centroidsL, bboxesL] = obj.blobL(maskL);
        %[centroidsR, bboxesR] = obj.blobR(maskR);
        
        %[rL,c]=size(centroidsL);
        %radiusL=zeros(rL,1)+3;
        %circleL=uint32([centroidsL radiusL]);
        %outL= shapeInserter(frameLeft, circleL);
        
        %[rR,c]=size(centroidsR);
        %radiusR=zeros(rR,1)+3;
        %circleR=uint32([centroidsR radiusR]);
        %outR= shapeInserter(frameRight, circleR);
        
       position3d=[];
       if(~isempty(centroidsL))
           for i=1:size(centroidsL,1)

                        BBL = bboxesL(i,:);
                        CL = centroidsL(i,:);

                        xl = BBL(1)-15;
                        Xl = BBL(1)+BBL(3)+15;
                        szxl = xl:Xl;

                        yl = BBL(2)-15;
                        Yl = BBL(2)+BBL(4)+15;
                        szyl = yl:Yl;

                        SectL = gpuArray(frameLeft(szyl,szxl));

                        xr = 1;
                        Xr = size(frameRight,2);
                        szxr = xr:Xr;

                        yr = BBL(2)-15;
                        Yr = BBL(2)+BBL(4)+15;
                        szyr = yr:Yr;

                        SectR = gpuArray(frameRight(szyr,szxr));

                        c = normxcorr2(SectL,SectR);

                        [ypeak, xpeak] = find(c==max(c(:)));
                        xoffSet = gather(xpeak) -(size(SectL,2)/2);
                        
                        axes(handles.LeftImage);
                        imshow(frameLeft)
                        hold on
                        rectangle('Position',[xl, yl, length(szxl), length(szyl)],'EdgeColor','y')

                        axes(handles.RightImage);
                        imshow(frameRight)
                        hold on
                        rectangle('Position',[gather(xpeak)-size(SectL,2),yr, length(szxl), length(szyl)],'EdgeColor','y')
                        
                        answer = questdlg('Is the NCC Right?','NCC Menu','Yes','No','No');
                        
                       switch answer 
                           case 'Yes'
                                axes(handles.Track3D);
                                position3d(i,:) = triangulate([CL(1) CL(2)],[xoffSet CL(2)],stereoParams);   
                                scatter3(position3d(:,1),position3d(:,2),position3d(:,3),'filled','MarkerFaceColor','b');
                                xlabel('X(mm)')
                                ylabel('Y(mm)')
                                zlabel('Z(mm)')
                                reset(gpuDevice(1));
                                hold on
                           case 'No' 
                               axes(handles.RightImage)
                                [xi,yi] = getpts();
                                axes(handles.Track3D);
                                position3d(i,:) = triangulate([CL(1) CL(2)],[xi yi],stereoParams);   
                                scatter3(position3d(:,1),position3d(:,2),position3d(:,3),'filled','MarkerFaceColor','b');
                                xlabel('X(mm)')
                                ylabel('Y(mm)')
                                zlabel('Z(mm)')
                                reset(gpuDevice(1));
                                hold on
                       end
               
           end

       end
end
