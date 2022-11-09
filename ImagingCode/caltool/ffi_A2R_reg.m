function ffi_A2R_reg

global gh

gh.main.param.singlemode=get(gh.main.rb_single,'Value');
gh.main.param.batchmode=get(gh.main.rb_batch,'Value');
gh.main.param.viewermode=get(gh.main.rb_viewer,'Value');
gh.reglog.task.lsbgsubtract=get(gh.main.cb_bgsubtract,'Value');
gh.reglog.task.lsvsnr=get(gh.main.cb_vsnr,'Value');
gh.reglog.task.ls2daffine=get(gh.main.cb_2daffine,'Value');
gh.reglog.task.ls3daffine=get(gh.main.cb_3daffine,'Value');
gh.reglog.task.lsnonrigided=get(gh.main.cb_imregdemon,'Value');
gh.reglog.task.createmask=get(gh.main.cb_createmask,'Value');
gh.reglog.task.lowerresol=get(gh.main.cb_lowerresol,'Value');
gh.reglog.transformtype = get(gh.main.edit_transformtype,'String');
gh.reglog.setfirstframe = get(gh.main.cb_setfirstframe,'Value');

if gh.main.param.singlemode
    ffi_register
    set(gh.display.rb_lsreg,'Enable','on')
    set(gh.display3.rb_lsref,'Enable','on')
    ffi_reg_updatedisplaysd
