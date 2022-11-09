function ffica_find_mi_ar
% similar to find_mr but find the "mi_ar" based on linearly-summed ("L" + "R")
% response
global allbrain wholebrain

for mm=1:length(allbrain.fishn)
    
    wholebrain = allbrain.data{mm};
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
        display(['Calculating MI : ',num2str(ii),'/',num2str(size(wholebrain.signal3,1))])
        signal = wholebrain.signal3(ii,:)';
        signal = signal./max(signal(~isinf(signal)));
        [ba,l,r,bi] = cut(signal);
        tic;
        l_perm = l(randperm(length(l)));
        r_perm = r(randperm(length(r)));
        bi_perm = bi(randperm(length(bi)));
        trial_length = int_endf - int_startf+1;
        
        if wholebrain.cal2.mi(ii,1)>wholebrain.cal2.mi(ii,2)
            np = r;
            p = l;
        else
            np = l;
            p = r;
        end
        c_biboth_matchedlength = matchbilength(c_biboth,p);
        p_reshaped = reshape(p,trial_length,[]);
        np = reshape(np,trial_length,[]);
        sz = size(p_reshaped,2);
        if size(np,2)~=1
            np = repmat(mean(np')',sz,1);
        else
            np = repmat(np,sz,1);
        end
        
        % calculate the artificial MI based on addition
        wholebrain.cal2.mi_ar(ii) = MutualInfo2(np+p,c_biboth_matchedlength);
    end
    allbrain.data{mm} = wholebrain;
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

    function output = matchbilength(input,bi)
        if length(input)>length(bi)
            output=input(1:length(bi));
        elseif length(input)<length(bi)
            m = ceil(length(bi)./length(input));
            temp_put=repmat(input,m,1);
            output=temp_put(1:length(bi));
        else
            output=input;
        end
    end

end

