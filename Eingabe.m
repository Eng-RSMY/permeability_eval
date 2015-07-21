function varargout = Eingabe(varargin)
%Eingabe M-file for Eingabe.fig
%      Opens the Saturated permeability GUI. With this GUI you can
%      evaluate a saturated permeability experiment. Loads data
%      from an Excel input file and saves the results to an Excel
%      output file.
%
%      Eingabe, by itself, creates a new Eingabe or raises the 
%      existing singleton*.
%
%      H = Eingabe returns the handle to a new Eingabe or the handle 
%      to the existing singleton*.
%
%      Eingabe('Property','Value',...) creates a new Eingabe using 
%      the given property value pairs. Unrecognized properties are  
%      passed via varargin to Eingabe_OpeningFcn.  This calling  
%      syntax produces a warning when there is an existing singleton*.
%
%      Eingabe('CALLBACK') and Eingabe('CALLBACK',hObject,...) call 
%      the local function named CALLBACK in Eingabe.M with the given 
%      input arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows  
%      only one instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Eingabe

% Last Modified by GUIDE v2.5 05-Sep-2012 17:16:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Eingabe_OpeningFcn, ...
                   'gui_OutputFcn',  @Eingabe_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Eingabe is made visible.
function Eingabe_OpeningFcn(hObject, ~, handles, varargin)

handles.Main = varargin{1};
handles.Berechnen = @calculate;
handles.load = @load_data;
% Choose default command line output for Eingabe
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Eingabe_OutputFcn(~, ~, handles)

varargout{1} = handles;

% --- Executes on button press in pb_Dateiwahl.
function pb_Dateiwahl_Callback(~, ~, handles) %#ok<DEFNU>

global dateiname pfad

[dateiname, pfad] = uigetfile('*.xls');
set(handles.tf_Wahl, 'String', dateiname);

% --- Executes on button press in pb_load_data.
function pb_load_data_Callback(~, ~, handles) %#ok<DEFNU>

load_data(handles)

function load_data(handles)
global dateiname pfad

input1 = xlsread([pfad dateiname], 'In_sat', 'D33:D89');
input2 = xlsread([pfad dateiname], 'In_sat', 'C92:D97');
set(handles.tf_Faserdichte, 'String', num2str(input1(1)));
set(handles.tf_Mediumdichte, 'String', num2str(input1(7)));
set(handles.tf_Laenge, 'String', num2str(input1(30)));
set(handles.tf_Breite, 'String', num2str(input1(31)));
set(handles.tf_Hoehe, 'String', num2str(input1(32)));
set(handles.Massentabelle, 'Data', input1(46:end));
set(handles.Zeittabelle, 'Data', input2);

% --- Executes on button press in pb_Berechnen.
function pb_Berechnen_Callback(~, ~, handles) %#ok<DEFNU>

calculate(handles)

function calculate(handles)
global dateiname pfad
format long
varargin

%% Load input data

Breite       = str2double(get(handles.tf_Breite, 'String'));
Laenge       = str2double(get(handles.tf_Laenge, 'String'));
Hoehe        = str2double(get(handles.tf_Hoehe, 'String'));
Faserdichte  = str2double(get(handles.tf_Faserdichte, 'String'));
Mediumdichte = str2double(get(handles.tf_Mediumdichte, 'String'));

Zeitbereich  = get(handles.Zeittabelle, 'Data');
Massen       = get(handles.Massentabelle, 'Data');
Speichername = get(handles.Main.Speichername, 'String');

%% Calculate some data

Lagenmasse_gesamt = sum(Massen);
Lagenmasse_spezifisch = Lagenmasse_gesamt/(Breite*Laenge)*1000;
V_f = Lagenmasse_spezifisch/(Faserdichte*Hoehe)*1000;
Porositaet = 1-V_f;
A_eff = Breite*Hoehe*Porositaet/1000000;
Messbereich = Zeitbereich;

%% Preallocate memory

n = Zeitbereich(1,2)-(Zeitbereich(1,1)-1);
p_anguss      = zeros(n,6);
p_abguss      = zeros(n,6);
kraft         = zeros(n,6);
t_anguss      = zeros(n,6);
t_abguss      = zeros(n,6);
Massenzunahme = zeros(1,6);

%% Load experimental data from the Excel-file

z = length(Messbereich(:,1));
Messbereich = Messbereich(1:z,:);
Daten = xlsread([pfad dateiname], 'raw', sprintf('B%d:G%d', 50,...
                Messbereich(z,2)+50));

