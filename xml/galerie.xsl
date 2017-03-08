<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">
  
  <!-- importiert Templates aus externen xsl-Dat, muss direkt hinter xsl:stylesheet-Deklaration -->
  <xsl:import href="templates/html.xsl"/>
  
  <!-- <xsl:output> kommt vom Template html.xsl -->
  
  <!-- setzt globale Variable 'seite', somit ueberall im Baum verwendbar -->
  <!-- es wird nur ein String erwartet, deswegen Verwendung der Funktion string() (Performance)
         => Wird von den meisten XSL-Prozessoren gecached
         => Sie führen damit direkt ein Type casting durch
         => Vermeidet die Verwendung von xsl:value-of 
         => macht Sinn bei Strings innerhalb von XSL-Funktionen oder einem XPATH-Ausdruck -->
  <xsl:variable name="seite" select="string(*/@name)" />
  
  <!-- Variable erzeugen, die den NCName der Seite in Lower Case umwandelt -->
  <xsl:variable name="seiteLC" select="translate($seite,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
  
  <!-- <xsl:template>-Element erzeugt Vorlagen; 
       match-Attribut spezifiziert exakt, auf welchen Knoten der Quelldatei diese Vorlage angewendet werden soll/kann 
       -> Wert (= Pattern): '/' verwendet root-Element, '*' verwendet alle Knoten-Elemente; 
       name-Attribut waere auch noch moeglich, welches einen eindeutigen Namen fuer das Template definiert, 
       der spaeter weiter verwendet werden kann. -->
  <xsl:template match="/">
    <!-- ruft importiertes Template 'html' auf und uebergibt die globale Variable 'seite' als Parameter -->
    <xsl:call-template name="html">
      <xsl:with-param name="seite" select="$seite"/>
      <xsl:with-param name="seiteLC" select="$seiteLC"/>
      <xsl:with-param name="id" select="4" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Stylesheet fuer section-Inhalt -->
  <xsl:template match="kategorie">
    <xsl:variable name="secID" select="string(position()-1)"/>
    <!-- fuer jede Kategorie eine section, damit ueber Unternavigation ein-/ausblenden -->
    <section id="G{$secID}">
      <h1><xsl:value-of select="string(@name)"/></h1>
      <xsl:apply-templates select="item"/>
    </section>
  </xsl:template>
  
  <xsl:template match="item">
    <!-- string(): immer wenn String innerhalb einer XSL-Funktion oder einem XPATH-Ausdruck erwartet/generieret 
                   - Wird von den meisten XSL-Prozessoren gecached
                   - Fuehrt damit direkt ein Type casting durch
                   - Vermeidet die Verwendung von xsl:value-of -->
    <xsl:variable name="pict" select="string(picture)" />
    <xsl:variable name="copyright" select="string(picture/@*[2])" />
    <xsl:variable name="title" select="string(titel)" />
    <xsl:variable name="desc" select="string(description)" />
    <!-- Lightbox ueber reinem CSS, koennte noch ausgebaut werden, zurueck-Befehl
         als Test gedacht, um auszuprobieren, ob das Einbinden von Bildern geht -->
    <figure>
      <a href="#{substring-before($pict,'.')}" title="{$title}">
        <img src="../../img/galerie/thumb/{substring-before($pict,'.')}_thumb.{substring-after($pict,'.')}" title="{$title}" alt="{$desc}" />
      </a>
      <!-- zunaechst unsichtbar, wird ueber anker ausgerufen -->
      <a id="{substring-before($pict,'.')}" class="background-overlay" href="#" title="{$title}" accesskey="0">
        <figure>
          <img src="../../img/galerie/{$pict}" title="{$title}" alt="{$desc}"/>
          <!-- figcaption ist in html5 die Bildunterschrift, gehoert zu <figure> => ermoeglicht Bildergalerien -->
          <figcaption><xsl:value-of select="concat($desc,' ',$copyright)"/></figcaption>
        </figure>
      </a> 
      <figcaption><xsl:value-of select="$desc"/></figcaption>
    </figure>
  </xsl:template>
 
</xsl:stylesheet>
