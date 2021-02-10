<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xsl:template match="node()">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!--<xsl:template match="xs:schema">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:namespace name="" select="@targetNamespace"/>
    <xsl:apply-templates/>
  </xsl:copy>  
</xsl:template>
-->

<xsl:template match="xs:import|xs:include">
  <xsl:copy-of select="doc(@schemaLocation)/xs:schema/node()[self::* or (self::text() and preceding-sibling::* and following-sibling::*)]"/>
</xsl:template>

</xsl:stylesheet>