%% Shrink the matrices

p_anguss      = p_anguss(:,1:z);
p_abguss      = p_abguss(:,1:z);
kraft         = kraft(:,1:z);
t_anguss      = t_anguss(:,1:z);
t_abguss      = t_abguss(:,1:z);
Massenzunahme = Massenzunahme(:,1:z);

%% Load data from the different testing ranges

while z>=1
    p_anguss(:,z) = Daten(Messbereich(z,1)+1:Messbereich(z,2)+1,1);
    p_abguss(:,z) = Daten(Messbereich(z,1)+1:Messbereich(z,2)+1,2);
    kraft(:,z) = Daten(Messbereich(z,1)+1:Messbereich(z,2)+1,4);
    t_anguss(:,z) = Daten(Messbereich(z,1)+1:Messbereich(z,2)+1,5);
    t_abguss(:,z) = Daten(Messbereich(z,1)+1:Messbereich(z,2)+1,6);
    Massenzunahme(1,z) = (kraft(n,z)-kraft(1,z))*1000/9.81;
    z=z-1;
end

%% Calculate some more data

t_anguss_m = mean(mean(t_anguss));
t_abguss_m = mean(mean(t_abguss));
Temperatur_m = (t_anguss_m+t_abguss_m)/2;
p_anguss_m = mean(p_anguss);
p_abguss_m = mean(p_abguss);
p_differenz = p_anguss_m-p_abguss_m;
Massenstrom = -Massenzunahme/300;
Volumenstrom = Massenstrom*1000/Mediumdichte;
Steigung = p_differenz(:)\Volumenstrom(:);
size = numel(p_differenz);
x1 = p_differenz(1):0.01:p_differenz(size);
y1 = Steigung*x1;

y_m = mean(Volumenstrom);
y_k = Steigung*p_differenz;
RSS = sum((Volumenstrom-y_k).^2);
TSS = sum((Volumenstrom-y_m).^2);
R2 = 1-(RSS/TSS);

%% Liner interpolation of the viscosity

temp = xlsread([pfad dateiname],'In_sat', 'C43:D58');
Viskositaet = interp1(temp(:,1),temp(:,2),Temperatur_m);

%% Calculation of the effective permeability

K_eff = (Steigung*(10^-11)*Laenge/1000*Viskositaet/1000)/A_eff;

%% Plot the data and the Darcy line

h2 = figure;
hold on
box on
grid on
plot(p_differenz,Volumenstrom,'m+')
axis ([0, p_differenz(size)+0.5, 0, Volumenstrom(size)+0.05])
xlabel('Pressure difference [bar]')
ylabel('Flow rate [cm^3/s]')
plot(x1,y1,'k-')
legend('Measured data','Fitted line','Location','NorthWest');

%% Select sheet

