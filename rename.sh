dir="/home/vijay/Pictures/wallpapers"

#rename files with numbers
j=0
for i in $(ls $dir/*jpg); do
    mv -v $i $j.jpg;
    j=$((j+1));
done

