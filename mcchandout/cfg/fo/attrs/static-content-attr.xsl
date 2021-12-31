<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

  <xsl:attribute-set name="odd__header">
    <xsl:attribute name="font-family">Century Gothic</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
    <xsl:attribute name="text-align-last">justify</xsl:attribute>
    <xsl:attribute name="margin-left">1in</xsl:attribute>
    <xsl:attribute name="margin-right">1in</xsl:attribute>
    <xsl:attribute name="end-indent">0pt</xsl:attribute>
    <xsl:attribute name="space-before">.5in</xsl:attribute>
    <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
    <xsl:attribute name="padding-bottom">.15in</xsl:attribute>
    <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
    <xsl:attribute name="border-bottom-width">thin</xsl:attribute>
    <xsl:attribute name="border-bottom-color">black</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="__document">
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="odd__footer">
    <xsl:attribute name="font-family">Century Gothic</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
    <xsl:attribute name="text-align-last">justify</xsl:attribute>
    <xsl:attribute name="margin-left">1in</xsl:attribute>
    <xsl:attribute name="margin-right">1in</xsl:attribute>
    <xsl:attribute name="space-after">.5in</xsl:attribute>
    <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
    <xsl:attribute name="border-top-style">solid</xsl:attribute>
    <xsl:attribute name="border-top-width">thin</xsl:attribute>
    <xsl:attribute name="border-top-color">black</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="even__footer" use-attribute-sets="odd__footer"/>

  <xsl:attribute-set name="__footer__container">
    <xsl:attribute name="width">8.5in</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="__footer__text">
    <xsl:attribute name="margin-top">.15in</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="pagenum">
    <xsl:attribute name="text-align">end</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="padding-top">.15in</xsl:attribute>
    <xsl:attribute name="padding-bottom">4pt</xsl:attribute>
    <xsl:attribute name="padding-left">.5in</xsl:attribute>
    <xsl:attribute name="padding-right">4pt</xsl:attribute>
    <xsl:attribute name="background-color">#8D1313</xsl:attribute>
    <xsl:attribute name="color">white</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="__productName">
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name="__body__odd__header__heading">
    <xsl:attribute name="text-align">end</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__odd__header" use-attribute-sets="odd__header">
    </xsl:attribute-set>

</xsl:stylesheet>