#!/bin/bash

 SRCDIR=../../incoming
 OUTDIR=.
 TMPDIR=.

 for SVG in `ls ${SRCDIR}/*.svg`
  do
     BASENAME=`basename $SVG`
     TMP=$TMPDIR/`echo ${BASENAME%%.*} | md5sum | cut -c 1-8`

     inkscape --export-pdf=${TMP}.pdf \
              $SVG
     inkscape --export-plain-svg=${TMP}.svg \
              ${TMP}.pdf

# =========================================================================== #
# APPLY GROUP TRANSFORMATIONS
#
# LAYER GROUPS TO NORMAL GROUPS
# --------------------------------------------------------------------------- #
  sed -i 's/inkscape:groupmode="layer"//g' ${TMP}.svg
  sed -i 's/inkscape:label="[^"]*"//g'     ${TMP}.svg

# UNGROUP EVERYTHING (=> APPLY GROUP TRANSFORMS)
# --------------------------------------------------------------------------- #
  U="--verb SelectionUnGroup "
  UNGROUPOFTEN="$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U"
  inkscape --verb EditSelectAllInAllLayers \
           $UNGROUPOFTEN  \
           --verb FileSave \
           --verb FileClose \
           ${TMP}.svg
# =========================================================================== #     

  sed ':a;N;$!ba;s/\n//g' ${TMP}.svg  | #
  sed 's/<path/\n<path/g'             | #
  sed 's/<meta/\n<meta/g'             | #
  tr -s ' '                           | #
  sed '/^<path/s/>$/XyZxYz/g'         | #
  sed '/^<path/s/>/>\n/'              | #
  sed 's/XyZxYz/>/g'                  | #
  tee  > ${TMP}.tmp

# =========================================================================== #     
  EDITABLE=$OUTDIR/${BASENAME%%.*}_EDIT.svg

  SVGHEADER=`head -n 1 ${TMP}.tmp`
  echo $SVGHEADER                                                >  $EDITABLE
  for STYLE in `sed ':a;N;$!ba;s/\n//g' ${TMP}.tmp | #
                sed 's/style="/\nXXXX/g'           | #
                sed 's/"/"\n/'                     | #
                grep "^XXXX"                       | #
                sed 's/^XXXX//g'                   | #
                sort | uniq`
   do
      NAME=`echo $STYLE | md5sum | cut -c 1-16`
      echo "<g inkscape:groupmode=\"layer\" 
            id=\"$RANDOM\" 
            inkscape:label=\"$NAME\">" | \
      tr -s ' '                                                  >> $EDITABLE
      grep $STYLE ${TMP}.tmp                                     >> $EDITABLE
      echo "</g>"                                                >> $EDITABLE
  done
  echo "</svg>"                                                  >> $EDITABLE

# =========================================================================== #     
  rm ${TMP}.*

 done




exit 0;

