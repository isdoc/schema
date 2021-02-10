<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="http://kosek.cz/proj/isdoc/functions"
                xmlns="http://isdoc.cz/namespace/2013"
                exclude-result-prefixes="f">

<xsl:key name="types" 
  match="xs:complexType[@name] | xs:simpleType[@name]"
  use="concat('{', ancestor::xs:schema[1]/@targetNamespace, '}', @name)"/>

<xsl:variable name="spaces" select="'                            '"/>

<xsl:function name="f:isUsed" as="xs:boolean">
  <xsl:param name="type" as="xs:string"/>
  <xsl:param name="doc"/>
  
  <xsl:choose>
    <xsl:when test="$doc/xs:schema/(xs:element | xs:attribute)[@type = $type]">
      <xsl:sequence select="true()"/>
    </xsl:when>
    <xsl:when test="$doc//(xs:element | xs:attribute)[@type = $type] or $doc//xs:group[@ref = $type]">
      <xsl:sequence select="some $ref in $doc//((xs:element | xs:attribute)[@type = $type] | xs:group[@ref = $type])
                            satisfies ($ref/ancestor::xs:complexType[@name][1]/f:isUsed(@name, $doc))
                                      or ($ref/ancestor::xs:element[parent::xs:schema]
                                      or ($ref/ancestor::xs:group[@name]/f:isUsed(@name, $doc)))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="false()"/>    
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:function>

<xsl:template match="node()">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="xs:simpleType[@name] | xs:complexType[@name] | xs:group[@name]">
  <xsl:if test="f:isUsed(@name, /)">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="text()[normalize-space(.) eq ''][not(if (preceding-sibling::*[1][self::xs:simpleType or self::xs:complexType]/@name) then f:isUsed(preceding-sibling::*[1]/@name, /) else true())]"/>  

<xsl:template match="comment()" priority="1">
  <xsl:text>&#xA;</xsl:text>
  <xsl:copy/>
  <xsl:text>&#xA;</xsl:text>
</xsl:template>
  
<xsl:template match="xs:element[not(xs:annotation/xs:documentation)] | xs:attribute[not(xs:annotation/xs:documentation)]">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:variable name="depth" select="count(ancestor::*) + 1"/>
    <xsl:text>&#xA;</xsl:text>
    <xsl:value-of select="substring($spaces, 1, $depth * 2)"/>
    <xs:annotation>
      <xsl:text>&#xA;</xsl:text>
      <xsl:value-of select="substring($spaces, 1, $depth * 2 + 2)"/>
      <xsl:choose>
        <xsl:when test="@type[not(contains(., ':'))] and key('types', concat('{', namespace::*[name()=''], '}', @type))/xs:annotation/xs:documentation != ''">
          <xsl:for-each select="key('types', concat('{', namespace::*[name()=''], '}', @type))/xs:annotation/xs:documentation">
            <xsl:copy-of select="."/>
            <xsl:if test="position() != last()">
              <xsl:text>&#xA;</xsl:text>
              <xsl:value-of select="substring($spaces, 1, $depth * 2 + 2)"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="@type[contains(., ':')] and key('types', concat('{', namespace::*[name()=substring-before(current()/@type, ':')], '}', substring-after(@type, ':')))/xs:annotation/xs:documentation != ''">
          <xsl:for-each select="key('types', concat('{', namespace::*[name()=substring-before(current()/@type, ':')], '}', substring-after(@type, ':')))/xs:annotation/xs:documentation">
            <xsl:copy-of select="."/>
            <xsl:if test="position() != last()">
              <xsl:text>&#xA;</xsl:text>
              <xsl:value-of select="substring($spaces, 1, $depth * 2 + 2)"/>
            </xsl:if>            
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>FIXME: ***</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#xA;</xsl:text>
      <xsl:value-of select="substring($spaces, 1, $depth * 2)"/>
      <xsl:apply-templates select="xs:annotation/*[not(self::xs:documentation)]"/>
    </xs:annotation>
    <xsl:text>&#xA;</xsl:text>
    <xsl:value-of select="substring($spaces, 1, $depth * 2 - 2)"/>
    <xsl:apply-templates select="node()[not(self::xs:annotation)]"/>
  </xsl:copy>
</xsl:template>  

</xsl:stylesheet>
