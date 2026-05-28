# HLAPI Demo Dashboard - Installation und Konfiguration 


## Docker Stack starten

1. Installation Docker Desktop
2. Dieses Repository klonen
3. Im Repositoy in den Pfad `docker/hlapi_dashboard` wechseln
4. Kommando `docker compose up` aufrufen
5. Docker Desktop aufrufen und dort den neuen Stack und seine Services suchen. Ggf. hier starten und stoppen


## Nodered konfigurieren

Hinweis: Die Konfiguration ist nur beim ersten Mal notwendig.

1. Im Browser `http://localhost:1880` starten
2. Begrüßung und Informationen durchklicken
3. Menü `Palette verwalten` öffnen und folgende Module installieren:
    - @flowfuse/node-red-dashboard 
    - @flowfuse/node-red-dashboard-2-ui-led 
4. Flow(s) aus Verzeichnis `flows/hlapi_dashboard` über das Menü `Import` aus Datei importieren (bei mehreren Versionen letzte Version nehmen)
5. Flow(s) übernehmen (`deploy`)


## Nodered Dashboard verwenden

Sobald Nodered mit dem HLAPI Dashboard konfiguriert wurde, steht es unter `http://localhost:1880/dashboard/hlapi_demo` zur Verfügung.

Damit auch andere Systeme wie ein entferntes SAP System an das lokale Dashboard gelangen, muss der lokale Port `1880` im Internet bekannt gemacht werden. Das ist ein typischen Netzwerkproblem und kann auf verschiedene Weise umgesetzt werden.

Eine sehr schnelle Umsetzung und vor allem zum Testen von lokalen Services bietet der Cloud Service https://ngrok.com/.
Dort muss man sich registrieren, die Client-Programme für seine lokale Plattform laden und einmal konfigurieren. Für Windows erhält man hier alle wichtigen Informationen: https://ngrok.com/download/windows.

Danach kann man den Nodered-Service `1880` mit dem Kommando `ngrok http 1880` freigeben. Der Service erzeugt eine temporäre Adresse im Internet, die nur solange verfügbar ist, wie der lokale ngrok Service läuft: z.B. `https://409b-2003-fd-f703-ba00-dcd8-9a7e-329e-8756.ngrok-free.app`.
Über diese Adresse können dann Fremde und auch SAP Systeme auf den lokalen Service zugreifen.

Achtung:
Theoretisch ist hier Missbrauch möglich, auch wenn solche Adressen nur temporär existieren und schwer zu erraten sind. Solche Verbindungen sollten nicht lange verwendet und die erzeugten Adressen wie Passwörter behandelt werden (nicht leichtsinnig verteilen).
Zusätzlich kann auf der ngrok Konsole der Netzwerkverkehr beobachtet werden. Fallen dort fremde Zugriffe auf, die nicht zu erklären sind, ist die ngrok Verbindung sofort zu beenden. 


## Docker Stack stoppen

Wenn das Terminal mit Meldungen läuftm dort mit `STRG-C` abbrechen.
Alternativ im Verzeichnis `docker/hlapi_dashboard` das Kommando `docker compose down` aufrufen oder den Stack über den Docker Desktop beenden.

