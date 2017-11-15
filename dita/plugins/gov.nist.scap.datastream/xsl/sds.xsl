<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sds="http://scap.nist.gov/schema/scap/source/1.2" 
    xmlns:cat="urn:oasis:names:tc:entity:xmlns:xml:catalog"
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output indent="yes" method="xml"/>
    
    <!-- DataStreamCollection -->
    <xsl:template match="*[contains(
        @class, 
        ' scapDataStreamCollection/scapDataStreamCollection ')]">
        <sds:data-stream-collection 
            id="scap_{@reverseDNS}_collection_{@id}" 
            schematron-version="{@schematronVersion}">
            <xsl:apply-templates select="*[contains(
                @class,
                ' scapDataStream-d/scapDataStream ')]"/>
        </sds:data-stream-collection>
    </xsl:template>
    
    <!-- DataStream -->
    <xsl:template match="*[contains(
        @class,
        ' scapDataStream-d/scapDataStream ')]">
        <sds:data-stream 
            id="scap_{../@reverseDNS}_datastream_{@id}" 
            scap-version="{@scapVersion}" 
            timestamp="{fn:current-dateTime()}" 
            use-case="{@useCase}">
            <xsl:apply-templates/>
        </sds:data-stream>
    </xsl:template>
    
    <!-- Dictionaries -->
    <xsl:template match="*[contains(
        @class,
        ' scapDataStream-d/scapDictionaries ')]">
        <sds:dictionaries> 
            <xsl:apply-templates/>
        </sds:dictionaries>
    </xsl:template>
    
    <!-- Checklists -->
    <xsl:template match="*[contains(
        @class,
        ' scapDataStream-d/scapChecklists ')]">
        <sds:checklists> 
            <xsl:apply-templates/>
        </sds:checklists>
    </xsl:template>

    <!-- Checks -->
    <xsl:template match="*[contains(
        @class,
        ' scapDataStream-d/scapChecks ')]">
        <sds:checks> 
            <xsl:apply-templates/>
        </sds:checks>
    </xsl:template>
    
    <!-- OvalRef -->
    <xsl:template match="*[contains(
        @class,
        ' scapDataStream-d/scapOvalRef ')]">
        <xsl:variable name="cref-id" 
            select="fn:string-join(('scap', ../../../@reverseDNS, 'cref', @keyref), '_')"/>
        <sds:component-ref
            id="{$cref-id}"
            xlink:href="#{$cref-id}"
            />
    </xsl:template>
    
    <!-- Identity transform -->
    <xsl:template match="*">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template>    
    <xsl:template match="comment()|processing-instruction()">
        <xsl:copy />
    </xsl:template>

</xsl:stylesheet>