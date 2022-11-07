function fhtrack_bttnExptType(hObject)

global gh

switch get(hObject,'String')
    case 'Control'
        set(hObject,'String','Aversive');
        set(hObject,'BackgroundColor',[0.85 0 0]);
        gh.param.ExptType = 'Aversive';
    case 'Aversive'
        set(hObject,'String','Appetitive');
        set(hObject,'BackgroundColor',[0 0.85 0]);
        gh.param.ExptType = 'Appetitive';
    case 'Appetitive'
        set(hObject,'String','Control');
        set(hObject,'BackgroundColor',[0 0.2 0.75]);
        gh.param.ExptType = 'Control';
end