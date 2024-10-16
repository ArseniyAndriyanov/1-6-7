#!/bin/bash

treshold=1048576
percentage=70
nec=204800

path="/home/andryanov_arseny/LOG"

foldersize=$(du -s "$path" --block-size=K | awk '{print $1}' | sed 's/K//')
fullness=$(bc <<< "scale=3; ($foldersize / $treshold) * 100")

if (( $(echo "$fullness <= $percentage" | bc -l) )); then
    echo "Папка заполнена менее чем на $percentage%, архивация файлов не требуется"
else
    mkdir -p ~/BACKUP
    cd "$path"

	currsize=$(du -s "$path" --block-size=K | awk '{print $1}' | sed 's/K//')
    while [ "$currsize" -ge "$nec" ]; do
		d=$(ls --sort=time | head -n 1)
		mv "$d" ~/BACKUP/
		cd ~/BACKUP
		tar -czvf "${d}.tar.gz" "$d"
		rm -f "$d"
		cd "$path"
		currsize=$(du -s "$path" --block-size=K | awk '{print $1}' | sed 's/K//')
	done
    echo "Файлы успешно перемещены и заархивированы"
fi
