#!/bin/bash

 SVG1=Andromeda_IAU_PURGED.svg
 SVG2=../../incoming/Andromeda_IAU.svg
 TMPID=XX
 inkscape --export-png=${TMPID}1.png \
          --export-background="#FFFFFF" \
          $SVG1
 inkscape --export-png=${TMPID}2.png \
          --export-background="#FFFFFF" \
          $SVG2
 compare -compose src ${TMPID}1.png ${TMPID}2.png \
         diff.png
#rm ${TMPID}*.png

exit 0;
