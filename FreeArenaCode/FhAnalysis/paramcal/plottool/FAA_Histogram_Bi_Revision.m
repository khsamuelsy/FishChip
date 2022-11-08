function  FAA_Histogram(plotdata)

close all
mycolor = FishyChemoBehav_ColorPlate;

posdata = NaN(10000,6);
negdata = NaN(10000,6);
for i=1:min(6,size(plotdata,2))
    figure(i)
    temp = plotdata(:,i)*-1; % for left negative, right postiive
    temp = temp(~isnan(temp));
    posmedian = median(temp(temp>0));
    negmedian = median(temp(temp<0));
    posdata(1:length(temp(temp>0)),i) = temp(temp>0);
    negdata(1:length(temp(temp<0)),i) = temp(temp<0);
    if  i==1
        thecolor = mycolor.baseline;
        l = mycolor.linestyle.baseline;
    elseif i==2
        thecolor = mycolor.mainbi;
        l = mycolor.linestyle.mainbi;
    elseif i==3
        thecolor = mycolor.mainleft;
        l = mycolor.linestyle.mainleft;
    elseif i==4
        thecolor = mycolor.mainright;
        l = mycolor.linestyle.mainright;
    elseif i==5
        thecolor = mycolor.mainnull;
        l = mycolor.linestyle.mainnull;
    elseif i==5
        thecolor = mycolor.mainnull;
        l = mycolor.linestyle.mainnull;
    end

        histogram(temp,[-185:10:185],'Normalization','pdf','DisplayStyle','stairs','EdgeColor',thecolor, ...
            'LineWidth',2) %'EdgeAlpha',0.5

    hold on
    figure(i)
    plot([posmedian posmedian],[0 0.04],':','color',thecolor,'LineWidth',2)
    plot([negmedian negmedian],[0 0.04],':','color',thecolor,'LineWidth',2)
    hold off
    xlim([-180 180])
    ylim([0 0.04])
    xticks(-180:30:180)
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    set(figure(i), 'Units', 'pixels', 'Position', [500, 1000-i*150, 500, 50]);
    box off
end