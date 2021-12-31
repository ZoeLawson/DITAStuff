<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    version="2.0">

  <!-- common attribute sets -->

  <!--<xsl:attribute-set name="common.border__top">
    <xsl:attribute name="border-before-style">solid</xsl:attribute>
    <xsl:attribute name="border-before-width">1pt</xsl:attribute>
    <xsl:attribute name="border-before-color">black</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="common.border__bottom">
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">1pt</xsl:attribute>
    <xsl:attribute name="border-after-color">black</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="common.border__right">
    <xsl:attribute name="border-end-style">solid</xsl:attribute>
    <xsl:attribute name="border-end-width">1pt</xsl:attribute>
    <xsl:attribute name="border-end-color">black</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="common.border__left">
    <xsl:attribute name="border-start-style">solid</xsl:attribute>
    <xsl:attribute name="border-start-width">1pt</xsl:attribute>
    <xsl:attribute name="border-start-color">black</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="common.border" use-attribute-sets="common.border__top common.border__right common.border__bottom common.border__left"/>-->

  <xsl:attribute-set name="base-font">
    <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
    <xsl:attribute name="font-family">Arial</xsl:attribute>
  </xsl:attribute-set>

  <!-- titles -->
  <xsl:attribute-set name="common.title">
    <xsl:attribute name="font-family">Century Gothic</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color">#8D1313</xsl:attribute>
  </xsl:attribute-set>

  <!-- paragraph-like blocks -->
  <!--<xsl:attribute-set name="common.block">
    <xsl:attribute name="space-before">0.6em</xsl:attribute>
    <xsl:attribute name="space-after">0.6em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="common.link">
    <xsl:attribute name="color">blue</xsl:attribute>
  </xsl:attribute-set>

    <xsl:attribute-set name="__unresolved__conref">
        <xsl:attribute name="color">#CC3333</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__fo__root" use-attribute-sets="base-font">
        <xsl:attribute name="font-family">serif</xsl:attribute>
        <!-\- TODO: https://issues.apache.org/jira/browse/FOP-2409 -\->
        <xsl:attribute name="xml:lang" select="translate($locale, '_', '-')"/>
        <xsl:attribute name="writing-mode" select="$writing-mode"/>
    </xsl:attribute-set>-->

    <xsl:attribute-set name="__force__page__count">
        <xsl:attribute name="force-page-count">
            <xsl:choose>
                <xsl:when test="/*[contains(@class, ' bookmap/bookmap ')]">
                  <!-- set to 'even' to have blank pages at ends of chapters -->
                    <xsl:value-of select="'auto'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'auto'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.cover" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>

  <!--<xsl:attribute-set name="page-sequence.frontmatter">
    <xsl:attribute name="format">i</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="page-sequence.notice" use-attribute-sets="__force__page__count page-sequence.frontmatter">
  </xsl:attribute-set>
    
  <xsl:attribute-set name="page-sequence.backmatter.notice" use-attribute-sets="__force__page__count">
    <xsl:attribute name="format">1</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="page-sequence.preface" use-attribute-sets="__force__page__count page-sequence.frontmatter">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.toc" use-attribute-sets="__force__page__count page-sequence.frontmatter">
  </xsl:attribute-set>

  <xsl:attribute-set name="page-sequence.lot" use-attribute-sets="page-sequence.toc">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="page-sequence.lof" use-attribute-sets="page-sequence.toc">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="page-sequence.body" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="page-sequence.part" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="page-sequence.appendix" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="page-sequence.glossary" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="page-sequence.index" use-attribute-sets="__force__page__count">
  </xsl:attribute-set>-->

</xsl:stylesheet>
