function FFICA_BrainMap(brainmap,options)

hr_f = 3;

% Generate Outline
load(['MaskDatabase.mat']);
MaskRegion = flip(reshape(full(MaskDatabase),[1406,621,138,294]),3);
classlist = [89,279,283,291,15,60,1,94,131,114];

outlines_z = zeros(679*hr_f,300*hr_f,length(classlist)+1,'logical');
outlines_y = zeros(679*hr_f,138*hr_f,length(classlist)+1,'logical');
outlines_x = zeros(138*hr_f,300*hr_f,length(classlist)+1,'logical');

for ii=1:10
    temp = bwmorph(imresize(mean(MaskRegion(:,:,:,classlist(ii)),3),[679*hr_f,300*hr_f]),'remove');
    se = strel('disk',2);
    outlines_z(:,:,ii) = imdilate(temp,se);
    temp = bwmorph(imresize(squeeze(mean(MaskRegion(:,:,:,classlist(ii)),2)),[679*hr_f,138*hr_f]),'remove');
    outlines_y(:,:,ii) = imdilate(temp,se);
    temp = bwmorph(imresize(squeeze(mean(MaskRegion(:,:,:,classlist(ii)),1)),[300*hr_f,138*hr_f]),'remove')';
    outlines_x(:,:,ii) = imdilate(temp,se);
end

outlines_z(:,:,11) = 0;
outlines_y(:,:,11) = 0;
outlines_x(:,:,11) = 0;

% Plot
hf = figure(options.fign);

% Plot the map
h2 = axes;
p2 = imshow(brainmap,[options.crange(1) options.crange(2)], 'InitialMag', 'fit');
set(p2,'AlphaData',~isnan(brainmap));

% Plot the outline
if options.type=='z'
    for ii=1:11
        o_h{ii} = axes;
        o_p{ii} = imshow(outlines_z(:,:,ii)*0.5,'InitialMag', 'fit');
        o_p{ii}.AlphaData=outlines_z(:,:,ii); hold on
        set(o_h{ii},'color','none','visible','off')
    end
end
if options.type=='y'
    for ii=1:11
        o_h{ii} = axes;
        o_p{ii} = imshow(outlines_y(:,:,ii)*0.5,'InitialMag', 'fit');
        o_p{ii}.AlphaData=outlines_y(:,:,ii);
        set(o_h{ii},'color','none','visible','off')
    end
end
if options.type=='x'
    for ii=1:11
        o_h{ii} = axes;
        o_p{ii} = imshow(outlines_x(:,:,ii)*0.5,'InitialMag', 'fit');
        o_p{ii}.AlphaData=outlines_x(:,:,ii);
        set(o_h{ii},'color','none','visible','off')
    end
end

% Calibrate the colormap
colormap(h2,options.colormap);
caxis(gca,[options.crange(1) options.crange(2)]);

% Link axes
linkaxes([h2 o_h{1} o_h{2} o_h{3} o_h{4} ...
    o_h{5} o_h{6} o_h{7} o_h{8} ...
    o_h{9} o_h{10} o_h{11}...
    ])
hold off

% Adjust aspect ratio
if options.type=='z'
    daspect([1 1 1])
elseif options.type=='y'
    daspect(h2,[2 1.65186 1])
    for ii=1:11
        daspect(o_h{ii},[2 1.65186 1])
    end
elseif options.type=='x'
    daspect(h2,[1.65186 2 1])
    for ii=1:11
        daspect(o_h{ii},[1.65186 2 1])
    end
end

% Final draw
drawnow;

end