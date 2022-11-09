function FFICA_BoxViolinPlot_2(param,options)

close all
colorplate; % or call ffica_colorplate
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
        data_perc = sum(round(LocalGroupData.*options.pt_spread_portion)==round(LocalGroupData(j).*options.pt_spread_portion));%*10
        weight = data_perc.*options.pt_spread/sum(~isnan(LocalGroupData));
        % generate a randn
        if options.uniproxi && i == 3
            therandn = abs(rand-0.5)*-1;
        elseif options.uniproxi && i == 4
            therandn = abs(rand-0.5);
        else
            therandn =(rand-0.5);
        end
        % specify violin direction and central-x of scatter points
        if ~options.uniproxi
            cen_x = i;
            side_spec='both';
        else
            if i == 1 || i ==2
                cen_x = i;
                side_spec='both';
            elseif i == 3
                cen_x = 2.95;
                side_spec='left';
            elseif i == 4
                cen_x = 3.05;
                side_spec='right';
            end
        end
        % render an x-pos for scatter points
        A(j) = cen_x + therandn*weight/2;
    end
    
    % mark the scatter points
    
    if isfield(options,'colorscheme')
        J=options.colorscheme;
    else
        J = customcolormap_preset('purple-white-green')*.9;
    end
    
    for j=1:sum(~isnan(LocalGroupData))
        scatter(A(j),LocalGroupData(j),2,'MarkerEdgeColor',[0.9 0.9 0.9]);
        hold on
    end
    
    % calculate average and intervals
    if options.parametric
        temp_mid = nanmean(LocalGroupData);
        nantemp = LocalGroupData(~isnan(LocalGroupData));
        temp_u = temp_mid+std(nantemp);
        temp_l = temp_mid-std(nantemp);
    else
        temp_mid = nanmedian(LocalGroupData);
        nantemp = LocalGroupData(~isnan(LocalGroupData));
        temp_u = quantile(nantemp,.75);
        temp_l = quantile(nantemp,.25);
    end
    
    % specify color of average and intervals, and violin plot
    if i==1
        color_draw=mycolor.baseline;
    elseif i==2
        color_draw=mycolor.baseline;
    elseif i==3
        color_draw=mycolor.baseline;
    elseif i==4
        color_draw = mycolor.mainright;
    end
    
    color_draw= J(round(((temp_mid+1)./2)*64),:);
    color_draw2 = [.7 .7 .7];
    % specify length of average and intervals lines
    if ~options.uniproxi
        len_1 = .12;
        len_2 = .08;
    else
        len_1 = .12;
        len_2 = .08;
    end
    
    violin(cen_x,plotdata(:,i),'facecolor',color_draw2,'side',side_spec, ...
        'scaling',options.violin_spread,'facealpha',0.2,'style',2); hold on;
    hold on
    % draw the average and intervals lines
    if options.uniproxi && i==3
        plot([cen_x-len_1,cen_x],[temp_mid temp_mid],'Color',color_draw,'LineWidth',2)
        plot([cen_x-len_2,cen_x],[temp_u temp_u],'Color',color_draw,'LineWidth',1.5)
        plot([cen_x-len_2,cen_x],[temp_l temp_l],'Color',color_draw,'LineWidth',1.5)
    elseif options.uniproxi && i==4
        plot([cen_x,cen_x+len_1],[temp_mid temp_mid],'Color',color_draw,'LineWidth',2)
        plot([cen_x,cen_x+len_2],[temp_u temp_u],'Color',color_draw,'LineWidth',1.5)
        plot([cen_x,cen_x+len_2],[temp_l temp_l],'Color',color_draw,'LineWidth',1.5)
    else
        plot([cen_x-len_1,cen_x+len_1],[temp_mid temp_mid],'Color',color_draw,'LineWidth',2)
        plot([cen_x-len_2,cen_x+len_2],[temp_u temp_u],'Color',color_draw,'LineWidth',1.5)
        plot([cen_x-len_2,cen_x+len_2],[temp_l temp_l],'Color',color_draw,'LineWidth',1.5)
    end
    hold on
    
    
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
