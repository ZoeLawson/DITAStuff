<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="xs dita-ot opentopic opentopic-func ot-placeholder opentopic-index"
    version="2.0">
  
    <xsl:template match="*[contains(@class, ' bookmap/chapter ')] |
                         *[contains(@class, ' bookmap/bookmap ')]/opentopic:map/*[contains(@class, ' map/topicref ')]" mode="tocPrefix" priority="-1">
        <!--<xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Chapter'"/>
            <xsl:with-param name="params">
                <number>
                    <xsl:apply-templates select="." mode="topicTitleNumber"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>-->
    </xsl:template>
    
  
    <xsl:template match="*[contains(@class, ' bookmap/appendix ')]" mode="tocPrefix">
        <!--<xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Appendix'"/>
            <xsl:with-param name="params">
                <number>
                    <xsl:apply-templates select="." mode="topicTitleNumber"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>-->
    </xsl:template>
    
</xsl:stylesheet>
