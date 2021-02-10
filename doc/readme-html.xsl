<?xml version="1.0" encoding="windows-1250"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:d="http://docbook.org/ns/docbook"
		xmlns:saxon="http://icl.com/saxon"
		xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="fo d saxon"
                version="1.0">

<xsl:import href="html.xsl"/>

  <!-- Číslování sekcí a kapitol -->
<xsl:param name="section.autolabel" select="0"/>
<xsl:param name="appendix.autolabel" select="0"/>

<xsl:param name="generate.toc">
article nop
</xsl:param>

</xsl:stylesheet>