Wert = get(handles.pm_Versuchwahl, 'Value');
Liste = get(handles.pm_Versuchwahl, 'String');
Versuch = Liste{Wert};
switch Versuch
    case '0° v_1'
        Sheet = '0°_v_1';
        set(handles.Main.checkbox0_1, 'Value', 1);
    case '0° v_2'
        Sheet = '0°_v_2';
        set(handles.Main.checkbox0_2, 'Value', 1);
    case '0° v_3'
        Sheet = '0°_v_3';
        set(handles.Main.checkbox0_3, 'Value', 1);
    case '0° v_4'
        Sheet = '0°_v_4';
        set(handles.Main.checkbox0_4, 'Value', 1);
    case '0° v_5'
        Sheet = '0°_v_5';
        set(handles.Main.checkbox0_5, 'Value', 1); 
    case '0° v_6'
        Sheet = '0°_v_6';
        set(handles.Main.checkbox0_6, 'Value', 1);  
    case '0° v_7'
        Sheet = '0°_v_7';
        set(handles.Main.checkbox0_7, 'Value', 1);
    case '0° v_8'
        Sheet = '0°_v_8';
        set(handles.Main.checkbox0_8, 'Value', 1);
    case '0° v_9'
        Sheet = '0°_v_9';
        set(handles.Main.checkbox0_9, 'Value', 1);
    case '0° v_10'
        Sheet = '0°_v_10';
        set(handles.Main.checkbox0_10, 'Value', 1);
    case '45° v_1'
        Sheet = '45°_v_1';
        set(handles.Main.checkbox45_1, 'Value', 1);
    case '45° v_2'
        Sheet = '45°_v_2';
        set(handles.Main.checkbox45_2, 'Value', 1);    
    case '45° v_3'
        Sheet = '45°_v_3';
        set(handles.Main.checkbox45_3, 'Value', 1);
    case '45° v_4'
        Sheet = '45°_v_4';
        set(handles.Main.checkbox45_4, 'Value', 1);        
    case '45° v_5'
        Sheet = '45°_v_5';
        set(handles.Main.checkbox45_5, 'Value', 1);        
    case '45° v_6'
        Sheet = '45°_v_6';
        set(handles.Main.checkbox45_6, 'Value', 1);        
    case '45° v_7'
        Sheet = '45°_v_7';
        set(handles.Main.checkbox45_7, 'Value', 1);        
    case '45° v_8'
        Sheet = '45°_v_8';
        set(handles.Main.checkbox45_8, 'Value', 1);        
    case '45° v_9'
        Sheet = '45°_v_9';
        set(handles.Main.checkbox45_9, 'Value', 1);        
    case '45° v_10'
        Sheet = '45°_v_10';
        set(handles.Main.checkbox45_10, 'Value', 1);    
    case '90° v_1'
        Sheet = '90°_v_1';
        set(handles.Main.checkbox90_1, 'Value', 1);        
    case '90° v_2'
        Sheet = '90°_v_2';
        set(handles.Main.checkbox90_2, 'Value', 1);        
    case '90° v_3'
        Sheet = '90°_v_3';
        set(handles.Main.checkbox90_3, 'Value', 1);        
    case '90° v_4'
        Sheet = '90°_v_4';
        set(handles.Main.checkbox90_4, 'Value', 1);        
    case '90° v_5'
        Sheet = '90°_v_5';
        set(handles.Main.checkbox90_5, 'Value', 1); 
    case '90° v_6'
        Sheet = '90°_v_6';
        set(handles.Main.checkbox90_6, 'Value', 1);        
    case '90° v_7'
        Sheet = '90°_v_7';
        set(handles.Main.checkbox90_7, 'Value', 1);        
    case '90° v_8'
        Sheet = '90°_v_8';
        set(handles.Main.checkbox90_8, 'Value', 1);  
    case '90° v_9'
        Sheet = '90°_v_9';
        set(handles.Main.checkbox90_9, 'Value', 1);        
    case '90° v_10'
        Sheet = '90°_v_10';
        set(handles.Main.checkbox90_10, 'Value', 1);        
end

%% Save the results

while length(p_differenz)<6
    p_differenz(end+1) = 0;
end
while length(Massen(:,1))<10
    Massen(end+1,1) = 0;
end
while length(Zeitbereich(:,1))<6
    Zeitbereich(end+1,:) = 0;
end

% Round data
V_f_r = round(V_f*1000)/1000;
Porositaet_r = round(Porositaet*1000)/1000;
A_eff_r = round(A_eff*100000)/100000;
Steigung_r = round(Steigung*1000)/1000;
Lagenmasse_spezifisch_r = round(Lagenmasse_spezifisch*1000)/1000;
Temperatur_m_r = round(Temperatur_m*1000)/1000;
Viskositaet_r = round(Viskositaet*1000)/1000;
R2_r = round(R2*1000)/1000;
p_differenz_r = round(p_differenz.*1000)./1000;


