###############################################
#Prepare your local environment
###############################################
#keep your git directory in memory for latest command
export SCRIPT_DIR=$(pwd)

#here we assume your etc host has been changed to have jfrog.local going to your artifactory instance.
#in order to validate this you can run (expected result : OK) :

curl http://jfrog.local/artifactory/api/system/ping 

#save your password

export ADMIN_PASSWORD=<password>


################################################
#init
################################################
#Create base needed repository for gradle (gradle-dev-local, jcenter, libs-release)
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/gradle-dev-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-gradle-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/jcenter -H "content-type: application/vnd.org.jfrog.artifactory.repositories.RemoteRepositoryConfiguration+json" -T $SCRIPT_DIR/init/jcenter-remote-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/libs-releases -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-gradle-release-virtual-config.json

#Create repositories for docker pipelines (prerequisites for lab1)
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/docker-dev-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-docker-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local/artifactory/api/repositories/docker-virtual -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-docker-virtual-config.json

################################################
#Lab 2
################################################
#Create a docker-prod-local repository
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/docker-prod-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-docker-dev-local-config.json

#update docker virtual repository
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local/artifactory/api/repositories/docker-virtual -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/lab2/repository-docker-virtual-config.json

################################################
#Lab 3
################################################
#Create helm-dev-local repository
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/helm-dev-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/lab3/repository-helm-local-config.json

#update helm virtual repository
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local/artifactory/api/repositories/helm-virtual -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/lab3/repository-helm-virtual-config.json

################################################
#Lab 4 - BONUS
################################################
#Create helm-prod-local repository
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/helm-prod-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/lab3/repository-helm-local-config.json

#update helm virtual repository
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local/artifactory/api/repositories/helm-virtual -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/solutions/lab4/repository-helm-virtual-config.json


################################################
#Lab 5
################################################
#Enable replication for build information

#Review json files for the build information replication and adjust the password
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/replications/artifactory-build-info -H "content-type: application/vnd.org.jfrog.artifactory.replications.ReplicationConfigRequest+json" -T $SCRIPT_DIR/lab5/buildReplication.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/replications/artifactory-build-info -H "content-type: application/vnd.org.jfrog.artifactory.replications.ReplicationConfigRequest+json" -T $SCRIPT_DIR/lab5/buildReplicationBack.json


#create same repo structure on each site
#Java repositories
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/gradle-dev-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-gradle-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/gradle-release-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-gradle-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/jcenter -H "content-type: application/vnd.org.jfrog.artifactory.repositories.RemoteRepositoryConfiguration+json" -T $SCRIPT_DIR/init/jcenter-remote-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/libs-releases -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-gradle-release-virtual-config.json

#docker repositories
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/docker-dev-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-docker-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/docker-prod-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-docker-dev-local-config.json

#helm repository
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/helm-dev-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/lab3/repository-helm-local-config.json

#Create replications target for meshed dev repo
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/gradle-dev-local-satellite -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-gradle-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/gradle-dev-local-satellite -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-gradle-dev-local-config.json

curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/docker-dev-local-satellite -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-docker-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/docker-dev-local-satellite -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-docker-dev-local-config.json

curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local/artifactory/api/repositories/helm-dev-local-satellite -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/lab3/repository-helm-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8092/artifactory/api/repositories/helm-dev-local-satellite -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/lab3/repository-helm-local-config.json

#Setup replications for meshed dev repo
curl -uadmin:$ADMIN_PASSWORD -X PUT -H 'Content-Type: application/json' \
      http://jfrog.local/artifactory/api/replications/gradle-dev-local -d '{
        "url" : "http://jfrog.local:8092/artifactory/gradle-dev-local-satellite",
        "username":"admin",
        "password":"'"${ADMIN_PASSWORD}"'",
        "enableEventReplication" : true,
        "enabled" : true,
        "cronExp" : "0 0 13 * * ?",
        "syncDeletes" : true,
        "syncProperties" : true,
        "syncStatistics" : false,
        "repoKey" : "gradle-dev-local-satellite"
       }'

curl -uadmin:$ADMIN_PASSWORD -X PUT -H 'Content-Type: application/json' \
      http://jfrog.local:8092/artifactory/api/replications/gradle-dev-local -d '{
        "url" : "http://jfrog.local/artifactory/gradle-dev-local-satellite",
        "username":"admin",
        "password":"'"${ADMIN_PASSWORD}"'",
        "enableEventReplication" : true,
        "enabled" : true,
        "cronExp" : "0 0 14 * * ?",
        "syncDeletes" : true,
        "syncProperties" : true,
        "syncStatistics" : false,
        "repoKey" : "gradle-dev-local-satellite"
       }'

curl -uadmin:$ADMIN_PASSWORD -X PUT -H 'Content-Type: application/json' \
      http://jfrog.local/artifactory/api/replications/docker-dev-local -d '{
        "url" : "http://jfrog.local:8092/artifactory/docker-dev-local-satellite",
        "username":"admin",
        "password":"'"${ADMIN_PASSWORD}"'",
        "enableEventReplication" : true,
        "enabled" : true,
        "cronExp" : "0 0 15 * * ?",
        "syncDeletes" : true,
        "syncProperties" : true,
        "syncStatistics" : false,
        "repoKey" : "docker-dev-local-satellite"
       }'

