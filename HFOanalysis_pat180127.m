addpath(genpath('C:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina


pat = 3

data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\';

bipol           = [[2:127]' [2:127]'+1]
ciao            = [5 12 20 29 31 32 38 44 50 52 55 61 69 78 84 87 92 97 105 113 118 ];
bipol(ciao,: )  = [];


% pat180127

block = 3;  samples =  100*2000  : 400*2000;
block = 3;  samples =  700*2000  : 1000*2000;
block = 3;  samples =  4860*2000 : 5160*2000;
block = 3;  samples =  5900*2000 : 6200*2000;
block = 4;  samples =  2000*2000 : 2300*2000;
block = 4;  samples =  2500*2000 : 2800*2000;

%     case 4
%     data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
%     data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'

%%

for block = [3  ]
    
    switch block % pat180122
        
        case 1,   filename = 'Pchelinceva_ K_43b56397-9714-43df-808c-165b3961f495.edf'    % 29.01.18      00.04.16
            
        case 2,   filename = 'Pchelinceva_ K_bb6ba06b-8485-4cd4-a53e-5ad1c67e4c93.edf'     % 29.01.18      02.00.53
            
        case 3,   filename = 'Pchelinceva_ K_c705eaaa-0a0f-4d80-a77b-53c763e22b6c.edf'     % 29.01.18      04.00.58
            
            for iter = 3:4
                switch iter    % block = 3
                    case 1
                        filesave = 'HFO_pat180127_block3_sample1';
                        block = 3;  samples =  [100*2000   400*2000];
                    case 2
                        filesave = 'HFO_pat180127_block3_sample2';
                        block = 3;  samples =  [700*2000   1000*2000];
                    case 3
                        filesave = 'HFO_pat180127_block3_sample2';
                        block = 3;  samples =  [4860*2000   5160*2000];
                    case 4
                        filesave = 'HFO_pat180127_block3_sample4';
                        block = 3;  samples =  [5900*2000   6200*2000];
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
            
        case 4,   filename = 'Pchelinceva_ K_9c80f5c7-d818-45b6-a0d1-697472331127.edf'     % 29.01.18      06.00.24
            
            for iter = 1:2
                switch iter   % block = 4
                    case 1
                        filesave = 'HFO_pat180127_block4_sample1';
                        block = 4;  samples =  [2000*2000   2300*2000];
                        
                    case 2
                        filesave = 'HFO_pat180127_block4_sample2';
                        block = 4;  samples =  [2500*2000   2800*2000];
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
            
        case 5,   filename = 'Pchelinceva_ K_b1d5d669-32b4-4b1a-86b0-a10b62d340cc.edf'     % 29.01.18      08.00.08
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
        chs = [1:20]+20+20+20+20+5%
        figure('units','normalized','outerposition',[0 0 1 1])
        shift = 1000
        ax(1) = subplot(1,1,1)
        plot_ch_list_simple(detrend(data.x_bip(chs,:)')', shift,  data.lab_bip(chs), 2000)
        
        addScrollbar( ax, 30  )
    end
    % bas channels: 10 11 28 29 43
    
    %% remove channels
    %  ciao = [10 11 28 29 43]
    %  data.x_bip(ciao,:) = [];
    %   data.lab_bip(ciao) = [];
    
    