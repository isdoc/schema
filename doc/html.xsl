<?xml version="1.0" encoding="windows-1250"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:d="http://docbook.org/ns/docbook"
		xmlns:saxon="http://icl.com/saxon"
		xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="fo d saxon"
                version="1.0">

<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/xhtml5/profile-docbook.xsl"/>
<!-- <xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/xhtml5/autoidx-kosek.xsl"/> -->
<xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/html/highlight.xsl"/>

<xsl:output method="saxon:xhtml" encoding="utf-8" saxon:character-representation="native" omit-xml-declaration="yes" indent="yes"/>

<xsl:param name="generate.css.header" select="1"/>

<xsl:param name="highlight.source">1</xsl:param>
<xsl:param name="highlight.xslthl.config">file:///e:/src/db/xsl/highlighting/xslthl-config.xml</xsl:param>

<!-- Needed for textdata inclusions -->
<xsl:param name="keep.relative.image.uris" select="0"/>

<xsl:template name="user.head.content">
  <xsl:param name="node" select="."/>
  <meta charset="utf-8"/>
  <style type="text/css">
    <xsl:text disable-output-escaping="yes">
    .screen, .programlisting, .literallayout { background-color: #F0F0F0; }
    body { font-family: Verdana, sans-serif; 
           background-attachment: fixed; 
           background-position: center center; 
	   max-width: 50em;
	   margin-left: auto;
	   margin-right: auto; }
    .article > .titlepage { text-align: center; background-color: #f8b439; padding-top: 0.5em; }
    .title { color: navy;  }
    .section .titlepage, .bibliography .titlepage { text-align: left; }
    .remark { color: red;
              background-color: yellow;
	      font-style: italics;
	    }
     :link { color: red; text-decoration: none; }
     :visited { color: red; text-decoration: none; }
     a:hover { text-decoration: underline; }
     .note { font-size: smaller; margin-left: 4em; margin-right: 4em; }
    </xsl:text>
  </style>
</xsl:template>

<!-- XSLT procesor může používat rozšíření pro callouts apod. -->
<xsl:param name="use.extensions" select="1"/>

<!-- Číslování sekcí a kapitol -->
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="1"/>
<xsl:param name="chapter.autolabel" select="1"/>
<xsl:param name="appendix.autolabel" select="'A'"/>
<xsl:param name="part.autolabel" select="1"/>
<xsl:param name="preface.autolabel" select="0"/>

<!-- Nechceme obrázek -->
<xsl:param name="draft.watermark.image" select="'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gQ3JlYXRlZCB3aXRoIElua3NjYXBlIChodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy8pIC0tPgoKPHN2ZwogICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iCiAgIHhtbG5zOmNjPSJodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9ucyMiCiAgIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyIKICAgeG1sbnM6c3ZnPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIgogICB2ZXJzaW9uPSIxLjIiCiAgIHdpZHRoPSI3NDQuMDk0NDgiCiAgIGhlaWdodD0iMTA1Mi4zNjIyIgogICBpZD0ic3ZnMiI+CiAgPGRlZnMKICAgICBpZD0iZGVmczQiIC8+CiAgPG1ldGFkYXRhCiAgICAgaWQ9Im1ldGFkYXRhNyI+CiAgICA8cmRmOlJERj4KICAgICAgPGNjOldvcmsKICAgICAgICAgcmRmOmFib3V0PSIiPgogICAgICAgIDxkYzpmb3JtYXQ+aW1hZ2Uvc3ZnK3htbDwvZGM6Zm9ybWF0PgogICAgICAgIDxkYzp0eXBlCiAgICAgICAgICAgcmRmOnJlc291cmNlPSJodHRwOi8vcHVybC5vcmcvZGMvZGNtaXR5cGUvU3RpbGxJbWFnZSIgLz4KICAgICAgICA8ZGM6dGl0bGU+PC9kYzp0aXRsZT4KICAgICAgPC9jYzpXb3JrPgogICAgPC9yZGY6UkRGPgogIDwvbWV0YWRhdGE+CiAgPGcKICAgICBpZD0ibGF5ZXIxIj4KICAgIDxnCiAgICAgICB0cmFuc2Zvcm09Im1hdHJpeCgxLjE5ODUyOTEsLTEuNzE4OTU4OSwxLjExNzgxNDMsMS42MDMxOTU3LC0zNTguMDc3NDgsNjg3LjI4MjYyKSIKICAgICAgIGlkPSJmbG93Um9vdDI5ODUiCiAgICAgICBzdHlsZT0iZm9udC1zaXplOjQwcHg7Zm9udC1zdHlsZTpub3JtYWw7Zm9udC13ZWlnaHQ6bm9ybWFsO2xpbmUtaGVpZ2h0OjEyNSU7bGV0dGVyLXNwYWNpbmc6MHB4O3dvcmQtc3BhY2luZzowcHg7ZmlsbDojY2NjY2NjO2ZpbGwtb3BhY2l0eToxO3N0cm9rZTpub25lO2ZvbnQtZmFtaWx5OlNhbnMiPgogICAgICA8cGF0aAogICAgICAgICBkPSJtIDExNi4xMjUsMjIzLjkwMDcxIDM4LjAzOTA2LDAgYyA4LjU3ODA3LDFlLTQgMTUuMTE3MTMsMC42NTYzNSAxOS42MTcxOSwxLjk2ODc1IDYuMDQ2OCwxLjc4MTM0IDExLjIyNjQ4LDQuOTQ1NCAxNS41MzkwNiw5LjQ5MjE4IDQuMzEyNDEsNC41NDY5NyA3LjU5MzY2LDEwLjExMzM3IDkuODQzNzUsMTYuNjk5MjIgMi4yNDk5MSw2LjU4NjAxIDMuMzc0OTEsMTQuNzA3MDkgMy4zNzUsMjQuMzYzMjggLTllLTUsOC40ODQ0MiAtMS4wNTQ3OCwxNS43OTY5MSAtMy4xNjQwNiwyMS45Mzc1IC0yLjU3ODIyLDcuNTAwMDIgLTYuMjU3OSwxMy41NzAzMyAtMTEuMDM5MDYsMTguMjEwOTQgLTMuNjA5NDYsMy41MTU2MyAtOC40ODQ0NSw2LjI1NzgyIC0xNC42MjUsOC4yMjY1NiAtNC41OTM4MiwxLjQ1MzEzIC0xMC43MzQ0MywyLjE3OTY5IC0xOC40MjE4OCwyLjE3OTY5IGwgLTM5LjE2NDA2LDAgeiBtIDIwLjgxMjUsMTcuNDM3NSAwLDY4LjI3MzQzIDE1LjUzOTA2LDAgYyA1LjgxMjQ1LDJlLTUgMTAuMDA3NzYsLTAuMzI4MSAxMi41ODU5NCwtMC45ODQzNyAzLjM3NDk0LC0wLjg0MzczIDYuMTc1NzIsLTIuMjczNDIgOC40MDIzNCwtNC4yODkwNiAyLjIyNjUsLTIuMDE1NiA0LjA0MjksLTUuMzMyMDEgNS40NDkyMiwtOS45NDkyMiAxLjQwNjE4LC00LjYxNzE1IDIuMTA5MywtMTAuOTEwMTIgMi4xMDkzOCwtMTguODc4OTEgLThlLTUsLTcuOTY4NjkgLTAuNzAzMiwtMTQuMDg1ODcgLTIuMTA5MzgsLTE4LjM1MTU2IC0xLjQwNjMyLC00LjI2NTU1IC0zLjM3NTA3LC03LjU5MzY3IC01LjkwNjI1LC05Ljk4NDM4IC0yLjUzMTMxLC0yLjM5MDU0IC01Ljc0MjI1LC00LjAwNzczIC05LjYzMjgxLC00Ljg1MTU2IC0yLjkwNjMsLTAuNjU2MTYgLTguNjAxNjEsLTAuOTg0MjkgLTE3LjA4NTk0LC0wLjk4NDM3IHoiCiAgICAgICAgIGlkPSJwYXRoMjk5NCIKICAgICAgICAgc3R5bGU9ImZvbnQtc2l6ZToxNDRweDtmb250LXZhcmlhbnQ6bm9ybWFsO2ZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1zdHJldGNoOm5vcm1hbDtmaWxsOiNjY2NjY2M7Zm9udC1mYW1pbHk6QXJpYWw7LWlua3NjYXBlLWZvbnQtc3BlY2lmaWNhdGlvbjpBcmlhbCBCb2xkIiAvPgogICAgICA8cGF0aAogICAgICAgICBkPSJtIDIyMC4zMjgxMiwzMjYuOTc4ODMgMCwtMTAzLjA3ODEyIDQzLjgwNDY5LDAgYyAxMS4wMTU1NiwxZS00IDE5LjAxOTQ2LDAuOTI1ODggMjQuMDExNzIsMi43NzczNCA0Ljk5MjExLDEuODUxNjYgOC45ODgyLDUuMTQ0NjMgMTEuOTg4MjgsOS44Nzg5MSAyLjk5OTkxLDQuNzM0NDYgNC40OTk5MSwxMC4xNDg1MSA0LjUsMTYuMjQyMTggLTllLTUsNy43MzQ0NCAtMi4yNzM1MywxNC4xMjExNiAtNi44MjAzMSwxOS4xNjAxNiAtNC41NDY5Niw1LjAzOTExIC0xMS4zNDM4Myw4LjIxNDg5IC0yMC4zOTA2Myw5LjUyNzM0IDQuNDk5OTMsMi42MjUwNSA4LjIxNDc3LDUuNTA3ODYgMTEuMTQ0NTQsOC42NDg0NCAyLjkyOTYsMy4xNDA2NiA2Ljg3ODgyLDguNzE4NzggMTEuODQ3NjUsMTYuNzM0MzggTCAzMTMsMzI2Ljk3ODgzIGwgLTI0Ljg5MDYzLDAgLTE1LjA0Njg3LC0yMi40Mjk2OSBjIC01LjM0MzgxLC04LjAxNTU5IC05LjAwMDA1LC0xMy4wNjYzNyAtMTAuOTY4NzUsLTE1LjE1MjM0IC0xLjk2ODgsLTIuMDg1OSAtNC4wNTQ3NCwtMy41MTU1OCAtNi4yNTc4MSwtNC4yODkwNiAtMi4yMDMxNywtMC43NzM0IC01LjY5NTM2LC0xLjE2MDEyIC0xMC40NzY1NywtMS4xNjAxNiBsIC00LjIxODc1LDAgMCw0My4wMzEyNSB6IG0gMjAuODEyNSwtNTkuNDg0MzcgMTUuMzk4NDQsMCBjIDkuOTg0MzIsNmUtNSAxNi4yMTg2OSwtMC40MjE4MiAxOC43MDMxMywtMS4yNjU2MyAyLjQ4NDMsLTAuODQzNjkgNC40Mjk2MiwtMi4yOTY4MSA1LjgzNTkzLC00LjM1OTM3IDEuNDA2MTgsLTIuMDYyNDQgMi4xMDkzMSwtNC42NDA1NiAyLjEwOTM4LC03LjczNDM4IC03ZS01LC0zLjQ2ODY3IC0wLjkyNTg1LC02LjI2OTQ1IC0yLjc3NzM0LC04LjQwMjM0IC0xLjg1MTY0LC0yLjEzMjczIC00LjQ2NDkxLC0zLjQ4MDM5IC03LjgzOTg1LC00LjA0Mjk3IC0xLjY4NzU2LC0wLjIzNDI5IC02Ljc1MDA1LC0wLjM1MTQ4IC0xNS4xODc1LC0wLjM1MTU2IGwgLTE2LjI0MjE5LDAgeiIKICAgICAgICAgaWQ9InBhdGgyOTk2IgogICAgICAgICBzdHlsZT0iZm9udC1zaXplOjE0NHB4O2ZvbnQtdmFyaWFudDpub3JtYWw7Zm9udC13ZWlnaHQ6Ym9sZDtmb250LXN0cmV0Y2g6bm9ybWFsO2ZpbGw6I2NjY2NjYztmb250LWZhbWlseTpBcmlhbDstaW5rc2NhcGUtZm9udC1zcGVjaWZpY2F0aW9uOkFyaWFsIEJvbGQiIC8+CiAgICAgIDxwYXRoCiAgICAgICAgIGQ9Im0gNDE3LjI3MzQ0LDMyNi45Nzg4MyAtMjIuNjQwNjMsMCAtOSwtMjMuNDE0MDYgLTQxLjIwMzEyLDAgLTguNTA3ODIsMjMuNDE0MDYgLTIyLjA3ODEyLDAgNDAuMTQ4NDQsLTEwMy4wNzgxMiAyMi4wMDc4MSwwIHogbSAtMzguMzIwMzIsLTQwLjc4MTI1IC0xNC4yMDMxMiwtMzguMjUgLTEzLjkyMTg4LDM4LjI1IHoiCiAgICAgICAgIGlkPSJwYXRoMjk5OCIKICAgICAgICAgc3R5bGU9ImZvbnQtc2l6ZToxNDRweDtmb250LXZhcmlhbnQ6bm9ybWFsO2ZvbnQtd2VpZ2h0OmJvbGQ7Zm9udC1zdHJldGNoOm5vcm1hbDtmaWxsOiNjY2NjY2M7Zm9udC1mYW1pbHk6QXJpYWw7LWlua3NjYXBlLWZvbnQtc3BlY2lmaWNhdGlvbjpBcmlhbCBCb2xkIiAvPgogICAgICA8cGF0aAogICAgICAgICBkPSJtIDQyOC41MjM0NCwzMjYuOTc4ODMgMCwtMTAzLjA3ODEyIDcwLjY2NDA2LDAgMCwxNy40Mzc1IC00OS44NTE1NiwwIDAsMjQuMzk4NDMgNDMuMDMxMjUsMCAwLDE3LjQzNzUgLTQzLjAzMTI1LDAgMCw0My44MDQ2OSB6IgogICAgICAgICBpZD0icGF0aDMwMDAiCiAgICAgICAgIHN0eWxlPSJmb250LXNpemU6MTQ0cHg7Zm9udC12YXJpYW50Om5vcm1hbDtmb250LXdlaWdodDpib2xkO2ZvbnQtc3RyZXRjaDpub3JtYWw7ZmlsbDojY2NjY2NjO2ZvbnQtZmFtaWx5OkFyaWFsOy1pbmtzY2FwZS1mb250LXNwZWNpZmljYXRpb246QXJpYWwgQm9sZCIgLz4KICAgICAgPHBhdGgKICAgICAgICAgZD0ibSA1MzkuNjE3MTksMzI2Ljk3ODgzIDAsLTg1LjY0MDYyIC0zMC41ODU5NCwwIDAsLTE3LjQzNzUgODEuOTE0MDYsMCAwLDE3LjQzNzUgLTMwLjUxNTYyLDAgMCw4NS42NDA2MiB6IgogICAgICAgICBpZD0icGF0aDMwMDIiCiAgICAgICAgIHN0eWxlPSJmb250LXNpemU6MTQ0cHg7Zm9udC12YXJpYW50Om5vcm1hbDtmb250LXdlaWdodDpib2xkO2ZvbnQtc3RyZXRjaDpub3JtYWw7ZmlsbDojY2NjY2NjO2ZvbnQtZmFtaWx5OkFyaWFsOy1pbmtzY2FwZS1mb250LXNwZWNpZmljYXRpb246QXJpYWwgQm9sZCIgLz4KICAgIDwvZz4KICA8L2c+Cjwvc3ZnPgo='"/>
<xsl:param name="draft.mode" select="'maybe'"/>

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

<xsl:param name="tablecolumns.extension" select="0"/>

<xsl:param name="table.cell.border.thickness">1px</xsl:param>
<xsl:param name="table.frame.border.thickness">1px</xsl:param>

<xsl:param name="callout.unicode" select="1"/>
<xsl:param name="callout.graphics" select="0"/>

<xsl:param name="callout.unicode.start.character" select="10102"/>
<xsl:param name="callout.unicode.number.limit" select="20"/>

<xsl:template match="d:varname | d:mathphrase">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="d:replaceable">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:param name="email.delimiters.enabled" select="0"/>
  
<!-- <xsl:template match="d:copyright" mode="article.titlepage.recto.auto.mode"/> -->

<xsl:template name="callout-bug">
  <xsl:param name="conum" select='1'/>

  <xsl:choose>
    <xsl:when test="$callout.graphics != 0
                    and $conum &lt;= $callout.graphics.number.limit">
      <!-- Added span to make valid in XHTML 1 -->
      <span><img src="{$callout.graphics.path}{$conum}{$callout.graphics.extension}"
           alt="{$conum}" border="0"/></span>
    </xsl:when>
    <xsl:when test="$callout.unicode != 0
                    and $conum &lt;= $callout.unicode.number.limit">
      <xsl:choose>
        <xsl:when test="$callout.unicode.start.character = 10102">
          <xsl:choose>
            <xsl:when test="$conum = 1">&#10102;</xsl:when>
            <xsl:when test="$conum = 2">&#10103;</xsl:when>
            <xsl:when test="$conum = 3">&#10104;</xsl:when>
            <xsl:when test="$conum = 4">&#10105;</xsl:when>
            <xsl:when test="$conum = 5">&#10106;</xsl:when>
            <xsl:when test="$conum = 6">&#10107;</xsl:when>
            <xsl:when test="$conum = 7">&#10108;</xsl:when>
            <xsl:when test="$conum = 8">&#10109;</xsl:when>
            <xsl:when test="$conum = 9">&#10110;</xsl:when>
            <xsl:when test="$conum = 10">&#10111;</xsl:when>
	    <xsl:when test="$conum = 11">&#9451;</xsl:when>
	    <xsl:when test="$conum = 12">&#9452;</xsl:when>
	    <xsl:when test="$conum = 13">&#9453;</xsl:when>
	    <xsl:when test="$conum = 14">&#9454;</xsl:when>
	    <xsl:when test="$conum = 15">&#9455;</xsl:when>
	    <xsl:when test="$conum = 16">&#9456;</xsl:when>
	    <xsl:when test="$conum = 17">&#9457;</xsl:when>
	    <xsl:when test="$conum = 18">&#9458;</xsl:when>
	    <xsl:when test="$conum = 19">&#9459;</xsl:when>
	    <xsl:when test="$conum = 20">&#9460;</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Don't know how to generate Unicode callouts </xsl:text>
            <xsl:text>when $callout.unicode.start.character is </xsl:text>
            <xsl:value-of select="$callout.unicode.start.character"/>
          </xsl:message>
          <xsl:text>(</xsl:text>
          <xsl:value-of select="$conum"/>
          <xsl:text>)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$conum"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>