curl -uadmin:$ADMIN_PASSWORD -X PUT -H 'Content-Type: application/json' \
      http://jfrog.local:8092/artifactory/api/replications/docker-dev-local -d '{
        "url" : "http://jfrog.local/artifactory/docker-dev-local-satellite",
        "username":"admin",
        "password":"'"${ADMIN_PASSWORD}"'",
        "enableEventReplication" : true,
        "enabled" : true,
        "cronExp" : "0 0 16 * * ?",
        "syncDeletes" : true,
        "syncProperties" : true,
        "syncStatistics" : false,
        "repoKey" : "docker-dev-local-satellite"
       }'

  curl -uadmin:$ADMIN_PASSWORD -X PUT -H 'Content-Type: application/json' \
      http://jfrog.local/artifactory/api/replications/helm-dev-local -d '{
        "url" : "http://jfrog.local:8092/artifactory/helm-dev-local-satellite",
        "username":"admin",
        "password":"'"${ADMIN_PASSWORD}"'",
        "enableEventReplication" : true,
        "enabled" : true,
        "cronExp" : "0 0 15 * * ?",
        "syncDeletes" : true,
        "syncProperties" : true,
        "syncStatistics" : false,
        "repoKey" : "helm-dev-local-satellite"
       }'

curl -uadmin:$ADMIN_PASSWORD -X PUT -H 'Content-Type: application/json' \
      http://jfrog.local:8092/artifactory/api/replications/helm-dev-local -d '{
        "url" : "http://jfrog.local/artifactory/helm-dev-local-satellite",
        "username":"admin",
        "password":"'"${ADMIN_PASSWORD}"'",
        "enableEventReplication" : true,
        "enabled" : true,
        "cronExp" : "0 0 16 * * ?",
        "syncDeletes" : true,
        "syncProperties" : true,
        "syncStatistics" : false,
        "repoKey" : "helm-dev-local-satellite"
       }'

#update virtual repositories
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local/artifactory/api/repositories/docker-virtual -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/lab5/repository-docker-virtual-config.json
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local:8092/artifactory/api/repositories/docker-virtual -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/lab5/repository-docker-virtual-config.json

curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local/artifactory/api/repositories/libs-releases -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/lab5/repository-gradle-release-virtual-config.json
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local:8092/artifactory/api/repositories/libs-releases -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/lab5/repository-gradle-release-virtual-config.json

curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local/artifactory/api/repositories/helm-virtual -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/lab5/repository-helm-virtual-config.json
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local:8092/artifactory/api/repositories/helm-virtual -H "content-type: application/vnd.org.jfrog.artifactory.repositories.VirtualRepositoryConfiguration+json" -T $SCRIPT_DIR/lab5/repository-helm-virtual-config.json


#Setup replications for star maturated repo
curl -uadmin:$ADMIN_PASSWORD -X PUT -H 'Content-Type: application/json' \
      http://jfrog.local/artifactory/api/replications/gradle-release-local -d '{
        "url" : "http://jfrog.local:8092/artifactory/gradle-release-local",
        "username":"admin",
        "password":"'"${ADMIN_PASSWORD}"'",
        "enableEventReplication" : true,
        "enabled" : true,
        "cronExp" : "0 0 17 * * ?",
        "syncDeletes" : true,
        "syncProperties" : true,
        "syncStatistics" : false,
        "repoKey" : "gradle-release-local"
       }'

curl -uadmin:$ADMIN_PASSWORD -X PUT -H 'Content-Type: application/json' \
      http://jfrog.local/artifactory/api/replications/docker-prod-local -d '{
        "url" : "http://jfrog.local:8092/artifactory/docker-prod-local",
        "username":"admin",
        "password":"'"${ADMIN_PASSWORD}"'",
        "enableEventReplication" : true,
        "enabled" : true,
        "cronExp" : "0 0 18 * * ?",
        "syncDeletes" : true,
        "syncProperties" : true,
        "syncStatistics" : false,
        "repoKey" : "docker-prod-local"
       }'

curl -uadmin:$ADMIN_PASSWORD -X PUT -H 'Content-Type: application/json' \
      http://jfrog.local/artifactory/api/replications/helm-prod-local -d '{
        "url" : "http://jfrog.local:8092/artifactory/helm-prod-local",
        "username":"admin",
        "password":"'"${ADMIN_PASSWORD}"'",
        "enableEventReplication" : true,
        "enabled" : true,
        "cronExp" : "0 0 19 * * ?",
        "syncDeletes" : true,
        "syncProperties" : true,
        "syncStatistics" : false,
        "repoKey" : "helm-local"
       }'


################################################
#Lab 6
################################################
#Make sure docker-local exists on edge nodes
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8090/artifactory/api/repositories/docker-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-docker-dev-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8091/artifactory/api/repositories/docker-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/init/repository-docker-dev-local-config.json

#Make sure helm-local repository
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8090/artifactory/api/repositories/helm-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/lab3/repository-helm-local-config.json
curl -uadmin:$ADMIN_PASSWORD -X PUT http://jfrog.local:8091/artifactory/api/repositories/helm-local -H "content-type: application/vnd.org.jfrog.artifactory.repositories.LocalRepositoryConfiguration+json" -T $SCRIPT_DIR/lab3/repository-helm-local-config.json

#Get service ids
export id_main=$(curl -uadmin:$ADMIN_PASSWORD -X GET  http://jfrog.local/artifactory/api/system/service_id)

sed -ie s#jfrt@...#$id_main#g $SCRIPT_DIR/lab6/release-bundle.json

#Create and sign a Release Bundle
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local:8083/api/v1/release_bundle -H "Content-Type: application/json" -T $SCRIPT_DIR/lab6/release-bundle.json

#Distribute the Release Bundle
curl -uadmin:$ADMIN_PASSWORD -X POST http://jfrog.local:8083/api/v1/distribution/MySwampupProduct/1.0 -H "Content-Type: application/json" -T $SCRIPT_DIR/lab6/distribute.json





 