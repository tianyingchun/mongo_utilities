#!/bin/sh
 
MONGODB_SHELL='/Users/tianyingchun/Software/mongodb/bin/mongo'
 
DUMP_UTILITY='/Users/tianyingchun/Software/mongodb/bin/mongodump'
DB_NAME='paf_dev2'
 
date_now=`date +%Y_%m_%d_%H_%M_%S`
dir_name='/Users/tianyingchun/Software/mongodb/dbback/db_backup_'${date_now}
file_name='/Users/tianyingchun/db_backup_'${date_now}'.bz2'
 
log() {
    echo $1
}
 
do_cleanup(){
    rm -rf db_backup_2010* 
    log 'cleaning up....'
}
 
do_backup(){
    log 'snapshotting the db and creating archive' && \
    ${MONGODB_SHELL} admin fsync_lock.js && \
    ${DUMP_UTILITY} -d ${DB_NAME} -o ${dir_name} && tar -jcf $file_name ${dir_name}
    ${MONGODB_SHELL} admin fsync_unlock.js && \
    log 'data backd up and created snapshot'
}
 
save_in_s3(){
    log 'saving the backup archive in amazon S3' && \
    #python aws_s3.py set ${file_name} && \
    log 'data backup saved in amazon s3'
}
 
do_backup ## && save_in_s3 && do_cleanup
