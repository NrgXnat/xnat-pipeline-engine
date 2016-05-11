<?xml version="1.0" encoding="iso-8859-1"?>
<iso:schema    xmlns="http://purl.oclc.org/dsdl/schematron" 
	       xmlns:iso="http://purl.oclc.org/dsdl/schematron"
	       xmlns:nrgxsl="http://nrg.wustl.edu/validate" 
	       queryBinding='xslt2'
	       schemaVersion="ISO19757-3">
<iso:ns uri="http://nrg.wustl.edu/xnat" prefix="xnat"/>
  <iso:title>Protocol Validator</iso:title>
<!-- It is expected that each rule file would have the following Patterns available viz. Start, ListScanIds -->
  <iso:pattern id="Start">
	   <iso:title>Validation report</iso:title>
	    <iso:rule context="/">
	     	<iso:assert test="xnat:MRSession">The root element must be an MRSession</iso:assert>
	    </iso:rule>
	    <iso:rule context="xnat:MRSession">
		<iso:report id="expt_id" test="true()"><iso:value-of select="@ID"/></iso:report>
		<iso:report id="expt_project" test="true()"><iso:value-of select="@project"/></iso:report>
		<iso:report id="expt_label" test="true()"><iso:value-of select="@label"/></iso:report>
	    </iso:rule>
 </iso:pattern>
 <iso:pattern id="Acquisition">
	    <iso:rule context="xnat:scans">
		<iso:assert test="count(xnat:scan[@type='MPRAGE']) >= 1 and count(xnat:scan[@type='bold1']) >= 2"> 
		<nrgxsl:acquisition>
		<nrgxsl:cause-id>Localizer Count</nrgxsl:cause-id>
		  MRSession must have alteast 1 MPRAGE scan and atleast 2 bold1 scans. Found <iso:value-of select="count(xnat:scan[@type='MPRAGE'])"/> MPRAGE scans and <iso:value-of select="count(xnat:scan[@type='bold1'])"/> bold1 scans. 
		</nrgxsl:acquisition> 
		</iso:assert>
            </iso:rule>
 </iso:pattern>
<iso:pattern id="ListScanIds">
	    <iso:rule context="//xnat:scan">
		<iso:report test="@ID">
		  <nrgxsl:scans>
		    <iso:value-of select="@ID"/>
		  </nrgxsl:scans> 	
		</iso:report>
            </iso:rule>
 </iso:pattern>
  <iso:pattern id="Scan">
		<iso:rule context="/xnat:MRSession/xnat:scans/xnat:scan[@type='MPRAGE']">
			<iso:assert test="xnat:frames = 128" >
			   <nrgxsl:scan>
			      <nrgxsl:scan-id><iso:value-of select="@ID"/></nrgxsl:scan-id>
			      <nrgxsl:cause-id>Frames</nrgxsl:cause-id>
			      <nrgxsl:xmlpath>frames</nrgxsl:xmlpath>
			      <iso:value-of select="concat( 'Expected: 128 Found: ', ./xnat:frames)"/>
			   </nrgxsl:scan>
			</iso:assert>
			<iso:assert test="xnat:parameters/xnat:tr = 2400" >
			   <nrgxsl:scan>
			      <nrgxsl:scan-id><iso:value-of select="@ID"/></nrgxsl:scan-id>
			      <nrgxsl:cause-id>TR</nrgxsl:cause-id>
			      <nrgxsl:xmlpath>parameters.tr</nrgxsl:xmlpath>
			   <iso:value-of select="concat('Expected: 2400 Found: ', ./xnat:parameters/xnat:tr)"/>
			   </nrgxsl:scan>
			</iso:assert>
			<iso:assert test="xnat:parameters/xnat:te = 3.93" >
			   <nrgxsl:scan>
			      <nrgxsl:scan-id><iso:value-of select="@ID"/></nrgxsl:scan-id>
			      <nrgxsl:cause-id>TE</nrgxsl:cause-id>
			      <nrgxsl:xmlpath>parameters.te</nrgxsl:xmlpath>
				<iso:value-of select="concat('Expected: 3.93 Found: ', ./xnat:parameters/xnat:te)"/>
			   </nrgxsl:scan>
			</iso:assert>
		</iso:rule>
 </iso:pattern>

</iso:schema>
