function fhtrack_editfunc(hObject)

EditName = get(hObject,'Tag');
ParamName = EditName(5:end);

EditValue = get(hObject,'String');

fhtrack_updateparam({ParamName},{EditValue});