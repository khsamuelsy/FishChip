function FFICA_BrainRegionScatter(data,options)

global mycolor allbrain

switch options.grouping
    
    
    case 'lateralized'
        
        mvalue = zeros(20,1);
        
        regionid_l = [89,279,283,291,15,60,1,94,131,114];
        regionid_r = regionid_l+294;
        
        % assign negative values for left brain
        for ii=1:length(data.nregionid_all)
            if data.nregionid_all(ii)<=294 && data.nregionid_all(ii)>0
                nregionid(ii) = find(regionid_l == data.nregionid_all(ii))*-1;
                data.qty(ii) = -data.qty(ii);
            elseif data.nregionid_all(ii)>294
                nregionid(ii) = find(regionid_r == data.nregionid_all(ii));
            else
                nregionid(ii) = 0;
            end
        end
        
        % find average(median) 
        for ii=1:10
            list_l = find(nregionid==-ii);    list_r = find(nregionid==ii);
            if ismember(ii,options.barset)
                mvalue(ii) = nanmedian(data.qty(list_l));
            else
                mvalue(ii) = 0;
            end
            if ismember(ii,options.barset)
                mvalue(ii+10) = nanmedian(data.qty(list_r));
            else
                mvalue(ii+10) = 0;
            end
        end
        
        % plot the bars
        figure(options.fign)
        b_l=barh(1:10,mvalue(1:10));
        b_l.FaceColor = mycolor.mainleft; b_l.FaceAlpha = .25;
        b_l.EdgeColor = 'none'; hold on
        b_r=barh(1:10,mvalue(11:20));
        b_r.FaceColor = mycolor.mainright; b_r.FaceAlpha = .25;
        b_r.EdgeColor = 'none'; hold on
        
        % plot the scatters
        for ii=1:length(data.qty)
            if ~isnan(data.qty(ii))
                scatter(data.qty(ii),abs(nregionid(ii))+(rand-0.5)./6,options.scatterpoint,'MarkerEdgeColor',[0.5 0.5 0.5]); hold on
            end
        end
        
        ax1= gca; hold on
        ax1.XAxisLocation = 'bottom';
        ax1_pos = ax1.Position; % position of first axes
        
        ax2 = axes('Position',ax1_pos,...
            'XAxisLocation','top',...
            'Color','none');
        
        % plot the fracion line
        
        line(-data.fraction(1:10),1:10,'LineStyle','--','linewidth',2,'color',repmat(0,1,3),'Parent',ax2); hold on
        line(data.fraction(11:20),1:10,'LineStyle','--','linewidth',2,'color',repmat(0,1,3),'Parent',ax2);
        
        set(ax2,'xticklabel',{[]});
        set(ax2,'yticklabel',{[]});
        set(ax2,'YDir','reverse');
        set(ax2,'xlim',[-options.setxticks_fraction(end) options.setxticks_fraction(end)])
        ax2.YAxis.Visible = 'off';
        
        set(ax1,'Box','off')
        set(ax1,'xTick',[fliplr(options.setxticks(2:end))*-1,options.setxticks])
        set(ax1,'yTick',[1:10])
        set(ax1,'xlim',[-options.setxticks(end) options.setxticks(end)])
        set(ax1,'xticklabel',{[]});        set(ax1,'yticklabel',{[]});
        set(ax1, 'YDir','reverse');        ax1.YAxis.Visible = 'off';        ax1.XAxisLocation = 'bottom';
        
        if isfield(options,'noOE') & options.noOE
            set(ax1,'yTick',[2:10]);
            set(ax1,'ylim',[1 10]);
        end
        
        linkaxes([ax1,ax2],'y');
        set(figure(options.fign), 'Units', 'pixels', 'Position', [500, 500, 400, 400]);box off;
        box off
        
       
    case 'lateralized_ref'
        
        mvalue = zeros(20,1);
        
        regionid_l = [89,279,283,291,15,60,1,94,131,114];
        regionid_r = regionid_l+294;
        for ii=1:length(data.nregionid_all)
            if data.nregionid_all(ii)<=294 && data.nregionid_all(ii)>0
                nregionid(ii) = find(regionid_l==data.nregionid_all(ii))*-1;
                data.qty(ii)=-data.qty(ii);
            elseif data.nregionid_all(ii)>294
                nregionid(ii) = find(regionid_r==data.nregionid_all(ii));
            else
                nregionid(ii) =0;
            end
        end
        for ii=1:10
            list_l = find(nregionid==-ii);    list_r = find(nregionid==ii);
            if ismember(ii,options.barset)
                mvalue(ii) = nanmedian(data.qty(list_l));
            else
                mvalue(ii)=0;
            end
            if ismember(ii,options.barset)
                mvalue(ii+10) = nanmedian(data.qty(list_r));
            else
                mvalue(ii+10)=0;
            end
        end
        
        figure(options.fign)
        ax1= gca; hold on
        ax1.XAxisLocation = 'bottom';
        ax1_pos = ax1.Position; % position of first axes

        ax2 = axes('Position',ax1_pos,...
            'XAxisLocation','top',...
            'Color','none');
        
        line(-data.fraction(1:10),1:10,'LineStyle','-','linewidth',2,'color',repmat(0,1,3),'Parent',ax2); hold on
        line(data.fraction(11:20),1:10,'LineStyle','-','linewidth',2,'color',repmat(0,1,3),'Parent',ax2); hold on
        hold on
        line(-data.ref_fraction(1:10),1:10,'LineStyle','--','linewidth',2,'color',repmat(0.5,1,3),'Parent',ax2); hold on
        line(data.ref_fraction(11:20),1:10,'LineStyle','--','linewidth',2,'color',repmat(0.5,1,3),'Parent',ax2); hold on

        hold on
        
        set(ax1,'xtick',[]);
        set(ax2,'xticklabel',{[]});
        set(ax2,'yticklabel',{[]});
        set(ax2, 'YDir','reverse')
        set(ax2, 'xlim',[-options.setxticks_fraction(end) options.setxticks_fraction(end)])
        ax2.YAxis.Visible = 'off';
        
        ylim([0 11])
        plot([0 0],[0 11],'color','k','linewidth',.5)
        set(ax2,'Box','off')
        set(ax1,'xticklabel',{[]});
        set(ax1,'yticklabel',{[]});
        ax1.YAxis.Visible = 'off';
        ax1.XAxisLocation = 'bottom';
        set(figure(options.fign), 'Units', 'pixels', 'Position', [500, 500, 400, 400]);box off;
        box off
        
    case 'unified'
        
        % reorganize data
        regionid = [89,279,283,291,15,60,1,94,131,114];
        for ii=1:length(data.nregionid_all)
            if data.nregionid_all(ii)<=294 && data.nregionid_all(ii)>0
                nregionid(ii) = find(regionid==data.nregionid_all(ii));
            else
                nregionid(ii) = 0;
            end
        end
        for ii=1:10
            list = find(nregionid==ii);
            nantemp = data.qty(list);
            nantemp = nantemp(~isnan(nantemp));
            temp_mid(ii) = nanmedian(data.qty(list));
            temp_u(ii) = quantile(nantemp,.75);
            temp_l(ii) = quantile(nantemp,.25);
        end
        
        % plot
        figure(options.fign)
        len_1 = 0.3;
        len_2 = 0.15;
        for ii=1:length(data.qty)
            displacement =(rand-.5)./2;
            if options.clearscatter & abs(displacement)<0.2
                displacement = max(.2, abs(displacement))*sign(displacement);
            end
            if ~isnan(data.qty(ii))

                
                if size(options.scattercolor,1)~=1
                    if data.qty(ii)>=0
                        scatter(nregionid(ii)+displacement,data.qty(ii),options.scatterpoint,'MarkerEdgeColor',options.scattercolor(1,:));
                    else
                        scatter(nregionid(ii)+displacement,data.qty(ii),options.scatterpoint,'MarkerEdgeColor',options.scattercolor(2,:));
                    end
                else
                    scatter(nregionid(ii)+displacement,data.qty(ii),options.scatterpoint,'MarkerEdgeColor',options.scattercolor);
                end
                hold on
            end
        end
        for ii=1:10
            cen_x = ii;
            if ~isnan(temp_mid(ii))
                if size(options.colorscheme,1)~=1


                    color_draw1= options.colorscheme(max(round(((temp_mid(ii)-options.set_yticks(1))/(options.set_yticks(end)-options.set_yticks(1)))*size(options.colorscheme,1)),1),:);
                else
                    color_draw1 = options.colorscheme;
                end
                line_color = [0.3 0.3 0.3];
                plot([cen_x,cen_x],[temp_mid(ii) temp_u(ii)],'Color',line_color,'LineWidth',1.5); hold on;
                plot([cen_x,cen_x],[temp_mid(ii) temp_l(ii)],'Color',line_color,'LineWidth',1.5); hold on;
                scatter([cen_x],[temp_mid(ii)],40,'MarkerFaceColor',color_draw1,'MarkerEdgeColor',[0.3 0.3 0.3]); hold on
            end
        end
        
        set(figure(options.fign), 'Units', 'pixels', 'Position', [500, 500, 400, 400]);
        box off;
        set(gca,'xticklabel',{[]});
        set(gca,'yticklabel',{[]});
        set(gca,'XTick',[]);
        ax1= gca;
        ax1.XAxis.Visible = 'on';
        ax1.XAxisLocation = 'origin';
        xticks([])
        xlim([0 12])
        yticks(options.set_yticks);
        ylim([options.set_yticks(1) options.set_yticks(end)]);
end
end