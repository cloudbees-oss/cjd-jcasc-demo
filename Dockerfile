FROM cloudbees/cloudbees-jenkins-distribution:2.176.2.3 as war_source

FROM jenkins/jenkins:2.176.2
COPY --from=war_source /usr/share/cloudbees-jenkins-distribution/cloudbees-jenkins-distribution.war /usr/share/jenkins/jenkins.war

# Startup all plugins included into the CloudBees Jenkins Distribution bundle
ENV JAVA_OPTS "-Dcom.cloudbees.jenkins.cjp.installmanager.CJPPluginManager.allRequired=true"

# Install additional plugins including JCasC
ENV JENKINS_UC http://jenkins-updates.cloudbees.com
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN bash /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Apply JCasC configuration
COPY jenkins.yaml /cfg/jenkins.yaml
ENV CASC_JENKINS_CONFIG /cfg/jenkins.yaml
