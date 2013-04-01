function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 22-Feb-2013 02:20:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to UI (see VARARGIN)

    global directory_selection kinect_value initialize points_selected frame_number bounding_box_p1 bounding_box_p2 tracking_started ;
    global offset_1_2 offset_1_3 offset_1_4 timestamp_cam1 timestamp_cam2 timestamp_cam3 timestamp_cam4 valid_view;
    timestamp_cam1 = load('127A_timestamps');
    timestamp_cam2 = load('123A_timestamps');
    timestamp_cam3 = load('104A_timestamps');
    timestamp_cam4 = load('51B_timestamps');
    
    offset_1_2 = 8505;
    offset_1_3 = -22821;
% %     offset_1_3 = -31026;
    offset_1_4 = -9218;
    
    directory_selection=0;
    initialize =0;
    frame_number=0;
    kinect_value=1;
    valid_view =0;
    points_selected = 0;
    tracking_started =0;
    bounding_box_p1 = [100, 100];
    bounding_box_p2 = [150, 150];
    % Choose default command line output for UI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes UI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);

    % --- Outputs from this function are returned to the command line.
    function varargout = UI_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on button press in pushbutton1. Start of video...
function pushbutton1_Callback (hObject, eventdata, handles)
    global fid  tracking_started directory_selection directory kinect_value flag frame_number  initialize numFrames points_selected limit_length bounding_box_p1 bounding_box_p2 x_plot y_plot filename_1_prefix filename_2_prefix filename_3_prefix filename_4_prefix  old_head img_x img_y gm_child draw_offset  x y head_depth reinitializing_number;
    if(directory_selection == 1)
        initialize=1;
        frame_number=1;
        points_selected = 0;      
% %         how many times have u set the face tracker...
        reinitializing_number =0; 
        
    % % Get the number of frames.
        numFrames = 42056;
        filename_1_prefix = strcat(directory,'/','USB-VID_045E&PID_02AE-A00364A04906127A_');
        filename_2_prefix = strcat(directory,'/','USB-VID_045E&PID_02AE-A00367A14179123A_');
        filename_3_prefix = strcat(directory,'/','USB-VID_045E&PID_02AE-A00365A09389104A_');
        filename_4_prefix = strcat(directory,'/','USB-VID_045E&PID_02AE-B00362214481051B_');
        fid = fopen('centres.txt', 'a');
    % % Create a figure
          hf = handles.axes1; 
    % % Resize figure based on the video's width and height
          set(hf)
        
        flag=1;
        while(flag==1 && (frame_number <numFrames))
            if(tracking_started ==1)
                [x_plot,y_plot,old_head,img_x,img_y,gm_child,draw_offset, x,y,head_depth] = get_bounding_box(directory,frame_number,old_head,img_x,img_y,gm_child,draw_offset, x,y,head_depth,limit_length,kinect_value);
                     
                
            end
            if(kinect_value ==1)
                file = strcat(filename_1_prefix,int2str(frame_number),'.mat');
            elseif(kinect_value ==2)
                file = strcat(filename_2_prefix,int2str(frame_number),'.mat');
            elseif(kinect_value ==3)
                file = strcat(filename_3_prefix,int2str(frame_number),'.mat');
            else 
                file = strcat(filename_4_prefix,int2str(frame_number),'.mat');
            end
            mat_data = load(file, '-mat','ColorFrame');
            drawnow update;
            imshow(mat_data.ColorFrame.ColorData,'Parent',hf);
            hold on;
            if(tracking_started ==1)
                plot(x_plot,y_plot,'r','LineWidth',2);
            end
            pause(0.25);
            frame_number = frame_number + 1;
        end
    end
        
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    space_function();


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    switch eventdata.Key
      case 'space'
        space_function(handles);
      case 'return'
        resume_function(handles);
    end

% --- Executes on button press in pushbutton2.
function space_function(handles)
    global flag  directory frame_number points_selected initialize x_plot y_plot old_head img_x img_y gm_child draw_offset limit_length x y head_depth min_depth max_depth tracking_started reinitializing_number kinect_value;
    flag=0;
    if(initialize==1)
