<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <!-- importiert Templates aus externen xsl-Dat, muss direkt hinter xsl:stylesheet-Deklaration -->
  <xsl:import href="templates/html.xsl"/>
  
  <!-- <xsl:output> kommt vom Template html.xsl -->

  <!-- setze globale Variablen 'seite' und 'seiteLC', letztere Umwandlung un LowerCase -->
  <xsl:variable name="seite" select="string(*/@name)"/>
  <xsl:variable name="seiteLC"
    select="translate($seite,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>

  <!-- <xsl:template>-Element erzeugt Vorlagen; 
       match-Attribut spezifiziert exakt, auf welchen Knoten der Quelldatei diese Vorlage angewendet werden soll/kann 
       -> Wert (= Pattern): '/' verwendet root-Element, '*' verwendet alle Knoten-Elemente; 
       name-Attribut gibt Template eindeutigen Namen fuer Wiederaufruf (Performance beachten, nur wenn noetig) -->
  <xsl:template match="/">
    <!-- ruft importiertes Template 'html' auf und uebergibt die globale Variable 'seite' als Parameter -->
    <xsl:call-template name="html">
      <xsl:with-param name="seite" select="$seite"/>
      <xsl:with-param name="seiteLC" select="$seiteLC"/>
      <xsl:with-param name="id" select="5"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Stylesheet fuer section-Inhalt -->
  <xsl:template match="url">
    <xsl:variable name="number">
      <xsl:number level="multiple" count="url" format="1.1.1.1 "/>
    </xsl:variable>
    <!-- XPATH-Achse ancestor::* waehlt das Tag mindestens eine Ebene hoeher aus. -->
    <xsl:variable name="urltiefe" select="string(count(ancestor::*))"/>
    <xsl:element name="{concat('h', $urltiefe)}">
      <xsl:value-of select="$number"/>
      <xsl:variable name="location" select="string(loc)"/>
      <a href="{$location}">
        <xsl:value-of select="@name"/>
      </a>
      <xsl:value-of select="concat('&#160;&gt;&#160;h',$urltiefe)"/>
    </xsl:element>
    <!-- Vermeidung von xsl:attribute, weil dies der Performance schadet und auch den Quellcode unuebersichtlich macht -->
    <xsl:if test="boolean(text/ancestor::*)">
      <xsl:variable name="texttiefe" select="count(text/ancestor::*)-1"/>
      <p class="{$texttiefe}">
        <xsl:value-of select="text/."/>
      </p>
    </xsl:if>
    <!-- <xsl:apply-templates>-Element waehlt ueber select-Attribut eine Gruppe von Knoten aus, 
      weist den XSLT-Prozessor an, fuer jeden der ausgewaehlten Knoten das <xsl:template> zu suchen 
      Fuer <xsl:apply-templates select="text"/> ist es nicht noetig, da das <text>-Element 
      keine weiteren Knoten enthaelt-->
    <!--<xsl:apply-templates select="text"/>-->
    <xsl:apply-templates select="url"/> <!-- rekursiver Aufruf von url -->
  </xsl:template>

  <!-- dieses Template ist nicht wirklich notwendig -->
  <!--<xsl:template match="text">
    <xsl:variable name="texttiefe" select="count(ancestor::*)-1"/>
    <!-\- Vermeidung von xsl:attribute, weil dies der Performance schadet und auch den Quellcode unuebersichtlich macht -\->
    <p class="{$texttiefe}">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>-->

</xsl:stylesheet>
