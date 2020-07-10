<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:output name="warnings" method="text"/>
    <xsl:param name="DitavalCSV" select="'Issues.csv'"/>
    <xsl:param name="DitavalUpgrade" select="'Upgrade.csv'"/>

    <xsl:template match="/">
        <xsl:choose>
            <!-- If the csv file exists -->
            <xsl:when test="unparsed-text-available($DitavalCSV)">
                <!-- Read the csv file -->
                <xsl:variable name="csv" select="unparsed-text($DitavalCSV)"/>
                <!-- Read the header row -->
                <xsl:variable name="version-tokens" as="xs:string*">
                    <xsl:analyze-string select="$csv" regex="\r\n?|\n">
                        <xsl:non-matching-substring>
                            <!-- Grab the first line -->
                            <xsl:if test="position() = 1">
                                <!-- and parse on the commas -->
                                <xsl:copy-of select="tokenize(., ',')"/>
                            </xsl:if>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <!-- get the number of columns -->
                <xsl:variable name="number_versions" select="count($version-tokens)"/>
                <!-- Get the list of versions from the CSV file and then, for each version... -->
                <!-- Column 1 = Issue -->
                <!-- Column 2 = Description -->
                <!-- Column 3 = Release -->
                <!-- Column 4 forward are the different versions -->
                <xsl:for-each select="4 to $number_versions">
                    <xsl:variable name="current_num" select="."/>
                    <xsl:variable name="current_version" select="$version-tokens[$current_num]"/>
                    <!-- Make the names of the ditaval files -->
                    <xsl:variable name="draft_ditaval">
                        <xsl:text>Product_</xsl:text>
                        <xsl:value-of select="$current_version"/>
                        <xsl:text>_draft.ditaval</xsl:text>
                    </xsl:variable>
                    <xsl:variable name="production_ditaval">
                        <xsl:text>Product_</xsl:text>
                        <xsl:value-of select="$current_version"/>
                        <xsl:text>_production.ditaval</xsl:text>
                    </xsl:variable>
                    <!-- Make the draft ditaval  -->
                    <xsl:result-document method="xml" href="ditaval/{$draft_ditaval}">
                        <xsl:comment>This ditaval was generated using GenDitavalFromCSV.xsl</xsl:comment>
                        <xsl:element name="val">
                            <xsl:call-template name="issues">
                                <xsl:with-param name="format">draft</xsl:with-param>
                                <xsl:with-param name="version" select="$current_version"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:result-document>
                    <!-- Make the production ditaval -->
                    <xsl:result-document method="xml" href="ditaval/{$production_ditaval}">
                        <xsl:comment>This ditaval was generated using GenDitavalFromCSV.xsl</xsl:comment>
                        <xsl:element name="val">
                            <xsl:call-template name="issues">
                                <xsl:with-param name="format">production</xsl:with-param>
                                <xsl:with-param name="version" select="$current_version"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:result-document>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- Thanks to https://stackoverflow.com/questions/29295377/xslt-2-0-to-convert-csv-to-xml-format for the basic start -->
    <xsl:template name="issues">
        <xsl:param name="format"/>
        <xsl:param name="version"/>
        <xsl:choose>
            <xsl:when test="unparsed-text-available($DitavalCSV)">
                <!-- again, read the csv file -->
                <xsl:variable name="csv" select="unparsed-text($DitavalCSV)"/>
                <!-- Get Header -->
                <xsl:variable name="header-tokens" as="xs:string*">
                    <xsl:analyze-string select="$csv" regex="\r\n?|\n">
                        <xsl:non-matching-substring>
                            <xsl:if test="position() = 1">
                                <xsl:copy-of select="tokenize(., ',')"/>
                            </xsl:if>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>

                <!-- Confirm that the UpgradeDitavals.csv has all the same versions -->
                <xsl:call-template name="checkUpgradeVersions">
                    <xsl:with-param name="version" select="$version"/>
                    <xsl:with-param name="format" select="$format"/>
                </xsl:call-template>
                <!-- Make all the include/exclude by version props -->
                <xsl:comment>Version values for cover/footer information, Installation Guides, Upgrade Guides, and Release Notes</xsl:comment>
                <xsl:text>&#10;</xsl:text>
                <xsl:variable name="number_versions" select="count($header-tokens)"/>
                <xsl:for-each select="4 to $number_versions">
                    <xsl:variable name="current_version" select="."/>
                    <xsl:element name="prop">
                        <xsl:attribute name="action">
                            <xsl:choose>
                                <xsl:when test="$header-tokens[$current_version] = $version">
                                    <xsl:text>include</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>exclude</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="att">
                            <xsl:text>otherprops</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="val">
                            <xsl:value-of select="$header-tokens[$current_version]"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
                <!-- Standard values -->
                <!-- TBR -->
                <xsl:comment>To mark a section for review, if not associated with a JIRA issue. </xsl:comment>
                <xsl:comment>You *cannot* filter (show/hide) content with this value</xsl:comment>
                <xsl:comment>tbr = To Be Reviewed</xsl:comment>
                <xsl:element name="revprop">
                    <xsl:attribute name="val">
                        <xsl:text>tbr</xsl:text>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$format = 'draft'">
                            <xsl:attribute name="action">
                                <xsl:text>flag</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="color">
                                <xsl:text>#660066</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="changebar">
                                <xsl:text>|</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="startflag">
                                <xsl:element name="alt-text">
                                    <xsl:text>&lt;&lt;TBR&gt;&gt;</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="action">passthrough</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <!-- TBD -->
                <xsl:comment> tbd is used for little things or restructure work that isn't associated with a feature, that you may need to hide 
         tbd is ALWAYS excluded from production </xsl:comment>
                <xsl:element name="prop">
                    <xsl:attribute name="att">
                        <xsl:text>otherprops</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="val">
                        <xsl:text>tbd</xsl:text>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$format = 'draft'">
                            <xsl:attribute name="action">
                                <xsl:text>flag</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="color">
                                <xsl:text>#003300</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="startflag">
                                <xsl:element name="alt-text">
                                    <xsl:text>TBD</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="action">
                                <xsl:text>exclude</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="prop">
                    <xsl:attribute name="att">
                        <xsl:text>otherprops</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="val">
                        <xsl:text>tbd_not</xsl:text>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$format = 'draft'">
                            <xsl:attribute name="action">
                                <xsl:text>exclude</xsl:text>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="action">
                                <xsl:text>include</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <!-- Set up include pdf, exclude html -->
                <!-- These attributes are reset during build time. 
                    Ditaval files are transformed again to set certain values -->
                <xsl:comment>For PDF vs Help content</xsl:comment>
                <xsl:element name="prop">
                    <xsl:attribute name="action">
                        <xsl:text>include</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="att">
                        <xsl:text>deliveryTarget</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="val">
                        <xsl:text>pdf</xsl:text>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="prop">
                    <xsl:attribute name="action">
                        <xsl:text>exclude</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="att">
                        <xsl:text>deliveryTarget</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="val">
                        <xsl:text>html</xsl:text>
                    </xsl:attribute>
                </xsl:element>
                <!-- audience attributes -->
                <xsl:call-template name="audience">
                    <xsl:with-param name="current_version" select="$version"/>
                </xsl:call-template>
                <!-- platform attributes -->
                <xsl:call-template name="platform">
                    <xsl:with-param name="current_version" select="$version"/>
                </xsl:call-template>
                <!-- props attributes -->
                <xsl:call-template name="install_props">
                    <xsl:with-param name="current_version" select="$version"/>
                </xsl:call-template>
                <!-- do issue things -->
                <xsl:comment>&#xA0;</xsl:comment>
                <xsl:comment> And here be the issue conditions </xsl:comment>
                <xsl:comment>&#xA0;</xsl:comment>
                <xsl:analyze-string select="$csv" regex="\r\n?|\n">
                    <xsl:non-matching-substring>
                        <xsl:if test="not(position() = 1)">
                            <xsl:variable name="linenumber" select="position()"/>
                            <!-- Go to another template that figures out which column matches the current version -->
                            <!-- The getVersionColumn template then calls the template that makes the props (issue_props) -->
                            <xsl:call-template name="getVersionColumn">
                                <xsl:with-param name="version" select="$version"/>
                                <xsl:with-param name="header" select="$header-tokens"/>
                                <xsl:with-param name="format" select="$format"/>
                                <xsl:with-param name="issue" select="."/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="error">
                    <xsl:text>Error reading "</xsl:text>
                    <xsl:value-of select="$DitavalCSV"/>
                    <xsl:text>".</xsl:text>
                </xsl:variable>
                <xsl:message>
                    <xsl:value-of select="$error"/>
                </xsl:message>
                <xsl:value-of select="$error"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getVersionColumn">
        <!-- this template figures out which version column matches the current column -->
        <xsl:param name="version"/>
        <xsl:param name="header"/>
        <xsl:param name="format"/>
        <xsl:param name="issue"/>
        <xsl:variable name="number_versions" select="count($header)"/>
        <xsl:for-each select="4 to $number_versions">
            <xsl:variable name="current_version" select="."/>
            <xsl:choose>
                <xsl:when test="$header[$current_version] = $version">
                    <xsl:variable name="version_column">
                        <xsl:value-of select="$current_version"/>
                    </xsl:variable>
                    <xsl:call-template name="issue_props">
                        <!-- issue_props makes the include/exclude props -->
                        <xsl:with-param name="version" select="$version"/>
                        <xsl:with-param name="version_column" select="$version_column"/>
                        <xsl:with-param name="issue" select="$issue"/>
                        <xsl:with-param name="format" select="$format"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="issue_props">
        <!-- This template makes the props for each issue -->
        <xsl:param name="version"/>
        <xsl:param name="version_column" as="xs:integer"/>
        <xsl:param name="format" as="xs:string"/>
        <xsl:param name="issue"/>
        <xsl:variable name="line" select="tokenize($issue, ',')"/>
        <xsl:choose>
            <xsl:when test="$line[3] = 'copyright'">
                <xsl:comment>
                    <xsl:text>Copyright year flags</xsl:text>
                </xsl:comment>
                <xsl:element name="prop">
                    <xsl:attribute name="action">
                        <xsl:text>exclude</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="att">otherprops</xsl:attribute>
                    <xsl:attribute name="val">
                        <xsl:text>Copyright_2019</xsl:text>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="prop">
                    <xsl:attribute name="action">
                        <xsl:choose>
                            <xsl:when test="$line[$version_column] = 'Copyright_2020'">
                                <xsl:text>include</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>exclude</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="att">otherprops</xsl:attribute>
                    <xsl:attribute name="val">
                        <xsl:text>Copyright_2020</xsl:text>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="prop">
                    <xsl:attribute name="action">
                        <xsl:choose>
                            <xsl:when test="$line[$version_column] = 'Copyright_2021'">
                                <xsl:text>include</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>exclude</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="att">otherprops</xsl:attribute>
                    <xsl:attribute name="val">
                        <xsl:text>Copyright_2021</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- Insert a comment with the version - Issue Key - Description of issue -->
                <xsl:comment>
                    <!-- version -->
                    <xsl:value-of select="$line[3]"/>
                    <xsl:text> - </xsl:text>
                    <!-- CP-nnnnnn -->
                    <xsl:value-of select="$line[1]"/>
                    <xsl:text> - </xsl:text>
                    <!-- Issue description -->
                    <xsl:value-of select="$line[2]"/>
                </xsl:comment>
                <!-- make the prop for the Issue -->
                <xsl:element name="prop">
                    <xsl:attribute name="action">
                        <xsl:choose>
                            <!-- Make the production flavor -->
                            <xsl:when test="$format = 'production'">
                                <xsl:choose>
                                    <!-- If the value is only, include -->
                                    <xsl:when test="$line[$version_column] = 'only'">
                                        <xsl:text>include</xsl:text>
                                    </xsl:when>
                                    <!-- otherwise, whatever the CSV says -->
                                    <xsl:otherwise>
                                        <xsl:value-of select="$line[$version_column]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- Make draft flavor -->
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$line[$version_column] = 'include'">
                                        <xsl:choose>
                                            <!-- When the version of the issue equals the version, flag it -->
                                            <xsl:when test="$line[3] = $version">
                                                <xsl:text>flag</xsl:text>
                                            </xsl:when>
                                            <!-- Otherwise, just include it -->
                                            <xsl:otherwise>
                                                <xsl:text>include</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="$line[$version_column] = 'only'">
                                        <xsl:choose>
                                            <!-- When the version of the issue equals the version, flag it -->
                                            <xsl:when test="$line[3] = $version">
                                                <xsl:text>flag</xsl:text>
                                            </xsl:when>
                                            <!-- Otherwise, just include it -->
                                            <xsl:otherwise>
                                                <xsl:text>include</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>exclude</xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <!-- Always set the @att="otherprops" -->
                    <xsl:attribute name="att">otherprops</xsl:attribute>
                    <!-- Always set the @val="IssueKey" -->
                    <xsl:attribute name="val">
                        <xsl:value-of select="$line[1]"/>
                    </xsl:attribute>
                    <!-- If generating the draft version, and the issue is for the version, and the action isn't exclude, -->
                    <!-- Add the additional color attributes and flagging elements -->
                    <xsl:if
                        test="$format = 'draft' and $line[3] = $version and $line[$version_column] != 'exclude'">
                        <xsl:attribute name="color">
                            <xsl:text>#000099</xsl:text>
                        </xsl:attribute>
                        <xsl:element name="startflag">
                            <xsl:element name="alt-text">
                                <xsl:text>&lt;&lt; </xsl:text>
                                <xsl:value-of select="$line[1]"/>
                                <xsl:text> &gt;&gt;</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
                <!-- Make the 'not' prop -->
                <xsl:element name="prop">
                    <xsl:attribute name="action">
                        <!-- get the original action and then make the _not value the opposite -->
                        <xsl:variable name="orig_action">
                            <xsl:value-of select="$line[$version_column]"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$orig_action = 'include'">
                                <xsl:text>exclude</xsl:text>
                            </xsl:when>
                            <xsl:when test="$orig_action = 'flag'">
                                <xsl:text>exclude</xsl:text>
                            </xsl:when>
                            <xsl:when test="$orig_action = 'only'">
                                <xsl:text>exclude</xsl:text>
                            </xsl:when>
                            <xsl:when test="$orig_action = 'exclude'">
                                <xsl:text>include</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:attribute name="att">otherprops</xsl:attribute>
                    <xsl:attribute name="val">
                        <xsl:value-of select="$line[1]"/>
                        <xsl:text>_not</xsl:text>
                    </xsl:attribute>
                </xsl:element>
                <!-- Make an _only value if there's an only in the row -->
                <xsl:if test="contains($issue, 'only')">
                    <xsl:element name="prop">
                        <xsl:attribute name="action">
                            <xsl:choose>
                                <!-- Make the production flavor -->
                                <xsl:when test="$format = 'production'">
                                    <xsl:choose>
                                        <!-- If the value is only, include -->
                                        <xsl:when test="$line[$version_column] = 'only'">
                                            <xsl:text>include</xsl:text>
                                        </xsl:when>
                                        <!-- otherwise, whatever the CSV says -->
                                        <xsl:otherwise>
                                            <xsl:text>exclude</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <!-- Make draft flavor -->
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$line[$version_column] = 'only'">
                                            <xsl:choose>
                                                <!-- When the version of the issue equals the version, flag it -->
                                                <xsl:when test="$line[3] = $version">
                                                  <xsl:text>flag</xsl:text>
                                                </xsl:when>
                                                <!-- Otherwise, just include it -->
                                                <xsl:otherwise>
                                                  <xsl:text>include</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>exclude</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <!-- Always set the @att="otherprops" -->
                        <xsl:attribute name="att">otherprops</xsl:attribute>
                        <!-- Always set the @val="IssueKey" -->
                        <xsl:attribute name="val">
                            <xsl:value-of select="$line[1]"/>
                            <xsl:text>_only</xsl:text>
                        </xsl:attribute>
                        <!-- If generating the draft version, and the issue is for the version, and the action isn't exclude, -->
                        <!-- Add the additional color attributes and flagging elements -->
                        <xsl:if
                            test="$format = 'draft' and $line[3] = $version and $line[$version_column] != 'exclude'">
                            <xsl:attribute name="color">
                                <xsl:text>#000099</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="startflag">
                                <xsl:element name="alt-text">
                                    <xsl:text>&lt;&lt; </xsl:text>
                                    <xsl:value-of select="$line[1]"/>
                                    <xsl:text> &gt;&gt;</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="audience">
        <xsl:param name="current_version"/>
        <xsl:comment>These are audience values. Used for the release type to help with install and upgrade guides.</xsl:comment>
        <xsl:comment>Maintained for Install and Upgrade Guides in Upgrade.xlsx</xsl:comment>
        <xsl:choose>
            <xsl:when test="unparsed-text-available($DitavalUpgrade)">
                <!-- Read the csv file -->
                <xsl:variable name="csv" select="unparsed-text($DitavalUpgrade)"/>
                <!-- Go through each line of the csv file that isn't the first -->
                <!-- If the version (first value) matches, set the audience attributes -->
                <xsl:analyze-string select="$csv" regex="\r\n?|\n">
                    <xsl:non-matching-substring>
                        <xsl:if test="not(position() = 1)">
                            <xsl:variable name="line" select="tokenize(., ',')"/>
                            <xsl:if test="$line[1] = $current_version">
                                <xsl:comment>
                                    <xsl:text>Release Type is </xsl:text>
                                    <xsl:value-of select="$line[2]"/>
                                </xsl:comment>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'audience'"/>
                                    <xsl:with-param name="prop_val" select="'featurepack'"/>
                                    <xsl:with-param name="prop_test" select="$line[2]"/>
                                </xsl:call-template>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'audience'"/>
                                    <xsl:with-param name="prop_val" select="'major'"/>
                                    <xsl:with-param name="prop_test" select="$line[2]"/>
                                </xsl:call-template>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'audience'"/>
                                    <xsl:with-param name="prop_val" select="'maintenance'"/>
                                    <xsl:with-param name="prop_test" select="$line[2]"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:if>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="platform">
        <xsl:param name="current_version"/>
        <xsl:comment>These are platform attribute values. Used for Installer_Version</xsl:comment>
        <xsl:comment>Maintained for Install and Upgrade Guides in Upgrade.xlsx</xsl:comment>
        <xsl:choose>
            <xsl:when test="unparsed-text-available($DitavalUpgrade)">
                <!-- Read the csv file -->
                <xsl:variable name="csv" select="unparsed-text($DitavalUpgrade)"/>
                <!-- Go through each line of the csv file that isn't the first -->
                <!-- If the version (first value) matches, set the audience attributes -->
                <xsl:analyze-string select="$csv" regex="\r\n?|\n">
                    <xsl:non-matching-substring>
                        <xsl:if test="not(position() = 1)">
                            <xsl:variable name="line" select="tokenize(., ',')"/>
                            <xsl:if test="$line[1] = $current_version">
                                <xsl:comment>
                                    <xsl:text>Installer_Version is </xsl:text>
                                    <xsl:value-of select="$line[3]"/>
                                </xsl:comment>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'platform'"/>
                                    <xsl:with-param name="prop_val" select="'iv10'"/>
                                    <xsl:with-param name="prop_test" select="$line[3]"/>
                                </xsl:call-template>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'platform'"/>
                                    <xsl:with-param name="prop_val" select="'iv11'"/>
                                    <xsl:with-param name="prop_test" select="$line[3]"/>
                                </xsl:call-template>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'platform'"/>
                                    <xsl:with-param name="prop_val" select="'iv20'"/>
                                    <xsl:with-param name="prop_test" select="$line[3]"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:if>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="install_props">
        <xsl:param name="current_version"/>
        <xsl:comment>These are props attribute values.</xsl:comment>
        <xsl:comment>Maintained for Install and Upgrade Guides in Upgrade.xlsx</xsl:comment>
        <xsl:comment>current_version is <xsl:value-of select="$current_version"/></xsl:comment>
        <xsl:choose>
            <xsl:when test="unparsed-text-available($DitavalUpgrade)">
                <!-- Read the csv file -->
                <xsl:variable name="csv" select="unparsed-text($DitavalUpgrade)"/>
                <!-- Go through each line of the csv file that isn't the first -->
                <!-- If the version (first value) matches, set the audience attributes -->
                <xsl:analyze-string select="$csv" regex="\r\n?|\n">
                    <xsl:non-matching-substring>
                        <xsl:if test="not(position() = 1)">
                            <xsl:variable name="line" select="tokenize(., ',')"/>
                            <xsl:if test="$line[1] = $current_version">
                                <xsl:comment>
                                    <xsl:text>Database_Upgrade is </xsl:text>
                                    <xsl:value-of select="$line[4]"/>
                                </xsl:comment>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'props'"/>
                                    <xsl:with-param name="prop_val" select="'db_upgrade'"/>
                                    <xsl:with-param name="prop_test" select="$line[4]"/>
                                </xsl:call-template>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'props'"/>
                                    <xsl:with-param name="prop_val" select="'db_none'"/>
                                    <xsl:with-param name="prop_test" select="$line[4]"/>
                                </xsl:call-template>

                                <xsl:comment>
                                    <xsl:text>WebApp is </xsl:text>
                                    <xsl:value-of select="$line[5]"/>
                                </xsl:comment>
                                <xsl:element name="prop">
                                    <xsl:attribute name="action">
                                        <xsl:value-of select="$line[5]"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="att">
                                        <xsl:text>props</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="val">
                                        <xsl:text>WebApp</xsl:text>
                                    </xsl:attribute>
                                </xsl:element>

                                <xsl:comment>
                                    <xsl:text>SSO is </xsl:text>
                                    <xsl:value-of select="$line[6]"/>
                                </xsl:comment>
                                <xsl:element name="prop">
                                    <xsl:attribute name="action">
                                        <xsl:value-of select="$line[6]"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="att">
                                        <xsl:text>props</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="val">
                                        <xsl:text>SSO</xsl:text>
                                    </xsl:attribute>
                                </xsl:element>

                                <xsl:comment>
                                    <xsl:text>RN Type is </xsl:text>
                                    <xsl:value-of select="$line[7]"/>
                                </xsl:comment>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'props'"/>
                                    <xsl:with-param name="prop_val" select="'rn_fixes'"/>
                                    <xsl:with-param name="prop_test" select="$line[7]"/>
                                </xsl:call-template>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'props'"/>
                                    <xsl:with-param name="prop_val" select="'rn_fixes_merges'"/>
                                    <xsl:with-param name="prop_test" select="$line[7]"/>
                                </xsl:call-template>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'props'"/>
                                    <xsl:with-param name="prop_val" select="'rn_na'"/>
                                    <xsl:with-param name="prop_test" select="$line[7]"/>
                                </xsl:call-template>

                                <xsl:comment>
                                    <xsl:text>Known_Issues is </xsl:text>
                                    <xsl:value-of select="$line[8]"/>
                                </xsl:comment>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'props'"/>
                                    <xsl:with-param name="prop_val" select="'ki_yes'"/>
                                    <xsl:with-param name="prop_test" select="$line[8]"/>
                                </xsl:call-template>
                                <xsl:call-template name="make_prop">
                                    <xsl:with-param name="prop_att" select="'props'"/>
                                    <xsl:with-param name="prop_val" select="'ki_no'"/>
                                    <xsl:with-param name="prop_test" select="$line[8]"/>
                                </xsl:call-template>

                            </xsl:if>
                        </xsl:if>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="make_prop">
        <xsl:param name="prop_att"/>
        <xsl:param name="prop_val"/>
        <xsl:param name="prop_test"/>
        <xsl:element name="prop">
            <xsl:attribute name="att">
                <xsl:value-of select="$prop_att"/>
            </xsl:attribute>
            <xsl:attribute name="val">
                <xsl:value-of select="$prop_val"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="$prop_test = $prop_val">
                    <xsl:attribute name="action">
                        <xsl:text>include</xsl:text>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="action">
                        <xsl:text>exclude</xsl:text>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template name="checkUpgradeVersions">
        <xsl:param name="version"/>
        <xsl:param name="format"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:choose>
            <xsl:when test="unparsed-text-available($DitavalUpgrade)">
                <!-- Read the csv file -->
                <xsl:variable name="csv" select="unparsed-text($DitavalUpgrade)"/>
                <!-- Go through each line of the csv file that isn't the first -->
                <!-- If the version (first value) matches, set the audience attributes -->
                <xsl:if test="$format = 'draft'">
                    <!-- Only do for draft, only need to create once -->
                    <xsl:variable name="warning_file">
                        <xsl:text>warnings/warnings_</xsl:text>
                        <xsl:value-of select="$version"/>
                        <xsl:text>_</xsl:text>
                        <xsl:value-of select="$format"/>
                        <xsl:text>.txt</xsl:text>
                    </xsl:variable>
                    <xsl:result-document omit-xml-declaration="yes" format="warnings"
                        href="{$warning_file}">
                        <xsl:choose>
                            <xsl:when test="contains($csv, $version)">
                                <xsl:text>[INFO] </xsl:text>
                                <xsl:value-of select="$DitavalUpgrade"/>
                                <xsl:text> contains </xsl:text>
                                <xsl:value-of select="$version"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>[WARNING] </xsl:text>
                                <xsl:value-of select="$DitavalUpgrade"/>
                                <xsl:text> is missing a row for </xsl:text>
                                <xsl:value-of select="$version"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:result-document>
                    <xsl:choose>
                        <xsl:when test="contains($csv, $version)">
                            <xsl:comment>
                            <xsl:value-of select="$DitavalUpgrade"/>
                            <xsl:text> contains </xsl:text>
                            <xsl:value-of select="$version"/>
                            </xsl:comment>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:comment>
                            <xsl:text>[WARNING] </xsl:text>
                            <xsl:value-of select="$DitavalUpgrade"/>
                            <xsl:text> is missing a row for </xsl:text>
                            <xsl:value-of select="$version"/>
                            </xsl:comment>
                            <xsl:text>&#10;</xsl:text>
                            <xsl:comment>This means Install and Upgrade Guides may not build properly</xsl:comment>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>

    <xsl:template name="makeVersionKeys">
        <xsl:choose>
            <xsl:when test="unparsed-text-available($DitavalCSV)">
                <!-- Read the csv file -->
                <xsl:variable name="csv" select="unparsed-text($DitavalCSV)"/>
                <!-- Read the header row -->
                <xsl:variable name="keys-tokens" as="xs:string*">
                    <xsl:analyze-string select="$csv" regex="\r\n?|\n">
                        <xsl:non-matching-substring>
                            <xsl:if test="position() = 1">
                                <xsl:copy-of select="tokenize(., ',')"/>
                            </xsl:if>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <xsl:variable name="number_keys" select="count($keys-tokens)"/>
                <!-- Get the list of versions from the CSV file and then, for each version... -->
                <xsl:for-each select="4 to $number_keys">
                    <xsl:variable name="current_num" select="."/>
                    <xsl:variable name="current_key" select="$keys-tokens[$current_num]"/>
                    <!-- Set the key name -->
                    <xsl:variable name="key_name">
                        <xsl:value-of select="$current_key"/>
                    </xsl:variable>
                    <xsl:element name="keydef">
                        <xsl:attribute name="keys">
                            <xsl:value-of select="$key_name"/>
                        </xsl:attribute>
                        <xsl:element name="topicmeta">
                            <xsl:element name="keywords">
                                <xsl:for-each select="tokenize($csv, '\r\n?|\n')">
                                    <xsl:if test="position() != 1">
                                        <xsl:variable name="version_row">
                                            <xsl:value-of select="tokenize(., ',')"/>
                                        </xsl:variable>
                                        <xsl:element name="keyword">
                                            <xsl:attribute name="otherprops">
                                                <xsl:value-of select="tokenize(., ',')[1]"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="tokenize(., ',')[$current_num]"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
