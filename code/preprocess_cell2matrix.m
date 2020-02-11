function [y] = preprocess_cell2matrix(MM, mm, lr, lc, bin, totDetect)
bincount=ceil((MM-mm+1)/10^12/bin);
y=zeros(lr,lc,bincount);
for a=1:lr
    for b=1:lc
        if size(totDetect{a,b},1)*size(totDetect{a,b},2)~=0
        [n,histbin]=histc(totDetect{a,b},mm:bin*10^(12):MM);
        y(a,b,:)=n;
        end
    end
end
end
