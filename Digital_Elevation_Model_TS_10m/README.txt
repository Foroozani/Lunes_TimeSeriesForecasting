2008-02-25 

ARPA FVG - Settore Tutela Qualità dell'Aria

COMPUTER: 05ACEVER3194 in arpa.fvg.it domain
DIRECTORY: D:\CALMET\data\outputs\DEM_FVG\

Files in this directory have been obtained from the Digital Elevation Model
(DEM) of the Friuli Venezia Giulia Regional Administration.

Original FVG-DEM files have been processed with an R(C) function called
read.fvg.DEM() in order to obtain:
- the ASCII files contained in this directory 
- the JPEG files contained in this directory

An extra .JPEG file is contained in this directory (quadro_unione_ts.jpg), 
visualizing the geographic area coverered by each elevation data file.

----------------------------------
ASCII file format

FVG_DEM_xxxxx0_xyz.txt contain

- a standard header, where informations about Geographic Coordinates System employed (Projection, Datum, Ellipsoid) and grid definition (number of x and y points, grid step, grid origin) are outlined

This is an example of header format:

Regional Agency for Environment Protection - Friuli Venezia Giulia Region (ARPA FVG) 
www.arpa.fvg.it 
Regional Center for Environmental Modelling (CRMA) 
via Cairoli, 14 - 33057 Palmanova (UD) ITALY 
Created on 2008-02-25 09:33:37 by FVG_DEM_Reader.r on 05ACEVER3194 Windows x86 machine 
Proj: UTM ; Datum: Rome Monte Mario 1940 ; Essipsoid: International 1924   Grid: 329 x 282 points ; Step 0.01 km ; Origin: ( 408.9 , 5047.363 ) km 

- measure units for x,y and elevation data:
km;km;m

- column names:
east;north;elevation

- data, separated by semicolon (column width is not fixed). 
Not available elevation data are flagged by -9999:

408.9;5047.363;-9999
408.91;5047.363;-9999
408.92;5047.363;-9999
408.93;5047.363;-9999
408.94;5047.363;-9999
408.95;5047.363;-9999
408.96;5047.363;-9999
408.97;5047.363;-9999
408.98;5047.363;-9999
408.99;5047.363;-9999
409;5047.363;-9999

----------------------------------


----------------------------------
FVG-DEM original files:

FVG-DEM has been obtained as a by-product of the FVG-CTRN and made available 
by the FVG Regional Authority

Contacts: 
arch. Mario Ghidini, tel. 040 3774062, e-mail mario.ghidini@regione.fvg.it
p.i. Massimo Zia, tel. 040 3774012, e-mail massimo.zia@regione.fvg.it

Data are stored in ASCII files. File names are in the format:
\verb&xxxxx0.asc&, where \verb&xxxxx0& is the 6 digits code of the corresponding 
CTRN 1:10000 Sections (eg: \verb&018130.asc&).

Files have an header where: number of columns and rows, coordinates of the 
lowest-left corner, cellsize and missing data code are specified.

E.g:
ncols         658
nrows         565
xllcorner     2422446
yllcorner     5050192
cellsize      10
NODATA_value  -9999  

No information has been required on the specific techniques and criteria applied 
to extract elevation data from CTRN and create the Digital Elevation Model.
----------------------------------