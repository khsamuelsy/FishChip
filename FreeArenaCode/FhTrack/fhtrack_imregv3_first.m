function fhtrack_imregv3_first(batchNum)

global gh

% variables for recording / keeping translations
%gh.data.TransOffset = zeros(size(gh.data.ImRaw,3),2);



if batchNum == 1
    
    % fftTemplate
    %gh.param.fftTemplate = fft2(gh.param.ImRefobj);
    
    % for background subtraction
    coorTemp = reshape([gh.data.refcoor{1,:}],2,[]);
    xi = coorTemp(1,:);
    yi = coorTemp(2,:);
    gh.param.ArenaMask = poly2mask(xi, yi, gh.param.ImWidth + 2*gh.param.HlfWid, gh.param.ImHeight)';
    gh.param.MeanGray = mean(reshape(gh.data.ImRaw(:,:,1),1,[]));
    gh.data.maxproj_norm = fhtrack_NormIm(single(gh.data.maxproj));
    gh.param.ArenaMaskU8 = uint8(single(1-gh.param.ArenaMask)*255);
    gh.param.maxprojstack = repmat(gh.data.maxproj,[1,1,100]);
    gh.param.arenastack = repmat(gh.param.ArenaMaskU8(:,16:end-15),[1,1,100]);

    % find the affine trasnformation needed for correcting images
    gh.data.tformVec = coorTemp(1:2,1);
    diffVec = coorTemp(:,2:4)-repmat(gh.data.tformVec,1,3);
    gh.data.tformMtx = [0,300,300;600,600,0]*diffVec'*(diffVec*diffVec')^-1;
    gh.data.tformAffine = affine2d([gh.data.tformMtx(1,1) gh.data.tformMtx(1,2) 0; ...
        gh.data.tformMtx(2,1) gh.data.tformMtx(2,2) 0; ...
        0                     0                     1    ]);
    
end

% perform the registration and background subtraction
for k = 1:size(gh.data.ImRaw,3)

%     ImPatch = gh.data.ImRaw(gh.data.refobjcoor(1,1)-375:gh.data.refobjcoor(1,1)+30,...
%         gh.data.refobjcoor(1,2)-60:gh.data.refobjcoor(1,2)+60,k);
%     output = dftregistration(gh.param.fftTemplate,fft2(ImPatch),1);
%     gh.data.TransOffset(k,1:2) = [output(3) output(4)];

%     if ~((gh.data.TransOffset(k,1)==0) && (gh.data.TransOffset(k,2)==0))
%         if ((gh.data.TransOffset(k,1)>=0) && (gh.data.TransOffset(k,2)>=0))
%             gh.data.ImRaw(gh.data.TransOffset(k,1)+1:end,gh.data.TransOffset(k,2)+1:end,k) = ...
%                 gh.data.ImRaw(1:end-gh.data.TransOffset(k,1),1:end-gh.data.TransOffset(k,2),k);
%         elseif ((gh.data.TransOffset(k,1)>=0) && (gh.data.TransOffset(k,2)<=0))
%             gh.data.ImRaw(gh.data.TransOffset(k,1)+1:end,1:end+gh.data.TransOffset(k,2),k) = ...
%                 gh.data.ImRaw(1:end-gh.data.TransOffset(k,1),-gh.data.TransOffset(k,2)+1:end,k);
%         elseif ((gh.data.TransOffset(k,1)<=0) && (gh.data.TransOffset(k,2)>=0))
%             gh.data.ImRaw(1:end+gh.data.TransOffset(k,1),gh.data.TransOffset(k,2)+1:end,k) = ...
%                 gh.data.ImRaw(-gh.data.TransOffset(k,1)+1:end,1:end-gh.data.TransOffset(k,2),k);
%         elseif ((gh.data.TransOffset(k,1)<=0) && (gh.data.TransOffset(k,2)<=0))
%             gh.data.ImRaw(1:end+gh.data.TransOffset(k,1),1:end+gh.data.TransOffset(k,2),k) = ...
%                 gh.data.ImRaw(-gh.data.TransOffset(k,1)+1:end,-gh.data.TransOffset(k,2)+1:end,k);
%         end
%     end
    
    if (mod(k,100)==0)
        gh.data.ImRaw(:,16:end-15,k-99:k) =...
            255 - (gh.param.maxprojstack-gh.data.ImRaw(:,16:end-15,k-99:k))...
            + gh.param.arenastack;
        set(gh.disp.textTrackProgress,'String',['Registered frame ' num2str(k) '/' num2str(size(gh.data.ImRaw,3))]);
        pause(0.001);
    end

end

fhtrack_getcentroid_first(batchNum);

fhtrack_addmask2Im(1,1:size(gh.data.FhCoor,2));
set(gh.disp.ChckbxDispMaskNum,'Value',1);

%add for gcamp6f part which has less dark pigment [delete and manual add
%previous algorith
for i=1:size(gh.data.FhCoor,2)

         set(gh.disp.textTrackProgress,'String', ['Tracking fish #: ' num2str(i) ]);
         pause(0.0001);

%     gh.data.FhCoor{1,i}(3:end,:) = 0;
%     gh.data.FhAng{1,i}(3:end) = 0;
%     LblMaskTemp = gh.data.LblMask(:,:,3:end);
%     LblMaskTemp(LblMaskTemp==i) = 0;
%     gh.data.LblMask(:,:,3:end) = LblMaskTemp;
    fhtrack_trackv10b(i, 3, gh.param.batchNum);
end
  

%alert the user when done tracking
fhtrack_alert1; 
%identify lost track during supervised tracking
fhtrack_playframes;
fhtrack_flagpotentiallosttrack;




