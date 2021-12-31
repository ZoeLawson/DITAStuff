<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="dita-ot ot-placeholder opentopic opentopic-index opentopic-func dita2xslfo xs"
    version="2.0">

    <xsl:template match="*" mode="placeImage">
        <xsl:param name="imageAlign"/>
        <xsl:param name="href"/>
        <xsl:param name="height" as="xs:string?"/>
        <xsl:param name="width" as="xs:string?"/>
        <xsl:param name="scale" as="xs:string?">
            <xsl:choose>
                <xsl:when test="@scale"><xsl:value-of select="@scale"/></xsl:when>
                <xsl:when test="ancestor::*[@scale]"><xsl:value-of select="ancestor::*[@scale][1]/@scale"/></xsl:when>
            </xsl:choose>
        </xsl:param>
<!--Using align attribute set according to image @align attribute-->
        <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="concat('__align__', $imageAlign)"/>
                <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
            </xsl:call-template>
        <xsl:choose>
            <xsl:when test="@placement = 'break'">
                <fo:external-graphic src="url('{$href}')" xsl:use-attribute-sets="image__block">
                    <!--Setting image height if defined-->
                    <xsl:if test="$height">
                        <xsl:attribute name="content-height">
                            <!--The following test was commented out because most people found the behavior
                 surprising.  It used to force images with a number specified for the dimensions
                 *but no units* to act as a measure of pixels, *if* you were printing at 72 DPI.
                 Uncomment if you really want it. -->
                            <xsl:choose>
                                <!--xsl:when test="not(string(number($height)) = 'NaN')">
                        <xsl:value-of select="concat($height div 72,'in')"/>
                      </xsl:when-->
                                <xsl:when test="not(string(number($height)) = 'NaN')">
                                    <xsl:value-of select="concat($height, 'px')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$height"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <!--Setting image width if defined-->
                    <xsl:if test="$width">
                        <xsl:attribute name="content-width">
                            <xsl:choose>
                                <!--xsl:when test="not(string(number($width)) = 'NaN')">
                        <xsl:value-of select="concat($width div 72,'in')"/>
                      </xsl:when-->
                                <xsl:when test="not(string(number($width)) = 'NaN')">
                                    <xsl:value-of select="concat($width, 'px')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$width"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="not($width) and not($height) and $scale">
                        <xsl:attribute name="content-width">
                            <xsl:value-of select="concat($scale,'%')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@scalefit = 'yes' and not($width) and not($height) and not($scale)">            
                        <xsl:attribute name="width">100%</xsl:attribute>
                        <xsl:attribute name="height">100%</xsl:attribute>
                        <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
                        <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
                        <xsl:attribute name="scaling">uniform</xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="*[contains(@class,' topic/alt ')]">
                            <xsl:apply-templates select="*[contains(@class,' topic/alt ')]" mode="graphicAlternateText"/>
                        </xsl:when>
                        <xsl:when test="@alt">
                            <xsl:apply-templates select="@alt" mode="graphicAlternateText"/>
                        </xsl:when>
                    </xsl:choose>
                    
                    <xsl:apply-templates select="node() except (text(),
                        *[contains(@class, ' topic/alt ') or
                        contains(@class, ' topic/longdescref ')])"/>
                </fo:external-graphic>
                
            </xsl:when>
            <xsl:otherwise>
                <fo:external-graphic src="url('{$href}')" xsl:use-attribute-sets="image__inline">
                    <!--Setting image height if defined-->
                    <xsl:if test="$height">
                        <xsl:attribute name="content-height">
                            <!--The following test was commented out because most people found the behavior
                 surprising.  It used to force images with a number specified for the dimensions
                 *but no units* to act as a measure of pixels, *if* you were printing at 72 DPI.
                 Uncomment if you really want it. -->
                            <xsl:choose>
                                <!--xsl:when test="not(string(number($height)) = 'NaN')">
                        <xsl:value-of select="concat($height div 72,'in')"/>
                      </xsl:when-->
                                <xsl:when test="not(string(number($height)) = 'NaN')">
                                    <xsl:value-of select="concat($height, 'px')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$height"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <!--Setting image width if defined-->
                    <xsl:if test="$width">
                        <xsl:attribute name="content-width">
                            <xsl:choose>
                                <!--xsl:when test="not(string(number($width)) = 'NaN')">
                        <xsl:value-of select="concat($width div 72,'in')"/>
                      </xsl:when-->
                                <xsl:when test="not(string(number($width)) = 'NaN')">
                                    <xsl:value-of select="concat($width, 'px')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$width"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="not($width) and not($height) and $scale">
                        <xsl:attribute name="content-width">
                            <xsl:value-of select="concat($scale,'%')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="@scalefit = 'yes' and not($width) and not($height) and not($scale)">            
                        <xsl:attribute name="width">100%</xsl:attribute>
                        <xsl:attribute name="height">100%</xsl:attribute>
                        <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
                        <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
                        <xsl:attribute name="scaling">uniform</xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="*[contains(@class,' topic/alt ')]">
                            <xsl:apply-templates select="*[contains(@class,' topic/alt ')]" mode="graphicAlternateText"/>
                        </xsl:when>
                        <xsl:when test="@alt">
                            <xsl:apply-templates select="@alt" mode="graphicAlternateText"/>
                        </xsl:when>
                    </xsl:choose>
                    
                    <xsl:apply-templates select="node() except (text(),
                        *[contains(@class, ' topic/alt ') or
                        contains(@class, ' topic/longdescref ')])"/>
                </fo:external-graphic>
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
