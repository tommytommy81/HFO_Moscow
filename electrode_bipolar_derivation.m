% bipolar derivation

% case of patient 180122
el_blocks = [10 10 10 10 6 10 10 12 6 12 10 10];

% % case of patient 180122 verify with hdr.label
el_blocks = [5 7 8 9 8 6 6 8 8 8 10 6 12 5 8 8 5 10];



final_el = cumsum(el_blocks)
initi_el = [1 final_el(1:end-1)+1]

bip  = []
for el = 1:length(final_el)
    ecco = initi_el(el):final_el(el);
    bip = [bip; ecco(2:end)' ecco(1:end-1)'];
end
