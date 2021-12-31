<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">
    

  <xsl:attribute-set name="region-body.odd">
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$body-margin-top"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$body-margin-bottom"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-body__frontmatter.first">
    <xsl:attribute name="margin-top">1in</xsl:attribute>
    <xsl:attribute name="margin-bottom">1in</xsl:attribute>
    <xsl:attribute name="margin-left">0in</xsl:attribute>
    <xsl:attribute name="margin-right">0in</xsl:attribute>
  </xsl:attribute-set>
  
</xsl:stylesheet>
