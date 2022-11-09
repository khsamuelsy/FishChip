function framedata = ffiba_tipangle_extraction(x,y)

framedata.tipangle  = -atand((y(1) - y(2)) / (x(1) - x(2)));

end