function sensorConsumption(fluxVal,Across,ton,OT)
  % fluxVal: MMOIDs flux [Impact/(year*A)]
  % Across: crossectional area [m^2]
  % ton: time the sensor stays active[s]
  % OT: required operational time\ [days]
  actI = 60e-6; %[A]
  inactI = 20e-6; %[A]
  secInH = 60*60;
  
  % Impact per day
  imp_PD = (fluxVal/365)*Across
  % Total active time per day
  actTime_PD = ton*imp_PD
  % Total inactive time per day
  inactTime_PD = secInH*24 - actTime_PD
  %total current*time for inactive state [Ah/day]
  inactI_PD = inactTime_PD * inactI / secInH
  %Total current*time for Active state [Ah/day]
  actI_PD = actTime_PD * actI / secInH
  %Total CurrTime [Ah/day]
  totalI_PD = inactI_PD + actI_PD
  % Ah required for the battery
  battery_Ah = totalI_PD*OT
 end