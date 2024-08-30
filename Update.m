% function to update the register with new sample
function newMat = Update(mat, dat)
    newMat = circshift(mat, 1, 2);
    assert(size(newMat, 1) == size(dat, 1), 'Shape of matrix should correspond with that of vector.');
    newMat(:, 1) = dat;
end