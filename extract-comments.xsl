<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  version="2.0">

<xsl:template match="/">
  <html>
    <head>
      <title>ISDOC comments</title>
    </head>
    <body>
      <table border="1">
        <tr>
          <th>ID</th>
          <th>Czech</th>
          <th>English</th>
        </tr>
        <xsl:for-each select="//xs:annotation">
          <tr>
            <td><xsl:value-of select="ancestor::*[1]/@name"/></td>
            <td lang="cs"><xsl:value-of select="xs:documentation[@xml:lang = 'cs']"/></td>
            <td lang="en"><xsl:value-of select="xs:documentation[@xml:lang = 'en']"/></td>
          </tr>
        </xsl:for-each>
      </table>
    </body>
  </html>  
</xsl:template>

</xsl:stylesheet>
