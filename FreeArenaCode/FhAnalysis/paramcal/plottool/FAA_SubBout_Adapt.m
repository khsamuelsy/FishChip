function FAA_SubBout_Adaptation_BoutN(bout1_vs_param,boutn_vs_param,options)

% reorganize data structure
intactwater = boutn_vs_param(:,1:2);
intactcad = boutn_vs_param(:,3:4);
leftintactcad = boutn_vs_param(:,5:6);
rightintactcad = boutn_vs_param(:,7:8);

% clear all NAN data
intactwater(isnan(intactwater(:,1)),:)=[];
intactcad(isnan(intactcad(:,1)),:)=[];
leftintactcad(isnan(leftintactcad(:,1)),:)=[];
rightintactcad(isnan(rightintactcad(:,1)),:)=[];

% correct boutn by subsequent bout by +1
intactwater(:,1) = intactwater(:,1)+1;
intactcad(:,1) = intactcad(:,1)+1;
leftintactcad(:,1) = leftintactcad(:,1)+1;
rightintactcad(:,1) = rightintactcad(:,1)+1;

% add first bout data
tempmean = zeros(1,4);
temp = bout1_vs_param(:,1);
temp2 = temp(~isnan(temp));
intactwater = [intactwater; repmat(1,length(temp2),1),temp2];
temp = bout1_vs_param(:,2);
temp2 = temp(~isnan(temp));
intactcad = [intactcad ; repmat(1,length(temp2),1),temp2];
temp = bout1_vs_param(:,3);
temp2 = temp(~isnan(temp));
leftintactcad= [leftintactcad; repmat(1,length(temp2),1),temp2];
temp = bout1_vs_param(:,4);
temp2 = temp(~isnan(temp));
rightintactcad = [rightintactcad; repmat(1,length(temp2),1),temp2];

% supp nan to fulfill the matrix data structure
intactwater(size(intactwater,1)+1:10000,1:2) = nan;
intactcad(size(intactcad,1)+1:10000,1:2) = nan;
leftintactcad(size(leftintactcad,1)+1:10000,1:2) = nan;
rightintactcad(size(rightintactcad,1)+1:10000,1:2) = nan;

names = {'intactwater','intactcad','leftintactcad','rightintactcad'};

for ii=1:4
    bout_number=eval([names{ii},'(:,1);']);
    param=eval([names{ii},'(:,2);']);
    for jj=1:10
        ind = find(bout_number==jj);
        %         [ii,jj,mean(tempdata2(ind)),length(ind)]
        anglevboutn(jj,ii) = mean(param(ind));
        anglevboutn_sem(jj,ii) = std(param(ind))./sqrt(length(param(ind)));
    end
end

for jj=1:4
testdata = [[1:10]',anglevboutn(:,jj)];
[taub tau h sig Z S sigma sen n senplot CIlower CIupper D Dall C3 nsigma] = ktaub(testdata, .05, 1);
[jj,sig]
end



cal.timevec = 1:10;
cal.meandata = anglevboutn;
cal.errordata = anglevboutn_sem;
FAA_Lineplot(cal,options)






end





