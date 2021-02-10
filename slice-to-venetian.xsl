<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xsl:template match="node()">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>  
</xsl:template>
  
<xsl:template match="xs:schema/xs:element[@name != 'Invoice'][*]">
  <xsl:for-each select="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>      
      <xsl:attribute name="name"><xsl:value-of select="../@name"/>Type</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>      
  </xsl:for-each>
</xsl:template>
  
<xsl:template match="xs:schema/xs:element[@name != 'Invoice'][not(*)]">
  <xs:simpleType name="{@name}Type">
    <xsl:choose>
      <xsl:when test="@type">
        <xs:restriction base="{@type}"/>    
      </xsl:when>
      <xsl:otherwise>
        <xs:restriction base="xs:string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xs:simpleType>
</xsl:template>
  
<xsl:template match="xs:element[starts-with(@ref, 'invoice:')]">
  <xsl:copy>
    <xsl:copy-of select="@*[name()!='ref']"/>
    <xsl:attribute name="name"><xsl:value-of select="substring-after(@ref,':')"/></xsl:attribute>
    <xsl:attribute name="type"><xsl:value-of select="substring-after(@ref,':')"/>Type</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>  
  
</xsl:stylesheet>
