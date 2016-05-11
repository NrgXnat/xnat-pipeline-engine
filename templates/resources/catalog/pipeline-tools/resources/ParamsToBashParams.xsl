<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:pip="http://nrg.wustl.edu/pipeline">
<xsl:output method="text" indent="yes" encoding="US-ASCII" />
<xsl:variable name="newline" select="'&#xA;'" />



<xsl:template match="/pip:Parameters">
      <xsl:for-each select="pip:parameter">
<xsl:choose>
			      <xsl:when test="count(./pip:values/pip:list)>0">
<xsl:value-of select="$newline"/>			      			      
			        <xsl:value-of select="pip:name"/>=(<xsl:for-each select="./pip:values/pip:list">  &quot;<xsl:value-of select="normalize-space(.)"/>&quot;</xsl:for-each>)
			      </xsl:when>
			      <xsl:otherwise>
	<xsl:value-of select="$newline"/>
			        <xsl:value-of select="pip:name"/>=&quot;<xsl:value-of select="./pip:values/pip:unique"/>&quot;
			      </xsl:otherwise>
	</xsl:choose>      
      </xsl:for-each>
</xsl:template>
</xsl:stylesheet> 
