#!/bin/bash

test_path="/home/andryanov_arseny/LOG"
backup_path="/home/andryanov_arseny/BACKUP"

run_original_script() {
    bash /home/andryanov_arseny/script1.sh
}

run_backup_test() {
    local test_number=$1
    foldersize=$(du -hs "$test_path" --block-size=K | awk '{print $1}')
    backupsize=$(du -hs "$backup_path" --block-size=K | awk '{print $1}')
    echo "Изначальный вес папки log: $foldersize, папки backup: $backupsize"
    run_original_script

    foldersize=$(du -k "$test_path" | cut -f1)
    backupsize=$(du -hs "$backup_path" --block-size=K | awk '{print $1}')

    if [ "$test_number" -eq 1 ] || [ "$test_number" -eq 4 ]; then
        if [ "$foldersize" -lt 204800 ] && [ -z "$(ls -A "$backup_path")" ]; then
            echo "Тест $test_number пройден. Вес папки log: $foldersize K, вес папки backup: $backupsize"
        else
            echo "Тест $test_number не пройден. Вес папки log: $foldersize K, вес папки backup: $backupsize"
        fi
    elif [ "$test_number" -eq 2 ] || [ "$test_number" -eq 3 ]; then
        if [ "$foldersize" -lt 204800 ] && ls "$backup_path"/*.tar.gz 1> /dev/null 2>&1; then
            echo "Тест $test_number пройден. Вес папки log: $foldersize K, вес папки backup: $backupsize"
        else
            echo "Тест $test_number не пройден. Вес папки log: $foldersize K, вес папки backup: $backupsize"
        fi
    fi

    rm -rf "$test_path/"*
    rm -rf "$backup_path/"*
    echo ""
}

echo "Тест 1: 1 файл весом 100МБ в папке"
fallocate -l 102400K "$test_path/file1.txt"
run_backup_test 1
sleep 2

echo "Тест 2: 1 файл весом 800МБ в папке"
fallocate -l 819200K "$test_path/file1.txt"
run_backup_test 2
sleep 2

echo "Тест 3: 69 файлов весом >700МБ в папке"
for ((i=1; i<70; i++)); do
    fallocate -l 11264K "$test_path/file$i.txt"
done
run_backup_test 3
sleep 2

echo "Тест 4: Пустая папка"
rm -rf "$test_path/"*
run_backup_test 4
sleep 2