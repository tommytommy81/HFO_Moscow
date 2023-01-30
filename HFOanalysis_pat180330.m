addpath(genpath('C:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina
addpath(genpath('C:\Tom_Local\Matlab Toolbox\FIELDTRIP\fieldtrip-20131216')) % athina

pat = 5
% pat180330
% block 3:   1000-2700 s
% block 3:   6500-7000 s
% block 4:   6000-6300 s
% block 5:   1-1500 s
% block 5:   4500-5500 s
% block 6:   2500-2800 s
% data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
data_dir = 'H:\DATA\MOSCOW\Pirogov\Pirogov DATA\180330\nights\';

bipol           = [[2:128]' [2:128]'+1]
ciao            = [8 16 26 32 40 50 60:64 74 84 90 98 106 118];
bipol(ciao,: )  = [];


    bad_channels = [27 28 44]


%%

for block = 5:6
    
    switch block % pat180122
        
        case 1,  filename = 'Trubitcyna_ Na_71756151-7475-4094-af1f-785b551692c3.edf'      % 04.04.18      07.00.33
            
        case 2,  filename = 'Trubitcyna_ Na_741e5837-ddf9-42df-89f6-71c8921b1f40.edf'      % 04.04.18      05.00.19
            
        case 3,  filename = 'Trubitcyna_ Na_acef1b9f-9fee-4c81-8bc4-0dc8b6725d59.edf'      % 04.04.18      03.00.07
            
            for iter = 1:4
                switch iter    
                    case 1
                        filesave = 'HFO_pat180330_block3_sample1';
                        block = 3;  samples =  [1000*2000   1300*2000];
                    case 2
                        filesave = 'HFO_pat180330_block3_sample2';
                        block = 3;  samples =  [1500*2000   1800*2000];
                    case 3
                        filesave = 'HFO_pat180330_block3_sample3';
                        block = 3;  samples =  [2000*2000   2300*2000];
                    case 4
                        filesave = 'HFO_pat180330_block3_sample4';
                        block = 3;  samples =  [6500*2000   6800*2000];
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
            
        case 4,  filename = 'Trubitcyna_ Na_cc877446-5c92-45c6-bc55-81e80696946e.edf'      % 03.04.18      23.12.42
            
           for iter = 1
                switch iter    
                    case 1
                        filesave = 'HFO_pat180330_block4_sample1';
                        block = 4;  samples =  [6000*2000   6300*2000];
                     
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
            
           
        case 5,  filename = 'Trubitcyna_ Na_fce2723f-acca-4353-94ba-7cf66119e143.edf'      % 04.04.18      01.00.15
            % block 5:   1-1500 s
            % block 5:   4500-5500 s
          for iter = 2:5
                switch iter    % block = 3
                    case 1
                        filesave = 'HFO_pat180330_block5_sample1';
                        block = 5;  samples =  [1*2000   300*2000];
                    case 2
                        filesave = 'HFO_pat180330_block5_sample2';
                        block = 5;  samples =  [500*2000   800*2000];
                    case 3
                        filesave = 'HFO_pat180330_block5_sample3';
                        block = 5;  samples =  [1000*2000   1300*2000];
                    case 4
                        filesave = 'HFO_pat180330_block5_sample4';
                        block = 5;  samples =  [4500*2000   4800*2000];
                    case 5
                        filesave = 'HFO_pat180330_block5_sample5';
                        block = 5;  samples =  [5000*2000   5300*2000];    
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

    
    
    
    %     % edfread targetSignals
    %     t1         = cputime;
    %     [hdr,data] = edfread([data_dir filename],'targetSignals',2); % EEG
    % %     [hdr,data] = edfread([data_dir filename],'targetSignals',1:129); % EEG
    %     t_load     = cputime-t1 % 600 s
    %     dataraw    = data;
    %     clear data
    
    
    
    
    %         for jj = 1:length(bipol)
    %             data.lab_bip{jj,1} = [char(hdr.label{bipol(jj,1)}) '-' char(hdr.label{bipol(jj,2)})];
    %             data.x_bip(jj,:)   = dataraw(bipol(jj,1),samples) - dataraw(bipol(jj,2),samples);
    %         end
    
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
    
    