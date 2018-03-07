grep -rlF '/bin/cp' . | while read file
do
	sed -e 's@cp -p \./cp@cp@g' -i "$file"
done
