#Modify Sudoers file to not require tty for shell script execution on CentOS
# sudo sed -i '/Defaults[[:space:]]\+requiretty/s/^/#/' /etc/sudoers

# Enable write access to the mongodb.repo and configure it for installation

#sudo chmod 777 /etc/yum.repos.d/mongodb.repo
LOG="/var/log/mongo-install-centos.log"
date +"%Y/%m/%d %H:%M:%S" > $LOG

touch /etc/yum.repos.d/mongodb.repo
echo "[mongodb-org-3.2]" >> /etc/yum.repos.d/mongodb.repo
echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb.repo
echo "baseurl=http://mirror.azure.cn/mongodb/yum/redhat/\$releasever/mongodb-org/3.2/x86_64/" >> /etc/yum.repos.d/mongodb.repo
echo "gpgcheck=0" >> /etc/yum.repos.d/mongodb.repo
echo "enabled=1" >> /etc/yum.repos.d/mongodb.repo

# Install updates
#yum -y update

#Install MongoDB
yum install -y mongodb-org | tee >> $LOG

#Configure MongoDB, make outside access
sed -i "s/bindIp/#bindIp/g" /etc/mongod.conf
sed -i "s/bind_ip/#bind_ip/g" /etc/mongod.conf

#disable selinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
setenforce 0

#restart MongoDB service
service mongod restart | tee >> $LOG
