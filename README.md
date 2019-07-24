# JCasC Demo on CloudBees Jenkins Distribution

| WARNING: This is a demo repository and image, it is not supported by CloudBees for production use |
| --- |

This demo demonstrates usage of the [Jenkins Configuration-as-Code Plugin](https://github.com/jenkinsci/configuration-as-code-plugin) plugin with
[CloudBees Jenkins Distribution (CJD)](https://www.cloudbees.com/products/cloudbees-jenkins-distribution).
The demo is based on the official Cloudbees Jenkins Distribution image available on Docker Hub
([here](https://hub.docker.com/r/cloudbees/cloudbees-jenkins-distribution)).

By default, all bundled plugins from CJD are loaded.
The configuration YAML file presets all of the configuration fields which are currently supported.
Note, this is a demo only and it doesn't configure a full production instance of CJD which is able to run production CI/CD pipelines.

## Usage

### Building the image

* Ensure that Docker and Make are installed on your machine
* Checkout the repository
* Run `make build`

It will produce a local `cloudbees/cjd-jcasc-demo:rolling` image.

### Running

* Run the image using the `make run` command
* Navigate to `http://localhost:8080`
* Login with the _admin/admin_ username/password pair
* **Register CloudBees Jenkins Distribution** screen.
  Select the _Activate online_ option and register your CJD instance.
  It is free, but you need to accept the license agreement
* **Customize CloudBees Jenkins Distribution** screen.
  Use the the _Select plugins to install_ option,
* Select _None_ in the top panel of the window to unselect all plugins. Then click _Install_
  * Plugins are already installed by CloudBees Assurance Program and Docker packaging,
    so selection of additional plugins is not needed here
  * This manual UI action is temporary step
* Your CloudBees Jenkins Distribution is ready and configured via Jenkins Configuration as Code plugin!
  Just start using it

### Advanced run options

* To disable booting of `fat` plugins, `-e INCLUDE_FAT_PLUGINS=false` can be passed to the Makefile
* Use `-e VERBOSE=true` to enable verbose mode with more debug information
* It is possible to munt a local workspace as a volume by `-v ${WORKSPACE_ABOLUTE_PATH}:/var/jenkins_home/`
  for troubleshooting purposes. Note that the workspace should be empty on startup.