d = {'Input file'            ,'',dateiname              ,''        ...
                    ,'',''                  ,''
     'Saturated measurement' ,'',''                     ,''        ...
                    ,'',''                  ,''
     ''                      ,'',''                     ,''        ...
                    ,'',''                  ,''
     'Fibre density'         ,'',Faserdichte            ,'[kg/m³]' ...
                    ,'','Measuring interval',''
     'Fluid density'         ,'',Mediumdichte           ,'[kg/m³]' ...
                    ,'','from [s]'          ,'to [s]'
     'Cavity length'         ,'',Laenge                 ,'[mm]'    ...
                    ,'',Zeitbereich(1,1)    ,Zeitbereich(1,2)
     'Cavity width'          ,'',Breite                 ,'[mm]'    ...
                    ,'',Zeitbereich(2,1)    ,Zeitbereich(2,2)
     'Cavity height'         ,'',Hoehe                  ,'[mm]'    ...
                    ,'',Zeitbereich(3,1)    ,Zeitbereich(3,2)
     ''                      ,'',''                     ,''        ...
                    ,'',Zeitbereich(4,1)    ,Zeitbereich(4,2)
     'Fibre volume fracture' ,'',V_f_r                  ,'[-]'     ...
                    ,'',Zeitbereich(5,1)    ,Zeitbereich(5,2)
     'Porosity'              ,'',Porositaet_r           ,'[-]'     ...
                    ,'',Zeitbereich(6,1)    ,Zeitbereich(6,2)
     'Aeff'                  ,'',A_eff_r                ,'[m²]'    ...
                    ,'',''                  ,''
     'Slope of Darcy Diag.'  ,'',Steigung_r             ,'[cm³/(s*bar)]'...
                    ,'',''                  ,''
     'Ply masses (total)'    ,'',Lagenmasse_gesamt      ,'[g]'     ...
                    ,'','Ply masses [g]'    ,''
     'Specific ply mass'     ,'',Lagenmasse_spezifisch_r,'[kg/m²]' ...
                    ,'','1'                 ,Massen(1,1)
     'Averaged temperature'  ,'',Temperatur_m_r         ,'[°C]'    ...
                    ,'','2'                 ,Massen(2,1)
     'Viscosity'             ,'',Viskositaet_r          ,'[mPa*s]' ...
                    ,'','3'                 ,Massen(3,1)
     'Bestimmtheitsmaß'      ,'',R2_r                   ,'[-]'     ...
                    ,'','4'                 ,Massen(4,1)
     ''                      ,'',''                     ,''        ...
                    ,'','5'                 ,Massen(5,1)
     'Effective permeability','',K_eff                  ,'[m²]'    ...
                    ,'','6'                 ,Massen(6,1)
     'Test number'           ,'',Sheet                  ,''        ...
                    ,'','7'                 ,Massen(7,1)
     ''                      ,'',''                     ,''        ...
                    ,'','8'                 ,Massen(8,1)
     ''                      ,'',''                     ,''        ...
                    ,'','9'                 ,Massen(9,1)
     ''                      ,'',''                     ,''        ...
                    ,'','10'                ,Massen(10,1)
     ''                      ,'',''                     ,''        ...
                    ,'',''                  ,''
     ''                      ,'',''                     ,''        ...
                    ,'',''                  ,''
     ''                      ,'',''                     ,''        ...
                    ,'','p stages'    ,'p_diff [bar]'
     ''                      ,'',''                     ,''        ...
                    ,'','1'                 ,p_differenz_r(1)
     ''                      ,'',''                     ,''        ...
                    ,'','2'                 ,p_differenz_r(2)
     ''                      ,'',''                     ,''        ...
                    ,'','3'                 ,p_differenz_r(3)
     ''                      ,'',''                     ,''        ...
                    ,'','4'                 ,p_differenz_r(4)
     ''                      ,'',''                     ,''        ...
                    ,'','5'                 ,p_differenz_r(5)
     ''                      ,'',''                     ,''        ...
                    ,'','6'                 ,p_differenz_r(6)};
xlswrite(Speichername, d, Sheet, 'A1:G33');
close ('Saturated permeability GUI')
figure(h2)
xlsPasteTo(Speichername, Sheet, 400, 400, h2, 'A24');

%% Change background color

% Start Excel-server
xls = actxserver('Excel.Application');
% Open file
wb = xls.Workbooks.Open([pwd() filesep Speichername]); 
% Activate sheet
wb.Sheets.Item(Sheet).Activate;                        
as = wb.ActiveSheet;   
% Change background color
as.Range('A4:D8').Interior.ColorIndex = 19;            
as.Range('A10:D18').Interior.ColorIndex = 40;
as.Range('F4:G11').Interior.ColorIndex = 19;
as.Range('F14:G24').Interior.ColorIndex = 19;
as.Range('F27:G33').Interior.ColorIndex = 40;
as.Range('A20:D21').Interior.ColorIndex = 40;
% Save sheet
wb.Save; 
% Close scheet
wb.Close;   
% Close server
delete(xls);                                           

% Close figure
close(h2)
clear h2

% --- Executes when entered data in editable cell(s) in Zeittabelle.
function Zeittabelle_CellEditCallback(~, ~, ~) %#ok<DEFNU>

% --- Executes when entered data in editable cell(s) in Massentabelle.
function Massentabelle_CellEditCallback(~, ~, ~) %#ok<DEFNU>

function tf_Faserdichte_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function tf_Faserdichte_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tf_Mediumdichte_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function tf_Mediumdichte_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tf_Laenge_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function tf_Laenge_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tf_Breite_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function tf_Breite_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tf_Hoehe_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function tf_Hoehe_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pm_Versuchwahl.
function pm_Versuchwahl_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function pm_Versuchwahl_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end