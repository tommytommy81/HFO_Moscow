 
 
addpath(genpath('F:\Tom_Local\hfEEG\hfEEGAquistionRoutines'))
data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180406\nights\'
addpath(genpath('F:\Tom_Local\Matlab Toolbox\FIELDTRIP\fieldtrip-20180122\'))

patient =  7

% pat180516
% block 2: 6500 6800
% block 2: 7000 7300
% block 3: 1600 1900
% block 4: 2300 2600

% data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180406\nights\'


%% create biploar


change = [];
for l = 2:93
    if ~strncmp(data.label{l-1}(1),data.label{l}(1),1)
        change = [change l];
    end
end
change = change-1;
bipol     = [[1:92]' [1:92]'+1]
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

bad_channels = [26 27 28 29 34 38 40 41 42 43 44 45 64 65]; % 28 and 29 are 4F1-2 and 4F2-3

%%

% pat180406
% block 1:   3500-5500 s
% block 2:   2500-4500 s
% block 3:   not sure
% block 4:   200-500 s
% block 5:   1500-2300 s

for block = 1:5
    
    switch block % pat180406
        
         case 1,  filename = 'Pavlova_ Yuliy_697afb2d-bd45-4f79-8c8e-f6dc9b513099.edf'      % 09.04.18      22.21.26
         
            
             for iter = 1:4
                switch iter    
                    case 1
                        filesave = 'HFO_pat180406_block1_sample1';
                        block = 1;  samples =  [3500*2000   3800*2000];
                    case 2
                        filesave = 'HFO_pat180406_block1_sample2';
                        block = 3;  samples =  [4000*2000   4300*2000];
                    case 3
                        filesave = 'HFO_pat180406_block1_sample3';
                        block = 3;  samples =  [4500*2000   4800*2000];    
                    case 4
                        filesave = 'HFO_pat180406_block1_sample4';
                        block = 3;  samples =  [5000*2000   5300*2000];
                end
                cfg            = [];
                cfg.continuous = 'yes';
                cfg.trl        = [samples 0];
                cfg.dataset    = [data_dir filename]
                data_baseline  = ft_preprocessing(cfg);
                hdr.label      = data_baseline.label';
                dataraw        = data_baseline.trial{1};
                clear data_baseline
                
                bipolar_HFOcomp_savemat
                
             end
            
        case 2,  filename = 'Pavlova_ Yuliy_b263c632-841e-4ec1-b378-134822adc022.edf'      % 10.04.18      00.21.04      
                      
            for iter = 1:4
                switch iter    
                    case 1
                        filesave = 'HFO_pat180406_block2_sample1';
                        block = 1;  samples =  [200*2000   500*2000];
                    case 2
                        filesave = 'HFO_pat180406_block2_sample2';
                        block = 3;  samples =  [3000*2000   3300*2000];
                    case 3
                        filesave = 'HFO_pat180406_block2_sample3';
                        block = 3;  samples =  [3500*2000   3800*2000];    
                    case 4
                        filesave = 'HFO_pat180406_block2_sample4';
                        block = 3;  samples =  [4000*2000   4300*2000];
                end
                cfg            = [];
                cfg.continuous = 'yes';
                cfg.trl        = [samples 0];
                cfg.dataset    = [data_dir filename]
                data_baseline  = ft_preprocessing(cfg);
                hdr.label      = data_baseline.label';
                dataraw        = data_baseline.trial{1};
                clear data_baseline
                
                bipolar_HFOcomp_savemat
                
            end
        
       case 3,  filename = 'Pavlova_ Yuliy_1ecc06da-f264-4027-971b-81e9ffcf6c7a.edf'      % 10.04.18      02.21.08
        case 4,  filename = 'Pavlova_ Yuliy_ec6b333c-5da2-4b42-8549-0e5bc615f343.edf'      % 10.04.18      04.21.13
             
             for iter = 1 
                switch iter    
                    case 1
                        filesave = 'HFO_pat180406_block4_sample1';
                        block = 1;  samples =  [200*2000   300*2000];                   
                   
                end
                cfg            = [];
                cfg.continuous = 'yes';
                cfg.trl        = [samples 0];
                cfg.dataset    = [data_dir filename]
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
    
    