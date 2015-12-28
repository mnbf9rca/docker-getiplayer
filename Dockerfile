FROM phusion/baseimage:0.9.18

MAINTAINER mnbf9rca

VOLUME ["/output", "/tmp", "/root/.get_iplayer/". "/etc/get_iplayer/"]

EXPOSE 80

ADD getiplayer.conf /root/getiplayer.conf

RUN export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
apt-get update && \
apt-get install -y \
software-properties-common \
python-software-properties && \
add-apt-repository -y ppa:jon-hedgerows/get-iplayer && \
apt-get update && \
apt-get install -y \
apache2 \
atomicparsley \
libav-tools \
get-iplayer \
id3v2 \
libproc-background-perl \
php5 \
rsync \
rtmpdump \
wget && \
mkdir -p /var/www/get_iplayer/output /var/www/get_iplayer/.get_iplayer && \
chown www-data:www-data /var/www/get_iplayer/output /var/www/get_iplayer/.get_iplayer && \
ln -s /usr/bin/get_iplayer /var/www/get_iplayer/ && \
ln -s /usr/share/get_iplayer/get_iplayer.cgi /var/www/get_iplayer/ && \
sed -i '/packagemanager apt/d' /etc/get_iplayer/options && \
sed -i '$ aOUTPUT \/output' /etc/get_iplayer/options && \
mv /etc/get_iplayer/options.new /etc/get_iplayer/options && \
cp /root/getiplayer.conf /etc/apache2/conf-available/getiplayer.conf && \
sed -i '/\<VirtualHost \*\:80\>/aInclude /etc/apache2/conf-available/getiplayer.conf\n' /etc/apache2/sites-available/000-default.conf && \
a2enmod cgi && \
service apache2 restart && \
crontab -l | { cat; echo "57 0 * * * timed-process 21600 /var/www/get_iplayer/get_iplayer --type=radio,podcast,tv --modes=best --output=/home/robert/Downloads/iplayer/incomplete -pvr --nopurge --tag-cnid --tag-hdvideo --tag-podcast --tag-fulltitle --aactomp3 --file-prefix=\"<nameshort> <senum> <descshort>\""; } | crontab - && \
crontab -l | { cat; echo "0 10 * * * timed-process 300 /var/www/get_iplayer/get_iplayer --update --plugins-update"; } | crontab - && \
crontab -l | { cat; echo "@hourly rsync --recursive --remove-source-files --exclude=*.partial.* /output/*.mp3 /output/mp3/ #copy MP3s"; } | crontab - && \
crontab -l | { cat; echo "@hourly rsync --recursive --remove-source-files --exclude=*.partial.* /output/*.mp4 /output/tv/ #move tv"; } | crontab - && \
crontab -l | { cat; echo "@hourly timed-process 900 /var/www/get_iplayer/get_iplayer --refresh --refresh-future --type=all --nopurge   #refresh get_iplayer cache"; } | crontab -


