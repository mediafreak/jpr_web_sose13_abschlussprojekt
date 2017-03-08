<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xsl">

  <!-- importiert Templates aus externen xsl-Dat, muss direkt hinter xsl:stylesheet-Deklaration -->
  <xsl:import href="templates/html.xsl"/>
  <xsl:import href="templates/umbruch.xsl" />
  
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
      <xsl:with-param name="id" select="3" />
    </xsl:call-template>
  </xsl:template>
  
  <!-- Stylesheet fuer section-Inhalt -->
  <xsl:template match="kategorie">
    <xsl:variable name="secID" select="string(position()-1)"/>
    <!-- fuer jede Kategorie eine section, damit ueber Unternavigation ein-/ausblenden -->
    <section id="T{$secID}">
      <h1><xsl:value-of select="string(@name)"/></h1>
      <xsl:apply-templates select="event"/>
    </section>
  </xsl:template>

  <xsl:template match="event">
    <!-- following-sibling::* Knoten, die nach dem aktuellen Knoten im restlichen XML-Dokument folgen, 
                              und zwar auf der gleichen Hierarchie-Ebene. -->
    <xsl:variable name="rowspan" select="string(count(veranstaltung/following-sibling::*))" />
    <table>
      <!-- Hierueber wird im CSS die Breite der einzelnen Spalten gesteuert, 
           width/height soll in HTML5 fuer tr und table kein Attribut mehr sein -->
      <colgroup>
        <col />
        <col />
        <col />
      </colgroup>
      <!-- Tabellenkopf, enthaelt Name der Veranstaltung -->
      <thead>
        <tr>
          <td colspan="3">
            <p>
              <xsl:value-of select="concat(position(),'. ',veranstaltung)"/>
              <!-- funktionieren wuerde auch <xsl:number count="".../>, aber wir haben ja nur ein single-Level:
                <xsl:variable name="number"><xsl:number level="single" count="event" format="1 "/></xsl:variable>
                <xsl:value-of select="concat($number,veranstaltung)"/> -->
            </p>
          </td>
        </tr>
      </thead>
      <!-- Tabellenkoerper, der alle weiteren Angaben zu veranstalter, uhrzeit, ort usw. enthaelt -->
      <tbody>
        <!-- variable vorher definieren: XSLT-Prozessor muss Wert nur einmal ermitteln, spart Zeit
                                         Werte in einer Variablen werden von den meisten XSLT-Prozessoren gecached -->
        <xsl:variable name="veranstalter" select="veranstalter" /> 
        <xsl:variable name="uhr" select="uhrzeit"/> 
        <xsl:variable name="adresse" select="adresse" /> 
        <xsl:variable name="eintritt" select="eintritt" />
        <xsl:variable name="urlStr" select="string(url)"/> 
        <tr>
          <td class="datum" rowspan="{$rowspan}">
            <xsl:apply-templates select="datum"/>
          </td>
          <th><p><xsl:value-of select="concat($veranstalter/@name,':')" /></p></th>
          <td><p><xsl:value-of select="$veranstalter"/></p></td>
        </tr>
        <!-- 'uhrzeit' optional, nur wenn Knoten vorhanden, dann <tr> generieren -->
        <xsl:if test="boolean($uhr)">
          <tr>
            <th><p><xsl:value-of select="$uhr/@name"/></p></th>
            <td><p><xsl:value-of select="$uhr"/></p></td>
          </tr>
        </xsl:if>
        <tr>
          <th><p><xsl:value-of select="$adresse/@name"/></p></th>
          <td><xsl:apply-templates select="$adresse"/></td>
        </tr>
        <tr>
          <th><p><xsl:value-of select="$eintritt/@name"/></p></th>
          <td><p><xsl:apply-templates select="$eintritt"/></p></td>
        </tr>
        <!-- 'url' optional, nur wenn Knoten vorhanden, dann <tr> generieren -->
        <xsl:if test="boolean($urlStr)">
          <tr>
            <td colspan="2">
              <p><a href="{concat('http://',$urlStr)}">
                <xsl:variable name="subStr" select="substring-before($urlStr,'/')"/>
                <xsl:choose>
                  <xsl:when test="boolean($subStr)"><xsl:value-of select="$subStr" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="$urlStr"/></xsl:otherwise>
                </xsl:choose>
                <!-- oder Weg ueber zwei if-Abfragen, Prozessor muss dann aber auch zweimal Variablen vergleichen/abfragen
                <xsl:if test="boolean($subStr)"><xsl:value-of select="$subStr"/></xsl:if> 
                <xsl:if test="boolean($subStr)=0"><xsl:value-of select="$urlStr"/></xsl:if>  -->
              </a>
              </p>
            </td>
          </tr>
        </xsl:if>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="datum">
    <p>
      <xsl:value-of select="string(wochentag)"/><br/>
      <strong><xsl:value-of select="string(tag)"/></strong><br/>
      <xsl:value-of select="string(../parent::*/@name)"/>
    </p>
  </xsl:template>

  <xsl:template match="adresse">
      <p>
        <!-- &#x002C; = Komma, &#x20; = Leerzeichen, &#x00A0; = geschuetztes Leerzeichen -->
        <xsl:value-of select="concat(strasse,'&#x002C;&#x20; ',plz,' &#x00A0;',ort)"/>
        <!-- 'zusatz' optional, nur wenn Knoten vorhanden, dann Absatz+String generieren -->
        <xsl:variable name="zusStr" select="string(zusatz)"/> <!-- wert in variable Performance -->
        <xsl:if test="boolean($zusStr)">
          <xsl:call-template name="br"/>
          <xsl:value-of select="concat('&#x28;',$zusStr,'&#x29;')"/>
        </xsl:if>
      </p>
  </xsl:template>
</xsl:stylesheet>
