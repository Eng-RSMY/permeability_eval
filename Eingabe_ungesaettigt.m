function varargout = Eingabe_ungesaettigt(varargin)
% EINGABE_UNGESAETTIGT MATLAB code for Eingabe_ungesaettigt.fig
%      Opens the Unsaturated permeability GUI. With this GUI you 
%      can evaluate a unsaturated permeability experiment. Loads 
%      data from an Excel input file and saves the results to an 
%      Excel output file.      
%
%      EINGABE_UNGESAETTIGT, by itself, creates a new 
%      EINGABE_UNGESAETTIGT or raises the existing singleton*.
%
%      H = EINGABE_UNGESAETTIGT returns the handle to a new 
%      EINGABE_UNGESAETTIGT or the handle to the existing singleton*.
%
%      EINGABE_UNGESAETTIGT('CALLBACK',hObject,eventData,handles,...) 
%      calls the local function named CALLBACK in  
%      EINGABE_UNGESAETTIGT.M with the given input arguments.
%
%      EINGABE_UNGESAETTIGT('Property','Value',...) creates a new
%      EINGABE_UNGESAETTIGT or raises the existing singleton*.  
%      Starting from the left, property value pairs areapplied to  
%      the GUI before Eingabe_ungesaettigt_OpeningFcn gets called. 
%      An unrecognized property name or invalid value makes property   
%      application stop. All inputs are passed to  
%      Eingabe_ungesaettigt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows  
%      only one instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response 
% to help Eingabe_ungesaettigt

