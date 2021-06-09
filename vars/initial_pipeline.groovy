properties = null
isDeployProp = false

def loadProperties() {
    properties = readProperties file: "devops/aws_main_infra/envs/${env.GIT_BRANCH}.properties"
}

def call(Map pipelineParams) {

  pipeline {

    agent any

    options {
      disableConcurrentBuilds()
    }

    tools {
      jdk 'jdk11'
    }

    triggers {
      upstream(upstreamProjects: "base-service/" + env.BRANCH_NAME, threshold: hudson.model.Result.SUCCESS)
      pollSCM('H/5 * * * *')
    }

    environment {
      /*def projectVersion = sh (
                  script: "./gradlew properties -q | grep -w \"version:\" | awk '{print \$2}'",
                  returnStdout: true
                ).trim() */
      def projectGroup = sh (
                  script: "./gradlew properties -q | grep -w \"group:\" | awk '{print \$2}'",
                  returnStdout: true
                ).trim()
      sonar_projectKey_init = "${projectGroup}:${pipelineParams.svc_name}:${env.BRANCH_NAME}"
      sonar_projectKey = sonar_projectKey_init.replaceAll("/","_")
      sonar_projectName_init = "${pipelineParams.svc_name}" + ":" + "${env.BRANCH_NAME}"
      sonar_projectName = sonar_projectName_init.replaceAll("/","_")
      credentials_id = "${env.GitcredentialsId}"
      //base_branch = "${env.BRANCH_NAME}".replaceAll("/","%2F")
    }

    stages {

      stage("AWS Config") {
        steps {
          script {
            catchError {
              dir('devops') {
                git branch: 'master',
                credentialsId: "${credentials_id}",
                url: 'https://bitbucket.org/xyz/devops.git',
                changelog: false,
                poll: false
              }
            }
            catchError {
              dir('./') {
                loadProperties()
                if (properties) {
                  env.env_prefix_value = "${properties.ENV_PREFIX}"
                  env.service_name = pipelineParams.svc_name
                  env.domainNamePrefixValue = "${properties.DomainNamePrefix}"
                  env.acc_id = "${properties.AccId}"
                  env.envName = "${properties.Environment}"
                  env.eks_cluster_name = "${properties.EKS_NAME}"
                  env.shared_account_id = "${properties.SharedAccountId}"
                  env.domain_name = "${properties.DomainName}"
                  env.replica_count = "${properties.replicaCount}"
                  env.database_name = "${properties.database_name}"
                  env.route53_role_arn = "${properties.route53_role_arn}"
                  env.infrastructure_profile = "${properties.infrastructure_profile}"
                  env.shared_profile = "${properties.shared_profile}"
                  env.archive_repo = "${properties.archive_repo}"
                  env.isDeploy = "true"
                  isDeployProp = true
			         		env.run_dependency_check = "${properties.run_dependency_check}"
                } else {
                  isDeployProp = false
                }
              }
            }
            catchError {
              dir("devops/aws_main_infra/scripts/deployment") {
                if (isDeployProp) {
                  sh "chmod +x ./aws_config.sh"
                  sh "./aws_config.sh ${acc_id} ${infrastructure_profile}"
                  sh "./aws_config.sh ${shared_account_id} ${shared_profile}"
                }
              }
            }
          }
        }
      }

      stage('Build') {
        steps {
          sh '''
            export CODEARTIFACT_AUTH_TOKEN=`aws --profile ${shared_profile} codeartifact get-authorization-token --domain xyz --domain-owner ${shared_account_id} --query authorizationToken --output text`
            ./gradlew clean build --refresh-dependencies -x test -Penv=${env_prefix_value} -Psnapshotrepo=${archive_repo} -Preleaserepo=${archive_repo} -PcodeartifactToken=$CODEARTIFACT_AUTH_TOKEN
          '''
        }
      }

      stage('Unit Tests') {
        steps {
          sh '''
            export CODEARTIFACT_AUTH_TOKEN=`aws --profile ${shared_profile} codeartifact get-authorization-token --domain xyz --domain-owner ${shared_account_id} --query authorizationToken --output text`
            ./gradlew test -Penv=${env_prefix_value} -Psnapshotrepo=${archive_repo} -Preleaserepo=${archive_repo} -PcodeartifactToken=$CODEARTIFACT_AUTH_TOKEN
          '''
        }
      }

      stage('SonarQube Analysis - No Dependency Check') {
  		  when {
          expression{
	  		   return env.run_dependency_check.toBoolean() == false;
		    	}
        }
        steps {
          withSonarQubeEnv('SonarQubeServer') {
            sh '''
              export CODEARTIFACT_AUTH_TOKEN=`aws --profile ${shared_profile} codeartifact get-authorization-token --domain xyz --domain-owner ${shared_account_id} --query authorizationToken --output text`
              ./gradlew -Dsonar.projectKey="${sonar_projectKey}" -Dsonar.projectName="${sonar_projectName}" sonarqube -x test -Penv=${env_prefix_value} -Psnapshotrepo=${archive_repo} -Preleaserepo=${archive_repo} -PcodeartifactToken=$CODEARTIFACT_AUTH_TOKEN
            '''
          }
        }
      }

  		stage('SonarQube Analysis - With Dependency Check') {
	  	  when {
          expression{
		  	   return env.run_dependency_check.toBoolean() == true;
			    }
        }
        steps {
          withSonarQubeEnv('SonarQubeServer') {
            sh '''
              export CODEARTIFACT_AUTH_TOKEN=`aws --profile ${shared_profile} codeartifact get-authorization-token --domain xyz --domain-owner ${shared_account_id} --query authorizationToken --output text`
              ./gradlew dependencyCheckAggregate -Dsonar.projectKey="${sonar_projectKey}" -Dsonar.projectName="${sonar_projectName}" -Dsonar.dependencyCheck.jsonReportPath=build/reports/dependency-check-report.json -Dsonar.dependencyCheck.xmlReportPath=build/reports/dependency-check-report.xml -Dsonar.dependencyCheck.htmlReportPath=build/reports/dependency-check-report.html sonarqube -x test -Penv=${env_prefix_value} -Psnapshotrepo=${archive_repo} -Preleaserepo=${archive_repo} -PcodeartifactToken=$CODEARTIFACT_AUTH_TOKEN
            '''
          }
        }
      }

      stage("SonarQube Quality Gate") {
        steps {
          timeout(time: 1, unit: 'HOURS') {
            waitForQualityGate abortPipeline: true
          }
        }
      }

      stage('Image Build') {
        when {
          environment name: 'isDeploy', value: 'true'
        }
        steps {
          script {
            catchError {
              dir("devops/aws_main_infra/scripts/deployment") {
                sh "chmod +x docker-build.sh"
                sh "./docker-build.sh ${GIT_COMMIT} ${acc_id} ${service_name} ${infrastructure_profile} ${env_prefix_value}"
              }
            }
            echo currentBuild.result
          }
        }
      }

      stage('Image Push') {
        when {
          environment name: 'isDeploy', value: 'true'
        }
        steps {
          script {
            catchError {
              dir("devops/aws_main_infra/scripts/deployment") {
                sh "chmod +x docker-push.sh"
                sh "./docker-push.sh ${GIT_COMMIT} ${acc_id} ${service_name} ${infrastructure_profile} ${env_prefix_value}"
              }
            }
            echo currentBuild.result
          }
        }
      }

      stage("Deploy") {
        when {
          environment name: 'isDeploy', value: 'true'
        }
        steps {
          script {
            catchError {
              dir("devops/aws_main_infra/scripts/deployment") {
                sh "chmod +x ./deploy_service.sh"
                sh "./deploy_service.sh ${service_name} ${acc_id} 0.1.${GIT_COMMIT} ${envName} ${infrastructure_profile} ${eks_cluster_name} ${domain_name} ${replica_count} ${database_name} ${route53_role_arn}  ${env_prefix_value} ${domainNamePrefixValue}"
              }
            }
            echo currentBuild.result
          }
        }
      }
    }

    post {
      failure {
        emailext (
          subject: '$DEFAULT_SUBJECT',
          mimeType: 'text/html',
          from: "dev-admin-notification@xyz.com",
          to: '$DEFAULT_RECIPIENTS',
          recipientProviders: [[$class: 'CulpritsRecipientProvider'],[$class: 'DevelopersRecipientProvider']],
          body: '$DEFAULT_CONTENT',
          attachLog: 'true'
        )
      }
      unstable {
        emailext (
          subject: '$DEFAULT_SUBJECT',
          mimeType: 'text/html',
          from: "dev-admin-notification@xyz.com",
          to: '$DEFAULT_RECIPIENTS',
          recipientProviders: [[$class: 'CulpritsRecipientProvider'],[$class: 'DevelopersRecipientProvider']],
          body: '$DEFAULT_CONTENT',
          attachLog: 'true'
        )
      }
      fixed {
        emailext (
          subject: '$DEFAULT_SUBJECT',
          mimeType: 'text/html',
          from: "dev-admin-notification@xyz.com",
          to: '$DEFAULT_RECIPIENTS',
          recipientProviders: [[$class: 'CulpritsRecipientProvider'],[$class: 'DevelopersRecipientProvider']],
          body: '$DEFAULT_CONTENT'
        )
      }
    }
  }
}
