#!/bin/bash

# Current date and time for backup file naming
DATE=$(date +"%Y%m%d_%H%M%S")

# MySQL Host and Port (for Docker container accessed from host)
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USER="dumper"
MYSQL_PASSWORD="your_dumper_password_here"

## declare an array variable
declare -a DATABASES=("alameen" "pakizaknowledgecity")

## now loop through the above array
for DB_NAME in "${DATABASES[@]}"; do
    echo "Backing up $DB_NAME..."
    # Backup directory
    BACKUP_DIR="/home/alameen/backup/$DB_NAME/mysql"

    # Create backup directory if it doesn't exist
    mkdir -p $BACKUP_DIR

    # Backup file
    BACKUP_FILE="$BACKUP_DIR/backup_$DATE.sql.gz"

    # mysqldump command to create the backup and compress it
    MYSQL_PWD="$MYSQL_PASSWORD" mysqldump -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER $DB_NAME | gzip > $BACKUP_FILE

    if [ $? -eq 0 ]; then
        echo "Backup of $DB_NAME completed: $BACKUP_FILE"
    else
        echo "Error backing up $DB_NAME"
        continue
    fi

    # Delete uncompressed backup files older than 7 days
    find $BACKUP_DIR -type f -name "backup_*.sql.gz" -mtime +7 -exec rm {} \;
done

echo "Backup process completed!"