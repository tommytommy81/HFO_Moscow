function distalch_id = distalcontact(labels)

% for each contact starting by number, find the highest contact

clear electrode contact
for ll = 1:length(labels)
    
    label_loc = char(labels(ll))
    
    if str2num(label_loc(1)) % if it is a contact
        ifletter = 0
        lable_num = []
        for nn = 1:length(label_loc)
            if str2num(label_loc(nn))
            lable_num(nn) = 1+ifletter;
            else
                ifletter = 1;
            end
        end    
    electrode(ll,1) = str2num(label_loc(find(lable_num==1)));
    contact(ll,1)   = str2num(label_loc(find(lable_num==2)));
    label_id(ll,1)  = ll;
    end
    
end

el9     = find(electrode == 9);
el11    = find(electrode == 11);
electrode(el9(end)+1:el11(1)-1) = 10;
els     = unique(electrode);
els(find(els == 0)) =[];
els     = els';

RESULTS =[]
for el = els
    eccoli = find(electrode==el);
    [cts(el),quale] = max(contact(eccoli));
    lbs(el)    = label_id(eccoli(quale))
    RESULTS = [RESULTS; lbs(el) el cts(el)]
end    
   
distalch_id = lbs;