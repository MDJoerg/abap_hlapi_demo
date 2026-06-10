# Prompts & System Prompts (Deutsch)

## System Prompt

### EN

````
You are a helpful assistant for a shopfloor dashboard demo with a SAP ABAP MCP Server. You can control different elements at the dashboard. 

Use the following tools:
1. `set_shopfloor_led_color`: set a LED to a given color. Supported colors and meanings are:
- `red` - "Full stop for everything"
- "green" - "The shopfloor is in normal state"
- "yellow" - "The shopfloor is in maintenance mode"
- "grey" - "The shopfloor is inactive"
Use only this colors and use lower case. Try to get the right color for the user request and ask him to execute the tool with the determined color if not given exactly by the user. 

2. `set_shopfloor_message`: set a shopfloor message. Use the id given from the user as `author`.

3. `set_progress`: set a progress indicator with a integer value from 0 to 120 in percent.

4. `simulate_process`: simulate a production process with a duration given by the parameter as worktime in seconds.
5. `get_weight`: get the current weight from a simulated scale.

if the user want to simulate a complex process call the tools in sequential order not in parallel. Ask the user if you are not sure what to do. Ask the user for missing optional parameters. Do not hallucinate.

```


## Konfiguration per Prompt

### Autor

```
ich bin der Autor "Player Gruppe 3"
```

### Kontext

```
Nutze als Kontext "Shopfloor Dashboard"
```

## Prompt Beispiele


### LED Farbe setzen

Verwendetes Tool: `set_shopfloor_led_color`

```
Setze die LED auf gelb mit dem Kontext "Achtung Menschen im Lager"
```

```
```

### Setze die Dashboard Nachricht

Verwendetes Tool: `set_shopfloor_message`

```
Setze die Nachricht "In ca. 60 min ist eine größere Besuchergruppe zu erwarten. Fahren sich vorsichtig!" vom Autor "Ludwig, der Lager-Boss". 
```


### Setze den Fortschritt

Verwendetes Tool: `set_shopfloor_progress`

```
Der Fortschritt ist jetzt 35%
```

### Ermittle das Gewicht der Waage

Verwendetes Tool: `get_weight`

```
Wie ist das aktuelle Gewicht der Waage?
```

### Simulieren Prozess

Verwendetes Tool: `simulate_process`

```
Simuliere einen Prozess mit einer Dauer von 5 Sekunden
```



## Komplexe Prompts

### Aktuelles Gewicht der Waage anzeigen

#### Prompt

```
Hole das aktuelle Gewicht und zeige es als Nachricht
```

#### Erwartungshaltung
- Das aktuelle Gewicht wird abgerufen und als Nachricht auf dem Dashboard angezeigt
- Der Autor wird erfragt oder aus dem bisherigen Kontext ermittelt

#### Erfolgreich getestete Modelle
- google/gemma-4-e2b
- nvidia/nemotron-3-nano-4b

#### Bekannte Probleme
- Manchmal klappt das mit dem Autor nicht, weil es nicht explizit angegeben wurde 
- Die erbetene Rückfrage klappt oft nicht


### Simuliere Produktionsprozess

#### Prompt

```
Simuliere einen Prozess:
- LED auf rot, Fortschritt 20%, Prozess simulieren für 5 Sekunden
- LED auf gelb, Fortschritt 50%, Nachricht "Wartung eingeleitet", Prozess simulieren 2 Sekunden
- LED grün, Fortschritt 100%, Nachricht "Fertig".
```

#### Erwartungshaltung
- Es werden in der richtigen Reihenfolge die verschiedenen MCP Tools aufgerufen
- Auf dem Dashboard sind die Aktivitäten 

#### Erfolgreich getestete Modelle
- google/gemma-4-e2b
- nvidia/nemotron-3-nano-4b

#### Bekannte Probleme
1. Je nach Frontend werden die Toolaufrufe nicht abgewartet. D.h. Die LED Aufrufe starten parallel und die Simulation des Prozesses wird nicht abgewartet.

## Sonstige Prompts

### Erstelle MCP API Dokumentation

```
Erstelle mir eine Art API Beschreibung über die in dieser Simulation verfügbaren MCP Tools, deren Parametern, Erklärungen und ein Anwendungsbeispiel. Ausgabeformat Markdown. Ich möchte das für eine Dokumentation für erfahrende Anwender/Entwickler verwenden.
```

Das Ergebnis sollte ein gut formatierte Dokumentation der API sein. Die API in diesem Repository wurde genau so erzeugt: [MCP API Dokumentation](mcp_tool_api.md)