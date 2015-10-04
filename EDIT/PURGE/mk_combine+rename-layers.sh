#!/bin/bash


 SRC=.
 TMPDIR=.

 COMBINETHESE=combinations.txt

 for SVG in `ls $SRC/*EDIT.svg`
  do

  BASENAME=`basename $SVG`
  TMP=$TMPDIR/`echo ${BASENAME%%.*} | md5sum | cut -c 1-8`

# --------------------------------------------------------------------------- #
# MOVE ALL LAYERS ON SEPARATE LINES IN A TMP FILE
# --------------------------------------------------------------------------- #
  sed ':a;N;$!ba;s/\n//g' $SVG           | # REMOVE ALL LINEBREAKS
  sed 's/<g/\n&/g'                       | # MOVE GROUP TO NEW LINES
  sed '/groupmode="layer"/s/<g/4Fgt7R/g' | # PLACEHOLDER FOR LAYERGROUP OPEN
  sed ':a;N;$!ba;s/\n/ /g'               | # REMOVE ALL LINEBREAKS
  sed 's/4Fgt7R/\n<g/g'                  | # RESTORE LAYERGROUP OPEN + NEWLINE
  sed 's/display:none/display:inline/g'  | # MAKE VISIBLE EVEN WHEN HIDDEN
  sed 's/<\/svg>/\n&/g'                  | # CLOSE TAG ON SEPARATE LINE
  sed "s/^[ \t]*//"                      | # REMOVE LEADING BLANKS
  tr -s ' '                              | # REMOVE CONSECUTIVE BLANKS
  tee > ${TMP}.tmp                         # WRITE TO TEMPORARY FILE
# --------------------------------------------------------------------------- #

  OUT=${TMP}.svg
  ALREADYTAKEN="XCGfdVdcHes7696" # NOTHING

  SVGHEADER=`head -n 1 ${TMP}.tmp`
  echo $SVGHEADER                                >  $OUT

  for KOMBI in `cat $COMBINETHESE` 
   do
      NEWLAYERNAME=`echo $KOMBI | #
                    cut -d ":" -f 1`
      echo "<g inkscape:groupmode=\"layer\" 
            id=\"$RANDOM\" 
            inkscape:label=\"$NEWLAYERNAME\">" | \
      tr -s ' '                                  >> $OUT

      for OLDLAYERNAME in `echo $KOMBI      | \
                           cut -d ":" -f 2- | \
                           sed 's/:/ /g'`
       do
          grep -n "label=\"$OLDLAYERNAME\"" ${TMP}.tmp | #
          egrep -v "$ALREADYTAKEN"                     | #
          sed 's/inkscape:groupmode="layer"//g'  >> ${OUT}.tmp
          ALREADYTAKEN=$OLDLAYERNAME"|"$ALREADYTAKEN
      done

      cat ${OUT}.tmp                   | #
      sort -n -u -t: -k1,1              | #
      cut -d ":" -f 2-                   | #
      sed "s/fill:#0f0c0c/fill:#dbdbdb/g" | #
      tee>> $OUT
      rm ${OUT}.tmp    
      echo "</g>"                                >> $OUT
  done
      echo "<g inkscape:groupmode=\"layer\" 
            id=\"$RANDOM\" 
            inkscape:label=\"unidentified\">" | \
      tr -s ' '                                  >> $OUT
      grep "^<g" ${TMP}.tmp            | #
      egrep -v "$ALREADYTAKEN"         | #
      sed 's/inkscape:groupmode="layer"//g'      >> $OUT
      echo "</g>"                                >> $OUT
      echo "</svg>"                              >> $OUT

      cp $OUT $SRC/${BASENAME%%.*}_SORTED.svg

      rm ${TMP}.*
 done


exit 0;

