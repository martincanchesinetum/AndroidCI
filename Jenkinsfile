class Constants {

    static final String MASTER_BRANCH = 'master'

    static final String QA_BUILD = 'Debug'
    static final String RELEASE_BUILD = 'Release'

    static final String INTERNAL_TRACK = 'internal'
    static final String RELEASE_TRACK = 'release'
}

def getBuildType() {
    switch (env.BRANCH_NAME) {
        case Constants.MASTER_BRANCH:
            return Constants.RELEASE_BUILD
        default:
            return Constants.QA_BUILD
    }
}

def getTrackType() {
    switch (env.BRANCH_NAME) {
        case Constants.MASTER_BRANCH:
            return Constants.RELEASE_TRACK
        default:
            return Constants.INTERNAL_TRACK
    }
}

def isDeployCandidate() {
    return ("${env.BRANCH_NAME}" =~ /(develop|master)/)
}

pipeline {
    agent { 
        docker {
            image 'demoandroid'
            args '-u root:sudo --mount source=temporal,destination=/temporal'
        }
    }
    
    /*agent {
        node{
            label 'master'
        }
    }*/
    
    stages {
        /*stage('Run Tests') {
            steps {
                echo 'Running Tests'
                script {
                    VARIANT = getBuildType()
                    sh '''#!/bin/bash
                            hostname 
                        '''
                    sh "/project/gradlew test${VARIANT}UnitTest"
                }
            }
        }*/
        stage('Build Bundle') {
            /*when { expression { return isDeployCandidate() } }*/
            steps {
                echo 'Building'
                script {
                    VARIANT = getBuildType()
                    echo "${VARIANT}"
                    sh '''
                        chmod +777 ./gradlew
                       ./gradlew --profile bundle
                    '''
                }
            }
        }
        stage('Deploy App to Store') {
            /*when { expression { return isDeployCandidate() } }*/
            steps {
                echo 'Deploying'
                script {
                    VARIANT = getBuildType()
                    TRACK = getTrackType()

                    if (TRACK == Constants.RELEASE_TRACK) {
                        timeout(time: 5, unit: 'MINUTES') {
                            input "Proceed with deployment to ${TRACK}?"
                        }
                    }

                    try {
                        CHANGELOG = readFile(file: 'CHANGELOG.txt')
                    } catch (err) {
                        echo "Issue reading CHANGELOG.txt file: ${err.localizedMessage}"
                        CHANGELOG = ''
                    }
                    sh 'ls -ltr ./app/build/outputs/bundle/release'         
                    androidApkUpload googleCredentialsId: 'play-store-credentials',
                            filesPattern: "**/build/outputs/bundle/release/*.aab",
                            trackName: TRACK,
                            rolloutPercentage: "100",
                            recentChangeList: [[language: 'en-US', text: CHANGELOG]]
                }
            }
        }
    }
}
