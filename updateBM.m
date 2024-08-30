function CCAF = updateBM(ccaf, yo, Dk, bound, mu)
    % constraint and update of BM parameters
    % bound passed in like [phi,psi]
    phi = bound(:,1:size(bound,2)/2); psi = bound(:,size(bound,2)/2+1:end);
    if vecnorm(Dk) == 0
        ccaf = ccaf;
    else
        ccaf = ccaf + mu*yo*Dk/vecnorm(Dk)^2;% Outproduct of yo dk
        ccaf(ccaf>phi) = phi(ccaf>phi); ccaf(ccaf<psi) = psi(ccaf<psi);  % Coefficient constraint
    end
    CCAF = ccaf;
end