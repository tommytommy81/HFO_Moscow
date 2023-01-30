

clear all

addpath(genpath('E:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina
resultsdir = 'E:\Tom_Local\Results\MOSCOW_HFO\'



list  = ls([resultsdir 'HFO_pat180424_*mat'])
   clear s_m* N_m*

for se = 1:size(list,1)
    
    se
    filesave = list(se,:);
    load( [resultsdir filesave])
    
    % visualize HFO distr
    %%
     
        close all

    dt = .5
    time_bins = dt:dt:300;
    sm_fact = 10/dt;
    %
    for ch = 1:length( HFOobj)
        
        R_ind  = find(HFOobj(ch).result.mark ~= 2);
        FR_ind = find(HFOobj(ch).result.mark ~= 1);
        RFR_ind = find(HFOobj(ch).result.mark ==3);
        
        s_m_ripple(:,ch,se) = sm_fact/dt*smooth(histc(HFOobj(ch).result.autoSta(R_ind),time_bins),sm_fact);
        s_m_FR(:,ch,se)     = sm_fact/dt*smooth(histc(HFOobj(ch).result.autoSta(FR_ind),time_bins),sm_fact);
        s_m_RFR(:,ch,se)  = sm_fact/dt*smooth(histc(HFOobj(ch).result.autoSta(RFR_ind),time_bins),sm_fact);
        labels(ch )  = HFOobj(ch).label;
        
        N_m_ripple(se,ch) = length(find(HFOobj(ch).result.mark ~= 2));
        N_m_FR(se,ch)     = length(find(HFOobj(ch).result.mark ~= 1));
        N_m_RFR(se,ch)    = length(find(HFOobj(ch).result.mark == 3));
        
        t1 = HFOobj(ch).result.autoSta(RFR_ind);
            for ch2 = 1:length( HFOobj)
                     ISI = [];
                     RFR_ind2 = find(HFOobj(ch2).result.mark ==3);
                     t2 = HFOobj(ch2).result.autoSta(RFR_ind2);  
                     for rfr = 1:length(RFR_ind)
                         ISI = [ISI t1(rfr)-t2];
                     end
                     Prob(ch,ch2).ISI = ISI;
            end
    end


                     
        
        
        
        
    end
    
%% plot prob

         ch_o_i = [1 10 39 47]
figure
         for i = 1:4
             for j = 1:4
                 subplot(4,4,(i-1)*4+j)
                 dt = .2
                 time_bins = -5:dt:5;
                 bar(time_bins,histc(Prob(ch_o_i(i), ch_o_i(j)).ISI,time_bins))
                 xlim([time_bins(1) time_bins(end)])
                  title(['Prob of ' char(labels(ch_o_i(j))) ' around ' char(labels(ch_o_i(i)))])

             end
         end

%%
    
%     figure('Name',['session' num2str(se),', Ch of int'])
%         % ax(1) = subplot(411)
%         for j = 1:4
%          ax(j) = subplot(4,1,j),plot(time_bins, s_m_RFR(:,ch_o_i(j)))
%         legend(labels(ch_o_i))
%         end
%         linkaxes(ax,'x')
        
%         figure('Name',['session' num2str(se),', Xcorr'])
%         plt=1
%         for i = ch_o_i,for j = ch_o_i
%                 if 1, j>= i
%                 [x, lags] = xcorr(s_m_RFR(:,i), s_m_RFR(:,j),3000);
%                 subplot(4,4,plt), plot((lags)*dt,x)
%                 xlim([-100 100])
%                 title([char(labels(i)) ' vs ' char(labels(j))])
%                 end
%                 plt = plt+1;
% 
%             end
%         end

 figure('Name',['session' num2str(se),', Xcorr'])
 
         ch_o_i = [1 2 3 10 11 12  39:41  47:49]
         
         L = length(ch_o_i),
         clear x
         for se =1:4
             plt=1,
             
             
             for i = 1:L
                 for j = 1:L
                     if 1,
                         [x(:,i,j,se), lags] = xcorr(squeeze(s_m_RFR(:,ch_o_i(i),se)), squeeze(s_m_RFR(:,ch_o_i(j),se)),300/dt);
                         
                     end
                     plt = plt+1;
                     
                 end
             end
         end
 
 if 0
 sss = [1:4 ]
 figure
 for i = 1:L, for j = 1:L
 subplot(L,L,(i-1)*L+j), 
 m = mean(squeeze(x(:,i,j,sss)),2);
 s = std(squeeze(x(:,i,j,sss)),0,2)/2;
 shadedErrorBar((lags)*dt,m,s)
                xlim([-100 100])
                title(['delay of ' char(labels(ch_o_i(i))) ' to ' char(labels(ch_o_i(j)))])
     end;end
 end
 
 sss = [1:4 ]
 figure
 for i = 1:L, %for j = 1:L
     subplot(4,3,i),
     m = squeeze(mean(mean(x(:,i,:,sss),4),3));
     s = squeeze(mean(std(squeeze(x(:,i,:,sss)),0,2)/2,3));
     shadedErrorBar((lags)*dt,m,s)
     xlim([-10 10])
     title(['delay of ' char(labels(ch_o_i(i))) ' to ' char(labels(ch_o_i(j)))])
 end;%end
        


%%



figure, 
 bar((N_m_RFR'))
set(gca,'XTick',1:length(N_m_ripple),'XTicklabel', labels,'fontsize',8)
rotateXLabels(gca,90)
%% all sessions

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

chosen_channels = [40 41 42 1 93 94 95]

dt   = 1/2000;
tt   = HFOobj(1).result.time;

pos = 1
for ch = chosen_channels
    labels(pos,1) = HFOobj(ch).label ;
    pos = pos+1;
end

figure('units','normalized','outerposition',[0 0 1 1])
    ax(1)=  subplot(1,3,1)
        shift = 1000
        pos = 1
        for ch = chosen_channels
            plot(tt, detrend(HFOobj(ch).result.signal) - shift*pos)
            hold on
            pos = pos+1;
        end
        ylim([-shift*(pos+1) 0]);
        set(gca,'YTick',[-shift*(pos-1):shift:-shift],'YTicklabel',flipud(labels))

    ax(2)=  subplot(1,3,2)
        shift = 40
        pos = 1
        for ch = chosen_channels
            N_ev =  (find(HFOobj(ch).result.mark ~=2));
            plot(tt, HFOobj(ch).result.signalFilt - shift*pos)
            hold on
            for evin = N_ev
                hfo_samplesin = round(HFOobj(ch).result.autoSta(evin)*2000):round(HFOobj(ch).result.autoEnd(evin)*2000);
                plot(tt(hfo_samplesin), HFOobj(ch).result.signalFilt(hfo_samplesin) - shift*pos, 'r')
            end
            pos = pos+1;
        end
        ylim([-shift*(pos+1) 0]);
        set(gca,'YTick',[-shift*(pos-1):shift:-shift],'YTicklabel',flipud(labels))

    ax(3)=  subplot(1,3,3)
        shift = 20
        pos = 1
        for ch = chosen_channels
            N_ev =  (find(HFOobj(ch).result.mark ~=1));
            plot(tt, HFOobj(ch).result.signalFiltFR - shift*pos)
            hold on
            for evin = N_ev
                hfo_samplesin = round(HFOobj(ch).result.autoSta(evin)*2000):round(HFOobj(ch).result.autoEnd(evin)*2000);
                plot(tt(hfo_samplesin), HFOobj(ch).result.signalFiltFR(hfo_samplesin) - shift*pos, 'r')
            end
            pos = pos+1;
        end
        ylim([-shift*(pos+1) 0]);
        set(gca,'YTick',[-shift*(pos-1):shift:-shift],'YTicklabel',flipud(labels))
    linkaxes(ax,'x')
    addScrollbar( ax, 5  )

 

