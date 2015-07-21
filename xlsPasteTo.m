function xlsPasteTo(filename, sheetname, width, height, fhandle, varargin)

%Paste figure to selected Excel sheet and cell
%
%
% xlsPasteTo(filename,sheetname,width,height,figurehandle,range)
%Example:
%xlsPasteTo('File.xls','Sheet1', 200, 200, h, 'A1')
% this will paset into A1 at Sheet1 at File.xls the figure with handle h
% with width and height of 200
%
% tal.shir@hotmail.com

options = varargin;

    range = varargin{1};
    




[fpath,file,ext] = fileparts(char(filename));
if isempty(fpath)
    fpath = pwd;
end
Excel = actxserver('Excel.Application');
set(Excel,'Visible',0);
Workbook = invoke(Excel.Workbooks, 'open', [fpath filesep file ext]);


sheet = get(Excel.Worksheets, 'Item',sheetname);
invoke(sheet,'Activate');




    ExAct = Excel.Activesheet;
   
  ExActRange = get(ExAct,'Range',range);
    ExActRange.Select;
    pos=get(fhandle,'Position');
    set(fhandle,'Position',[ pos(1:2) width height])
    print (fhandle, '-dmeta')

invoke(Excel.Selection,'PasteSpecial');

invoke(Workbook, 'Save');
invoke(Excel, 'Quit');
delete(Excel);

