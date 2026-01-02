#!/bin/bash

# Color codes for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Current date and time for backup file naming
DATE=$(date +"%Y%m%d_%H%M%S")

# MySQL Host and Port (for Docker container accessed from host)
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USER="dumper"
MYSQL_PASSWORD="your_dumper_password_here"

# Statistics
TOTAL_DATABASES=0
SUCCESSFUL_BACKUPS=0
FAILED_BACKUPS=0
TOTAL_SIZE=0

# Print header
clear
echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}          🔐 DATABASE BACKUP SCRIPT 🔐${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}ℹ️  Starting backup process...${NC}"
echo ""

## declare an array variable
declare -a DATABASES=("alameen" "pakizaknowledgecity")
TOTAL_DATABASES=${#DATABASES[@]}

## now loop through the above array
for i in "${!DATABASES[@]}"; do
    DB_NAME="${DATABASES[$i]}"
    CURRENT=$((i + 1))
    
    echo -e "${BLUE}[${CURRENT}/${TOTAL_DATABASES}] Backing up: ${CYAN}${DB_NAME}${NC}"
    
    # Backup directory
    BACKUP_DIR="/home/alameen/backup/$DB_NAME/mysql"

    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"

    # Backup file
    BACKUP_FILE="$BACKUP_DIR/backup_$DATE.sql.gz"

    # Show progress
    echo -e "   ${YELLOW}⏳ Progress:${NC} Creating dump..."
    
    # mysqldump command to create the backup and compress it
    MYSQL_PWD="$MYSQL_PASSWORD" mysqldump -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER $DB_NAME 2>/dev/null | gzip > "$BACKUP_FILE"

    if [ $? -eq 0 ]; then
        # Get file size
        FILE_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
        TOTAL_SIZE=$((TOTAL_SIZE + $(du -b "$BACKUP_FILE" | cut -f1)))
        
        echo -e "   ${GREEN}✓ Success${NC}"
        echo -e "   ${GREEN}📦 File:${NC} $BACKUP_FILE"
        echo -e "   ${GREEN}💾 Size:${NC} $FILE_SIZE"
        
        SUCCESSFUL_BACKUPS=$((SUCCESSFUL_BACKUPS + 1))
        
        # Delete old backup files (older than 7 days)
        OLD_FILES=$(find $BACKUP_DIR -type f -name "backup_*.sql.gz" -mtime +7)
        if [ ! -z "$OLD_FILES" ]; then
            echo -e "   ${YELLOW}🗑️  Cleaning old backups...${NC}"
            find $BACKUP_DIR -type f -name "backup_*.sql.gz" -mtime +7 -exec rm {} \;
        fi
    else
        echo -e "   ${RED}✗ Failed${NC}"
        FAILED_BACKUPS=$((FAILED_BACKUPS + 1))
    fi
    echo ""
done

# Print summary
echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}                    BACKUP SUMMARY${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
echo -e "Total Databases:     ${BLUE}${TOTAL_DATABASES}${NC}"
echo -e "Successful Backups:  ${GREEN}${SUCCESSFUL_BACKUPS}${NC}"
echo -e "Failed Backups:      ${RED}${FAILED_BACKUPS}${NC}"
echo -e "Total Size:          ${YELLOW}$(numfmt --to=iec $TOTAL_SIZE 2>/dev/null || echo "$TOTAL_SIZE bytes")${NC}"
echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
echo ""

# Final status
if [ $FAILED_BACKUPS -eq 0 ]; then
    echo -e "${GREEN}✓ All backups completed successfully!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some backups failed.${NC}"
    exit 1
fi