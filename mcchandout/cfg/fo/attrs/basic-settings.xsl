<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="xs">

  <!-- Determine how to style topics referenced by <chapter>, <part>, etc. Values are:
         MINITOC: render with a MiniToc on left, content indented on right.
         BASIC: render the same way as any topic. -->
  <xsl:param name="antArgsChapterLayout" select="'BASIC'"/>
  <xsl:variable name="chapterLayout" select="if (normalize-space($antArgsChapterLayout)) then $antArgsChapterLayout else 'BASIC'"/>

  <!-- The default of 215.9mm x 279.4mm is US Letter size (8.5x11in) -->
  <xsl:variable name="page-width">8.5in</xsl:variable>
  <xsl:variable name="page-height">11in</xsl:variable>

  <!-- Change these if your page has different margins on different sides. -->
  <xsl:variable name="page-margin-inside">1in</xsl:variable>
  <xsl:variable name="page-margin-outside">1in</xsl:variable>
  <xsl:variable name="page-margin-top">1in</xsl:variable>
  <xsl:variable name="page-margin-bottom">1in</xsl:variable>
  <xsl:variable name="body-margin-top">1.25in</xsl:variable>
  <xsl:variable name="body-margin-bottom">1.25in</xsl:variable>

</xsl:stylesheet>
