<?xml version="1.0" encoding="windows-1250"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:d="http://docbook.org/ns/docbook"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/fo/profile-docbook.xsl"/>
<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/fo/autoidx-kosek.xsl"/>

<!-- Úpravy parametrů -->

<!-- Velikost papíru -->
<xsl:param name="paper.type" select="'A4'"/>

<xsl:param name="double.sided" select="1"/>

<!-- XSLT procesor může používat rozšíření pro callouts apod. -->
<xsl:param name="use.extensions" select="1"/>

<!-- Rozšíření specifická pro daný FO procesor -->
<xsl:param name="xep.extensions" select="1"/>

<!-- Velikost písma textu -->
<xsl:param name="body.font.master">11</xsl:param>

<!-- Velikost okrajů -->
<xsl:param name="page.margin.inner" select="'1in'"/>
<xsl:param name="page.margin.outer" select="'1in'"/>

<!-- Číslování sekcí a kapitol -->
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="1"/>
<xsl:param name="chapter.autolabel" select="1"/>
<xsl:param name="appendix.autolabel" select="'A'"/>
<xsl:param name="part.autolabel" select="1"/>
<xsl:param name="preface.autolabel" select="0"/>

<!-- Nechceme obrázek -->
<xsl:param name="draft.watermark.image" select="'draft.svg'"/>
<xsl:param name="draft.mode" select="'maybe'"/>

<!-- Nadpisy jsou zarovnány s textem, jak je zvykem v evropské typografii -->
<xsl:param name="body.start.indent" select="'0pt'"/>

<xsl:param name="generate.toc">
article toc
</xsl:param>

<xsl:param name="toc.max.depth" select="2"/>

<xsl:template name="is.graphic.extension">
  <xsl:param name="ext"></xsl:param>
  <xsl:if test="$ext = 'png'
                or $ext = 'jpeg'
                or $ext = 'jpg'
                or $ext = 'gif'
                or $ext = 'pdf'">1</xsl:if>
</xsl:template>

<xsl:template match="d:varname | d:mathphrase">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:param name="email.delimiters.enabled" select="0"/>

<xsl:param name="header.column.widths" select="'1 4 1'"/>
<xsl:param name="footer.column.widths" select="'10 1 1'"/>

<xsl:attribute-set name="footer.content.properties">
  <xsl:attribute name="font-size">9pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="header.content.properties">
  <xsl:attribute name="font-size">9pt</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="tablecolumns.extension" select="0"/>

<xsl:param name="callout.unicode" select="1"/>
<xsl:param name="callout.graphics" select="0"/>

<xsl:param name="callout.unicode.start.character" select="10102"/>
<xsl:param name="callout.unicode.number.limit" select="20"/>

<xsl:param name="ulink.footnotes" select="1"/>

<xsl:template name="hyperlink.url.display">
  <!-- * This template is called for all external hyperlinks (ulinks and -->
  <!-- * for all simple xlinks); it determines whether the URL for the -->
  <!-- * hyperlink is displayed, and how to display it (either inline or -->
  <!-- * as a numbered footnote). -->
  <xsl:param name="url"/>
  <xsl:param name="ulink.url">
    <!-- * ulink.url is just the value of the URL wrapped in 'url(...)' -->
    <xsl:call-template name="fo-external-image">
      <xsl:with-param name="filename" select="$url"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:if test="count(child::node()) != 0
                and string(.) != $url
                and $ulink.show != 0">
    <!-- * Display the URL for this hyperlink only if it is non-empty, -->
    <!-- * and the value of its content is not a URL that is the same as -->
    <!-- * URL it links to, and if ulink.show is non-zero. -->
    <xsl:choose>
      <xsl:when test="$ulink.footnotes != 0 and not(ancestor::d:footnote) and not(ancestor::*[@floatstyle='before'])">
        <!-- * ulink.show and ulink.footnote are both non-zero; that -->
        <!-- * means we display the URL as a footnote (instead of inline) -->
        <fo:footnote>
          <xsl:call-template name="ulink.footnote.number"/>
          <fo:footnote-body xsl:use-attribute-sets="footnote.properties">
            <fo:block>
              <xsl:call-template name="ulink.footnote.number"/>
              <xsl:text> </xsl:text>
              <fo:basic-link external-destination="{$ulink.url}" font-family="{$monospace.font.family}" font-stretch="narrower">
                <xsl:value-of select="$url"/>
              </fo:basic-link>
            </fo:block>
          </fo:footnote-body>
        </fo:footnote>
      </xsl:when>
      <xsl:otherwise>
        <!-- * ulink.show is non-zero, but ulink.footnote is not; that -->
        <!-- * means we display the URL inline -->
        <fo:inline hyphenate="false">
          <!-- * put square brackets around the URL -->
          <xsl:text> [</xsl:text>
          <fo:basic-link external-destination="{$ulink.url}">
            <xsl:call-template name="hyphenate-url">
              <xsl:with-param name="url" select="$url"/>
            </xsl:call-template>
          </fo:basic-link>
          <xsl:text>]</xsl:text>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

</xsl:template> 

<xsl:param name="symbol.font.family" select="'Symbol,LucidaUnicode,ArialUnicode,ZapfDingbats'"/>
<xsl:param name="callout.unicode.font">Calibri</xsl:param>
<xsl:param name="body.font.family" select="'Bookman,serif'"/>
<xsl:param name="title.font.family" select="'Bookman,serif'"/>
<xsl:param name="monospace.font.family" select="'DejaVu Sans Mono,monospace,ArialUnicode'"/>

