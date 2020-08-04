@ECHO OFF

REM If you are using a java based transform
SET java=C:\Program Files\Java\jdk1.8.0_221\bin\java.exe
REM cp is short for classpath
SET cp=C:\Tools\SaxonHE\saxon9he.jar
REM If you are using the .Net flavor of saxon
SET saxon=C:\Program Files\Saxonica\SaxonHE9.9N\bin\Transform.exe
REM Whichever you're using, the name of the xslt file
SET xslt=GenDitavalFromCSV.xsl
REM The csv file that lists all the issues
SET csvfile=Issues.csv
REM The csv file with upgrade parameters
SET upgradecsv=Upgrade.csv

REM If you have a java version of saxon
REM ECHO Running "%java%" -cp "%cp%" net.sf.saxon.Transform -s:dummy.xml -xsl:%xslt% DitavalCSV=%csvfile% DitavalUpgrade=%upgradecsv%
REM CALL "%java%" -cp "%cp%" net.sf.saxon.Transform -s:dummy.xml -xsl:%xslt% DitavalCSV=%csvfile% DitavalUpgrade=%upgradecsv%

REM If you have .NET
ECHO Running "%saxon%" -s:dummy.xml -xsl:%xslt% DitavalCSV=%csvfile% DitavalUpgrade=%upgradecsv%
CALL "%saxon%" -s:dummy.xml -xsl:%xslt% DitavalCSV=%csvfile% DitavalUpgrade=%upgradecsv%

GOTO :EOF