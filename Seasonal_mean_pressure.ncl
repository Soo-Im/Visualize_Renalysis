begin

; read file
file1   =   "~//pres.mon.mean.nc"
f1      =   addfile(file1,"r")

; select period
t_limit =   12*(2019-1948)-1        ; 1948/01 ~ 2018/12
pres    =   f1->pres(0:t_limit,:,:) ; [mb]


; seasonal mean spatial plot
season = (/"DJF","MAM","JJA","SON"/)

do i = 0,3
    sson_raw    = month_to_season(pres,season(i))
    sson_mean = dim_avg_n_Wrap(sson_raw,0)  
;   printVarSummary(sson_raw)
    
    res     =   True
    wks     =   gsn_open_wks("png","~/HW/2019-2/2_1_"+season(i)+"_mean")
    res@tiMainString    =   "Mean surface pressure for "+season(i)

    res@cnLevelSelectionMode    = "ManualLevels"
    res@cnMaxLevelValF  = 1080
    res@cnMinLevelValF  = 520
    res@cnLevelSpacingF = 20

    res@cnFillOn         = True
    res@cnLineColor      = "Gray"
    res@cnFillPalette    = "BlueRed"    ; set color map 

    plot    = gsn_csm_contour_map(wks,sson_mean,res)

    rad     =   4.*atan(1.)/180.
    lat     =   f1->lat
    cost    =   cos(lat*rad)
    mean_pres   =   wgt_areaave_Wrap(sson_mean,cost,1.0,0)  ; weight "cost" for lat, "1.0" for lon 

    print (season(i))
    print (mean_pres)

    delete([/sson_raw,sson_mean,res/])
end do

end
