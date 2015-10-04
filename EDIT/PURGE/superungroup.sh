#!/bin/bash

 SRCDIR=.

 for SVG in `ls ${SRCDIR}/*.svg`
  do

# UNGROUP EVERYTHING (=> APPLY GROUP TRANSFORMS)
# --------------------------------------------------------------------------- #
  U="--verb SelectionUnGroup "
  UNGROUPOFTEN="$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U$U"
  inkscape --verb EditSelectAllInAllLayers \
           $UNGROUPOFTEN  \
           --verb FileSave \
           --verb FileClose \
           $SVG
 done




exit 0;

