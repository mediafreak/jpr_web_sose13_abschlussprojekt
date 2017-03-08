// JavaScript Document

$(document).ready(function () {
    
    // Abfangen von Chrome und Maxthon am Anfang einmalig eine Information, dass der Browser offline kein XML/XSLT unterstuetzt+Empfehlung
    /*var nAgt = navigator.userAgent;
    var browserName = navigator.appName;
    var verOffset;
    var selfLoc = self.location.href;
    
    if ((verOffset = nAgt.indexOf("Chrome")) != -1 && selfLoc.toLowerCase().indexOf("file:") >= 0) {
        var browserName = "Chrome/Maxthon";  
        alert("Browser unterstützt offline leider keine XML-XSL-Darstellung");
    }*/
    
    // Konfiguration => koennte noch einmal als inc.config.js (auf Server besser .php) ausgelagert werden
    // Home-Pfad ermitteln, damit xml-Dateien ueberall aus Verzeichnisstruktur aufgerufen werden koennen
    var homeArr = window.location.pathname.split("/");
    
    var length = homeArr.length -1;
    // Position fuer Strings xml+html ermitteln, gehoeren nicht zum Home-Pfad
    if (homeArr.indexOf("xml") != -1) {
        length = homeArr.indexOf("xml");
    } else if (homeArr.indexOf("html") != -1) {
        length = homeArr.indexOf("html");
    }
    
    // homePath: homeArr bis ermittelte Position wieder zusammensetzen
    var homePath = "";
    for (i = 1; i < length; i++) {
        homePath += "/";
        homePath += homeArr[i];
    }
    
    // Laden der xmlDateien fuer Auswertung bzgl. Unternavigation
    // bei groesserem Projekt, waere es hier sinnvoller, den Aufruf dann ueber Array+for-Schleife umzusetzen
    xmlNav(homePath + '/xml/termine/termine.xml', 'xmlNavT');
    xmlNav(homePath + '/xml/galerie/galerie.xml', 'xmlNavG');
    // Ende Konfiguration
    
    // Variablen aus URL auslesen und in Array idAnzRub speichern
    // [1] = aufgerufene ID, [2] = Anzahl <section>-Element, [3] = aufgerufene Rubrik (z.B. T = Termine)
    var idAnzRub;
    if (window.location.search != "")
    idAnzRub = window.location.search.split("?");
    
    // nicht ausgewaehlte Section-Elemente (xmlNav) ausblenden
    var idA = '#' + idAnzRub[3];
    for (var j = 0; j < idAnzRub[2]; j++) {
        var idStr = '#' + idAnzRub[3] + j;
        // ausblenden wenn j != augerufener ID
        if (j != idAnzRub[1]) {
            $('#doc article:has(section)').find(idStr).hide();
        }
    }
    
    // ermitteln der ID des aktiven Unternavigationspunktes (fuer xmlNav)
    // blende Unternavigation bei hover ein/aus
    var idAct = 'xmlNav' + idAnzRub[3] + idAnzRub[1];
    $('#main-nav li:has(ul)').hover(function () {
        $('#' + idAct).addClass('active');
        // class='active' zuweisen (class, weil 'active' auch im zugehoerigen main-nav-Punkt )
        $(this).find('ul').slideDown();
    },
    // wieder ausblenden
    function () {
        $(this).find('ul').hide();
    });
});

// generiert fuer xml-Dateien dynamisch die Unternavigationen
/* hier noch Darstellungsprobleme im IE und Opera, die Zeilenabstaende stimmen manchmal nicht in der Unternaviagtion 
   -> Ursache hierfuer noch nicht gefunden */
function xmlNav(xmlLink, id) {
    // ganze XML-datei einlesen und in variable 'XMLkatArray' speichern
    $.get(xmlLink, function (XMLkatArray) {
        // suche nach jedem (each) <kategorie>-element
        var anzSec = $(XMLkatArray).find("kategorie").length;
        var i = 0;
        var lastL;
        $(XMLkatArray).find("kategorie").each(function () {
            // gefundenen abschnitt in variable zwischenspeichern (cachen)
            var $myMedia = $(this);
            // einzelne werte auslesen und zwischenspeichern
            // attribute: funktion 'attr()' => sucht nach attribut 'name'
            // tags: nach dem tag suchen & text auslesen
            var menuP = $myMedia.attr("name");
            
            // letzten Buchstaben der xmlNav-ID auslesen
            // link neu setzen, um spaeter
            lastL = id.substr(id.length - 1);
            var vars = '?' + i + '?' + anzSec + '?' + lastL;
            
            // append = inhalt/link an 'ul'-Element anhaengen
            $('#' + id).append(
            '<li id="' + id + i + '"><a href="' + xmlLink + vars + '"  title="' + menuP + '" >' + menuP + '</a></li>');
            i++;
            //alert(i);
        });
        // existiert eine id fuer <a>-Element mit dem letzten Buchstaben von id?
        // an Wert des href-Attribut Variablen fuer ID, Anzahl Sektion-Elemente und Rubrik ranhaengen
        if ($('a #' + lastL)) {
            var vars = '?0?' + anzSec + '?' + lastL;
            var htmlLink = $('#' + lastL).attr("href") + vars
            $('#' + lastL).attr('href', htmlLink);
        }
    });
}

// Cookie-Konzept wieder verworfen, da Browser
// doch zu unterschiedlich in der Abarbeitung (Reihenfolge)
/*function setCookie(c_name, value, exdays, rub) {
$.cookie(c_name, value, {
expires: exdays
});
alert("set: " + $.cookie(c_name) + ' rub: ' + rub);
//show(c_name, rub);
}*/