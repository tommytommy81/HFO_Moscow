 
 
addpath(genpath('D:\Tom_Local\hfEEG\hfEEGAquistionRoutines'))
addpath(genpath('D:\Tom_Local\Matlab Toolbox\FIELDTRIP\fieldtrip-20180122\'))




% data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
data_dir = 'D:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180424\nights\'

% pat180424
%block3: 6200-7000 s
%block3: 7750-8100
 

%% create biploar


filename = 'Mahacheva_ El_213b4f12-c559-4473-a5a6-f724373cb522.edf' 
[hdr] = edfread([data_dir filename]);
label = hdr.label';
change = [];
for l = 2:65
    if ~strncmp(hdr.label{l-1}(1),hdr.label{l}(1),1)
        change = [change l];
    end
end
change = change-1;
bipol           = [[1:64]' [1:64]'+1]
bipol(change,:) = [];

% %%test
% clear data
for jj = 1:length(bipol)
    data_bip.lab_bip{jj,1}       = [char(data.label{bipol(jj,1)}) '-' char(data.label{bipol(jj,2)})];
    for tr = 1:length(data.trial)
    data_bip.trial{tr,1}   = data.trial{tr,1}(bipol(jj,1),:) - data.trial{tr,1}(bipol(jj,1),:) ;
    end
end
% 
% data.lab_bip 


 %%

% bad_channels = [37 38 41 50]; % 28 and 29 are 4F1-2 and 4F2-3

%%

% pat180424
%block3: 6200-7000 s
%block3: 7750-8100

for block = 2:3
    
    switch block % pat180424
        
         case 3,   filename = 'Mahacheva_ El_bf994021-2b5c-418e-9fd4-7c7e4460bf45.edf'      % 27.04.18      01.41.31   
         
            
             for iter = 2:4
                switch iter    
                    case 1
                        filesave = 'HFO_pat180424_block3_sample1';
                        block = 3;  samples =  [6200*2048   6500*2048];
                    case 2
                        filesave = 'HFO_pat180424_block3_sample2';
                        block = 3;  samples =  [6700*2048   7000*2048];
                    case 3
                        filesave = 'HFO_pat180424_block3_sample3';
                        block = 3;  samples =  [7200*2048   7500*2048];    
                    case 4
                        filesave = 'HFO_pat180424_block3_sample4';
                        block = 3;  samples =  [7800*2048   8100*2048];
                end
                cfg            = [];
                cfg.continuous = 'yes';
                cfg.trl        = [samples 0];
                cfg.dataset    = [data_dir filename]
                cfg.channel = [1:65]';
                data_baseline  = ft_preprocessing(cfg);
                hdr.label      = data_baseline.label';
                dataraw        = data_baseline.trial{1};
                clear data_baseline
                
                bipolar_HFOcomp_savemat
                
             end
            
    
            
             
           
            
       
            
           
        
            
       
                
           end
            
end

    
    
    
     
    %%
    if 0
        close all
        chs = [1:20]%+20+20+20+20+5%
        figure('units','normalized','outerposition',[0 0 1 1])
        shift = 1000
        ax(1) = subplot(1,1,1)
        plot_ch_list_simple(detrend(data.x_bip(chs,:)')', shift,  data.lab_bip(chs), 2000)
        
        addScrollbar( ax, 30  )
    end
    
    %% remove channels
    %  ciao = [10 11 28 29 43]
    %  data.x_bip(ciao,:) = [];
    %   data.lab_bip(ciao) = [];
    
    