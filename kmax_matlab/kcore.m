function result = kcore(A)
N = length(A); k = 2;
while 1
    degree = sum(A,2);
    if sum(degree<=k-1)==0
        result = k;
        k = k + 1;
        continue;
    end
    A(degree<=k-1,:) = [];
    if size(A,1) == 0||size(A,2) == 0
        result = k - 1;
        break;
    end
    A(:,degree<=k-1) = [];
end
