@Library('ppj_coins_app@master') _

import groovy.json.JsonOutput
import firm.project.Env

def configs = Env.getEnviroments(env)

node {

    env.DEBIAN_FRONTEND = 'noninteractive'
    env.TZ = 'Asia/Singapore'

    docker.image("${configs.dockerImage.name}").inside("${configs.dockerImage.arguments}") {
        stage('CHECKOUT') {
            gitCheckoutLibrary(configs.git)
        }
        stage('INSTALL TOOLS') {
            installDependenciesLibrary(configs.dockerImage.dependencies)
        }
        stage('INITIALIZE') {
            flutterAnalyzeLibrary(configs.flutter.analyzeOptions)
        }
        stage('TEST') {        
            flutterTestLibrary()
        }
        stage('BUILD') {
            flutterBuildLibrary()
        }
        stage('UPLOAD ARTIFACT') {
            zipTheFileLibrary(configs.zipFile)

            uploadToNexusLibrary(configs.nexus)
        }
        /*stage('PUBLISH') {
            publishAndroidLibrary(configs.googlePlay)
        }*/
    }
}
