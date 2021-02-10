<?xml version="1.0" encoding="utf-8"?>
<!--

Stylesheet for analyzing schema documentation inside WSDL/XSD file
==================================================================

$Id: xsd-doc-check.xsl,v 1.1 2009/02/26 14:38:19 jkj Exp $

(c) 2008 Jirka Kosek <jirka@kosek.cz>

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="xs"
		version="1.0">

<xsl:key name="types" 
	 match="xs:complexType[@name] | xs:simpleType[@name]"
	 use="concat('{', ancestor::xs:schema[1]/@targetNamespace, '}', @name)"/>

<xsl:template match="/">
  <html>
    <head>
      <title>Kontrola dokumentace ve schématu</title>
      <style type="text/css">
	html   { font-family: Verdana }
	.nodoc { background-color: red }
	table  { border: solid 2px black;
	         border-collapse: collapse; }
        td, th { border: solid 1px black;
	         border-collapse: collapse; }
      </style>
    </head>
    <body>
      <xsl:call-template name="check-wsdl"/>
    </body>
  </html>
</xsl:template>

<xsl:template name="check-wsdl">
  <xsl:for-each select="//xs:schema[.//xs:element[@name] | .//xs:attribute[@name]]">
    <h2>Schéma pro jmenný prostor <tt><xsl:value-of select="@targetNamespace"/></tt></h2>

    <xsl:if test=".//xs:element[@name]">
      <h3>Elementy</h3>

      <table width="100%">
	<col width="30%"/>
	<col width="70%"/>
	<tr>
	  <th>Jméno elementu</th>
	  <th>Dokumentace</th>
	</tr>
	<xsl:for-each select=".//xs:element[@name]">
	  <xsl:sort select="@name"/>
	  <xsl:call-template name="show-doc"/>
	</xsl:for-each>
      </table>
    </xsl:if>
 
    <xsl:if test=".//xs:attribute[@name]">
      <h3>Atributy</h3>

      <table width="100%">
	<col width="30%"/>
	<col width="70%"/>
	<tr>
	  <th>Jméno atributu</th>
	  <th>Dokumentace</th>
	</tr>
	<xsl:for-each select=".//xs:attribute[@name]">
	  <xsl:sort select="@name"/>
	  <xsl:call-template name="show-doc"/>
	</xsl:for-each>
      </table>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template name="show-doc">
  <xsl:variable name="doc">
    <xsl:choose>
      <xsl:when test="xs:annotation/xs:documentation != ''">
	<xsl:copy-of select="xs:annotation/xs:documentation/node()"/>
      </xsl:when>
      <xsl:when test="@type[not(contains(., ':'))] and key('types', concat('{', namespace::*[name()=''], '}', @type))/xs:annotation/xs:documentation != ''">
	<xsl:copy-of select="key('types', concat('{', namespace::*[name()=''], '}', @type))/xs:annotation/xs:documentation/node()"/>
      </xsl:when>
      <xsl:when test="@type[contains(., ':')] and key('types', concat('{', namespace::*[name()=substring-before(current()/@type, ':')], '}', substring-after(@type, ':')))/xs:annotation/xs:documentation != ''">
	<xsl:copy-of select="key('types', concat('{', namespace::*[name()=substring-before(current()/@type, ':')], '}', substring-after(@type, ':')))/xs:annotation/xs:documentation/node()"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <tr>
    <xsl:if test="$doc = '' or $doc = 'FIXME:'">
      <xsl:attribute name="class">nodoc</xsl:attribute>
    </xsl:if>
    <td>
      <xsl:value-of select="@name"/>
    </td>
    <td class="doc">
      <xsl:copy-of select="$doc"/>
    </td>
  </tr>
</xsl:template>

</xsl:stylesheet>