function fhtrack_editnumfunc(hObject)

EditName = get(hObject,'Tag');
ParamName = EditName(5:end);

EditValue = str2double(get(hObject,'String'));

fhtrack_updateparam({ParamName},{EditValue});