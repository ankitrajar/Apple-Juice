cd logs
for i in $(ls *log00*); do cp "${i}" ../cmbined_logs/cef5_"${i}" ; done
cd xcc_logs
for i in *.txt; do cp "${i}" targetdirectory/"${i}".OK ; done