<xsl:attribute-set name="footnote.properties">
  <xsl:attribute name="font-stretch">normal</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="footnote.mark.properties">
  <xsl:attribute name="font-stretch">normal</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="monospace.properties">
  <xsl:attribute name="font-size">90%</xsl:attribute>
  <xsl:attribute name="hyphenate">false</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="verbatim.properties">
  <xsl:attribute name="space-before.optimum">0em</xsl:attribute>
  <xsl:attribute name="space-after.optimum">0em</xsl:attribute>
</xsl:attribute-set>

<xsl:param name="hyphenate.verbatim" select="1"/>

<xsl:attribute-set name="monospace.verbatim.properties" use-attribute-sets="verbatim.properties monospace.properties">
  <xsl:attribute name="font-stretch">narrower</xsl:attribute>
  <xsl:attribute name="wrap-option">wrap</xsl:attribute>
  <xsl:attribute name="hyphenation-character">&#x25BA;</xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:choose>
      <xsl:when test="@role = 'small'">70%</xsl:when>
      <xsl:otherwise>90%</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="table.cell.padding">
  <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="admonition.properties">
  <xsl:attribute name="font-size">80%</xsl:attribute>
  <xsl:attribute name="space-after">1em</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="admonition.title.properties">
  <xsl:attribute name="font-size">inherit</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="d:phrase[@role='nohyph']">
  <fo:inline hyphenate="false">
    <xsl:apply-imports/>
  </fo:inline>
</xsl:template>

<xsl:attribute-set name="formal.title.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level1.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master * 1.2"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level2.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master * 1.1"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.title.level3.properties">
  <xsl:attribute name="font-size">
    <xsl:value-of select="$body.font.master * 1.0"/>
    <xsl:text>pt</xsl:text>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:template match="d:replaceable">
  <fo:inline font-style="italic">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:table[@tabstyle='smaller']|d:informaltable[@tabstyle='smaller']">
  <fo:block font-size="88%">
    <xsl:apply-imports/>
  </fo:block>
</xsl:template>

<xsl:template name="bibliography.titlepage.recto">
  <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="bibliography.titlepage.recto.style" margin-left="{$title.margin.left}" font-size="13.2pt" font-family="{$title.fontset}" font-weight="bold">
<xsl:call-template name="component.title">
<xsl:with-param name="node" select="ancestor-or-self::d:bibliography[1]"/>
</xsl:call-template></fo:block>
  <xsl:choose>
    <xsl:when test="d:info/d:subtitle">
      <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="info/subtitle"/>
    </xsl:when>
    <xsl:when test="d:subtitle">
      <xsl:apply-templates mode="bibliography.titlepage.recto.auto.mode" select="subtitle"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:attribute-set name="biblioentry.properties">
  <xsl:attribute name="text-align">left</xsl:attribute>
  <xsl:attribute name="hyphenate">false</xsl:attribute>
</xsl:attribute-set>


<xsl:template match="d:subtitle" mode="article.titlepage.recto.auto.mode">
  <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="article.titlepage.recto.style" font-weight="bold" font-size="18pt">
    <xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="article.titlepage.recto.auto.mode">
  <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" xsl:use-attribute-sets="article.titlepage.recto.style" space-before="0.5em" text-align="justify" text-align-last="center" start-indent="4em" end-indent="4em" font-family="{$body.fontset}" font-style="italic">
    <xsl:apply-templates select="." mode="article.titlepage.recto.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:copyright" mode="article.titlepage.recto.auto.mode"/>

<xsl:template name="footer.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <fo:block>
    <!-- pageclass can be front, body, back -->
    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>
      <xsl:when test="$pageclass = 'titlepage'">
        <!-- nop; no footer on title pages -->
      </xsl:when>

      <xsl:when test="($sequence = 'even' and $position='left') or (($sequence = 'odd' or $sequence = 'first') and $position='right')">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="($sequence = 'even' and $position='right') or (($sequence = 'odd' or $sequence = 'first') and $position='left')">
        <xsl:apply-templates select="/d:article/d:info/d:copyright"/>
      </xsl:when>

      <xsl:when test="$sequence='blank'">
        <xsl:choose>
          <xsl:when test="$double.sided != 0 and $position = 'left'">
            <fo:page-number/>
          </xsl:when>
          <xsl:when test="$double.sided = 0 and $position = 'center'">
            <fo:page-number/>
          </xsl:when>
          <xsl:otherwise>
            <!-- nop -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <xsl:otherwise>
        <!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template> 

<xsl:template match="d:copyright">
  <fo:inline>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="d:year"/>
    <xsl:if test="d:holder">
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="d:holder"/>
    </xsl:if>
  </fo:inline>
  <xsl:if test="following-sibling::*[1]/self::d:copyright"> – </xsl:if>
</xsl:template> 

<xsl:template match="d:year">
  <xsl:apply-templates/><xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="d:year[position()=last()]">
  <xsl:apply-templates/>
</xsl:template> 

<xsl:template match="d:holder">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:remark">
  <xsl:if test="$show.comments != '0'">
    <fo:block color="red" background-color="yellow">
      <xsl:apply-imports/>
    </fo:block>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>