% Last Modified by GUIDE v2.5 05-Sep-2012 17:20:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State =struct('gui_Name',      mfilename, ...
                  'gui_Singleton', gui_Singleton, ...
                  'gui_OpeningFcn',@Eingabe_ungesaettigt_OpeningFcn,...
                  'gui_OutputFcn', @Eingabe_ungesaettigt_OutputFcn,...
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


% --- Executes just before Eingabe_ungesaettigt is made visible.
function Eingabe_ungesaettigt_OpeningFcn(hObject, ~, handles, varargin)

handles.Main = varargin{1};
handles.Berechnen = @calculate;
handles.load = @load_data;
% Choose default command line output for Eingabe_ungesaettigt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Eingabe_ungesaettigt_OutputFcn(~, ~, handles) 

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
input = xlsread([pfad dateiname], 'In_unsat', 'D33:D89');

set(handles.tf_Faserdichte, 'String', num2str(input(1)));
set(handles.tf_Mediumdichte, 'String', num2str(input(7)));
set(handles.tf_Laenge, 'String', num2str(input(30)));
set(handles.tf_Breite, 'String', num2str(input(31)));
set(handles.tf_Hoehe, 'String', num2str(input(32)));
set(handles.Massentabelle, 'Data', input(46:end));

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
Intervall    = str2double(get(handles.tf_Intervall, 'String'))/100;
Startzeit    = str2double(get(handles.tf_Startzeit, 'String'));

Massen       = get(handles.Massentabelle, 'Data');
Speichername = get(handles.Main.Speichername, 'String');

%% Calculate some data

Lagenmasse_gesamt = sum(Massen);
Lagenmasse_spezifisch = Lagenmasse_gesamt/(Breite*Laenge)*1000;
V_f = Lagenmasse_spezifisch/(Faserdichte*Hoehe)*1000;
Porositaet = 1-V_f;
A_eff = Breite*Hoehe*Porositaet/1000000;

%% Load experimental data from the Excel-file

Daten = xlsread([pfad dateiname], 'raw', 'A50:D4000');
Zeit = Daten(:,1);
% p_inj_all = Daten(:,2);
% Sensor1 = Daten(:,3)
Sensor2 = Daten(:,2);
% Sensor3 = Daten(:,5)
Sensor4 = Daten(:,3);
Sensor5 = Daten(:,4);
% Sensor6 = Daten(:,8);
% Temperatur_m = mean(Daten(:,9));

Temperatur_m = 20;

%% Determine t_inj in the interval [0;(Startzeit+5s)] 
%  via lokal maximum

% [~, t_inj_1] = max(Sensor1(1:Startzeit+5));
[~, t_inj_2] = max(Sensor2(1:Startzeit+5));
% [~, t_inj_3] = max(Sensor3(1:Startzeit+5));
[~, t_inj_4] = max(Sensor4(1:Startzeit+5));
[~, t_inj_5] = max(Sensor5(1:Startzeit+5));
% [~, t_inj_6] = max(Sensor6(1:Startzeit+5));

if isequal(t_inj_2,t_inj_4,t_inj_5)
    t_inj = t_inj_2;
elseif isequal(t_inj_2,t_inj_4)
        t_inj = t_inj_2;
elseif isequal(t_inj_2,t_inj_5)
        t_inj = t_inj_2;
elseif isequal(t_inj_4,t_inj_5)
        t_inj = t_inj_4;
end

%% Derive the data

% ableitung1 = diff(Sensor1)./diff(Zeit);
ableitung2 = diff(Sensor2)./diff(Zeit);
% ableitung3 = diff(Sensor3)./diff(Zeit);
ableitung4 = diff(Sensor4)./diff(Zeit);
ableitung5 = diff(Sensor5)./diff(Zeit);
% ableitung6 = diff(Sensor6)./diff(Zeit);

%% Determine global minimum of the derivative

% [min1,index1] = min(ableitung1(Startzeit:end));
% index1 = index1+Startzeit-1;
[min2,index2] = min(ableitung2(Startzeit:end));
index2 = index2+Startzeit-1;
% [min3,index3] = min(ableitung3(Startzeit:end));
% index3 = index3+Startzeit-1;
[min4,index4] = min(ableitung4(Startzeit:end));
index4 = index4+Startzeit-1;
[min5,index5] = min(ableitung5(Startzeit:end));
index5 = index5+Startzeit-1;
% [min6,index6] = min(ableitung6(Startzeit:end));
% index6 = index6+Startzeit-1;

%% Find the points of time, where the slope is smaller 
%  than 10% of the minimum of the derivative

% Intervall1 = round(index1-Intervall*index1);
Intervall2 = round(index2-Intervall*index2);
% Intervall3 = round(index3-Intervall*index3);
Intervall4 = round(index4-Intervall*index4);
Intervall5 = round(index5-Intervall*index5);
% Intervall6 = round(index6-Intervall*index6);

% if Intervall1<Startzeit
%     ind1 = Startzeit-1+find(ableitung1(Startzeit:end)<0.1*min1);
% else
%     ind1 = Intervall1-1+find(ableitung1(Intervall1:end)<0.1*min1);
% end

if Intervall2<Startzeit
    ind2 = Startzeit-1+find(ableitung2(Startzeit:end)<0.1*min2);
else
    ind2 = Intervall2-1+find(ableitung2(Intervall2:end)<0.1*min2);
end

% if Intervall3<Startzeit
%     ind3 = Startzeit-1+find(ableitung3(Startzeit:end)<0.1*min3);
% else
%     ind3 = Intervall3-1+find(ableitung3(Intervall3:end)<0.1*min3);
% end

if Intervall4<Startzeit
    ind4 = Startzeit-1+find(ableitung4(Startzeit:end)<0.1*min4);
else
    ind4 = Intervall4-1+find(ableitung4(Intervall4:end)<0.1*min4);
end

if Intervall5<Startzeit
    ind5 = Startzeit-1+find(ableitung5(Startzeit:end)<0.1*min5);
else
    ind5 = Intervall5-1+find(ableitung5(Intervall5:end)<0.1*min5);
end

% if Intervall6<Startzeit
%     ind6 = Startzeit-1+find(ableitung6(Startzeit:end)<0.1*min6);
% else
%     ind6 = Intervall6-1+find(ableitung6(Intervall6:end)<0.1*min6);
% end

% t1 = ind1(1)-t_inj;
t2 = ind2(1)-t_inj;
% t3 = ind3(1)-t_inj;
t4 = ind4(1)-t_inj;
t5 = ind5(1)-t_inj;
% t6 = ind6(1)-t_inj;

%% Determine the injection pressure at the detected instats of time

p_inj = [1 1 1 1];
% p_inj = [p_inj_all(1) p_inj_all(ind1(1)) p_inj_all(ind2(1))...
%          p_inj_all(ind3(1)) p_inj_all(ind4(1)) p_inj_all(ind5(1))...
%          p_inj_all(ind6(1))]; 

%% Plot the p-t-diagram
if handles.Main.batch_unsat == 0
    h1 = figure;
    hold on
    grid on
    % plot(Zeit,Sensor1,'-k')
    % plot(ind1(1),Sensor1(ind1(1)+1),'m+')
    plot(Zeit,Sensor2,'-k')
    plot(ind2(1),Sensor2(ind2(1)+1),'m+')
    % plot(Zeit,Sensor3,'-k')
    % plot(ind3(1),Sensor3(ind3(1)+1),'m+')
    plot(Zeit,Sensor4,'-k')
    plot(ind4(1),Sensor4(ind4(1)+1),'m+')
    plot(Zeit,Sensor5,'-k')
    plot(ind5(1),Sensor5(ind5(1)+1),'m+')
    % plot(Zeit,Sensor6,'-k')
    % plot(ind6(1),Sensor6(ind6(1)+1),'m+')
    legend('Pressure curve','Detected points of time',...
           'Location','SouthEast');
    xlabel('Time [s]')
    ylabel('Pressure [bar]')

    button = questdlg('Are the detected points of time correct?',...
                      'Points of time','Yes','No','Yes');
    switch button
        case 'Yes'
            close(h1)
        case 'No'
            close(h1)
            uiwait(msgbox...
        ('Please change the interval and start the calculation again!'));
            return
    end
end

%% Liner interpolation of the viscosity

temp = xlsread([pfad dateiname],'In_unsat', 'C43:D58');
Viskositaet = interp1(temp(:,1),temp(:,2),Temperatur_m);

%% Least Square Fit Approach
%  - Calculation of the effective permeability

% t = [0 t1 t2 t3 t4 t5 t6];
t = [0 t2 t4 t5];

L_exp = [0 81 241 317];

dt = zeros(1,length(t));
Q = zeros(1,length(t));
R = zeros(1,length(t));
L_interp = zeros(1,length(t));
V_int = zeros(1,length(t));
K_Elem = zeros(1,length(t));
K_Sp = zeros(1,length(t));
dL_exp = zeros(1,length(t));

for n=2:length(t)
    dt(n) = t(n)-t(n-1);
    dL_exp(n) = L_exp(n)-L_exp(n-1);
    Q(n) = Q(n-1)+(p_inj(n)+p_inj(n-1))/2*dt(n);
end

for n=1:length(t)
    R(n) = L_exp(n)*sqrt(Q(n));
end

Q39 = sum(Q);
R39 = sum(R);

for n=1:length(t)
    L_interp(n) = R39/Q39*sqrt(Q(n));
end

V_exp = [0 0.75*dL_exp(2)/dt(2)];

for n=3:length(t)
    V_exp(n) = 0.5*(dL_exp(n)/dt(n)+dL_exp(n-1)/dt(n-1));
end

for n=2:length(t)
    V_int(n) = (L_interp(n)-L_interp(n-1))/dt(n);
    K_Elem(n) = Porositaet*Viskositaet/1000*V_exp(n)*L_exp(n)/...
                ((p_inj(n)+p_inj(n-1))/2)*0.00000000001;
    K_Sp(n) = Porositaet*Viskositaet/1000*V_int(n)*L_exp(n)/...
              ((p_inj(n)+p_inj(n-1))/2)*0.00000000001;
end

K_Interp = 0.5*Porositaet*Viskositaet/1000*(R39/Q39)^2*0.00000000001;

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


%% Plot and save the results
 
h2 = figure;
hold on
grid on
box on
% plot(Zeit(t_inj:end)-t_inj,Sensor1(t_inj:end),'-k')
% plot(t1,Sensor1(ind1(1)+1),'m+')
plot(Zeit(t_inj:end)-t_inj,Sensor2(t_inj:end),'-k')
plot(t2,Sensor2(ind2(1)+1),'m+')
% plot(Zeit(t_inj:end)-t_inj,Sensor3(t_inj:end),'-k')
% plot(t3,Sensor3(ind3(1)+1),'m+')
plot(Zeit(t_inj:end)-t_inj,Sensor4(t_inj:end),'-k')
plot(t4,Sensor4(ind4(1)+1),'m+')
plot(Zeit(t_inj:end)-t_inj,Sensor5(t_inj:end),'-k')
plot(t5,Sensor5(ind5(1)+1),'m+')
% plot(Zeit(t_inj:end)-t_inj,Sensor6(t_inj:end),'-k')
% plot(t6,Sensor6(ind6(1)+1),'m+')
legend('Pressure curve','Detected points of time',...
       'Location','SouthEast');
xlabel('Time [s]')
ylabel('Pressure [bar]')
axis tight


while length(Massen(:,1))<10
    Massen(end+1,1) = 0;
end

% Round data
V_f_r = round(V_f*1000)/1000;
Porositaet_r = round(Porositaet*1000)/1000;
A_eff_r = round(A_eff*100000)/100000;
Lagenmasse_spezifisch_r = round(Lagenmasse_spezifisch*1000)/1000;
Temperatur_m_r = round(Temperatur_m*1000)/1000;
Viskositaet_r = round(Viskositaet*1000)/1000;



d = {'Input file'             ,'',dateiname              ,''       ...
                ,'',''                    ,''
     'Unsaturated measurement','',''                     ,''       ...
                ,'',''                    ,''
     ''                       ,'',''                     ,''       ...
                ,'',''                    ,''
     'Fibre density'          ,'',Faserdichte            ,'[kg/m³]'...
                ,'','Points of time [s]',''
     'Fluid density'          ,'',Mediumdichte           ,'[kg/m³]'...
                ,'','Sensor2'             ,t2
     'Cavity length'          ,'',Laenge                 ,'[mm]'   ...
                ,'','Sensor4'             ,t4
     'Cavity width'           ,'',Breite                 ,'[mm]'   ...
                ,'','Sensor5'             ,t5'
     'Cavity height'          ,'',Hoehe                  ,'[mm]'   ...
                ,'',''                    ,''
     ''                       ,'',''                     ,''       ...
                ,'',''                    ,''
     'Fibre volume fracture'  ,'',V_f_r                  ,'[-]'    ...
                ,'','Ply masses [g]'      ,''
     'Porosity'               ,'',Porositaet_r           ,'[-]'    ...
                ,'','1'                   ,Massen(1,1)
     'Aeff'                   ,'',A_eff_r                ,'[m²]'   ...
                ,'','2'                   ,Massen(2,1)
     'Ply masses (total)'     ,'',Lagenmasse_gesamt      ,'[g]'    ...
                ,'','3'                   ,Massen(3,1)
     'Specific ply mass'      ,'',Lagenmasse_spezifisch_r,'[kg/m²]'...
                ,'','4'                   ,Massen(4,1)
     'Averaged temperature'   ,'',Temperatur_m_r         ,'[°C]'   ...
                ,'','5'                   ,Massen(5,1)
     'Viscosity'              ,'',Viskositaet_r          ,'[mPa*s]'...
                ,'','6'                   ,Massen(6,1)
     ''                       ,'',''                     ,''       ...
                ,'','7'                   ,Massen(7,1)
     ''                       ,'',''                     ,''       ...
                ,'','8'                   ,Massen(8,1)
     ''                       ,'',''                     ,''       ...
                ,'','9'                   ,Massen(9,1)
     'Effective permeability' ,'',K_Interp               ,'[m²]'   ...
                ,'','10'                  ,Massen(10,1)
     'Test number'            ,'',Sheet                  ,''       ...
                ,'',''                    ,''};
xlswrite(Speichername, d, Sheet, 'A1:G21');
close ('Unsaturated permeability GUI')
figure(h2)
xlsPasteTo(Speichername, Sheet, 550, 400, h2, 'A24');

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
as.Range('A10:D16').Interior.ColorIndex = 40;
as.Range('F4:G7').Interior.ColorIndex = 40;
as.Range('F10:G20').Interior.ColorIndex = 19;
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

% --- Executes on selection change in pm_Versuchwahl.
function pm_Versuchwahl_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function pm_Versuchwahl_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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

function tf_Startzeit_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function tf_Startzeit_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tf_Intervall_Callback(~, ~, ~) %#ok<DEFNU>

% --- Executes during object creation, after setting all properties.
function tf_Intervall_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
   get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end