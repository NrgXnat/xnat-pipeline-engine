<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:pip="http://nrg.wustl.edu/pipeline" xmlns:prov="http://www.nbirn.net/prov" xmlns:xnat="ttp://nrg.wustl.edu/xnat"  exclude-result-prefixes="pip xnat prov">
<xsl:output method="xml" indent="yes" />
<xsl:variable name="newline" select="'&#xA;'" />

<xsl:template match="/">
	<xsl:value-of select="$newline"/>			      			      
<xnat:provenance>
<xsl:for-each select=".//pip:processStep">
	<xsl:value-of select="$newline"/>			      			      
<prov:processStep>
<prov:program>
	<xsl:value-of select="prov:program[@version]"></xsl:value-of>
</prov:program>
	<xsl:copy-of select="prov:timestamp" copy-namespaces="no" ></xsl:copy-of>	      		
	<xsl:copy-of select="prov:user" copy-namespaces="no" ></xsl:copy-of>	      		
        <xsl:copy-of select="prov:machine" copy-namespaces="no" ></xsl:copy-of>	      		
        <xsl:copy-of select="prov:platform" copy-namespaces="no" ></xsl:copy-of>	      		
</prov:processStep>
</xsl:for-each>
</xnat:provenance>
	<xsl:value-of select="$newline"/>			      			      
</xsl:template>
</xsl:stylesheet> 

