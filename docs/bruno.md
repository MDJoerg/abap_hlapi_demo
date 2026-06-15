# Bruno Collection

Bruno gilt als Open Source Alternative zu Postman. Man kann Bruno hier downloaden: https://www.usebruno.com/.

In einer Bruno Collection sind die wichtigsten API Aufrufe eines MCP Clients dokumentiert, die man gegen das SAP System nachvollziehen kann, welches die HLAPI Demo als ABAP Backend enthält (Bestandteil dieses Repositories).

## Installation

im Verzeichnis `bruno` findet man:
- ein Verzeichnis `HLAPI Demo` - dieses kann man mit Bruno öffnen
- eine JSON-Datei `HLAPI Demo Collection Bruno Import.json` - diese kann man in Bruno als neue Collection importieren  

## Konfiguration

Nachdem die Collection in Bruno importiert oder geöffnet wurde, muss noch der Pfad zum SAP Server und die Login-Daten angepasst werden. Diese findet man in den Reitern:
- `Vars` - hier die Protokoll, URL, Port und Parameter zum SAP Mandanten austauschen
- `Auth` - hier die Anmeldedaten zum SAP System austauschen

## Test

Die Requests für verschiedene MCP Funktionen sind vorkonfiguriert und können danach sofort gestartet werden. 