%         [x,y] = ginput(2,'Color', 'r', 'LineWidth', 3);
        [x,y] = ginput(2);
% % %         plot(x(1),y(1),'r*');
% % %         plot(x(2),y(2),'r*');
% % %         rectangle('Position',[x(1),y(1),x(2)-x(1),y(2)-y(1)]);
    end
    points_selected=1;
    [x_plot,y_plot,old_head,img_x,img_y,gm_child,draw_offset, x,y,head_depth,limit_length,min_depth ,max_depth] = set_bounding_box(directory,frame_number,x,y,gm_child,reinitializing_number,kinect_value);
    reinitializing_number = reinitializing_number   + 1;
    plot(x_plot,y_plot,'r','LineWidth',2);
    tracking_started =1;
    
% --- Executes on button press in pushbutton3.
function resume_function(handles)
    global fid directory  tracking_started flag frame_number kinect_value initialize numFrames points_selected bounding_box_p1 bounding_box_p2 min_depth max_depth limit_length x_plot y_plot filename_1_prefix filename_2_prefix filename_3_prefix filename_4_prefix old_head img_x img_y gm_child draw_offset  x y head_depth ;
    global offset_1_2 offset_1_3 offset_1_4 timestamp_cam1 timestamp_cam2 timestamp_cam3 timestamp_cam4 valid_view ;
    flag=1;
    if(initialize ==1 && points_selected==1)
        fprintf(fid, '\n\n');
        points_selected = 0;
        hf = handles.axes1; 
        set(hf);
        while( flag ==1 && frame_number <numFrames)
            if(tracking_started ==1)
             [x_plot,y_plot,old_head,img_x,img_y,gm_child,draw_offset, x,y,head_depth,min_depth ,max_depth] = get_bounding_box(directory,frame_number,old_head,img_x,img_y,gm_child,draw_offset, x,y,head_depth,limit_length,min_depth ,max_depth,kinect_value);                
            end
            if(kinect_value ==1)
                file = strcat(filename_1_prefix,int2str(frame_number),'.mat');
            elseif(kinect_value ==2)
                file = strcat(filename_2_prefix,int2str(frame_number),'.mat');
            elseif(kinect_value ==3)
                file = strcat(filename_3_prefix,int2str(frame_number),'.mat');
            else 
                file = strcat(filename_4_prefix,int2str(frame_number),'.mat');
            end
            mat_data = load(file, '-mat','ColorFrame');
            drawnow update;
            cla reset;
            imshow(mat_data.ColorFrame.ColorData,'Parent',hf);
            hold on;
            if(tracking_started ==1)
                plot(x_plot,y_plot,'r','LineWidth',2);
                
                                                %       hdl = get(0,'CurrentFigure');
                f=getframe(handles.axes1);               %select axes in GUI
                                                % % % % %     figure();                                          %new figure
                                                % % % % %     image(F.cdata);                                %show selected axes in new figure

                                                % % % % % % f = getframe(gcf);
                [im,map] = frame2im(f);
% % %                 imwrite(im,fullfile(['/Users/karanjitcheema/Desktop/RA_Work/results/baby_face_',num2str(frame_number,'%05d.jpg')]));
                                                % % % % % % % %     saveas(gcf, fullfile(directory,['baby_face_',num2str(frame_number,'%05d.jpg')]));%save figure
                                                % % % % % % % %     close(gcf);                                       %and close it
                                                %                 saveas(hdl,fullfile(directory,['baby_face_',num2str(frame_number,'%05d.jpg')]));

                                                % % %             saving the centre and the width height of the face's
                                                % bounding box...
                unique_x_values(1) = max(x_plot);
                unique_x_values(2) = min(x_plot);
                width = abs(unique_x_values(2)- unique_x_values(1));
                unique_y_values(1) = max(y_plot);
                unique_y_values(2) = min(y_plot);
                height = abs(unique_y_values(2)- unique_y_values(1));
                centre(1) = (width/2  + unique_x_values(2) );
                centre(2) = (height/2  + unique_y_values(2) );
                if(kinect_value == 1)
                    time_acc_to_cam_1  = timestamp_cam1.mystruct(frame_number).value ;
                elseif(kinect_value == 2)
                    time_acc_to_cam_1   = timestamp_cam2.mystruct(frame_number).value  - offset_1_2 ;
                elseif(kinect_value == 3)
                    time_acc_to_cam_1   = timestamp_cam3.mystruct2(frame_number).value - offset_1_3 ;
                else
                    time_acc_to_cam_1   = timestamp_cam4.mystruct3(frame_number).value - offset_1_4;
                end
                fprintf(fid, '%1.0f %5.0f %7.0f %1.0f %3.2f %3.2f %3.2f %3.2f\n', kinect_value,  frame_number, valid_view, time_acc_to_cam_1 , centre(1),centre(2),width,height);
            end
