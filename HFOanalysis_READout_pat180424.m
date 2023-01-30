

clear all

addpath(genpath('D:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina 
resultsdir = 'D:\Tom_Local\Results\MOSCOW_HFO\'

 
     
list  = ls([resultsdir 'HFO_pat180424_*mat'])    
 
 
for se = 1:size(list,1)
    se
    filesave = list(se,:);
    load( [resultsdir filesave])    
    
    % visualize HFO distr
    
    for ch = 1:length( HFOobj)
        N_m_ripple(se,ch) = length(find(HFOobj(ch).result.mark ~= 2));
        N_m_FR(se,ch)     = length(find(HFOobj(ch).result.mark ~= 1));
        N_m_RFR(se,ch)    = length(find(HFOobj(ch).result.mark == 3));
        N_m_THRFR(se,ch) =  (HFOobj(ch).result.THRFR);
        labels(ch,:)     = HFOobj(ch).label;
    end
end

% bad = [25 33 47]
% 
% N_m_ripple(:,bad) = [];
% N_m_FR(:,bad)     = [];
% N_m_RFR(:,bad)    = [];
% N_m_THRFR(:,bad)  = [];
% labels(bad,:)      = [];

%%

figure, 
subplot(311), bar(mean(N_m_ripple))
subplot(312), bar(mean(N_m_FR))
subplot(313), bar(mean(N_m_RFR))
hold on
subplot(311), hold on, plot(mean(N_m_ripple)+std(N_m_ripple))
subplot(312), hold on, plot(mean(N_m_FR)+std(N_m_FR))
subplot(313), hold on, plot(mean(N_m_RFR)+std(N_m_RFR))
set(gca,'XTick',1:length(N_m_ripple),'XTicklabel', labels,'fontsize',8)
rotateXLabels(gca,90)


figure, bar(N_m_THRFR)



%% plot HFOs
close all

chosen_channels = [2 10 26 39 47 ]

labels_chosen = labels(chosen_channels)

fs = 2048;


dt   = 1/fs;
tt   = HFOobj(1).result.time;

% pos = 1
% for ch = chosen_channels
%     labels(pos,1) = HFOobj(ch).label ;
%     pos = pos+1;
% end

figure('units','normalized','outerposition',[0 0 1 1])
    ax(1)=  subplot(1,3,1)
        shift = 1000
        pos = 1
        for ch = chosen_channels
            plot(tt, detrend(HFOobj(ch).result.signal) - shift*pos,'b')
            hold on
            pos = pos+1;
        end
        ylim([-shift*(pos+1) 0]);
        set(gca,'YTick',[-shift*(pos-1):shift:-shift],'YTicklabel',flipud(labels_chosen))

    ax(2)=  subplot(1,3,2)
        shift = 40
        pos = 1
        for ch = chosen_channels
            N_ev =  (find(HFOobj(ch).result.mark ~=2));
            plot(tt, HFOobj(ch).result.signalFilt - shift*pos,'b')
            hold on
            for evin = N_ev
                hfo_samplesin = round(HFOobj(ch).result.autoSta(evin)*fs):round(HFOobj(ch).result.autoEnd(evin)*fs);
                plot(tt(hfo_samplesin), HFOobj(ch).result.signalFilt(hfo_samplesin) - shift*pos, 'r')
            end
            pos = pos+1;
        end
        ylim([-shift*(pos+1) 0]);
        set(gca,'YTick',[-shift*(pos-1):shift:-shift],'YTicklabel',flipud(labels_chosen))

    ax(3)=  subplot(1,3,3)
        shift = 20
        pos = 1
        for ch = chosen_channels
            N_ev =  (find(HFOobj(ch).result.mark ~=1));
            plot(tt, HFOobj(ch).result.signalFiltFR - shift*pos,'b')
            hold on
            for evin = N_ev
                hfo_samplesin = round(HFOobj(ch).result.autoSta(evin)*fs):round(HFOobj(ch).result.autoEnd(evin)*fs);
                plot(tt(hfo_samplesin), HFOobj(ch).result.signalFiltFR(hfo_samplesin) - shift*pos, 'r')
            end
            pos = pos+1;
        end
        ylim([-shift*(pos+1) 0]);
        set(gca,'YTick',[-shift*(pos-1):shift:-shift],'YTicklabel',flipud(labels_chosen))
    linkaxes(ax,'x')
    addScrollbar( ax, 5  )

 

