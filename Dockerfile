FROM jenkins/jenkins:2.190 as install_scripts_source
FROM cloudbees/cloudbees-jenkins-distribution:2.176.2.3
COPY --from=install_scripts_source /usr/local/bin/jenkins-support /usr/local/bin/jenkins-support
COPY --from=install_scripts_source /usr/local/bin/install-plugins.sh /usr/local/bin/install-plugins.sh

ENV JENKINS_UC http://jenkins-updates.cloudbees.com
ENV JENKINS_INCREMENTALS_REPO_MIRROR https://repo.jenkins-ci.org/incrementals

# Set the war
ENV JENKINS_WAR /usr/share/cloudbees-jenkins-distribution/cloudbees-jenkins-distribution.war

# Startup all plugins included into the CloudBees Jenkins Distribution bundle
ENV JAVA_OPTS "-Dcom.cloudbees.jenkins.cjp.installmanager.CJPPluginManager.allRequired=true"

# Install extra plugins
ENV REF=/usr/share/cloudbees-jenkins-distribution/ref
COPY plugins.txt $REF/plugins.txt
RUN bash /usr/local/bin/install-plugins.sh < $REF/plugins.txt

# Apply JCasC
COPY jenkins.yaml /cfg/jenkins.yaml
ENV CASC_JENKINS_CONFIG /cfg/jenkins.yaml