%             pause(0.01);
            frame_number = frame_number + 1;
        end
    end
    
    
    
    
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % % % Points have been selected... Now resume the video.
    resume_function(handles);



% --- Executes on button press in pushbutton5 --- GO TO SPECIFIC FRAME.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global flag tracking_started directory frame_number kinect_value initialize numFrames bounding_box_p1 bounding_box_p2 limit_length x_plot y_plot filename_1_prefix filename_2_prefix filename_3_prefix filename_4_prefix old_head img_x img_y gm_child draw_offset  x y head_depth;
    flag=0;
    frame_number_in_string = (inputdlg('Enter Frame Number:','Display from a Specific Frame Number'));
    frame_number = str2double(frame_number_in_string);
    if(initialize ==1)
        hf = handles.axes1; 
        set(hf);
        flag=1;
        while( flag ==1 && frame_number <numFrames)
            if(tracking_started ==1)
            [x_plot,y_plot,old_head,img_x,img_y,gm_child,draw_offset, x,y,head_depth] = get_bounding_box(directory,frame_number,old_head,img_x,img_y,gm_child,draw_offset, x,y,head_depth,limit_length,kinect_value);
                    
            end
            if(kinect_value ==1)
                file = strcat(filename_1_prefix,int2str(frame_number),'.mat');
            elseif(kinect_value ==2)
                file = strcat(filename_2_prefix,int2str(frame_number),'.mat');
            elseif(kinect_value ==3)
                file = strcat(filename_3_prefix,int2str(frame_number),'.mat');
            else 
                file = strcat(filename_4_prefix,int2str(frame_number),'.mat');
            end
            mat_data = load(file, '-mat','ColorFrame');
            drawnow update;
            drawnow;
            imshow(mat_data.ColorFrame.ColorData,'Parent',hf);
            hold on;
            if(tracking_started ==1)
                plot(x_plot,y_plot,'r','LineWidth',2);
            end
            pause(0.25);
            frame_number = frame_number + 1;
        end
    end


% --- Executes on button press in pushbutton6-- Open a Directory.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global directory_selection directory ;
    directory = uigetdir;
    directory_selection=1;


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes when selected object is changed in uipanel3.
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel3 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
    global directory_selection kinect_value flag frame_number timestamp_cam1 timestamp_cam2 timestamp_cam3 timestamp_cam4 filename_1_prefix filename_2_prefix filename_3_prefix filename_4_prefix;
    str= (get(hObject,'Tag'));
    older_cam = kinect_value;
    kinect_value  = str(end) - '4'
    if(directory_selection ==0)
        return;
    end
    new_cam = kinect_value;
    offset = calculate_offset_value(older_cam,new_cam);
    if(older_cam ==1)
        timestamp = timestamp_cam1.mystruct(frame_number);
    elseif(older_cam ==2)
        timestamp = timestamp_cam2.mystruct(frame_number);
    elseif(older_cam ==3)
        timestamp = timestamp_cam3.mystruct2(frame_number);
    elseif(older_cam ==4)
        timestamp = timestamp_cam4.mystruct3(frame_number);
    end
    new_timestamp = timestamp.value + offset;
    calculate_new_frame_number(new_timestamp);
    if(kinect_value ==1)
        file = strcat(filename_1_prefix,int2str(frame_number),'.mat');
    elseif(kinect_value ==2)
        file = strcat(filename_2_prefix,int2str(frame_number),'.mat');
    elseif(kinect_value ==3)
        file = strcat(filename_3_prefix,int2str(frame_number),'.mat');
    else 
        file = strcat(filename_4_prefix,int2str(frame_number),'.mat');
    end
    flag =0;
    mat_data = load(file, '-mat','ColorFrame');
    drawnow update;
    drawnow;
    hf = handles.axes1; 
    imshow(mat_data.ColorFrame.ColorData,'Parent',hf);
    hold on;
    space_function();

    
