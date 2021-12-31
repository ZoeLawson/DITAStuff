<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">


    <xsl:template name="insertBodyOddHeader">
        <fo:static-content flow-name="odd-body-header">
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body odd header'"/>
                    <xsl:with-param name="params">
                        <document>
                            <fo:inline xsl:use-attribute-sets="__document">
                                <xsl:value-of select="$documentTitle"/>
                            </fo:inline>
                            <fo:leader/>
                        </document>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstHeader">
        <fo:static-content flow-name="first-body-header">
            <!--<fo:block xsl:use-attribute-sets="__body__first__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body first header'"/>
                    <xsl:with-param name="params">
                        <prodname>
                          <xsl:value-of select="$productName"/>
                        </prodname>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__first__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                        <pagenum>
                            <fo:inline xsl:use-attribute-sets="__body__first__header__pagenum">
                                <fo:page-number/>
                            </fo:inline>
                        </pagenum>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>-->
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstFooter">
        <fo:static-content flow-name="first-body-footer">
            <fo:block-container xsl:use-attribute-sets="__footer__container">
                <fo:block xsl:use-attribute-sets="__body__odd__footer">
                    <fo:block xsl:use-attribute-sets="__footer__text">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Body odd footer'"/>
                            <xsl:with-param name="params">
                                <prodname>
                                    <fo:inline xsl:use-attribute-sets="__productName">
                                        <xsl:value-of select="$productName"/>
                                    </fo:inline>
                                    <fo:leader/>
                                </prodname>
                                <pagenum>
                                    <fo:inline
                                        xsl:use-attribute-sets="__body__first__footer__pagenum">
                                        <fo:page-number/>
                                    </fo:inline>
                                </pagenum>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:block>
            </fo:block-container>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyOddFooter">
        <fo:static-content flow-name="odd-body-footer">
            <fo:block-container xsl:use-attribute-sets="__footer__container">
                <fo:block xsl:use-attribute-sets="__body__odd__footer">
                    <fo:block xsl:use-attribute-sets="__footer__text">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Body odd footer'"/>
                            <xsl:with-param name="params">
                                <prodname>
                                    <fo:inline xsl:use-attribute-sets="__productName">
                                        <xsl:value-of select="$productName"/>
                                    </fo:inline>
                                    <fo:leader/>
                                </prodname>
                                <pagenum>
                                    <fo:inline
                                        xsl:use-attribute-sets="__body__first__footer__pagenum">
                                        <fo:page-number/>
                                    </fo:inline>
                                </pagenum>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:block>
            </fo:block-container>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyEvenFooter">
        <fo:static-content flow-name="even-body-footer">
            <fo:block-container xsl:use-attribute-sets="__footer__container">
                <fo:block xsl:use-attribute-sets="__body__odd__footer">
                    <fo:block xsl:use-attribute-sets="__footer__text">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Body odd footer'"/>
                            <xsl:with-param name="params">
                                <prodname>
                                    <fo:inline xsl:use-attribute-sets="__productName">
                                        <xsl:value-of select="$productName"/>
                                    </fo:inline>
                                    <fo:leader/>
                                </prodname>
                                <pagenum>
                                    <fo:inline
                                        xsl:use-attribute-sets="__body__first__footer__pagenum">
                                        <fo:page-number/>
                                    </fo:inline>
                                </pagenum>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:block>
            </fo:block-container>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastFooter">
        <fo:static-content flow-name="last-body-footer">
            <fo:block-container xsl:use-attribute-sets="__footer__container">
                <fo:block xsl:use-attribute-sets="__body__odd__footer">
                    <fo:block xsl:use-attribute-sets="__footer__text">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Body odd footer'"/>
                            <xsl:with-param name="params">
                                <prodname>
                                    <fo:inline xsl:use-attribute-sets="__productName">
                                        <xsl:value-of select="$productName"/>
                                    </fo:inline>
                                    <fo:leader/>
                                </prodname>
                                <pagenum>
                                    <fo:inline
                                        xsl:use-attribute-sets="__body__first__footer__pagenum">
                                        <fo:page-number/>
                                    </fo:inline>
                                </pagenum>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:block>
            </fo:block-container>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="insertTocOddHeader">
        <fo:static-content flow-name="odd-toc-header">
            <fo:block xsl:use-attribute-sets="__toc__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc odd header'"/>
                    <xsl:with-param name="params">
                        <document>
                            <fo:inline xsl:use-attribute-sets="__document">
                                <xsl:value-of select="$documentTitle"/>
                            </fo:inline>
                            <fo:leader/>
                        </document>
                        <heading>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading">
                                <fo:retrieve-marker retrieve-class-name="current-header"/>
                            </fo:inline>
                        </heading>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocOddFooter">
        <fo:static-content flow-name="odd-toc-footer">
            <fo:block-container xsl:use-attribute-sets="__footer__container">
                <fo:block xsl:use-attribute-sets="__toc__odd__footer">
                    <fo:block xsl:use-attribute-sets="__footer__text">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Toc odd footer'"/>
                            <xsl:with-param name="params">
                                <prodname>
                                    <fo:inline xsl:use-attribute-sets="__productName">
                                        <xsl:value-of select="$productName"/>
                                    </fo:inline>
                                    <fo:leader/>
                                </prodname>
                                <pagenum>
                                    <fo:inline
                                        xsl:use-attribute-sets="__body__first__footer__pagenum">
                                        <fo:page-number/>
                                    </fo:inline>
                                </pagenum>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </fo:block>
            </fo:block-container>
        </fo:static-content>
    </xsl:template>
    
</xsl:stylesheet>
