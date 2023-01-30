addpath(genpath('C:\Tom_Local\hfEEG\hfEEG software analysis\hfEEGAquistionRoutines')) % athina


pat = 2

switch pat
    
    case 2

    data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180122\nights\'
    data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180122\nights\'
    % case of patient 180122
    block = 4;
    samples1 = 600*2000 : 900*2000;
    samples2 = 900*2000 : 1200*2000;
    samples3 = 1200*2000: 1500*2000;
    samples4 = 1500*2000: 1800*2000;
    
    
    block = 2;
    samples1 = 2500*2000 : 2800*2000; 
    samples2 = 3000*2000 : 3300*2000;
   
    
    
    
    el_blocks = [10 10 12  10 6 10 10 12 6 12 10 10 ];


    case 3
    data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
    data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'

    case 4
    data_dir = 'F:\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'
    data_dir = 'F:\Tom_Local\DATA\MOSCOW\Pirogov\Pirogov DATA\180127\nights\'

    end

% bipolar derivation
final_el = cumsum(el_blocks);
initi_el = [1 final_el(1:end-1)+1];

bipol  = []
for el = 1:length(final_el)
    ecco = initi_el(el):final_el(el);
    bipol = [bipol; ecco(2:end)' ecco(1:end-1)'];
end

switch block % pat180122
        
        case 1,  filename = 'Novichihin_ Vi_99462218-099d-49e2-b5d8-f85ca8c4338a.edf'      % 22.01.18      22.44.59
        case 2,  filename = 'Novichihin_ Vi_225196a0-a682-45f6-86e3-12eb9701b3c5.edf'      % 23.01.18      11.59.25
        case 3,  filename = 'Novichihin_ Vi_893b93f3-9663-40b1-b9f5-0885b6ea2679.edf'      % 23.01.18      00.00.45
        case 4,  filename = 'Novichihin_ Vi_5f27075a-82f5-4ed5-b1c2-422833bfb919.edf'      % 23.01.18      02.00.04
        case 5,  filename = 'Novichihin_ Vi_97a947f5-86c2-43c0-b877-eb268e68d905.edf'      % 23.01.18      04.00.35
        case 6,  filename = 'Novichihin_ Vi_ea07348b-4641-4420-8451-e69f29513547.edf'      % 23.01.18      05.59.54
            
end

[hdr] = edfread([data_dir filename]);
[hdr.startdate '      ' hdr.starttime]
 


% edfread targetSignals
t1         = cputime;
[hdr,data] = edfread([data_dir filename],'targetSignals',2:119); % EEG
t_load     = cputime-t1 % 600 s
dataraw = data;
clear data



for iter = 1:2
    
    switch iter        
        case 1
            samples = samples1;
            filesave = 'HFO_pat180122_block2_sample1';
        case 2
            samples = samples1;
            filesave = 'HFO_pat180122_block2_sample2'; 
    end


for jj = 1:length(bipol)
    data.lab_bip{jj,1} = [char(hdr.label{bipol(jj,1)}) '-' char(hdr.label{bipol(jj,2)})];
    data.x_bip(jj,:)   = dataraw(bipol(jj,1),samples4) - dataraw(bipol(jj,2),samples4);
end

%%
if 0
close all
chs = [1:20]+20+20+20+20+6
figure('units','normalized','outerposition',[0 0 1 1])
    shift = 1000 
    ax(1) = subplot(1,1,1)
    plot_ch_list_simple(detrend(data.x_bip(chs,:)')', shift,  data.lab_bip(chs), 2000)
     
    addScrollbar( ax, 30  )
end    
 % bas channels: 10 11 28 29 43
 
 %% remove channels
 ciao = [10 11 28 29 43]
 data.x_bip(ciao,:) = [];
  data.lab_bip(ciao) = [];
 %% HFO analysis
load FIR_2Khz
% run the detector
p.fs          = 2000; % SAMPLING Frequency
p.duration    = length(data.x_bip); % HOW MANY SECONDS OF DATA TO ANALYZE
p.filter      = filter;
p.hp          = 80; % high pass ripple
p.hpFR        = 250; % high pass FR
p.lp          = 500; % low pass FR
dt            = 1/p.fs;

for ch = 1:length( data.lab_bip)
    ch
    HFOobj(ch).result      = McGillDetector160422(data.x_bip(ch,:), p);
    HFOobj(ch).label       = data.lab_bip(ch);
    HFOobj(ch).result.time = dt:dt:dt*length(data.x_bip);
end

% save HFO_pat180122_sample1 HFOobj -v7.3
% save HFO_pat180122_sample2 HFOobj -v7.3
% save HFO_pat180122_sample3 HFOobj -v7.3
% save HFO_pat180122_sample4 HFOobj -v7.3

save( filesave, 'HFOobj','-v7.3')
end

%% visualize HFO distr

for ch = 1:length( data.lab_bip)
    N_m_ripple(ch) = length(find(HFOobj(ch).result.mark ~= 2));
    N_m_FR(ch)     = length(find(HFOobj(ch).result.mark ~= 1));
    N_m_RFR(ch)    = length(find(HFOobj(ch).result.mark == 3));
    N_m_THRFR(ch) =  (HFOobj(ch).result.THRFR); 
end

figure, 
subplot(311), bar(N_m_ripple)
subplot(312), bar(N_m_FR)
subplot(313), bar(N_m_RFR)
set(gca,'XTick',1:length(N_m_ripple),'XTicklabel', (char(data.lab_bip)),'fontsize',8)
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

 