elseif gh.main.param.batchmode
    delete(ffi_reg_display)
    delete(ffi_reg_display2)
    delete(ffi_reg_display3)
    gh.main.param.fishnlist = getindexlist(get(gh.main.edit_fishn,'String'));
    for i=1:size(gh.main.param.fishnlist,1)
        gh.main.param.fishn=gh.main.param.fishnlist(i);
        ffi_reg_statusbar('fishn',num2str(gh.main.param.fishn),0)
        ffi_reg_updatebrainlist;
        ffi_reg_updateregn;
        set(gh.main.edit_regn','String',num2str(gh.main.param.regn))
        ffi_reg_loaddata;
        ffi_register; 
        ffi_reg_statusbar('fishn',num2str(NaN),0)
    end
elseif gh.main.param.viewermode
end
end

function ffi_register

global gh
if gh.reglog.setfirstframe
 ffi_reg_setlsfirstframe;
end
gh.im.list={};
gh.mask={};
list_length = 1;

if get(gh.main.cb_vsnr,'Value')
    ffi_reg_statusbar('reg','Denoise in progress ...',1)
    tic
    gh.im.lsvsnr=ffi_reg_destripe(gh.im.lsreg);
    toc
    ffi_reg_save(gh.main.param.fishn,gh.main.param.regn,'vsnr',gh.im.lsvsnr)
    gh.im.lsreg=im2_uint16(gh.im.lsvsnr);
    ffi_reg_statusbar('reg','Done VSNR ...',0)
    gh.im.list{list_length}='lsvsnr';
    list_length=list_length+1;
else
end


if get(gh.main.cb_2daffine,'Value') || get(gh.main.cb_3daffine,'Value') || get(gh.main.cb_imregdemon,'Value')
    if get(gh.main.cb_corrarte,'Value')
        ffi_reg_statusbar('reg','Correct affine artefact...',1)
        gh.im.lsreg = ffi_reg_corrstackarte (gh.im.lsreg,gh.regdata.lsfirstframe);
        ffi_reg_save(gh.main.param.fishn,gh.main.param.regn,'corrarte',gh.im.lsreg)
        ffi_reg_statusbar('reg','Done affine artefact',0)
    end
    if get(gh.main.cb_lowerresol,'Value')
        ImLs = imresize3(gh.im.lsreg, [round(300*size(gh.im.lsreg,1)/size(gh.im.lsreg,2)) 300 138]);
        ImRef = imresize3(gh.im.ref,[679 300 138]);
    else
        ImLs = gh.im.lsreg;
        ImRef = gh.im.ref;
    end
    gh.im.ref_resized=ImRef;
    
    if get(gh.main.cb_2daffine,'Value')
        ffi_reg_statusbar('reg','2D affine in progress...',1)
        tic
        [gh.regdata.tform2d,gh.im.ls2daffine,gh.regdata.ref2d_sr,gh.regdata.im2d_sr] = ffi_reg_2daffine(ImLs,ImRef);
        toc
        gh.reglog.regdata2d = gh.regdata.tform2d;
        gh.im.lsreg = gh.im.ls2daffine;
        ffi_reg_statusbar('reg','Done 2D affine',0)
        ffi_reg_save(gh.main.param.fishn,gh.main.param.regn,'2daff',gh.im.lsreg)
        gh.im.list{list_length}='ls2daffine';
        list_length=list_length+1;
    end
    if get(gh.main.cb_3daffine,'Value')
        gh.reglog.param3d.maxit = 7200; %1200
        gh.reglog.param3d.icpflag = 1; %1
        gh.reglog.param3d.dper = 0.02;
        gh.reglog.param3d.initradius = 9e-4; %9e-4
        gh.reglog.param3d.epilson = 1.5e-4; %1.5e-4
        gh.reglog.param3d.growthfactor = 1.001;%1.001
        ffi_reg_statusbar('reg','3D affine in progress...',1)
        tic

        [gh.regdata.tform3d,gh.im.ls3daffine,gh.regdata.ref3d_sr,gh.regdata.im3d_sr] = ffi_reg_3daffine(gh.im.ls2daffine,ImRef, gh.reglog.param3d);
        toc
        gh.reglog.regdata3d = gh.regdata.tform3d;
        gh.im.lsreg = gh.im.ls3daffine;
        ffi_reg_save(gh.main.param.fishn,gh.main.param.regn,'3daff',gh.im.lsreg)
        ffi_reg_statusbar('reg','Done 3D affine',0)
        gh.im.list{list_length}='ls3daffine';
        list_length=list_length+1;
        
    end
    
    if get(gh.main.cb_imregdemon,'Value')
        ffi_reg_statusbar('reg','Nonrigid reg in progress...',1)
        fixedGPU = (ImRef);
        movingGPU = (gh.im.ls3daffine);
        gh.reglog.imregdemon = [1000 500 500]; %1000 500 500
        tic
        [DfieldGPU, RegisteredGPU] = imregdemons(movingGPU , fixedGPU, gh.reglog.imregdemon, 'AccumulatedFieldSmoothing', 2); %100 50 50
        [DfieldGPU2, ~] = imregdemons(fixedGPU , movingGPU, gh.reglog.imregdemon, 'AccumulatedFieldSmoothing', 2); %100 50 50
        toc
        
        gh.regdata.nonrigid_dfield = (DfieldGPU);
        gh.im.lsnonrigided = (RegisteredGPU);
        % recent iteration is 400 200 200
        % KH default is %100 50 50
        gh.reglog.dfield = sparse(reshape(gh.regdata.nonrigid_dfield,[prod(size(DfieldGPU2)),1]));
        gh.im.lsreg = gh.im.lsnonrigided;
        ffi_reg_save(gh.main.param.fishn,gh.main.param.regn,'nr',gh.im.lsreg)
        ffi_reg_statusbar('reg','Done nonrigid',0)
        gh.im.list{list_length}='lsnonrigided';
        list_length=list_length+1;
    end
end

if get(gh.main.cb_createmask,'Value')
    
    ffi_reg_statusbar('reg','Mask creation in progress...',1)
    if get(gh.main.cb_lowerresol,'Value')
        if get(gh.main.cb_inclall,'Value')
            ffi_reg_createMask_all_lateralized_left;
            ffi_reg_createMask_all_lateralized_right;
        else
            ffi_reg_createMask;
        end
    else
        ffi_reg_createMask_oriresol;
    end
    gh.display.param.maskcreated = 1;
    ffi_reg_save(gh.main.param.fishn,gh.main.param.regn,'mask')
    ffi_reg_statusbar('reg','Created Mask',0)
end
end

function [tform2d,newIm,ref2d_sr,im2d_sr]=ffi_reg_2daffine(Im,Ref)
global gh
Im_avg=mean(Im,3);
Ref_avg=mean(Ref,3);
ref2d_sr = imref2d(size(Ref_avg));
im2d_sr = imref2d(size(Im_avg));
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.0009;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;

tform2d = imregtform(Im_avg, Ref_avg, gh.reglog.transformtype, optimizer, metric);
Im_avg_reg = imwarp(Im_avg, tform2d, 'OutputView', imref2d(size(Ref_avg)));

newIm = zeros(size(Ref));

for i = 1:size(newIm, 3)
    newIm(:, :,i) = imwarp(Im(:, :, i), tform2d, 'OutputView', imref2d(size(Ref_avg)));
end

end

function [tform3d,newIm,ref3d_sr,im3d_sr]=ffi_reg_3daffine(Im,Ref,param)
global gh
if param.icpflag
display('start icp')
tic
BW_Im = imbinarize(Im,'adaptive');
[r,c,v] = ind2sub(size(Im),find(BW_Im));
Im_ptCloud =pcdownsample(pointCloud([r,c,v]),'Random',param.dper);
BW_Ref = imbinarize(Ref,'adaptive');
[r2,c2,v2] = ind2sub(size(Ref),find(BW_Ref));
Ref_ptCloud = pcdownsample(pointCloud([r2,c2,v2]),'Random',1);
tform3d1 = pcregrigid(Im_ptCloud,Ref_ptCloud);
tempIm = imwarp(Im, tform3d1, 'OutputView', imref3d(size(Ref)));
toc
display('done icp')
pause(0.01)
end
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = param.initradius; %9e-4
optimizer.Epsilon = param.epilson; %1.5e-4
optimizer.GrowthFactor = param.growthfactor;%1.001
optimizer.MaximumIterations = param.maxit;

if param.icpflag
    tform3d2 = imregtform(tempIm, Ref, gh.reglog.transformtype, optimizer, metric);
    A = tform3d1.T*tform3d2.T;
else
    tform3d2 = imregtform(Im, Ref,gh.reglog.transformtype, optimizer, metric);
    A = tform3d2.T;
end

tform3d = affine3d(A);
ref3d_sr = imref3d(size(Ref));
im3d_sr = imref3d(size(Im));
newIm = imwarp(Im, tform3d, 'OutputView', imref3d(size(Ref)));

end