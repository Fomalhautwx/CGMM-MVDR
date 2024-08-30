function NCAF = updateMC(ncaf, z, Yk, K, mu)
% update of MC parameters with norm constraint
    if sum(vecnorm(Yk, 2, 2)) == 0
        w_prime = ncaf;
    else
        w_prime = ncaf + mu*z.*Yk/sum(vecnorm(Yk, 2, 2).^2);    % Adaptation of W   
    end
    normSum = sum(vecnorm(ncaf, 2, 2));
    NCAF = (normSum>K) : (@() sqrt(K./normSum)*w_prime) : (@() w_prime);% NCAF
end