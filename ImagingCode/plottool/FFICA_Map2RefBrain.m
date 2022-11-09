function [n_voxels,indx]=FFICA_Map2RefBrain(voxels,thisbrain,fishn,rOE_indx)

new_voxels = zeros(size(voxels));
voxels = round(voxels);

for ii=2:30
    indx = find(thisbrain.planeid==ii);
    [voxels(indx,1),voxels(indx,2)]=transformPointsForward((thisbrain.mask.tform2d{ii}),voxels(indx,1),voxels(indx,2));
end

voxels = round(voxels);

if fishn>400
    voxels(:,1) = voxels(:,1).*300/800;
    voxels(:,2) = voxels(:,2).*(300*1600/800)./1600;
elseif fishn>300
    voxels(:,1) = voxels(:,1).*300/792;
    voxels(:,2) = voxels(:,2).*(300*1408/792)./1408;
end

new_voxels(:,1) = voxels(:,1);
new_voxels(:,2) = voxels(:,2);

[new_voxels(:,1),new_voxels(:,2)]=transformPointsForward((thisbrain.regdata.regdata2d),voxels(:,1),voxels(:,2));

new_voxels = round(new_voxels);
[new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward((thisbrain.regdata.regdata3d),new_voxels(:,1),new_voxels(:,2),voxels(:,3));


dfield = reshape(full(thisbrain.regdata.dfield),[679 300 138 3]);

indx = [];
sz = size(dfield);

new_voxels = round(new_voxels);


for ii=1:size(voxels,1)
    if new_voxels(ii,2) <= sz(1) && new_voxels(ii,2) > 0 && ...
            new_voxels(ii,1) <= sz(2) && new_voxels(ii,1) > 0 && ...
            new_voxels(ii,3) <= sz(3) && new_voxels(ii,3) > 0
        indx = [indx;ii];
    else
        new_voxels(ii,:);
    end
end

thisbrain.indx=indx;

for ii=1:size(voxels,1)
    if ~any(indx==ii)
        new_voxels(ii,:) = [0,0,0];
    end
end

for ii=1:size(voxels,1)
    if any(indx==ii)
        x = new_voxels(ii,1) + ...
            dfield(new_voxels(ii,2),new_voxels(ii,1),new_voxels(ii,3),1);
        y = new_voxels(ii,2) + ...
            dfield(new_voxels(ii,2),new_voxels(ii,1),new_voxels(ii,3),2);
        z = new_voxels(ii,3) + ...
            dfield(new_voxels(ii,2),new_voxels(ii,1),new_voxels(ii,3),3);
        new_voxels(ii,:) = [x,y,z];
    end
end

list175 = [315,321];
list2 = [425,418];
list225 = [424,415];
list25 = [412];
list3 = [406];

rOE_transl = [412 15 -15;...
    415 25 -15; ...
    418 15 -15; ...
    424 25 -25; ...
    425 35 -35; ...
    406 20 -10;
    315 10 -5 ; ...
    321 0 0; ...
    334 45 -45; ...
    ];

if ismember(fishn,list2)
    fac = 2;
elseif ismember(fishn,list175)
    fac = 1.75;
elseif ismember(fishn,list225)
    fac=2.25;
elseif ismember(fishn,list25)
    fac=2.5;
elseif ismember(fishn,list3)
    fac=3;
else
    fac=5;
end

for ii=1:length(new_voxels(:,2))
    if new_voxels(ii,2)<=169
        ori_dis = 169-new_voxels(ii,2);
        new_voxels(ii,2) = 169 - ori_dis.*fac;
    end
    
    rown = find(rOE_transl(:,1)==fishn);
    if find(rOE_indx == ii)
        new_voxels(ii,1) = new_voxels(ii,1)+rOE_transl(rown,2);
        new_voxels(ii,2) = new_voxels(ii,2)+rOE_transl(rown,3);
    end
end

% manual registraiton of f334
if fishn==334
    R1 = zeros(4,4); R1(:,4) = [-200;0;0;0];  R1(4,4) = 1; R1(1,1) = 1;R1(2,2) = 1; R1(3,3) = 1;
    R2 = rotz(-2); R2(:,4) = 0; R2(4,:) = 0; R2(4,4) = 1;
    R3 = zeros(4,4); R3(:,4) = [+200;0;0;0];  R3(4,4) = 1;R3(1,1) = 1;R3(2,2) = 1; R3(3,3) = 1;
    R4 = zeros(4,4); R4(:,4) = [-200;-340;0;0];  R4(4,4) = 1; R4(1,1) = 1;R4(2,2) = 1; R4(3,3) = 1;
    R5 = rotx(50); R5(:,4) = 0; R5(4,:) = 0; R5(4,4) = 1;
    R6 = zeros(4,4); R6(:,4) = [+190;-50+340;0;0];  R6(4,4) = 1;R6(1,1) = 1;R6(2,2) = 1; R6(3,3) = 1;
    tform_f334_1 = affine3d(R1');
    tform_f334_2 = affine3d(R2');
    tform_f334_3 = affine3d(R3');
    tform_f334_4 = affine3d(R4');
    tform_f334_5 = affine3d(R5');
    tform_f334_6 = affine3d(R6');
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f334_1,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f334_2,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f334_3,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f334_4,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f334_5,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f334_6,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    for ii=1:length(new_voxels(:,2))
        if new_voxels(ii,2)>=300
            ori_dis = new_voxels(ii,2)-300;
            new_voxels(ii,2) = 300 + ori_dis.*2.25;
        end
    end
end

% manual registraiton of f406
if fishn==406
    R1 = zeros(4,4); R1(:,4) = [-150;0;0;0];  R1(4,4) = 1; R1(1,1) = 1;R1(2,2) = 1; R1(3,3) = 1;
    R2 = roty(-30); R2(:,4) = 0; R2(4,:) = 0; R2(4,4) = 1;
    R3 = zeros(4,4); R3(:,4) = [150;0;0;0];  R3(4,4) = 1;R3(1,1) = 1;R3(2,2) = 1; R3(3,3) = 1;
    R5 = rotz(2); R5(:,4) = 0; R5(4,:) = 0; R5(4,4) = 1;
    R6 = zeros(4,4); R6(:,4) = [60;-340;-7;0];  R6(4,4) = 1;R6(1,1) = 1;R6(2,2) = 1; R6(3,3) = 1;
    R7 = rotx(60); R7(:,4) = 0; R7(4,:) = 0; R7(4,4) = 1;
    R8 = zeros(4,4); R8(:,4) = [0;340;-15;0];  R8(4,4) = 1;R8(1,1) = 1;R8(2,2) = 1; R8(3,3) = 1;

    tform_f406_1 = affine3d(R1');
    tform_f406_2 = affine3d(R2');
    tform_f406_3 = affine3d(R3');
    tform_f406_5 = affine3d(R5');
    tform_f406_6 = affine3d(R6');
    tform_f406_7 = affine3d(R7');
    tform_f406_8 = affine3d(R8');
    
    for ii=1:length(new_voxels(:,2))
        if new_voxels(ii,2)>=300
            ori_dis = new_voxels(ii,2)-300;
            new_voxels(ii,2) = 300 + ori_dis.*1.75;
        end
    end

    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f406_1,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f406_2,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f406_3,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f406_5,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f406_6,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f406_7,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
    [new_voxels(:,1),new_voxels(:,2),new_voxels(:,3)]=transformPointsForward(tform_f406_8,new_voxels(:,1),new_voxels(:,2),voxels(:,3));
end

if fishn==418
   for ii=1:length(new_voxels(:,1))
        if new_voxels(ii,2)>=300
            new_voxels(ii,1) = new_voxels(ii,1)+15;
        end
   end
end
n_voxels = round(new_voxels);

end