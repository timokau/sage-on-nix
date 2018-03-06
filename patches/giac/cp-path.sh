grep -rlF '/bin/cp' . | while read file
do
	sed -e 's@/bin/cp@cp@g' -i "$file"
done
