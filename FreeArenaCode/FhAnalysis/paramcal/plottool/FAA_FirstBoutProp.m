function FAA_FirstBoutProp(all_boutn,options)

mycolor = colorplate;
plotdata = all_boutn;
datasize = zeros(4,1);firstboutesp = zeros(4,1);secondboutesp= zeros(4,1);
firstboutesp_combined = zeros(4,1);
percentage1 =[];percentage2 =[];

for i=1:4
    temp = plotdata(:,i);
    nantemp = temp(~isnan(temp));
    datasize(i) = length(nantemp);
    firstboutesp(i) = sum(nantemp<=1) ;
    secondboutesp(i) = sum(nantemp==2) ;
    firstboutesp_combined(i) = sum(nantemp<=2);
end
percentage1 = [firstboutesp./datasize];
percentage2 = [secondboutesp./datasize];
all_percentage = [percentage1,percentage2];

figure(1)
b=bar([1,2,2.8,3.2],all_percentage,.8,'stacked','FaceColor','flat','EdgeColor','None','BarWidth', 0.01); %% put the unilateral tgr
% alters the color
b(2).CData(1,:) = mycolor.baseline;b(2).CData(2,:) = mycolor.mainbi;
b(2).CData(3,:) = mycolor.mainleft;b(2).CData(4,:)= mycolor.mainright;
b(1).CData(1,:) = mycolor.baseline;b(1).CData(2,:) = mycolor.mainbi;
b(1).CData(3,:) = mycolor.mainleft;b(1).CData(4,:)= mycolor.mainright;
set(b(1),'BarWidth',1,'FaceAlpha',0.65,'EdgeColor','k','BarWidth', 0.8)
set(b(2),'BarWidth',1,'FaceAlpha',0.65,'FaceColor','none','EdgeColor','k','BarWidth', 0.8)
set(figure(1), 'Units', 'pixels', 'Position', [500, 500, 400, 400]);

ax1 = gca;
f2 = figure(2);
ax2 = copyobj(ax1,f2);

set(figure(2), 'Units', 'pixels', 'Position', [1000, 500, 400, 400]);
set(gca,'XTickLabel',[]);
set(gcf,'renderer','opengl'); box off
set(gca,'XTickLabel',[]);set(gca,'YTickLabel',[]);set(gca,'XTick',[]);

if options.stat
    % comparison of proportion using chi-square, matlab function crosstabl only
    % accepts raw data
    ChiSqTestData_x =[];
    ChiSqTestData_y =[];
    for i=1:4
        ChiSqTestData_x = [ChiSqTestData_x;repmat('y',firstboutesp_combined(i),1); repmat('n',(datasize(i)-firstboutesp_combined(i)),1); ];
        ChiSqTestData_y =[ChiSqTestData_y;repmat(num2str(i),datasize(i),1);];
    end
    yticklabels({});xticks([]);
    [tbl, chi2m, pm] = crosstab(ChiSqTestData_x ,ChiSqTestData_y );
    format short e
    display(['Group-wise stat p value: ',num2str(pm)])
    % post hoc comparison
    MaraTestData = [firstboutesp_combined,datasize];
    tmcomptest(MaraTestData,0.01)
end