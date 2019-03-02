for i in 0 1
do
    for j in 0 1
    do
        for k in 0 1
        do
            python SAR_p2_cuenta_palabras.py tirantloblanc.txt $i $j $k > Data_tirantloblanc_${i}${j}${k}.txt
        done
    done
done