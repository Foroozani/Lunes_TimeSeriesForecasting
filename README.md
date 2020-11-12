# Lunes_TimeSeriesForecasting
Time series forecasting models
---
To study the problem we have data measured from the stations  01.01.2008-30.12.2008. Also we used CALMET-CALPUFF modelling to generate more label data which can be feed to the models and our Neural Networks.

![Stations](https://github.com/Foroozani/Lunes_TimeSeriesForecasting/blob/main/images/stations.png)

## CALMET-CALPUFF modeling system
CALMET is a meteorological model composed of a module for calculating the wind field and micro-meteorological modules studied for the boundary layers both on water and the ground. CALMET generates 3D fields of wind and temperature, fields 2D mixing height, friction speed, precipitation rate etc and surface parameters such as roughness, albedo, etc. The diagnostic model for the calculation of the wind field is structured in two phases. The first phase consists of adapting the initial test field into based on the kinematic  effects of the terrain, on the slopes and on the blocking effects of the land.  The second phase, on the other hand, foresees the use of the data observed for determine the final wind field.

Our domin is the industrial part of Trieste (is a city and a seaport in northeastern Italy) as shown here. 
![Trieste](https://github.com/Foroozani/Lunes_TimeSeriesForecasting/blob/main/images/Domain.png)
