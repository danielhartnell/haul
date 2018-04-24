@Library('nubis') import org.mozilla.nubis.Static

def nubisStatic = new org.mozilla.nubis.Static()

node {
   stage('Prep') {
    checkout([$class: 'GitSCM', branches: [[name: '*/gh-pages']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'src/'], [$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: true], [$class: 'CleanBeforeCheckout']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/mozilla/www.ccadb.org.git']]])
   }

  stage ('Build') {
    docker.image('starefossen/ruby-node:2-8').inside('-e https_proxy=$HTTPS_PROXY -e HTTPS_PROXY -e http_proxy=$HTTP_PROXY -e HTTP_PROXY') {
      sh "pwd"
      sh "cd src && bundle update"
      sh "cd src && bundle exec jekyll --version"
      sh "cd src && bundle exec jekyll build --verbose  -d ../dst"
    }
  }

  stage('Sync') {
     nubisStatic.syncSite()
  }
}
