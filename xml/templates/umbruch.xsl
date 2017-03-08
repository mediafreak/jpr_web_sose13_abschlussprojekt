<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <xsl:template name="br">
    <!-- disable-output-escaping: yes => bei der Ausgabe keine Entity-Codierung -->
    <!-- Firefox ueber Abruf der System-Property abfangen -->
    <xsl:variable name="system" select="string(system-property('xsl:vendor-url'))"/>
    <!-- leider lassen sich Chrome und Maxthon nicht ueber diesen Wege abfangen, da sie den komplett gleichen Prozessor wie der Safari verwenden -->
    <!--<xsl:variable name="system" select="concat(system-property('xsl:vendor-url'),system-property('xsl:version'),'/',system-property('xsl:vendor'))"/>
    <xsl:value-of select="concat(' ',$system)"/>-->
    <xsl:choose>
      <xsl:when test="contains($system,'mozilla')">
        <!-- Firefox unterstuetzt kein disable-output-escaping -->
        <br/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Zeilenumbruch-Entitaeten werden von Browser nicht unterstuetzt (&#xA;) -->
        <!-- <br /> fuehrt bei Browsern, die nicht Firefox sind, zu doppelten Zeilenumbruch
             wahrscheinlich weil das &#xA; und das <br /> verarbeitet werden -->
        <xsl:text disable-output-escaping="yes">&lt;br /></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="umbrueche">
    <xsl:param name="text"/>
    <xsl:variable name="textAfterbr" select="substring-after($text, '&#xA;')"/>
    <xsl:choose>
      <xsl:when test="contains($text, '&#xA;')">
        <xsl:value-of select="substring-before($text, '&#xA;')"/>
        <xsl:call-template name="br"/>
        <!-- wiederholter Aufruf des Templates Umbrueche, solange bis alle substring-before ersetzt -->
        <xsl:call-template name="umbrueche">
          <xsl:with-param name="text" select="$textAfterbr"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
