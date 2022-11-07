function [reversalFlag] = fhtrack_fhcheckreversal(oldCoor, newCoor, oldAng, newAng)

oldCoorTail = oldCoor - 10*[cosd(oldAng) sind(oldAng)];
newCoorTail = newCoor - 10*[cosd(newAng) sind(newAng)];

reversalFlag = ((norm(oldCoorTail-newCoorTail)>10) && (norm(oldCoor-newCoor)<7)) || ...
    (norm(oldCoorTail-newCoor)<norm(oldCoorTail-newCoorTail));
    
    