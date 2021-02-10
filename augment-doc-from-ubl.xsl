<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:ccts="urn:un:unece:uncefact:documentation:2"
  xmlns="urn:un:unece:uncefact:documentation:2"
  exclude-result-prefixes="ccts" version="2.0">

<xsl:template match="node()">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:variable name="types" select="collection('file:///E:/src/ubl/os-UBL-2.0/xsd/?select=*.xsd&amp;recurse=yes')//(xs:complexType|xs:simplyType)"/>

<xsl:template match="xs:documentation">
  <xsl:copy-of select="."/>
  <xsl:copy-of select="preceding-sibling::node()[1][self::text()[normalize-space(.) = '']]"/>
  <xsl:choose>
    <xsl:when test="ancestor::*[@name][1]/@name = $types/@name">
      <xs:documentation xml:lang="en">
        <xsl:value-of select="$types[@name = current()/ancestor::*[@name][1]/@name]/xs:annotation/xs:documentation//ccts:Definition"/>
      </xs:documentation>
    </xsl:when>
    <xsl:otherwise>
      <xs:documentation xml:lang="en">
        <xsl:text>FIXME:</xsl:text>
      </xs:documentation>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>  

</xsl:stylesheet>
