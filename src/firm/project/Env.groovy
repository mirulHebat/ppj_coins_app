// src/firm/project/Env.groovy
package firm.project

class Enviroment {
    static Map getEnviroments(env) {

        // Static Enviroments Array
        def staticEnviroments = [
            git: [
                branch: "master",
                url: "https://github.com/mirulHebat/ppj_coins_app.git",
                credentialsId: "cde083e3-cd55-4fd4-8461-27371229505b"
            ],
            artifact: [
                name: "project"
            ],
            dockerImage: [
                name: 'instrumentisto/flutter:3.22.2-androidsdk33-r0',
                arguments: '--user 0 --volume=$HOME/.ssh:/root/.ssh -v .:/app -w /app',
                dependencies: ['clang', 'cmake', 'ninja-build', 'pkg-config', 'libgtk-3-dev']
            ],
            googlePlay: [
                credentialsId: "26f58c8f-dba0-4a60-9fdc-62a20dd377a0",
                trackName: 'internal',
                filesPattern: '**/build/app/outputs/bundle/release/*.aab',
                applicationId: 'com.firm.project',
                rolloutPercentage: '100'
            ],
            flutter: [
                version: '3.22.2',
                dartVersion: '3.4.3',
                analyzeOptions: [
                    fatalInfos: false,
                    fatalWarnings: false
                ]
            ]
        ]

        // Zip File Name
        def zipName = "${staticEnviroments.artifact.name}-${staticEnviroments.git.branch}-${env.BUILD_NUMBER}.zip"

        // Derived Enviroments Array
        def derivedEnviroments = [
            zipFile: [
                name: zipName,
                dir: 'build/app/outputs/bundle/release',
                archive: false
            ],
            nexus: [
                credentialsId: 'nexuscredentialsid',
                nexusUrl: "${env.NEXUS_URL}",
                nexusRepo: "${env.NEXUS_RAW_REPO}",
                filePath: "./${zipName}",
                remotePath: "project/android/${staticEnviroments.git.branch}/${zipName}"
            ]
        ]

        staticEnviroments << derivedEnviroments

        return staticEnviroments
    }
}
