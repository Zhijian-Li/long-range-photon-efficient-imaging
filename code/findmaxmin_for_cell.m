function [MM, mm] = findmaxmin_for_cell(totDetect, lr, lc)
MM=0;
mm=Inf;
for a=1:lr
    for b=1:lc
        if(size(totDetect{a,b},1)*size(totDetect{a,b},2)~=0)
            if(max(totDetect{a,b}(:))>MM)
                MM=max(totDetect{a,b}(:));
            end
            if(min(totDetect{a,b}(:))<mm)
                mm=min(totDetect{a,b}(:));
            end
        end
    end
end
end