function varargout = Permeabilitaet_Main(varargin)
% PERMEABILITAET_MAIN MATLAB code for Permeabilitaet_Main.fig
%      Opens the Permeability Main GUI. With this GUI you can evaluate
%      single experiments, calculate the principal permeabilities or
%      evaluate several experiments via batch processing.
%      
%      PERMEABILITAET_MAIN, by itself, creates a new  
%      PERMEABILITAET_MAIN or raises the existing singleton*.
%
%      H = PERMEABILITAET_MAIN returns the handle to a new 
%      PERMEABILITAET_MAIN or the handle to the existing
%      singleton*.
%
%      PERMEABILITAET_MAIN('CALLBACK',hObject,eventData,handles,...)  
%      calls the local function named CALLBACK in 
%      PERMEABILITAET_MAIN.M with the given input arguments.
%
%      PERMEABILITAET_MAIN('Property','Value',...) creates a new 
%      PERMEABILITAET_MAIN or raises the existing singleton*.   
%      Startingfrom the left, property value pairs are applied to the  
%      GUI before Permeabilitaet_Main_OpeningFcn gets called. 
%      An unrecognized property name or invalid value makes property 
%      application stop.
%      All inputs are passed to Permeabilitaet_Main_OpeningFcn 
%      via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows  
%      only one instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to 
% help Permeabilitaet_Main

