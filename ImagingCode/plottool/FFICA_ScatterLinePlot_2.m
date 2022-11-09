function FFICA_ScatterLinePlot_2(param,options)

close all
colorplate;
global mycolor
if ~options.logtransform
    plotdata = param;
else
    plotdata = log10(param);
end
% plot the 4 groups of data in plotdata
figure(1)

for i=1:size(param,2)
    display(['Working on dataset : ', num2str(i)])
    A = [];
    LocalGroupData = (plotdata(:,i));
    
    % render an x-pos for scatter points
    for j=1:10000
        % specify violin direction and central-x of scatter points
        if i == 1 || i ==3 ||  i==5
            cen_x = i+.12;
        else
            cen_x = i-.12;
        end
        
        % render an x-pos for scatter points
        A(j) = cen_x;
    end
    
    % mark the scatter points
    J = customcolormap_preset('purple-white-green')*.9;
    
    for j=1:6
        if mod(i,2)==0
            scattercolor = mycolor.mainbi_selcolor;
        else
            scattercolor = mycolor.mainuni_selcolor;
        end
        scatter(A(j),LocalGroupData(j),25,'filled','MarkerFaceColor',[scattercolor],'MarkerEdgeColor',[scattercolor]); hold on
        hold on
    end
    hold on
end

for i=1:6
    plot([1.1 1.9],[plotdata(i,1) plotdata(i,2)],'k','linestyle','--'); hold on
    plot([3.1 3.9],[plotdata(i,3) plotdata(i,4)],'k','linestyle','--'); hold on
    plot([5.1 5.9],[plotdata(i,5) plotdata(i,6)],'k','linestyle','--'); hold on
end

set(figure(1), 'Units', 'pixels', 'Position', [500, 500, 400, 400]);
if isfield(options,'set_yticks')
    
    ylim([options.set_yticks(1) options.set_yticks(end)])
    if ~options.skiplastyticks
        yticks(options.set_yticks)
    else
        yticks(options.set_yticks(1:end-1))
    end
end

ax1 = gca;
f2 = figure(2);
ax2 = copyobj(ax1,f2);
set(figure(2), 'Units', 'pixels', 'Position', [1000, 500, 400, 400]);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
set(gca,'XTick',[]);
ax1= gca;
ax1.XAxis.Visible = 'on';
ax1.XAxisLocation = 'origin';
box off

xlim([.5 size(param,2)+.5])