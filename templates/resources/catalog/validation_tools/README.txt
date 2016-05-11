README

Validation plugin for XNAT

Implementation:

A Schematron based validation engine. Create a validation rule file and associate this file to a project and datatype. A datatype could have multiple rule files. Use the content tag  to differentiate between them. Admins while setting up the pipeline can choose the content tag.

For each datatype, say xnat:mrSessionData, create a collection with the content tag set to validation_xnat_mrSessionData (Note: Colon character in the datatype has been replaced by _)
 and insert files into this collection with different content tags using the following commands:
 
 XNATRestClient -host HOST -u USERNAME -p PASSWORD -m PUT -remote "/REST/projects/YOUR_PROJECT/resources/validation_xnat_mrSessionData"
 
 XNATRestClient -host HOST -u USERNAME -p PASSWORD -m PUT -remote "/REST/projects/YOUR_PROJECT/resources/validation_xnat_mrSessionData/files?content=DEFAULT" -local ./mrsession_rules.sch

REFERENCES:

http://www.schematron.com/

XPATH, XSLT

http://www.w3schools.com/Xpath

http://www.w3schools.com/Xsl


XNAT Schema:

Validation.xsd is in <XNAT_HOME>/plugin-resources/project-skeletons/xnat/validation

Add this schema to the Instance document.


REST URI to launch the pipeline (POST to this URI)

REST/projects/YOUR_PROJECT/pipelines/AUTO_ARCHIVE_PROTOCOLCHECK/experiments/SESSION_ID_HERE

PREREQUISITES:

XNATRestClient should be in the path of the tomcat user


This folder contains the following files:

<PIPELINE_HOME>/validation_tools contains the following files:

validation_transform

Validate.xml - Pipeline which generates the validation assessor for a datatype

resources
  
  create_validate.xsl
  
  validation-transform.xml
  
  svrl
  
  mrsession_rules.sch - a sample rule file for an MRSession
  
