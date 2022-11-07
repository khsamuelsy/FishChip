function fhtrack_bttnNextExpt

global gh

switch gh.param.ExptIndex
    case 'a'
        fhtrack_updateparam({'ExptIndex'},{'b'});
    case 'b'
        fhtrack_updateparam({'ExptIndex'},{'c'});
    case 'c'
        fhtrack_updateparam({'ExptIndex'},{'a'});
end