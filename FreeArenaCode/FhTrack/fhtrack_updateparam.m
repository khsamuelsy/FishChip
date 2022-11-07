function fhtrack_updateparam(ParamList,ValueList)

global gh

if ischar(ValueList{1,1})
    for ii=1:length(ParamList)
        set(eval(['gh.main.edit' ParamList{ii,1}]),'String',ValueList{ii,1});
        eval(['gh.param.' ParamList{ii,1} '=''' ValueList{ii,1} ''';']);
    end
else
    for ii=1:length(ParamList)
        set(eval(['gh.main.edit' ParamList{ii,1}]),'String',num2str(ValueList{ii,1}));
        eval(['gh.param.' ParamList{ii,1} '=' num2str(ValueList{ii,1}) ';']);
    end
end