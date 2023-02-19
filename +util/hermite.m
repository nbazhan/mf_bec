function h = hermite(x, N)
    N = N + 1;
    htable = zeros(3, size(x, 2));
    htable(1, :) = ones(size(x));
    htable(2, :) = 2*x;
    
    if N <= 2
        h = htable(N, :);
    else
        n = 1;
        while n < N - 1
            htable(3, :) = 2*x.*htable(2, :) - 2*n*htable(1, :);
            htable([1,2,3],:) =  htable([2,3,1],:);
            n = n + 1;
        end
        h = htable(2, :);
    end
        
end