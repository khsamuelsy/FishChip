function fhtrack_cvloadfunc(beginFlag)

global gh

numFrameToLoad = round(gh.param.ChunkSize*gh.param.FrameRate);

if beginFlag
    gh.param.FileName = [gh.param.RootDir,'\',gh.param.ExptDate,'\',gh.param.ExptIndex];
%     gh.data.vidObj = vision.VideoFileReader(FileName);
%     gh.data.vidObj.ImageColorSpace = 'intensity';
%     gh.data.vidObj.VideoOutputDataType = 'uint8';
    gh.data.ImRaw = zeros(gh.param.ImHeight,gh.param.ImWidth + 2*gh.param.HlfWid,numFrameToLoad,'uint8');
    gh.data.maxproj = imread([gh.param.RootDir,'\',gh.param.ExptDate,'\','1_maxproj.tif']);
    gh.param.batchNum =(str2num(gh.param.ExptIndex(1:end-4))-1)/gh.param.nframepbatch + 1;
    fhtrack_loadexistingdata;
    
else
    previous_tiff=gh.param.ExptIndex(1:end-4);
    new_tiff=num2str(str2num(previous_tiff)+gh.param.nframepbatch);
    new_tiff=strcat(new_tiff,'.tif');
    gh.param.ExptIndex=new_tiff;
    gh.param.FileName = [gh.param.RootDir,'\',gh.param.ExptDate,'\',gh.param.ExptIndex];
end


gh.data.LblMask = zeros(gh.param.ImHeight,gh.param.ImWidth + 2*gh.param.HlfWid,numFrameToLoad,'uint8');

t=Tiff(gh.param.FileName,'r');
imgdetails=imfinfo(gh.param.FileName);
nframes=length(imgdetails);


for k=1:nframes
    if mod(k,100)==0
        set(gh.main.txtLoadProgress,'String',['Loading ' num2str(k) ' / ' num2str(numFrameToLoad)]);
        pause(0.0001);
    end
    setDirectory(t,k);
    gh.data.ImRaw(:,gh.param.HlfWid+1:end-gh.param.HlfWid,k) = read(t);
end


close (t);
    
gh.data.ImRaw(:,[1:gh.param.HlfWid end-gh.param.HlfWid+1:end],:) = 255;

fhtrack_disp;