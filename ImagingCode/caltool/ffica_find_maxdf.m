function ffica_find_maxdf

% find maxdf

global wholebrain

totalsessionn = min(size(wholebrain.signal3,2)./wholebrain.exptlog.fps,12);
framepsession = wholebrain.exptlog.fps;
summarystat = wholebrain.stiminfo.summarystat;
int_startf = 31; %from t = 0 to t = 15 s
int_endf = wholebrain.exptlog.fps;

ffica_loadstimt;
unileft_stim = wholebrain.stimtextract.unileft.profile(1:totalsessionn*framepsession);
uniright_stim = wholebrain.stimtextract.uniright.profile(1:totalsessionn*framepsession);
bilateral_stim = min(wholebrain.stimtextract.unileft.profile,wholebrain.stimtextract.uniright.profile);

act_startf = round(mean([wholebrain.stiminfo.summarystat.stat.leftchannel_startf_mean; ...
    wholebrain.stiminfo.summarystat.stat.rightchannel_startf_mean])) - int_startf;
act_endf = round(mean([wholebrain.stiminfo.summarystat.stat.leftchannel_endf_mean; ...
    wholebrain.stiminfo.summarystat.stat.rightchannel_endf_mean])) - int_startf;

[~,c_unileft,~,c_bileft] = cut(unileft_stim);
[~,~,c_uniright,c_biright] = cut(uniright_stim);
c_biboth = (c_bileft+c_biright)./2;

for ii=1:size(wholebrain.signal3,1)
    display(['Calculating dF : ',num2str(ii),'/',num2str(size(wholebrain.signal3,1))])
    signal = wholebrain.signal3(ii,:)';
    
    [ba,l,r,bi] = cut(signal);
    ba_traces = reshape(ba,[],wholebrain.exptlog.fps-30);
    l_traces = reshape(l,[],wholebrain.exptlog.fps-30);
    r_traces = reshape(r,[],wholebrain.exptlog.fps-30);
    bi_traces = reshape(bi,[],wholebrain.exptlog.fps-30);

    ba_median = getmedian(ba_traces);
    l_median = getmedian(l_traces);
    r_median = getmedian(r_traces);
    bi_median = getmedian(bi_traces);

    wholebrain.df.maxs(ii,1) = max(max(l_median(act_startf:act_startf+3))-max(ba_median(act_startf:act_startf+3)),0);
    wholebrain.df.maxs(ii,2) = max(max(r_median(act_startf:act_startf+3))-max(ba_median(act_startf:act_startf+3)),0);
    wholebrain.df.maxs(ii,3) = max(max(bi_median(act_startf:act_startf+3))-max(ba_median(act_startf:act_startf+3)),0);
    wholebrain.df.maxs(ii,4) = max(ba_median(act_startf:act_startf+3));
    wholebrain.df.maxs(ii,5) = max(max(l_median(act_startf:act_endf))-max(ba_median(act_startf:act_endf)),0);
    wholebrain.df.maxs(ii,6) = max(max(r_median(act_startf:act_endf))-max(ba_median(act_startf:act_endf)),0);
    wholebrain.df.maxs(ii,7) = max(max(bi_median(act_startf:act_endf))-max(ba_median(act_startf:act_endf)),0);
    wholebrain.df.maxs(ii,8) = max(ba_median(act_startf:act_endf));
end

    function output=getmedian(input)
        if ~isvector(input)
            output = median(input);
        else
            output = input;
        end
    end

    function [ba,l,r,bi] = cut(input)
        % cut the signal into corresponding trial
        ba=[];l=[];r=[];bi=[];
        for kk=1:min(totalsessionn,12)
            if isempty(find(wholebrain.misc.excluded_session == kk))
                offset=(kk-1)*framepsession;
                n = offset_bgdtrend(input(offset+int_startf:offset+int_endf));
                if strcmp(summarystat.session(kk).pracstim, ...
                        'baseline')
                    ba = [ba; n];
                elseif strcmp(summarystat.session(kk).pracstim, ...
                        'uni-left')
                    l = [l; n];
                elseif strcmp(summarystat.session(kk).pracstim, ...
                        'uni-right')
                    r = [r; n];
                elseif strcmp(summarystat.session(kk).pracstim, ...
                        'bilateral')
                    bi = [bi; n];
                end
            end
        end
    end
end

