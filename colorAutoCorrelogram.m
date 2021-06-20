function colorAutoCorrelogram = colorAutoCorrelogram(image)


    [img_no_dither, map] = rgb2ind(image, 64, 'nodither');

    rgb = ind2rgb(img_no_dither, map);

    clear('img_no_dither');

    distances = [1 3 5 7];

    colorAutoCorrelogram = correlogram(rgb, map, distances);
    colorAutoCorrelogram = reshape(colorAutoCorrelogram, [4 4 4]);

    colorAutoCorrelogram(:, :, 1) = colorAutoCorrelogram(:, :, 1)*distances(1);
    colorAutoCorrelogram(:, :, 2) = colorAutoCorrelogram(:, :, 2)*distances(2);
    colorAutoCorrelogram(:, :, 3) = colorAutoCorrelogram(:, :, 3)*distances(3);
    colorAutoCorrelogram(:, :, 4) = colorAutoCorrelogram(:, :, 4)*distances(4);
    
    colorAutoCorrelogram = reshape(colorAutoCorrelogram, 1, 64);
end

function valid = is_valid(X, Y, point)
    if point(1) < 0 || point(1) >= X
        valid = 0;
    end
    if point(2) < 0 || point(2) >= Y
        valid = 0;
    end
    valid = 1;
end

function Cn = get_neighbors(X, Y, x, y, dist)
    cn1 = [x+dist, y+dist];
    cn2 = [x+dist, y];
    cn3 = [x+dist, y-dist];
    cn4 = [x, y-dist];
    cn5 = [x-dist, y-dist];
    cn6 = [x-dist, y];
    cn7 = [x-dist, y+dist];
    cn8 = [x, y+dist];
 
    points = {cn1, cn2, cn3, cn4, cn5, cn6, cn7, cn8};
    Cn = cell(1, length(points));
 
    for ii = 1:length(points)
        valid = is_valid(X, Y, points{1, ii});
        if (valid)
        Cn{1, ii} = points{1, ii};
        end
    end
end

function colors_percent = correlogram(photo, Cm, K)
    [X, Y, ttt] = size(photo);
    colors_percent = [];
 
    for k = 1:K
        countColor = 0;
 
        color = zeros(1, length(Cm));
 
        for x = 2:floor(X/10):X
           for y = 2:floor(Y/10):Y
               Ci = photo(x, y);
               Cn = get_neighbors(X, Y, x, y, k);
 
               for jj = 1:length(Cn)
                   Cj = photo( Cn{1, jj}(1), Cn{1, jj}(2) );
 
                   for m = 1:length(Cm)
                       if isequal(Cm(m), Ci) && isequal(Cm(m), Cj)
                           countColor = countColor + 1;
                           color(m) = color(m) + 1;
                       end
                   end
               end
           end
        end
 
        for ii = 1:length(color)
            color(ii) = double( color(ii) / countColor );
        end
 
        colors_percent = color;
    end
end