function offset = calculate_offset_value(older_cam,new_cam)
    global offset_1_2 offset_1_3 offset_1_4;
    
    if(older_cam ==1 && new_cam ==1)
        offset = 0;
    elseif(older_cam ==1 && new_cam ==2)
        offset = offset_1_2;    
    elseif(older_cam ==1 && new_cam ==3)
        offset = offset_1_3;    
    elseif(older_cam ==1 && new_cam ==4)
        offset = offset_1_4;    

    elseif(older_cam ==2 && new_cam ==1)
        offset = -1 * offset_1_2;
    elseif(older_cam ==2 && new_cam ==2)
        offset = 0;    
    elseif(older_cam ==2 && new_cam ==3)
        offset = (-1 * offset_1_2) + (offset_1_3);
    elseif(older_cam ==2 && new_cam ==4)
        offset = (-1 * offset_1_2) + (offset_1_4);
        
    elseif(older_cam ==3 && new_cam ==1)
        offset = -1 * offset_1_3;
    elseif(older_cam ==3 && new_cam ==2)
        offset = (-1 * offset_1_3) + (offset_1_2);
    elseif(older_cam ==3 && new_cam ==3)
        offset = 0;    
    elseif(older_cam ==3 && new_cam ==4)
        offset = (-1 * offset_1_3) + (offset_1_4);
    
    elseif(older_cam ==4 && new_cam ==1)
        offset = -1 * offset_1_4;
    elseif(older_cam ==4 && new_cam ==2)
        offset = (-1 * offset_1_4) + (offset_1_2);
    elseif(older_cam ==4 && new_cam ==3)
        offset = (-1 * offset_1_4) + (offset_1_3);
    elseif(older_cam ==4 && new_cam ==4)
        offset = 0;    

    end
    
    
function calculate_new_frame_number(new_timestamp)
    global kinect_value frame_number timestamp_cam1 timestamp_cam2 timestamp_cam3 timestamp_cam4;
    if(kinect_value ==1)
        for i = -1500 : 1500
            if( (frame_number +i )>0  && timestamp_cam1.mystruct(frame_number + i).value >= new_timestamp )
                frame_number = frame_number + i;
                break;
            end
        end
    elseif(kinect_value ==2)
        for i = -1500 : 1500
            if((frame_number +i )>0  && timestamp_cam2.mystruct(frame_number + i).value >= new_timestamp )
                frame_number = frame_number + i;
                break;
            end
        end
    elseif(kinect_value ==3)
        for i = -1500 : 1500
            if( (frame_number +i )>0  && timestamp_cam3.mystruct2(frame_number + i).value >= new_timestamp )
                frame_number = frame_number + i;
                break;
            end
        end
    elseif(kinect_value ==4)
        for i = -1500 : 1500
            if( (frame_number +i )>0  && timestamp_cam4.mystruct3(frame_number + i).value >= new_timestamp )
                frame_number = frame_number + i;
                break;
            end
        end
    end
    
    
    
    


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
    global valid_view;
    button_state = get(hObject,'Value');
    if button_state == get(hObject,'Max')
        % toggle button is pressed
        valid_view =1;
    elseif button_state == get(hObject,'Min')
        % toggle button is not pressed
        valid_view =0;
    end