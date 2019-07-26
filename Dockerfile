FROM jenkins/jenkins:2.176.2 as install_scripts_source

FROM cloudbees/cloudbees-jenkins-distribution:2.176.2.3
COPY --from=install_scripts_source /usr/local/bin/jenkins-support /usr/local/bin/jenkins-support
COPY --from=install_scripts_source /usr/local/bin/install-plugins.sh /usr/local/bin/install-plugins.sh

ENV JENKINS_UC http://jenkins-updates.cloudbees.com
ENV JENKINS_INCREMENTALS_REPO_MIRROR https://repo.jenkins-ci.org/incrementals

# Workaround https://github.com/jenkinsci/docker/issues/857
USER root
RUN mkdir -p /usr/share/jenkins/ && ln -s /usr/share/cloudbees-jenkins-distribution/cloudbees-jenkins-distribution.war /usr/share/jenkins/jenkins.war
USER cloudbees-jenkins-distribution

# Startup all plugins included into the CloudBees Jenkins Distribution bundle
ENV JAVA_OPTS "-Dcom.cloudbees.jenkins.cjp.installmanager.CJPPluginManager.allRequired=${INCLUDE_ALL_BUNDLED_PLUGINS}"

# Install extra plugins
# REF_ROOT is consumed by jenkins-support in the https://github.com/jenkinsci/docker/issues/861 workaround
ENV REF_ROOT=/usr/share/cloudbees-jenkins-distribution/ref
ENV REF=${REF_ROOT}/plugins
COPY plugins.txt /usr/share/cloudbees-jenkins-distribution/ref/plugins.txt
RUN bash /usr/local/bin/install-plugins.sh < /usr/share/cloudbees-jenkins-distribution/ref/plugins.txt

# Apply JCasC
COPY jenkins.yaml /cfg/jenkins.yaml
ENV CASC_JENKINS_CONFIG /cfg/jenkins.yaml

# Temporary override for jenkins-support to support custom ref-roots there
# TODO: remove once https://github.com/jenkinsci/docker/issues/861 is fixed
COPY jenkins-support /usr/local/bin/jenkins-support