% Last Modified by GUIDE v2.5 06-Sep-2012 11:29:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State =struct('gui_Name',      mfilename, ...
                  'gui_Singleton', gui_Singleton, ...
                  'gui_OpeningFcn',@Permeabilitaet_Main_OpeningFcn, ...
                  'gui_OutputFcn', @Permeabilitaet_Main_OutputFcn, ...
                  'gui_LayoutFcn', [] , ...
                  'gui_Callback',  []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Permeabilitaet_Main is made visible.
function Permeabilitaet_Main_OpeningFcn(hObject, ~, handles, varargin)

handles.batch_unsat = 0;
% Choose default command line output for Permeabilitaet_Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Permeabilitaet_Main_OutputFcn(~, ~, handles) 

varargout{1} = handles.output;

% --- Executes on button press in Neu.
function Neu_Callback(~, ~, handles) %#ok<DEFNU>

h_selectedRadioButton = get(handles.uipanel5,'SelectedObject'); 
selectedRadioTag = get(h_selectedRadioButton,'tag'); 
switch selectedRadioTag 
    case 'unsaturated'
        Eingabe_ungesaettigt(handles);
    case 'saturated'
        Eingabe(handles);
end

% --- Executes on button press in Berechnung.
function Berechnung_Callback(~, ~, handles) %#ok<DEFNU>

format long
Speichername = get(handles.Speichername, 'String');

%% Load selected effective permeabilities
Wahl = {'','',''
        '','',''
        '','',''
        '','',''
        '','',''
        '','',''
        '','',''
        '','',''
        '','',''
        '','',''};
z=1;
if get(handles.checkbox0_1, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_1', 'C20:C20');
    Wahl(z,1) = {'0°_v1'};
    z=z+1;
end

if get(handles.checkbox0_2, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_2', 'C20:C20');
    Wahl(z,1) = {'0°_v2'};
    z=z+1;
end

if get(handles.checkbox0_3, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_3', 'C20:C20');
    Wahl(z,1) = {'0°_v3'};
    z=z+1;
end

if get(handles.checkbox0_4, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_4', 'C20:C20');
    Wahl(z,1) = {'0°_v4'};
    z=z+1;
end

if get(handles.checkbox0_5, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_5', 'C20:C20');
    Wahl(z,1) = {'0°_v5'};
    z=z+1;
end

if get(handles.checkbox0_6, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_6', 'C20:C20');
    Wahl(z,1) = {'0°_v6'};
    z=z+1;
end

if get(handles.checkbox0_7, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_7', 'C20:C20');
    Wahl(z,1) = {'0°_v7'};
    z=z+1;
end

if get(handles.checkbox0_8, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_8', 'C20:C20');
    Wahl(z,1) = {'0°_v8'};
    z=z+1;
end

if get(handles.checkbox0_9, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_9', 'C20:C20');
    Wahl(z,1) = {'0°_v9'};
    z=z+1;
end

if get(handles.checkbox0_10, 'Value') == 1
    raw_0(z) = xlsread(Speichername,'0°_v_10', 'C20:C20');
    Wahl(z,1) = {'0°_v10'};
end

t=1;
if get(handles.checkbox45_1, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_1', 'C20:C20');
    Wahl(t,2) = {'45°_v1'};
    t=t+1;
end

if get(handles.checkbox45_2, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_2', 'C20:C20');
    Wahl(t,2) = {'45°_v2'};
    t=t+1;
end

if get(handles.checkbox45_3, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_3', 'C20:C20');
    Wahl(t,2) = {'45°_v3'};
    t=t+1;
end

if get(handles.checkbox45_4, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_4', 'C20:C20');
    Wahl(t,2) = {'45°_v4'};
    t=t+1;
end

if get(handles.checkbox45_5, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_5', 'C20:C20');
    Wahl(t,2) = {'45°_v5'};
    t=t+1;
end

if get(handles.checkbox45_6, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_6', 'C20:C20');
    Wahl(t,2) = {'45°_v6'};
    t=t+1;
end

if get(handles.checkbox45_7, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_7', 'C20:C20');
    Wahl(t,2) = {'45°_v7'};
    t=t+1;
end

if get(handles.checkbox45_8, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_8', 'C20:C20');
    Wahl(t,2) = {'45°_v8'};
    t=t+1;
end

if get(handles.checkbox45_9, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_9', 'C20:C20');
    Wahl(t,2) = {'45°_v9'};
    t=t+1;
end

if get(handles.checkbox45_10, 'Value') == 1
    raw_45(t) = xlsread(Speichername,'45°_v_10', 'C20:C20');
    Wahl(t,2) = {'45°_v10'};
end

f=1;
if get(handles.checkbox90_1, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_1', 'C20:C20');
    Wahl(f,3) = {'90°_v1'};
    f=f+1;
end

if get(handles.checkbox90_2, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_2', 'C20:C20');
    Wahl(f,3) = {'90°_v2'};
    f=f+1;
end

if get(handles.checkbox90_3, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_3', 'C20:C20');
    Wahl(f,3) = {'90°_v3'};
    f=f+1;
end

if get(handles.checkbox90_4, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_4', 'C20:C20');
    Wahl(f,3) = {'90°_v4'};
    f=f+1;
end

if get(handles.checkbox90_5, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_5', 'C20:C20');
    Wahl(f,3) = {'90°_v5'};
    f=f+1;
end

if get(handles.checkbox90_6, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_6', 'C20:C20');
    Wahl(f,3) = {'90°_v6'};
    f=f+1;
end

if get(handles.checkbox90_7, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_7', 'C20:C20');
    Wahl(f,3) = {'90°_v7'};
    f=f+1;
end

if get(handles.checkbox90_8, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_8', 'C20:C20');
    Wahl(f,3) = {'90°_v8'};
    f=f+1;
end

if get(handles.checkbox90_9, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_9', 'C20:C20');
    Wahl(f,3) = {'90°_v9'};
    f=f+1;
end

if get(handles.checkbox90_10, 'Value') == 1
    raw_90(f) = xlsread(Speichername,'90°_v_10', 'C20:C20');
    Wahl(f,3) = {'90°_v10'};
end

%% Calculate principal permeabilities and plot the results

K_1_1 = 0;
K_2_1 = 0;
phi = 0;
K_1_2 = 0;
K_2_2 = 0;
gamma = 0;
radiobutton1 = get(handles.radiobutton1, 'Value');
radiobutton2 = get(handles.radiobutton2, 'Value');
h = figure(1);
set(h,'position',[0 0, 800 550])
if radiobutton1 == 1 
       perm = [raw_0
              raw_90
              raw_45];
       [flowfrontfit] = fit_flowfront(perm);
       K_1_1 = flowfrontfit.a;
       K_2_1 = flowfrontfit.b;
       phi = flowfrontfit.phi;
       if K_2_1>K_1_1
           phi = phi + pi/2;
       end       
       if K_2_1>K_1_1
           temp = K_1_1;
           K_1_1 = K_2_1;
           K_2_1 = temp;
       end
       x_2 = [cos(phi)*K_1_1 -cos(phi)*K_1_1]; 
       y_2 = [sin(phi)*K_1_1 -sin(phi)*K_1_1];
       x_3 = [sin(phi)*K_2_1 -sin(phi)*K_2_1];
       y_3 = [-cos(phi)*K_2_1 cos(phi)*K_2_1];
       subplot(2,2,1)
       plot(x_2, y_2, '-.k');
       plot(x_3, y_3, '-.k');
       subplot(2,2,3)
       hold on
       axis equal
       grid on
       box on
       title('Vergleich')
       plot_ellipse(0,0,K_1_1,K_2_1,phi*180/pi,'-r');
       drawnow
end 
if radiobutton2 == 1 
       K_0_exp  = mean(raw_0);
       K_45_exp = mean(raw_45);
       K_90_exp = mean(raw_90);
       alpha = (K_0_exp + K_90_exp)/2;
       beta  = (K_0_exp - K_90_exp)/2;
       gamma = 0.5*atan(alpha/beta-(alpha^2-beta^2)/(K_45_exp*beta));
       K_1_2 = K_0_exp*(alpha-beta)/(alpha-beta/cos(2*gamma));
       K_2_2 = K_90_exp*(alpha+beta)/(alpha+beta/cos(2*gamma));
       if K_2_2>K_1_2
           gamma = gamma + pi/2;
       end       
       if K_2_2>K_1_2
           temp = K_1_2;
           K_1_2 = K_2_2;
           K_2_2 = temp;
       end
       x_1 = [K_0_exp 0 sind(45)*K_45_exp];
       y_1 = [0 K_90_exp cosd(45)*K_45_exp];
       x_2 = [cos(gamma)*K_1_2 -cos(gamma)*K_1_2]; 
       y_2 = [sin(gamma)*K_1_2 -sin(gamma)*K_1_2];
       x_3 = [sin(gamma)*K_2_2 -sin(gamma)*K_2_2];
       y_3 = [-cos(gamma)*K_2_2 cos(gamma)*K_2_2];
       figure(1)
       subplot(2,2,2)
       hold on
       axis equal
       grid on
       box on
       title('Analytic')
       plot(x_1, y_1, 'ko');
       plot(x_2, y_2, '-.k');
       plot(x_3, y_3, '-.k');
       plot_ellipse(0,0,K_1_2,K_2_2,gamma*180/pi,'-k');
       drawnow
       subplot(2,2,3)
       hold on
       axis equal
       grid on
       box on
       title('Comparison')
       plot_ellipse(0,0,K_1_2,K_2_2,gamma*180/pi,'-k');
       drawnow
end
Maximalwert = max([raw_0;raw_45;raw_90]);
Wertebereich = max([K_1_1 K_1_2 Maximalwert]);

subplot(2,2,1)
axis([-Wertebereich Wertebereich -Wertebereich Wertebereich]);
subplot(2,2,2)
axis([-Wertebereich Wertebereich -Wertebereich Wertebereich]);
subplot(2,2,3)
axis([-Wertebereich Wertebereich -Wertebereich Wertebereich]);

figure(1)
subplot(2,2,4)
hold on
axis equal
box on
title('Legend')
axis([-4 4 -4 4]);
set(gca,'XTickLabel',[],'YTickLabel',[])
plot(3.5,3.5,'-r')
plot(3.5,3.5,'-k')
plot(3.5,3.5,'ko')
quiver(-3.5,-3.5,3.5,0,'k')
quiver(-3.5,-3.5,0,3.5,'k')
quiver(-3.5,-3.5,2.5,2.5,'k')
text(0,-3.5,'0°')
text(-1,-1,'45°')
text(-3.5,0,'90°')
legend('Ellipse fit','Analytic','Data',1);
drawnow

%% Save the results

h_selectedRadioButton = get(handles.uipanel5,'SelectedObject'); 
selectedRadioTag = get(h_selectedRadioButton,'tag'); 
switch selectedRadioTag 
    case 'unsaturated'
        Methode = 'Unsaturatet measurement';
    case 'saturated'
        Methode = 'Saturated measurement';
end
raw = [raw_0' raw_45' raw_90'];
raw = num2cell(raw);
while size(raw,1)<10
    raw{end+1,1} = '';
    raw{end,2} = '';
    raw{end,3} = '';
end
d = {'Principal Permeabilities'        ,''          ,''        ...
                             ,''          ,''          ,''
     Methode                           ,''          ,''        ...
                             ,''          ,''          ,''
     ''                                ,''          ,'K1 [m²]' ...
                             ,'K2 [m²]'   ,'Gamma [°]' ,'Gamma [rad]'
     ''                                ,''          ,''        ...
                             ,''          ,''          ,''
     'Ellipse fit'                     ,''          ,K_1_1     ...
                             ,K_2_1       ,phi*180/pi  ,phi
     ''                                ,''          ,''        ...
                             ,''          ,''          ,''
     'Analytic (Benchmark)'            ,''          ,K_1_2     ...
                             ,K_2_2       ,gamma*180/pi,gamma
     ''                                ,''          ,''        ...
                             ,''          ,''          ,''
     ''                                ,''          ,''        ...
                             ,''          ,''          ,''
     'Experiments used for calculation',''          ,''        ...
                             ,''          ,''          ,''
     ''                                ,''          ,''        ...
                             ,''          ,''          ,''
     ''                                ,'K_eff [m²]',''        ...
                             ,'K_eff [m²]',''          ,'K_eff [m²]'
     Wahl{1,1}                         ,raw{1,1}    ,Wahl{1,2} ...
                             ,raw{1,2}  ,Wahl{1,3}     ,raw{1,3}
     Wahl{2,1}                         ,raw{2,1}    ,Wahl{2,2} ...
                             ,raw{2,2}  ,Wahl{2,3}     ,raw{2,3}
     Wahl{3,1}                         ,raw{3,1}    ,Wahl{3,2} ...
                             ,raw{3,2}  ,Wahl{3,3}     ,raw{3,3}
     Wahl{4,1}                         ,raw{4,1}    ,Wahl{4,2} ...
                             ,raw{4,2}  ,Wahl{4,3}     ,raw{4,3}
     Wahl{5,1}                         ,raw{5,1}    ,Wahl{5,2} ...
                             ,raw{5,2}  ,Wahl{5,3}     ,raw{5,3}
     Wahl{6,1}                         ,raw{6,1}    ,Wahl{6,2} ...
                             ,raw{6,2}  ,Wahl{6,3}     ,raw{6,3}
     Wahl{7,1}                         ,raw{7,1}    ,Wahl{7,2} ...
                             ,raw{7,2}  ,Wahl{7,3}     ,raw{7,3}
     Wahl{8,1}                         ,raw{8,1}    ,Wahl{8,2} ...
                             ,raw{8,2}  ,Wahl{8,3}     ,raw{8,3}
     Wahl{9,1}                         ,raw{9,1}    ,Wahl{9,2} ...
                             ,raw{9,2}  ,Wahl{9,3}     ,raw{9,3}
     Wahl{10,1}                        ,raw{10,1}   ,Wahl{10,2}...
                             ,raw{10,2},Wahl{10,3}     ,raw{10,3}};
xlswrite(Speichername, d, 'Principal perm.', 'A1:F22');
close (gcbf)
xlsPasteTo(Speichername, 'Principal perm.', 500, 500, h, 'A23');


%% Change background colors

% Start Excel-Server
xls = actxserver('Excel.Application'); 
% Open file
wb = xls.Workbooks.Open([pwd() filesep [Speichername '.xls']]); 
% Activate sheet
wb.Sheets.Item('Principal perm.').Activate;                     
as = wb.ActiveSheet;  
% Change background color
as.Range('A5:F5').Interior.ColorIndex = 40;                     
as.Range('A7:F7').Interior.ColorIndex = 40;
as.Range('A12:B22').Interior.ColorIndex = 40;
as.Range('C12:D22').Interior.ColorIndex = 19;
as.Range('E12:F22').Interior.ColorIndex = 40;
% Save sheet
wb.Save;
% Close sheet
wb.Close;   
% Close server
delete(xls);                                                    


%% Delete default sheets

excelFileName = [Speichername '.xls'];
excelFilePath = pwd; % Current working directory.
sheetName = 'Tabelle'; % EN: Sheet, DE: Tabelle

% Open Excel file.
objExcel = actxserver('Excel.Application');
% Full path is necessary!
objExcel.Workbooks.Open(fullfile(excelFilePath, excelFileName));

% Delete sheets.
try
% Throws an error if the sheets do not exist.
objExcel.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete;
objExcel.ActiveWorkbook.Worksheets.Item([sheetName '2']).Delete;
objExcel.ActiveWorkbook.Worksheets.Item([sheetName '3']).Delete;
catch
; % Do nothing.
end

% Save, close and clean up.
objExcel.ActiveWorkbook.Save;
objExcel.ActiveWorkbook.Close;
objExcel.Quit;
objExcel.delete;

clear all

%% Batch processing

% --- Executes on button press in pb_load_batch.
function pb_load_batch_Callback(~, ~, handles) %#ok<DEFNU>

[file, path] = uigetfile('*.txt');
set(handles.tf_batch_processing, 'String', [path file]);

% --- Executes on button press in pb_batch_processing.
function pb_batch_processing_Callback(~, ~, handles) %#ok<DEFNU>

global pfad dateiname
% set(handles.Main_GUI, 'Visible', 'off')
filepath = get(handles.tf_batch_processing, 'String');
fid = fopen(filepath);
data = textscan(fid, '%s %s %s', 'delimiter', '\t');
list = {'0°_v1';'0°_v2';'0°_v3';'0°_v4';'0°_v5';'0°_v6';'0°_v7';'0°_v8'
        '0°_v9';'0°_v10';'45°_v1';'45°_v2';'45°_v3';'45°_v4';'45°_v5'
        '45°_v6';'45°_v7';'45°_v8';'45°_v9';'45°_v10';'90°_v1';'90°_v2'
        '90°_v3';'90°_v4';'90°_v5';'90°_v6';'90°_v7';'90°_v8';'90°_v9'
        '90°_v10'};
for k=1:size(data{1},1)
    b=0;
    t=1;
    while b~=1 && t<=size(list,1)
        b = strcmp(data{3}{k},list{t});
        t=t+1;
    end
    data{4}{k} = t-1;
end


h_selectedRadioButton = get(handles.uipanel5,'SelectedObject'); 
selectedRadioTag = get(h_selectedRadioButton,'tag'); 
switch selectedRadioTag 
    case 'unsaturated'
        for k=1:size(data{1},1)
            handles.batch_unsat = 1;
            unsat = Eingabe_ungesaettigt(handles);
            pfad = data{1}{k};
            dateiname = data{2}{k};
            set(unsat.tf_Wahl, 'String', dateiname)
            set(unsat.pm_Versuchwahl, 'Value', data{4}{k})
            unsat.load(unsat)
            unsat.Berechnen(unsat)
            handles.batch_unsat = 0;
        end
    case 'saturated'
        for k=1:size(data{1},1)
            sat = Eingabe(handles);
            pfad = data{1}{k};
            dateiname = data{2}{k};
            set(sat.tf_Wahl, 'String', dateiname)
            set(sat.pm_Versuchwahl, 'Value', data{4}{k})
            sat.load(sat)
            sat.Berechnen(sat)
        end
end
% set(handles.Main_GUI, 'Visible', 'on')

% --- Executes on button press in checkbox0_1.
function checkbox0_1_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox0_2.
function checkbox0_2_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox0_3.
function checkbox0_3_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox0_4.
function checkbox0_4_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox0_5.
function checkbox0_5_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox0_6.
function checkbox0_6_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox0_7.
function checkbox0_7_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox0_8.
function checkbox0_8_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox0_9.
function checkbox0_9_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox0_10.
function checkbox0_10_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_1.
function checkbox45_1_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_2.
function checkbox45_2_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_3.
function checkbox45_3_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_4.
function checkbox45_4_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_5.
function checkbox45_5_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_6.
function checkbox45_6_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_7.
function checkbox45_7_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_8.
function checkbox45_8_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_9.
function checkbox45_9_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox45_10.
function checkbox45_10_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_1.
function checkbox90_1_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_2.
function checkbox90_2_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_3.
function checkbox90_3_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_4.
function checkbox90_4_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_5.
function checkbox90_5_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_6.
function checkbox90_6_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_7.
function checkbox90_7_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_8.
function checkbox90_8_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_9.
function checkbox90_9_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes on button press in checkbox90_10.
function checkbox90_10_Callback(~, ~, ~) %#ok<DEFNU>

function Speichername_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function Speichername_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end