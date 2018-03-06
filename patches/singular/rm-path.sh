grep -rlF '/bin/rm' . | while read file
do
	sed -e 's@/bin/rm@rm@g' -i "$file"
done

patchShebangs .
