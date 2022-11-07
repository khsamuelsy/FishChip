function fhtrack_initialization(GUI)

global gh

switch GUI
    
    case 'main'
        gh.param.batchNum = 1;
        gh.main.opened=1;
        gh.param.nframepbatch=6000;
        fhtrack_updateparam({'RootDir';'ExptDate';'ExptIndex'},...
            {'E:\';'';''});
%         fhtrack_updateparam({'ChunkSize';'FrameRate';'ImHeight';'ImWidth'},{25;240;484;644});
         fhtrack_updateparam({'ChunkSize';'FrameRate';'ImHeight';'ImWidth'},{25;240;360;640});
        gh.param.InferFlag = 0;
        gh.param.HlfWid = 15;
        gh.param.ExptType = 'Control';
        
        % for registration and background subtraction
        gh.data.refcoor = [];
        
         % load the template for calculating angles
        FileTemp = load('FhTemplate.mat','FhTemplate');
        gh.param.FhTemplate = fhtrack_NormIm(FileTemp.FhTemplate);
        for k = 1:360
            gh.param.FhTemplateRot{1,k} = imrotate(1-gh.param.FhTemplate,k-1);
        end
        gh.param.MaxCorr = zeros(36,1);

        % for the particular mask as of 2018-04-01
        ATemp = zeros(size(gh.param.FhTemplate));
        
        % corrdinate of fish head in the template
        Hx = 13; Hy = 6;
        ATemp(Hx,Hy) = 1;
        gh.param.FhTemplateHeadPt = zeros(360,2);
        for k = 1:360
            TemplateRotTemp = imrotate(ATemp, k-1, 'bicubic');
            [gh.param.FhTemplateHeadPt(k,1),gh.param.FhTemplateHeadPt(k,2)] = ind2sub(size(TemplateRotTemp),find(TemplateRotTemp==max(TemplateRotTemp(:))));
        end
        
        gh.param.FailIdx = [];
        
        
        
        gh.param.fhDeleteIdx = [];
        
    case 'disp'
        
        gh.disp.opened = 1;
        
        gh.data.sze = size(gh.data.ImRaw);
        gh.data.nFrame = gh.data.sze(3);
        gh.data.cFrame = 1;
        gh.data.cMax = 1;
        gh.data.cMin = 0;
        gh.data.Gamma = 1;
        gh.data.cSlice = zeros(gh.data.sze(1),gh.data.sze(2),3);
        
        % for storing initial coordinates and angles of fish
        gh.data.ix = [];
        gh.data.iy = [];
        gh.data.itheta = [];
        
        set(gh.disp.TextNFrame,'String',num2str(gh.data.nFrame));
        set(gh.disp.SliderMain,'Value',0, 'SliderStep',[1/(gh.data.nFrame-1) 0.1]);
        
        gh.disp.ih = image(zeros(1,1,3),'Parent',gh.disp.AxesMain);
        set(gh.disp.ih,'ButtonDownFcn',@fhtrack_axesfunc);
        daspect([1 1 1]);
        set(gh.disp.AxesMain,'XLim',[1,gh.data.sze(2)],'YLim',[1,gh.data.sze(1)]);
        
        fhtrack_dispdrawfunc;
        
    case 'manualtrack'
        
        gh.manualtrack.opened = 1;
        gh.param.nFrameApply = 1;
        gh.param.TogFlag = 0;
        
end
