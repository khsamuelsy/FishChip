function ffica_find_area_sensory2
% recalculate the area of each trace
%for Fig. S9e

global allbrain

for aa=1:length(allbrain.fishn)
    
    wholebrain = allbrain.data{aa};
    totalsessionn = min(size(wholebrain.signal3,2)./wholebrain.exptlog.fps,12);
    framepsession = wholebrain.exptlog.fps;
    summarystat = wholebrain.stiminfo.summarystat;
    int_startf = 31; %from t = 0 to t = 15 s
    int_endf = wholebrain.exptlog.fps;

    unileft_stim = wholebrain.stiminfo.unileft.profile(1:totalsessionn*framepsession);
    uniright_stim = wholebrain.stiminfo.uniright.profile(1:totalsessionn*framepsession);
    bilateral_stim = min(wholebrain.stiminfo.unileft.profile,wholebrain.stiminfo.uniright.profile);
    
    act_startf = round(mean([wholebrain.stiminfo.summarystat.stat.leftchannel_startf_mean; ...
        wholebrain.stiminfo.summarystat.stat.rightchannel_startf_mean])) - int_startf;
    act_endf = round(mean([wholebrain.stiminfo.summarystat.stat.leftchannel_endf_mean; ...
        wholebrain.stiminfo.summarystat.stat.rightchannel_endf_mean])) - int_startf;
    
    actlength = act_endf-act_startf+1;
    
    [~,c_unileft,~,c_bileft] = cut(unileft_stim,wholebrain);
    [~,~,c_uniright,c_biright] = cut(uniright_stim,wholebrain);
    c_biboth = (c_bileft+c_biright)./2;
    
    for ii=1:size(wholebrain.signal3,1)
        display(['Calculating area : ',num2str(ii),'/',num2str(size(wholebrain.signal3,1))])
        signal = wholebrain.signal3(ii,:)';
        
        [ba,l,r,bi] = cut(signal,wholebrain);
        ba=ba';
        l=l';
        r=r';
        bi=bi';
        area.bi =[];
        
        for jj=1:size(bi,1)
            area.bi=[area.bi;abs(trapz(1:actlength,bi(jj,act_startf:act_endf)))];
        end
        area.uni = [];
        for jj=1:size(l,1)
            area.uni = [area.uni; abs(trapz(1:actlength,l(jj,act_startf:act_endf)))];
        end
        for jj=1:size(r,1)
            area.uni = [area.uni; abs(trapz(1:actlength,r(jj,act_startf:act_endf)))];
        end
        
        wholebrain.cal2.area.uni(ii) = mean(area.uni);
        wholebrain.cal2.area.bi(ii) = mean(area.bi);
    end
    allbrain.data{aa}=wholebrain;
    
    
    
end
end

function [ba,l,r,bi] = cut(input,wholebrain)
% cut the signal into corresponding trial
ba=[];l=[];r=[];bi=[];
framepsession = wholebrain.exptlog.fps;
totalsessionn = min(size(wholebrain.signal3,2)./wholebrain.exptlog.fps,12);
int_startf = 31; %from t = 0 to t = 10 s
int_endf = wholebrain.exptlog.fps;

act_startf = round(mean([wholebrain.stiminfo.summarystat.stat.leftchannel_startf_mean; ...
    wholebrain.stiminfo.summarystat.stat.rightchannel_startf_mean])) - int_startf;
act_endf = round(mean([wholebrain.stiminfo.summarystat.stat.leftchannel_endf_mean; ...
    wholebrain.stiminfo.summarystat.stat.rightchannel_endf_mean])) - int_startf;
summarystat = wholebrain.stiminfo.summarystat;
for kk=1:min(totalsessionn,12)
    if isempty(find(wholebrain.misc.excluded_session == kk))
        offset=(kk-1)*framepsession;
        n = detrend(input(offset+int_startf:offset+int_endf));
        if strcmp(summarystat.session(kk).pracstim, ...
                'baseline')
            ba = [ba,n];
        elseif strcmp(summarystat.session(kk).pracstim, ...
                'uni-left')
            l = [l, n];
        elseif strcmp(summarystat.session(kk).pracstim, ...
                'uni-right')
            r = [r, n];
        elseif strcmp(summarystat.session(kk).pracstim, ...
                'bilateral')
            bi = [bi, n];
        end
    end
end
end