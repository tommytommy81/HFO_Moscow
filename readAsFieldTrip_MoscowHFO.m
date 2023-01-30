 
clc, clear all, close all
 
addpath(genpath('C:\Tom_Local\Matlab Toolbox\fieldtrip-20160216\'))
addpath(genpath('C:\Tom_Local\Matlab Toolbox\FIELDTRIP\fieldtrip-20131216')) % athina
 

%%

close all
data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\';
filename = 'Pchelinceva_ K_9c80f5c7-d818-45b6-a0d1-697472331127.edf'  
[hdr]    = edfread([data_dir filename])

cfg            = [];
cfg.continuous = 'yes';
cfg.trl        = [100*2000 400*2000 0];
cfg.dataset    = [data_dir filename]
data_baseline  = ft_preprocessing(cfg);
dataraw        = data_baseline.trial{1};
clear data_baseline
% figure, plot(data_baseline.trial{1}(2,:))
% hold on
% plot(dataraw(100*2000:400*2000),'r')


%% have a look at the beast!!!

 
%%

 

%  divide by trials

    
   
%  divide by trials
cfg                     = [];
cfg.channel             = [1:hdr.nChans];
cfg.dataset             = data_dir;
cfg.trialfun            = 'ft_trialfun_general'; % this is the default
cfg.fs                  = hdr.Fs;
cfg.event               = event;
cfg.trialdef.prestim    = 2; % in seconds
cfg.trialdef.poststim   = 20;

cfg.trialdef.type       = 'baseline';
cfg.trialdef.value      = 100;
cfg                     = ft_definetrialtom(cfg); 
if pat == 14
    shift = mean(diff(cfg.trl));
    cfg.trl = [cfg.trl(1,:)-3*shift;
        cfg.trl(1,:)-2*shift;
        cfg.trl(1,:)-1*shift;
        cfg.trl];end
 if pat == 9
 cfg.trl(end,:) = [];end
    
data_baseline           = ft_preprocessing(cfg);

 
cfg.trialdef.type       = 'fear';
cfg.trialdef.value      = 200;
cfg.fs                  = hdr.Fs;
cfg                     = ft_definetrialtom(cfg); 
if pat == 14
    cfg.trl = [cfg.trl(1,:)-3*shift;
        cfg.trl(1,:)-2*shift;
        cfg.trl(1,:)-1*shift;
        cfg.trl];end

data_fear               = ft_preprocessing(cfg);

 
 
%%
cfg             = [];

cfg.resamplefs  = 2000;
cfg.detrend     = 'no'
[data_land] = ft_resampledata(cfg, data_baseline)

cfg=[];
cfg.resamplefs  = 2000;
cfg.detrend     = 'no'
[data_face]     = ft_resampledata(cfg, data_fear)

% figure,
% plot(data_fear.time{1},data_fear.trial{1},'r')
% hold on
% plot(data_fear1.time{1},data_fear1.trial{1})


 
%% bipolar derivation
    clear data_land_bip data_land_bip
    
    
    data_land_bip = data_land;
    data_land_bip = rmfield(data_land_bip,{'trial','label'});    
    for tr = 1:length(data_land.trial)
        data_land_bip.trial{1,tr} = data_land.trial{1,tr}(bip2,:) - data_land.trial{1,tr}(bip1,:);
    end    
    for ch = 1:length(bip2)
                data_land_bip.label{ch}      = [char(data_land.label(bip2(ch))) '-' char(data_land.label(bip1(ch)))];end

    data_face_bip = data_face;
    data_face_bip = rmfield(data_face_bip,{'trial','label'});    
    for tr = 1:length(data_face.trial)
        data_face_bip.trial{1,tr} = data_face.trial{1,tr}(bip2,:) - data_face.trial{1,tr}(bip1,:);
    end    
    for ch = 1:length(bip2)
                data_face_bip.label{ch}      = [char(data_face.label(bip2(ch))) '-' char(data_face.label(bip1(ch)))];end
 
            
save([resultsdir '\' savemat], 'data_face_bip','data_land_bip','cfg' )

 
            
%         %% TF timelockaverage
% %  
% % 
% %  cfg = [];
% % %    time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
% % cfg.channels = data_land.label;
% % 
% % Tlock_Land   = ft_timelockanalysis(cfg, data_land_bip);   
% % Tlock_Face   = ft_timelockanalysis(cfg, data_face_bip);   
% %  
% %  
% %  % 
% % figure('units','normalized','outerposition',[0 0 1 1])
% % for ch = 1:64
% %     
% %     subplot(8,8,ch)
% %         plot(Tlock_Land.time, Tlock_Land.avg(ch,:) ,'b')
% %         hold on
% %         plot(Tlock_Face.time, Tlock_Face.avg(ch,:), 'r')
% %         
% %     title(Tlock_Face.label(ch))
% %     xlim([-2 10])
% % end       
% % 
% 
% 
% 
%     %% TF anaylsis
% %  load ([resultsdir savemat], 'data' )
% 
%  cfg = [];
% cfg.method       = 'mtmconvol'; 
% cfg.tapsmofrq    = 4;
% cfg.foi          = 2:2:200;                         % analysis 2 to 30 Hz in steps of 2 Hz 
% cfg.t_ftimwin    = ones(length(cfg.foi),1).*1  ;   % length of time window = 0.5 sec
% cfg.toi          = -2:0.2:10;                  % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
% 
%  %    time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
% cfg.channels = data_land_bip.label;
% 
%   
%   TFR_land  = ft_freqanalysis(cfg, data_land_bip);   
%  TFR_face  = ft_freqanalysis(cfg, data_face_bip);   
% 
%  
%  
% save([resultsdir '\' savemat '_TFR'], 'TFR_land','TFR_face','cfg' )

end
%  %% TF fig
% 
% close all
%  zrange = [-2  2 ]
% 
% base_ind = 5:20;
% time_bin = size(TFR_land.powspctrm,3);
% 
% 
% figure('units','normalized','outerposition',[0 0 1 1])
% plt = 1
% for ch =  1:64
% % for ch =  1:42,[1:3 8:10 15:17 22:24 29:31 36:38]       
%     subplot(8,8,plt) 
%     imagesc(TFR_land.time, TFR_land.freq, squeeze(TFR_land.powspctrm(ch,:,:))-   repmat(nanmean(squeeze(TFR_land.powspctrm(ch,:,base_ind)),2),1,time_bin),zrange);  
% %     colorbar
%         set(gca,'YDir','normal')
%     hold on
%     title(TFR_land.label(ch))
%     axis([-2 6 60 150])
%     plt = plt+1;
% end
% 
% 
% figure('units','normalized','outerposition',[0 0 1 1])
% plt = 1
% for ch =  1:64
% % for ch =  1:42,[1:3 8:10 15:17 22:24 29:31 36:38]       subplot(6,7,plt)
%     subplot(8,8,plt) 
%     imagesc(TFR_face.time, TFR_face.freq, squeeze(TFR_face.powspctrm(ch,:,:))-   repmat(nanmean(squeeze(TFR_face.powspctrm(ch,:,base_ind)),2),1,time_bin),zrange);  
% %     colorbar
%         set(gca,'YDir','normal')
%     hold on
%     title(TFR_land.label(ch))
%     axis([-2 6 60 150])
%     plt = plt+1;
% end


% figure('units','normalized','outerposition',[0 0 1 1])
% plt = 1
% for ch =  1:64
% % for ch =  1:42,[1:3 8:10 15:17 22:24 29:31 36:38]       subplot(6,7,plt)
%     subplot(8,8,plt) 
%     imagesc(TFR_face.time, TFR_face.freq, squeeze(TFR_face.powspctrm(ch,:,:))-   squeeze(TFR_land.powspctrm(ch,:,:)));  
% %     colorbar
%         set(gca,'YDir','normal')
%     hold on
%     title(TFR_land.label(ch))
%     axis([-1.5 6 60 150])
%     plt = plt+1;
% end
