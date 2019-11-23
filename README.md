XNAT Pipeline Engine
====================

Version 1.7.2
Neuroinformatics Research Group (http://nrg.wustl.edu), Washington University in Saint Louis

Developers
----------

* Mohana Ramaratnam, mohanakannan9@gmail.com
* Rick Herrick, rick.herrick@wustl.edu
* John Flavin, jflavin@wustl.edu

This repository was copied from a [previous repository on Bitbucket](https://bitbucket.org/xnatdev/xnat-pipeline), which was itself copied from a different [previous repository on Bitbucket](https://bitbucket.org/nrg/pipeline_1_7dev).

Installation
------------

This version of the XNAT pipeline engine is built and installed differently from earlier
versions. It uses a [Gradle-based](http://www.gradle.org) build script to manage the pipeline
resources and dependencies. More importantly, instead of building directly back into the
pipeline installation folder, it builds to another destination folder. You can specify the
build property destination with the path to the destination folder or just use the default
destination, which is the folder **build/pipeline** in the pipeline build folder.

You can build the pipeline engine by three different methods:

1. Call the **setup.sh** or **setup.bat** script, passing the administrator email, mail server,
and XNAT server address as parameters (you can also add the optional XNAT site name parameter):

        ./setup.sh <admin email> <SMTP server> <XNAT url> [XNAT site name] [destination] [modulePath1 modulePath2 modulePath3... modulePathn]

        ./setup.sh you@yourlab.org mail.yourlab.org http://xnat.yourlab.org YourXNAT

2. Call the **gradlew** or **gradlew.bat** script located in the root folder of the pipeline
build, along with values for all of the required and optional build parameters. Note that
Gradle build parameters are passed in the form **-P**_param_=_value_.

        ./gradlew -PadminEmail=you@yourlab.org -Pdestination=/pipeline/folder \
                  -PsiteName=YourXNAT -PxnatUrl=http://xnat.yourlab.org \
                  -PsmtpServer=mail.yourlab.org -PmodulePaths=/path1/to/modules,/path2/to/modules \
                  -PpluginsDir=/path/to/plugins -PpluginsDirProd=/path/to/plugins/on/prod

3. Lastly, you can call the **gradlew** or **gradlew.bat** script on its own, with all of the
values passed on the command line in the previous method now stored in the **gradle.properties**
file. This file just takes the standard properties file format of _param_=_value_. There's a
sample version of this file already in the build folder named **sample.gradle.properties**.
You can copy that file and fill in your own values as appropriate. This is very useful when
developing pipeline modules or other code that requires frequent redeployment.

Customization
-------------

The main point of converting the pipeline build to use Gradle is to support pipeline modules.
Pipeline modules are collections of code, scripts, and configuration files that can be integrated
directly into the pipeline build. The purpose of this README is _not_ to explain how to create
custom pipeline modules, however a little information on how modules can be deployed is in
order.

Pipeline modules can be placed in a number of locations:

* In the **modules** folder located inside the pipeline engine
* In any of the folders indicated by a path configured with the **modulePaths** build property

Pipeline modules can be structured in two ways:

* All folders and files directly under the module folder, using the same structure as the
pipeline build. This is a resource-only module, i.e. it has no scripts.
* All resource folders and files in a folder named **resources** located under the module
folder and all script folders and files in a folder named **scripts** located under the module
folder. Scripts are treated somewhat differently from resources, in that they are renamed
with the **.bat** extension when built on a Windows machine.


Plugins
-------------

If you have added plugins to your XNAT and these plugins add data types (have a `*beans*.jar`), 
then you need to include these in many of the pipeline executables. To do so, provide `-PpluginsDir=/path/to/plugins`
where `/path/to/plugins` is the location of all your plugin jars. If you are building the pipeline
engine on a machine that differs from the production environment, you can provide a mapping `-PpluginsDirProd=/path/to/plugins/on/prod`
which will replace the `/path/to/plugins` in the executables.

E.g., My plugins are in `/Users/me/XNATDEV/plugins` on the machine on which I'm building the pipeline engine:

		$ ls /Users/me/XNATDEV/plugins
		mydata-beans-1.0-SNAPSHOT.jar
		mydata-1.0-SNAPSHOT.jar


And I plan to copy them to production to `/data/xnat/home/plugins`. I should run:

        ./gradlew -PadminEmail=you@yourlab.org -Pdestination=/pipeline/folder \
                  -PsiteName=YourXNAT -PxnatUrl=http://xnat.yourlab.org \
                  -PsmtpServer=mail.yourlab.org -PpluginsDir=/Users/me/XNATDEV/plugins
                  -PpluginsDirProd=/data/xnat/home/plugins
