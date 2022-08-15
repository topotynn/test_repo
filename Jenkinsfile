stage('Migrations') {
  node('docker&internal') {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm', 'defaultFg': 1, 'defaultBg': 2]) {
      docker.withRegistry('https://registry.digicode.net', 'harbor_admin'){
        docker
          .image("registry.digicode.net/digicode/orange:fix-migrations-error")
          .inside('-u root --privileged') {
            statusCode = sh script: "echo 'hello!!'; exit 1", returnStatus: true
          }

        echo "${statusCode}"
        if (statusCode > 0) {
          error "Migrations failed!"
        }
      }

    }
  }
}
