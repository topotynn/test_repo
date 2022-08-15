stage('Migrations') {
  node('docker&internal') {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm', 'defaultFg': 1, 'defaultBg': 2]) {
      docker.withRegistry('https://registry.digicode.net', 'harbor_admin'){
        docker
          .image(IMAGE_NAME)
          .inside('-u root --privileged') {
            statusCode = sh script: "echo 'hello!!'", returnStatus: true
          }

        if (statusCode > 0) {
          error "Migrations failed!"
        }
      }

    }
  }
}
