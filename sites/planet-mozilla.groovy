@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
  stage('Prep') {
    nubisStatic.prepSite()
    sh "mkdir -p /data/haul/.planet-cache/${env.JOB_NAME}"
  }

  stage ('Build') {
    docker.image('dhartnell/mozilla-planet-builder:4.8').inside("-u 0:0 -e https_proxy=$HTTPS_PROXY -e HTTPS_PROXY -e http_proxy=$HTTP_PROXY -e HTTP_PROXY -v /data/haul/.planet-cache/${env.JOB_NAME}:/data/efs/") {
      sh "/usr/local/bin/planet-build.sh planet"
      sh "rsync -aq /data/genericrhel6/src/planet.mozilla.org/ dst/"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
  }

}
