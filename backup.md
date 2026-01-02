# This should be run on source host
```bash
rsync -av --progress --delete --exclude 'wtosConfig.php' /var/www/al-ameen.in/ root@72.61.228.253:/var/www/al-ameen.in/
rsync -av --progress --delete /var/www/cdn.webtrackers.co.in/ root@72.61.228.253:/var/www/cdn.webtrackers.co.in/
rsync -av --progress --delete /var/www/face.al-ameen.in/ root@72.61.228.253:/var/www/face.al-ameen.in/
rsync -av --progress --delete /var/www/pakizaknowledgecity.in/ root@72.61.228.253:/var/www/pakizaknowledgecity.in/
rsync -av --progress --delete /var/www/pma.al-ameen.in/ root@72.61.228.253:/var/www/pma.al-ameen.in/
rsync -av --progress --delete /var/www/socket.webtrackers.co.in/ root@72.61.228.253:/var/www/socket.webtrackers.co.in/
```