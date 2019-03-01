node("docker") {
  docker.withRegistry('DOCKER_SOURCE_REGISTRY', 'DOCKER_USERNAME') {
  
    git url: "https://github.com/department-of-veterans-affairs/health-apis-token-validator.git", credentialsId: 'GITHUB_USERNAME_PASSWORD'

    sh "git rev-parse HEAD > .git/commit-id"
    def commit_id = readFile('.git/commit-id').trim()
    println commit_id

    stage "build"
    def app = docker.build "health-apis-kong"

    stage "publish"
    app.push 'master'
    app.push "${commit_id}"
  }
}