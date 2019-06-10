#Exercise 3b - JFROG CLI Download
loginArt () {
   echo "Log into Artifactories"
   curl -fLs jfrog https://getcli.jfrog.io | sh
   jfrog rt c ${REMOTE_ART_ID} --url=${REMOTE_ARTFACTORY} --apikey=${REMOTE_ART_APIKEY}
   jfrog rt c ${SERVER_ID} --url=${ART_URL} --apikey=${USER_APIKEY}
   jfrog rt c show
}

# Download the required dependencies from remote artifactory instance (jfrogtraining)
# paths -
#    tomcat-local/org/apache/apache-tomcat/
#    tomcat-local/java/
#    generic-local/helm
# Similar to using third party binaries that are not available from remote repositories.
downloadDependencies () {
  echo "Fetch tomcat for the later docker framework build"
  jfrog rt dl ${TOMCAT} ./tomcat/apache-tomcat-8.tar.gz --server-id ${REMOTE_ART_ID} --threads=5 --flat=true --props=swampup2019=ready
  echo "Fetch java for the later docker framework build"
  jfrog rt dl ${JDK} ./jdk/jdk-8-linux-x64.tar.gz --server-id ${REMOTE_ART_ID} --threads=5 --flat=true --props=swampup2019=ready
  echo "Fetch Helm Client for later helm chart"
  jfrog rt dl ${HELM} ./ --server-id ${REMOTE_ART_ID} --props=swampup2019=ready
}