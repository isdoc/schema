<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:db="http://docbook.org/ns/docbook"
  exclude-result-prefixes="xs db"
  version="2.0">
  
  <xsl:output indent="yes"/>
  
  <xsl:template match="/">
    <sch:schema queryBinding="xslt2">
      <sch:title>Kontrola vybraných pravidel ISDOC</sch:title>
      <sch:ns uri="http://isdoc.cz/namespace/2013" prefix="isdoc"/>
      <xsl:for-each-group select="//sch:rule" group-by="generate-id(..)">
        <sch:pattern>
          <sch:title><xsl:value-of select="../db:title"/></sch:title>
          <xsl:apply-templates select="current-group()" mode="copy-schematron"/>
        </sch:pattern>
      </xsl:for-each-group>
    </sch:schema>
  </xsl:template>
  
  <xsl:template match="node()" mode="copy-schematron">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="copy-schematron"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="sch:assert[not(*)]" mode="copy-schematron">
    <xsl:copy copy-namespaces="no">
      <xsl:copy-of select="@*"/>
      <xsl:value-of select="../../following-sibling::*" separator="&#xA;&#xA;"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>