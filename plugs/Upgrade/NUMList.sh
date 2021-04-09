#!/bin/bash

NUMLSave=""
Count=1

for Item in (len ($NUMList))
do
    case $Item in
        * )
            $NUMLSave = $NUMLSave + " [$Count] " + $Item
            $Count = $Count + 1
            echo "$Count" 
        ;;
    esac
done

count=1

NUMList=$NUMLSave