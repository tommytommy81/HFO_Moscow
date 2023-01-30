for ch = 1:length( HFOobj)
    N_m_ripple(ch) = length(find(HFOobj(ch).result.mark ~= 2));
    N_m_FR(ch)     = length(find(HFOobj(ch).result.mark ~= 1));
    N_m_RFR(ch)    = length(find(HFOobj(ch).result.mark == 3));
    N_m_THRFR(ch) =  (HFOobj(ch).result.THRFR); 
    labels(ch) =  (HFOobj(ch).label)
end

 
figure, 
subplot(311), bar(N_m_ripple)
subplot(312), bar(N_m_FR)
subplot(313), bar(N_m_RFR)
set(gca,'XTick',1:length(N_m_ripple),'XTicklabel', char(labels),'fontsize',8)
rotateXLabels(gca,90)


figure, bar(N_m_THRFR)


%% plot HFOs
close all

chosen_channels = [40 41 42 1 93 94 95]
chosen_channels = [34 51 60 80]

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